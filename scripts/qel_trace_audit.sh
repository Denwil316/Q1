#!/usr/bin/env bash
# QEL — Auditoría de Traza (E1–E12) + métricas IT/TC/TI/TT/UH
# Escanea multi-raíz, cruza con ListadoR + Diario, NO recalcula hash.
# Escribe RunID y APENDE (no sobrescribe) el reporte MD.
# CSV enriquecido: HASH_EOF,HASH_LISTADOR,HASH_DIARIO,HASH_CANONICAL,HASH_STATUS

set -euo pipefail
export LC_ALL=C

# =========================
# CONFIG (ajustables por env)
# =========================
# Raíces a auditar (separadas por ":" o espacios)
DOCS_DIRS="${DOCS_DIRS:-docs:memory:README:pub}"

# Directorios a excluir (cualquier nivel). Patrones -path de find.
EXCLUDE_DIRS="${EXCLUDE_DIRS:-.git:node_modules:scripts:tools:out:apps/*/src:apps/*/scripts:apps/*/dist:apps/*/build}"

# Extensiones incluidas (coma-separadas)
INCLUDE_EXT="${INCLUDE_EXT:-md,MD}"

# ListadoR (canónico)
LISTADOR="${LISTADOR:-docs/core/QEL_ListadoR_master_v1.0.md}"

# Directorios donde buscar Diarios (para registrar hash)
DIARIO_DIRS="${DIARIO_DIRS:-docs/core/diarios:memory/archive:pub/an}"

# Atlas y exposición pública (chequeos opcionales)
ATLAS_JSONL="${ATLAS_JSONL:-docs/core/atlas_microreg_v1.0.jsonl}"
PUBLIC_DIR="${PUBLIC_DIR:-apps/preh-nav-m1/public/docs}"
CHECK_PUBLIC="${CHECK_PUBLIC:-0}"  # 1=activa E10

# Salidas
OUT_DIR="${OUT_DIR:-out}"
OUT_CSV="${OUT_DIR}/qel_trace_report.csv"
OUT_MD="${OUT_DIR}/qel_trace_report.md"
RUN_JSON="${OUT_DIR}/qel_trace_run.json"
TOP_N="${TOP_N:-20}"

# Progreso
PROGRESS_EVERY="${PROGRESS_EVERY:-200}"
SPIN_CHARS='-\|/'
SPIN_IDX=0
START_TS="$(date +%s)"
START_ISO="${START_ISO:-$(date -u +'%Y-%m-%dT%H:%M:%SZ')}"

# =========================
# Utilidades
# =========================
mkdir -p "${OUT_DIR}"

# Construye find con nombre y exclusiones (macOS/BSD compatible)
find_newline() {
  IFS=': ' read -r -a ROOTS <<< "$DOCS_DIRS"
  IFS=': ' read -r -a EXCS  <<< "$EXCLUDE_DIRS"
  IFS=','   read -r -a EXTS  <<< "$INCLUDE_EXT"

  # nombre de archivos: -name "*.md" -o -name "*.MD" ...
  local name_expr=()
  for ext in "${EXTS[@]}"; do
    name_expr+=( -name "*.${ext}" -o )
  done
  [[ ${#name_expr[@]} -gt 0 ]] && unset 'name_expr[${#name_expr[@]}-1]'

  for root in "${ROOTS[@]}"; do
    [[ -d "$root" ]] || continue
    # armar exclusiones -path "*/X/*" -o -path "*/apps/*/public/docs/*"
    local excl=( -path "*/apps/*/public/docs/*" )
    for p in "${EXCS[@]}"; do
      excl+=( -o -path "*/${p}/*" )
      excl+=( -o -path "${p}/*" )
    done
    # find con prune
    find "$root" \
      \( "${excl[@]}" \) -prune -o \
      \( -type f \( "${name_expr[@]}" \) -print \)
  done
}

find_null() {
  find_newline | tr '\n' '\0'
}

sec_hms () {
  local s="${1:-0}"; (( s < 0 )) && s=0
  printf "%02d:%02d:%02d" $((s/3600)) $(((s%3600)/60)) $((s%60))
}
progress_line () {
  local scanned="$1"; local current="${2:-}"
  local now elapsed eta pct spin bn
  SPIN_IDX=$(( (SPIN_IDX + 1) % 4 )); spin="${SPIN_CHARS:$SPIN_IDX:1}"
  now="$(date +%s)"; elapsed=$(( now - START_TS ))

  if [[ -z "${TOTAL_CANDIDATES:-}" ]]; then
    TOTAL_CANDIDATES="$(find_newline | wc -l | awk '{print $1}')"
    [[ -z "$TOTAL_CANDIDATES" ]] && TOTAL_CANDIDATES=0
  fi
  if (( scanned > 0 && TOTAL_CANDIDATES > 0 )); then
    eta=$(( (TOTAL_CANDIDATES - scanned) * (elapsed > 0 ? elapsed : 1) / scanned ))
    pct=$(( scanned * 100 / TOTAL_CANDIDATES ))
  else
    eta=0; pct=0
  fi
  bn=""
  [[ -n "$current" ]] && bn="$(basename "$current")"
  printf "\r[%s] %8d/%d  %3d%%  ETA %s  | %s" \
    "$spin" "$scanned" "$TOTAL_CANDIDATES" "$pct" "$(sec_hms "$eta")" "$bn" >&2
}

# Campos front-matter
get_field() { local f="$1" k="$2" line; line=$(grep -m1 -E "^${k}=" "$f" 2>/dev/null || true); echo "${line#${k}=}"; }

# CUE
has_cue() { grep -qm1 -E '^\[QEL::ECO\[[0-9]+\]::RECALL .+\]' "$1"; }

# HASH EOF (última línea == 10 hex)
get_hash10_eof() { local f="$1" last; last=$(tail -n1 "$f" | tr -d '\r' || true); [[ "$last" =~ ^[0-9a-f]{10}$ ]] && echo "$last" || echo ""; }

# ListadoR: bloque cercano al basename
listador_block() {
  local f="$1" bn ln s e
  [[ -f "$LISTADOR" ]] || { echo ""; return 0; }
  bn="$(basename "$f")"
  ln=$(grep -n -F "$bn" "$LISTADOR" 2>/dev/null | head -n1 | cut -d: -f1 || true)
  [[ -z "$ln" ]] && { echo ""; return 0; }
  s=$(( ln>4 ? ln-4 : 1 )); e=$(( ln+6 ))
  sed -n "${s},${e}p" "$LISTADOR"
}

extract_meta_from_block() { echo "$1" | grep -m1 -E "^$2=" | sed -E "s/^$2=//" || true; }

extract_path_from_block() { echo "$1" | grep -Eo 'docs/[A-Za-z0-9_./-]+\.md' | head -n1 || true; }

listador_hash() {
  local f="$1" block h
  block="$(listador_block "$f")"
  [[ -z "$block" ]] && { echo ""; return 0; }
  h="$(printf "%s\n" "$block" | grep -Eo 'hash\(10\):[[:space:]]*([0-9a-f]{10})' | tail -n1 | awk -F': *' '{print $2}')"
  echo "$h"
}

# Diario(s): busca basename y toma hash(10) en ventana +/- N líneas
diario_hash() {
  local f="$1" bn N=12
  IFS=': ' read -r -a DROOTS <<< "$DIARIO_DIRS"
  bn="$(basename "$f")"
  for d in "${DROOTS[@]}"; do
    [[ -d "$d" ]] || continue
    # Explora .md en ese directorio (no recursivo excesivo; si quieres, cambia a -type f -name '*.md' con -maxdepth)
    find "$d" -type f -name '*.md' -print0 2>/dev/null | while IFS= read -r -d '' m; do
      local ln
      ln="$(grep -n -F "$bn" "$m" 2>/dev/null | head -n1 | cut -d: -f1 || true)"
      [[ -z "$ln" ]] && continue
      local s=$(( ln>N ? ln-N : 1 )); local e=$(( ln+N ))
      local win
      win="$(sed -n "${s},${e}p" "$m" 2>/dev/null || true)"
      local h
      h="$(printf "%s\n" "$win" | grep -Eo 'hash\(10\):[[:space:]]*([0-9a-f]{10})' | tail -n1 | awk -F': *' '{print $2}')"
      [[ -n "$h" ]] && { echo "$h"; return 0; }
    done
  done
  echo ""
}

# Atlas presencia
has_jq=0; command -v jq >/dev/null 2>&1 && has_jq=1
atlas_has_file() {
  local f="$1"
  [[ ! -f "$ATLAS_JSONL" ]] && { echo "SKIP"; return 0; }
  if [[ $has_jq -eq 1 ]]; then
    jq -e --arg f "$f" 'select(.FILE==$f)' "$ATLAS_JSONL" >/dev/null && echo "YES" || echo "NO"
  else
    grep -F -q "\"FILE\":\"$f\"" "$ATLAS_JSONL" && echo "YES" || echo "NO"
  fi
}

# Público por basename
is_exposed_public() { local f="$1" bn; bn="$(basename "$f")"; [[ -f "${PUBLIC_DIR}/${bn}" ]]; }

# RunID
runid_from() {
  if command -v shasum >/dev/null 2>&1; then
    shasum -a 1 | awk '{print tolower(substr($1,1,10))}'
  else
    openssl dgst -sha1 | awk '{print tolower(substr($2,1,10))}'
  fi
}

# ============
# Acumuladores
# ============
total_files=0
e1=0; e2=0; e3=0; e4=0; e5=0; e6=0; e7=0; e8=0; e9=0; e10=0; e11=0; e12=0
skipped_atlas=0

STATUS_NO_HASH_ANY=0
STATUS_LEDGER_MISMATCH=0
STATUS_EOF_DIFFERS_LEDGER=0
STATUS_LEDGER_PRESENT=0

TMP_HASHMAP="$(mktemp)"; trap 'rm -f "$TMP_HASHMAP"' EXIT

# CSV header (enriquecido)
echo "file,SeedI,SoT,Version,Updated,HASH_EOF,HASH_LISTADOR,HASH_DIARIO,HASH_CANONICAL,HASH_STATUS,errors" > "$OUT_CSV"

# ============
# Escaneo
# ============
find_null | while IFS= read -r -d '' f; do
  total_files=$((total_files+1))
  (( total_files % PROGRESS_EVERY == 0 )) && progress_line "$total_files" "$f"

  # Campos
  SeedI="$(get_field "$f" "SeedI")"
  SoT="$(get_field "$f" "SoT")"
  Version="$(get_field "$f" "Version")"
  Updated="$(get_field "$f" "Updated")"
  CUE_OK=0; has_cue "$f" && CUE_OK=1

  errors=()

  # E1: front-matter incompleto
  if [[ -z "$SeedI" || -z "$SoT" || -z "$Version" || -z "$Updated" ]]; then
    errors+=("E1"); e1=$((e1+1))
  fi
  # E12: CUE ausente
  (( CUE_OK == 0 )) && { errors+=("E12"); e12=$((e12+1)); }

  # HASHES
  HASH_EOF="$(get_hash10_eof "$f")"
  [[ -z "$HASH_EOF" ]] && { errors+=("E2"); e2=$((e2+1)); } || printf '%s\t%s\n' "$HASH_EOF" "$f" >> "$TMP_HASHMAP"

  HASH_LISTADOR="$(listador_hash "$f")"
  HASH_DIARIO="$(diario_hash "$f")"

  HASH_CANONICAL=""
  HASH_STATUS=""

  if [[ -n "$HASH_LISTADOR" && -n "$HASH_DIARIO" ]]; then
    if [[ "$HASH_LISTADOR" == "$HASH_DIARIO" ]]; then
      HASH_CANONICAL="$HASH_LISTADOR"
      HASH_STATUS="LEDGER_OK"
      STATUS_LEDGER_PRESENT=$((STATUS_LEDGER_PRESENT+1))
    else
      HASH_STATUS="LEDGER_MISMATCH(${HASH_LISTADOR}|${HASH_DIARIO})"
      STATUS_LEDGER_MISMATCH=$((STATUS_LEDGER_MISMATCH+1))
    fi
  elif [[ -n "$HASH_LISTADOR" || -n "$HASH_DIARIO" ]]; then
    HASH_CANONICAL="${HASH_LISTADOR:-$HASH_DIARIO}"
    HASH_STATUS="LEDGER_PARTIAL"
    STATUS_LEDGER_PRESENT=$((STATUS_LEDGER_PRESENT+1))
  else
    HASH_STATUS="NO_HASH_ANYWHERE"
    STATUS_NO_HASH_ANY=$((STATUS_NO_HASH_ANY+1))
  fi

  # Diferencia EOF vs ledger canónico (si lo hay)
  if [[ -n "$HASH_CANONICAL" ]]; then
    if [[ -n "$HASH_EOF" && "$HASH_EOF" != "$HASH_CANONICAL" ]]; then
      HASH_STATUS="${HASH_STATUS};EOF_NEQ_LEDGER"
      STATUS_EOF_DIFFERS_LEDGER=$((STATUS_EOF_DIFFERS_LEDGER+1))
    fi
  fi

  # E11: SoT canónico (heurístico)
  if ! echo "$SoT" | grep -Eq '^[A-Z0-9_./-]+$'; then
    [[ -n "$SoT" ]] && { errors+=("E11"); e11=$((e11+1)); }
  fi

  # Cruces con ListadoR (ruta/metas/temporalidad)
  if [[ -f "$LISTADOR" ]]; then
    block="$(listador_block "$f" || true)"
    if [[ -z "${block:-}" ]]; then
      errors+=("E8"); e8=$((e8+1))
    else
      path_lr="$(extract_path_from_block "$block" || true)"
      [[ -n "$path_lr" && "$path_lr" != "$f" ]] && { errors+=("E6"); e6=$((e6+1)); }

      SeedI_lr="$(extract_meta_from_block "$block" "SeedI" || true)"
      SoT_lr="$(extract_meta_from_block "$block" "SoT" || true)"
      Version_lr="$(extract_meta_from_block "$block" "Version" || true)"
      Updated_lr="$(extract_meta_from_block "$block" "Updated" || true)"

      [[ -n "$SeedI_lr" && -n "$SeedI" && "$SeedI_lr" != "$SeedI" ]] && { errors+=("E4"); e4=$((e4+1)); }

      local_e5=0
      [[ -n "$SoT_lr" && -n "$SoT" && "$SoT_lr" != "$SoT" ]] && local_e5=1
      [[ -n "$Version_lr" && -n "$Version" && "$Version_lr" != "$Version" ]] && local_e5=1
      [[ -n "$Updated_lr" && -n "$Updated" && "$Updated_lr" != "$Updated" ]] && local_e5=1
      (( local_e5 == 1 )) && { errors+=("E5"); e5=$((e5+1)); }

      # E7 temporalidad
      bn="$(basename "$f")"
      updates="$(
        { grep -n -F "$bn" "$LISTADOR" || true; } \
        | cut -d: -f1 \
        | while read -r n; do
            s=$(( n>2 ? n-2 : 1 )); e=$(( n+2 ))
            sed -n "${s},${e}p" "$LISTADOR" \
            | { grep -m1 -E '^Updated=' || true; } \
            | sed 's/^Updated=//'
          done \
        | sort -u
      )"
      if [[ -n "$Updated" ]]; then
        u_file="$(echo "$Updated" | sed 's/-//g')"
        if [[ -n "$u_file" && -n "$updates" ]]; then
          u_max=""
          while IFS= read -r u; do
            uu="$(echo "$u" | sed 's/-//g')"
            [[ -n "$uu" ]] && { [[ -z "$u_max" || "$uu" > "$u_max" ]] && u_max="$uu"; }
          done <<< "$updates"
          if [[ -n "$u_max" && "$u_file" < "$u_max" ]]; then
            errors+=("E7"); e7=$((e7+1))
          fi
        fi
      fi
    fi
  else
    echo "WARN: No se encontró ListadoR en '$LISTADOR' — se omiten E4,E5,E6,E7,E8." >&2
  fi

  # Atlas (E9)
  atlas_state="$(atlas_has_file "$f")"
  if [[ "$atlas_state" == "SKIP" ]]; then
    skipped_atlas=$((skipped_atlas+1))
  else
    [[ "$atlas_state" == "NO" ]] && { errors+=("E9"); e9=$((e9+1)); }
  fi

  # Exposición pública (E10)
  if [[ "$CHECK_PUBLIC" == "1" ]]; then
    ! is_exposed_public "$f" && { errors+=("E10"); e10=$((e10+1)); }
  fi

  joined="$(IFS=';'; echo "${errors[*]:-}")"
  printf '"%s","%s","%s","%s","%s","%s","%s","%s","%s","%s","%s"\n' \
    "$f" "$SeedI" "$SoT" "$Version" "$Updated" \
    "$HASH_EOF" "$HASH_LISTADOR" "$HASH_DIARIO" "$HASH_CANONICAL" "$HASH_STATUS" "$joined" \
    >> "$OUT_CSV"
done

# Cierra barra de progreso
(( total_files > 0 )) && progress_line "$total_files" "" && echo >&2

# E3: HASH duplicados (EOF)
if [[ -s "$TMP_HASHMAP" ]]; then
  dup_count=$(awk '{cnt[$1]++} END{c=0; for(h in cnt){if(cnt[h]>1)c+=cnt[h]} print c}' "$TMP_HASHMAP")
  if [[ "${dup_count:-0}" -gt 0 ]]; then
    e3=$((e3+dup_count))
    awk -F',' -v OFS=',' -v map="$TMP_HASHMAP" '
      BEGIN{while((getline<map)>0){split($0,a,"\t");cnt[a[1]]++}}
      NR==1{print;next}
      {h=$6;gsub(/^"|"$/,"",h); if(h in cnt && cnt[h]>1){
         er=$11;gsub(/^"|"$/,"",er); if(er==""){er="E3"} else if(er !~ /(^|;)E3(;$|$)/){er=er ";E3"}
         $11="\"" er "\""
       } print }' "$OUT_CSV" > "${OUT_CSV}.tmp" && mv "${OUT_CSV}.tmp" "$OUT_CSV"
  fi
fi

# ==========================
# Métricas
# ==========================
N="$total_files"
tc_bad=$((e1+e2+e8+e9+e10))
ti_bad=$((e4+e5+e6+e12))
tt_bad=$((e7))
uh_bad=$((e3))

float_div() { awk -v a="$1" -v b="$2" 'BEGIN{if(b==0)print "1.0000"; else printf "%.4f", (a<0?0:a)/b}'; }
float_one_minus() { awk -v x="$1" 'BEGIN{printf "%.4f", 1.0 - x}'; }
float_weighted() { awk -v tc="$1" -v ti="$2" -v tt="$3" -v uh="$4" 'BEGIN{printf "%.4f", 0.40*tc + 0.30*ti + 0.20*tt + 0.10*uh}'; }

TC="$(float_one_minus "$(float_div "$tc_bad" "$N")")"
TI="$(float_one_minus "$(float_div "$ti_bad" "$N")")"
TT="$(float_one_minus "$(float_div "$tt_bad" "$N")")"
UH="$(float_one_minus "$(float_div "$uh_bad" "$N")")"
IT="$(float_weighted "$TC" "$TI" "$TT" "$UH")"

END_ISO="$(date -u +'%Y-%m-%dT%H:%M:%SZ')"

RUN_ID="$(
  {
    printf '%s\n' "$DOCS_DIRS" "$EXCLUDE_DIRS" "$INCLUDE_EXT" "$LISTADOR" "$ATLAS_JSONL" "$DIARIO_DIRS";
    tail -n +2 "$OUT_CSV" | awk -F',' '{print $1","$6","$7","$8","$9","$10","$11}' | sort;
  } | runid_from
)"

echo "----------------------------------------"
echo "QEL · Auditoría de Traza"
echo "Archivos auditados: $N"
echo "TC (Traza-Completitud): $TC"
echo "TI (Integridad cruzada): $TI"
echo "TT (Temporalidad): $TT"
echo "UH (Unicidad HASH): $UH"
echo "IT (Índice Global, 0–1): $IT"
echo "RunID: $RUN_ID"
echo "----------------------------------------"
printf "E1=%d  E2=%d  E3=%d  E4=%d  E5=%d  E6=%d  E7=%d  E8=%d  E9=%d  E10=%d  E11=%d  E12=%d\n" \
  "$e1" "$e2" "$e3" "$e4" "$e5" "$e6" "$e7" "$e8" "$e9" "$e10" "$e11" "$e12"
echo "Ledger: present=$STATUS_LEDGER_PRESENT  mismatch=$STATUS_LEDGER_MISMATCH  eof≠ledger=$STATUS_EOF_DIFFERS_LEDGER  none=$STATUS_NO_HASH_ANY"
[[ "$CHECK_PUBLIC" != "1" ]] && echo "Nota: E10 desactivado (CHECK_PUBLIC=0)."
[[ "$skipped_atlas" -gt 0 ]] && echo "Nota: Atlas no encontrado — se omitieron E9 en $skipped_atlas archivo(s)."
echo "CSV detallado: $OUT_CSV"
echo "----------------------------------------"

# Persistir JSON del run
cat > "$RUN_JSON" <<EOF
{"run_id":"$RUN_ID","started_at":"$START_ISO","finished_at":"$END_ISO","N":$N,
 "metrics":{"TC":"$TC","TI":"$TI","TT":"$TT","UH":"$UH","IT":"$IT"},
 "ledger":{"present":$STATUS_LEDGER_PRESENT,"mismatch":$STATUS_LEDGER_MISMATCH,"eof_differs":$STATUS_EOF_DIFFERS_LEDGER,"none":$STATUS_NO_HASH_ANY},
 "config":{"DOCS_DIRS":"$DOCS_DIRS","EXCLUDE_DIRS":"$EXCLUDE_DIRS","INCLUDE_EXT":"$INCLUDE_EXT",
           "LISTADOR":"$LISTADOR","DIARIO_DIRS":"$DIARIO_DIRS","ATLAS_JSONL":"$ATLAS_JSONL","PUBLIC_DIR":"$PUBLIC_DIR","CHECK_PUBLIC":"$CHECK_PUBLIC"}}
EOF
echo "Run JSON: $RUN_JSON"

# ==========================
# Reporte Markdown (APÉNDE)
# ==========================
{
  echo ""
  echo "## Auditoría — $(date '+%Y-%m-%d %H:%M:%S %Z')"
  echo
  echo "- **RunID:** \`$RUN_ID\`"
  echo "- **Iniciado (UTC):** $START_ISO"
  echo "- **Terminado (UTC):** $END_ISO"
  echo
  echo "# QEL · Informe de Trazabilidad"
  echo
  echo "- **Archivos auditados:** $N"
  echo "- **TC (Traza-Completitud):** $TC"
  echo "- **TI (Integridad cruzada):** $TI"
  echo "- **TT (Temporalidad):** $TT"
  echo "- **UH (Unicidad HASH):** $UH"
  echo "- **IT (Índice global de Traza):** $IT"
  echo "- **Ledger:** present=$STATUS_LEDGER_PRESENT · mismatch=$STATUS_LEDGER_MISMATCH · eof≠ledger=$STATUS_EOF_DIFFERS_LEDGER · none=$STATUS_NO_HASH_ANY"
  echo
  echo "## Leyenda de errores"
  echo
  echo "| Código | Descripción breve |"
  echo "|--------|--------------------|"
  echo "| E1 | Front-matter incompleto (SeedI/SoT/Version/Updated) |"
  echo "| E2 | HASH(10) ausente o mal formateado en EOF |"
  echo "| E3 | HASH(10) duplicado en más de un archivo |"
  echo "| E4 | SeedI del artefacto ≠ SeedI en ListadoR |"
  echo "| E5 | SoT/Version/Updated ≠ ListadoR |"
  echo "| E6 | Ruta en ListadoR ≠ ruta real del archivo |"
  echo "| E7 | Temporalidad no monótona (Updated < max histórico en ListadoR) |"
  echo "| E8 | Artefacto ausente en ListadoR |"
  echo "| E9 | Artefacto ausente en Atlas (cuando aplica) |"
  echo "| E10 | No expuesto en carpeta pública (cuando CHECK_PUBLIC=1) |"
  echo "| E11 | SoT no canónico (regex simple; posible problema de formato) |"
  echo "| E12 | CUE ausente \`[QEL::ECO[..]::RECALL ...]\` |"
  echo
  echo "## Conteo global de errores"
  echo
  echo "| Código | Conteo |"
  echo "|--------|--------|"
  echo "| E1 | $e1 |"
  echo "| E2 | $e2 |"
  echo "| E3 | $e3 |"
  echo "| E4 | $e4 |"
  echo "| E5 | $e5 |"
  echo "| E6 | $e6 |"
  echo "| E7 | $e7 |"
  echo "| E8 | $e8 |"
  echo "| E9 | $e9 |"
  echo "| E10 | $e10 |"
  echo "| E11 | $e11 |"
  echo "| E12 | $e12 |"
  echo
  echo "## Discrepancias de hash"
  echo
  echo "- **Sin hash en ledger (ListadoR ni Diario):** $STATUS_NO_HASH_ANY"
  echo "- **Mismatch ListadoR ≠ Diario:** $STATUS_LEDGER_MISMATCH"
  echo "- **EOF ≠ ledger canónico:** $STATUS_EOF_DIFFERS_LEDGER"
  echo
  echo "### Listado — Sin hash en ledger"
  echo
  awk -F',' 'NR>1 && $10 ~ /NO_HASH_ANYWHERE/ {gsub(/^"|"$/,"",$1); print "- " $1}' "$OUT_CSV"
  echo
  echo "### Listado — Mismatch ListadoR ≠ Diario"
  echo
  awk -F',' 'NR>1 && $10 ~ /LEDGER_MISMATCH/ {
    f=$1; gsub(/^"|"$/,"",f);
    l=$7; d=$8; gsub(/^"|"$/,"",l); gsub(/^"|"$/,"",d);
    print "- " f "  (L=" l ", D=" d ")"
  }' "$OUT_CSV"
  echo
  echo "### Listado — EOF ≠ Ledger"
  echo
  awk -F',' 'NR>1 && $10 ~ /EOF_NEQ_LEDGER/ {
    f=$1; gsub(/^"|"$/,"",f);
    e=$6; c=$9; gsub(/^"|"$/,"",e); gsub(/^"|"$/,"",c);
    print "- " f "  (EOF=" e ", CAN=" c ")"
  }' "$OUT_CSV"
  echo
  echo "## Top archivos con más errores"
  echo
  echo "| # errores | archivo | errores |"
  echo "|----------:|---------|---------|"
} >> "$OUT_MD"

# Construcción Top-N desde CSV
awk -F',' 'NR>1{
  f=$1; errs=$11; gsub(/^"|"$/,"",f); gsub(/^"|"$/,"",errs);
  n=0; if(length(errs)>0){ split(errs,a,";"); n=length(a); }
  print n "\t" f "\t" errs;
}' "$OUT_CSV" \
| sort -nr \
| head -n "$TOP_N" \
| while IFS=$'\t' read -r n f errs; do
    (( n > 0 )) && printf '| %d | `%s` | %s |\n' "$n" "$f" "$errs" >> "$OUT_MD"
  done

echo "Informe Markdown (apéndice): $OUT_MD"
echo "----------------------------------------"
# Fin
