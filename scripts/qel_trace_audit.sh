#!/usr/bin/env bash
# QEL — Auditoría de Traza (E1–E12) + métricas IT/TC/TI/TT/UH
# Uso: scripts/qel_trace_audit.sh
# Reqs: bash, grep, sed, awk, sort, uniq, find, mktemp. (jq opcional)

set -euo pipefail
export LC_ALL=C

# =========================
# CONFIG (ajustables por env)
# =========================
ROOT="${ROOT:-.}"
# Raíces a auditar (multi-ruta: separador ":" o espacios)
DOCS_DIRS="${DOCS_DIRS:-docs:memory:README:pub}"

# Directorios a excluir (separador ":" o espacios; se hace prune)
EXCLUDE_DIRS="${EXCLUDE_DIRS:-.git:node_modules:scripts:tools:out:apps/*/src:apps/*/scripts:apps/*/dist:apps/*/build}"

# Extensiones a incluir (separadas por coma). Ej: "md,MD,txt"
INCLUDE_EXT="${INCLUDE_EXT:-md,MD}"

# Ruta real de tu ListadoR
LISTADOR="${LISTADOR:-docs/core/QEL_ListadoR_master_v1.0.md}"

ATLAS_JSONL="${ATLAS_JSONL:-docs/core/atlas_microreg_v1.0.jsonl}"
PUBLIC_DIR="${PUBLIC_DIR:-apps/preh-nav-m1/public/docs}"   # Carpeta de exposición pública
CHECK_PUBLIC="${CHECK_PUBLIC:-0}"               # 1 = activar E10; 0 = desactivar (default)
OUT_DIR="${OUT_DIR:-out}"
OUT_CSV="${OUT_DIR}/qel_trace_report.csv"
OUT_MD="${OUT_DIR}/qel_trace_report.md"
TOP_N="${TOP_N:-20}"                            # Máx. archivos en el "top errores"

# Para no spamear el WARN del ListadoR:
WARNED_LISTADOR=0

# Patrones de archivos a auditar (MD dentro de docs/, excluyendo public/docs)
FIND_GLOBS=("-type" "f" "-name" "*.md" ! -path "${PUBLIC_DIR}/*")

# ===== Progreso (visible, sin sacrificar chequeos) =====
PROGRESS_EVERY="${PROGRESS_EVERY:-200}"  # refresco de línea de estado
SPIN_CHARS='-\|/'
SPIN_IDX=0
START_TS="$(date +%s)"

sec_hms () {
  local s="${1:-0}"; (( s < 0 )) && s=0
  printf "%02d:%02d:%02d" $((s/3600)) $(((s%3600)/60)) $((s%60))
}
progress_line () {
  local scanned="$1"; local current="${2:-}"
  local now elapsed eta pct spin bn
  SPIN_IDX=$(( (SPIN_IDX + 1) % 4 )); spin="${SPIN_CHARS:$SPIN_IDX:1}"
  now="$(date +%s)"; elapsed=$(( now - START_TS ))

  # Estimar total con el mismo find (sin -print0)
  # Nota: lo calculamos una sola vez y lo memorizamos con variable global.
  if [[ -z "${TOTAL_CANDIDATES:-}" ]]; then
    TOTAL_CANDIDATES="$(find "$DOCS_DIRS" "${FIND_GLOBS[@]}" | wc -l | awk '{print $1}')"
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

# ==============
# Utilidades
# ==============
mkdir -p "${OUT_DIR}"

has_jq=0
if command -v jq >/dev/null 2>&1; then has_jq=1; fi

# Normaliza fecha a YYYYMMDD (acepta YYYY-MM-DD o YYMMDD). Devuelve "" si no parsea.
to_yyyymmdd() {
  local s="$1"
  if [[ "$s" =~ ^20[0-9]{2}-[01][0-9]-[0-3][0-9]$ ]]; then
    echo "${s//-/}"
  elif [[ "$s" =~ ^[0-9]{6}$ ]]; then
    # Asumimos YYMMDD -> 20YYMMDD
    echo "20${s}"
  elif [[ "$s" =~ ^20[0-9]{6}$ ]]; then
    echo "$s"
  else
    echo ""
  fi
}

# Extrae primera coincidencia KEY=... (literal) de un archivo
get_field() {
  local file="$1"; local key="$2"
  local line
  line=$(grep -m1 -E "^${key}=" "$file" 2>/dev/null || true)
  echo "${line#${key}=}"
}

# Extrae CUE (línea [QEL::ECO[..]::RECALL ...])
has_cue() {
  local file="$1"
  grep -qm1 -E '^\[QEL::ECO\[[0-9]+\]::RECALL .+\]' "$file"
}
# Construye un find que:
#  - recorre múltiples raíces
#  - hace prune de EXCLUDE_DIRS
#  - incluye archivos con extensiones de INCLUDE_EXT
#  - excluye apps/.../public/docs (duplicados)
find_target_files() {
  IFS=': ' read -r -a ROOTS <<< "$DOCS_DIRS"
  IFS=': ' read -r -a EXCS  <<< "$EXCLUDE_DIRS"

  # prepara patrón de extensiones: -name "*.md" -o -name "*.MD" ...
  IFS=',' read -r -a EXTS <<< "$INCLUDE_EXT"
  local name_expr=()
  for ext in "${EXTS[@]}"; do
    name_expr+=( -name "*.${ext}" -o )
  done
  # quita el último -o
  [[ ${#name_expr[@]} -gt 0 ]] && unset 'name_expr[${#name_expr[@]}-1]'

  for root in "${ROOTS[@]}"; do
    [[ -d "$root" ]] || continue
    find "$root" \
      \( -type d \( \
        -path "*/apps/*/public/docs" -o \
        $(printf ' -path "%s" -o' "${EXCS[@]}") -false \
      \) -prune \) -o \
      \( -type f \( "${name_expr[@]}" \) -print0 \)
  done
}

# Obtiene HASH(10) de la última línea (si cumple regex)
get_hash10_eof() {
  local file="$1"
  local last
  last=$(tail -n1 "$file" | tr -d '\r' || true)
  if [[ "$last" =~ ^[0-9a-f]{10}$ ]]; then
    echo "$last"
  else
    echo ""
  fi
}

# Busca presencia en ListadoR por basename
listador_find_block() {
  local file="$1"
  local bn ln start end
  bn="$(basename "$file")"
  ln=$(grep -n -F "$bn" "$LISTADOR" 2>/dev/null | head -n1 | cut -d: -f1 || true)
  if [[ -z "$ln" ]]; then
    return 1
  fi
  start=$(( ln>2 ? ln-2 : 1 ))
  end=$(( ln+2 ))
  sed -n "${start},${end}p" "$LISTADOR"
  return 0
}

# Extrae campos SoT/Version/Updated/SeedI de un bloque de ListadoR (si existieran)
extract_meta_from_block() {
  local block="$1" key="$2"
  echo "$block" | grep -m1 -E "^${key}=" | sed -E "s/^${key}=//" || true
}

# Intenta extraer ruta docs/...md desde el bloque
extract_path_from_block() {
  local block="$1"
  echo "$block" | grep -Eo 'docs/[A-Za-z0-9_./-]+\.md' | head -n1 || true
}

# Busca entrada en Atlas por FILE (requiere misma ruta exacta que pasó el microreg)
atlas_has_file() {
  local file="$1"
  if [[ ! -f "$ATLAS_JSONL" ]]; then
    echo "SKIP" # no contamos E9 si no hay Atlas
    return 0
  fi
  if [[ $has_jq -eq 1 ]]; then
    if jq -e --arg f "$file" 'select(.FILE==$f)' "$ATLAS_JSONL" >/dev/null; then
      echo "YES"
    else
      echo "NO"
    fi
  else
    if grep -F -q "\"FILE\":\"$file\"" "$ATLAS_JSONL"; then
      echo "YES"
    else
      # Fallback: buscar por basename si las rutas difieren en prefijo
      local bn
      bn="$(basename "$file")"
      if grep -F -q "$bn" "$ATLAS_JSONL"; then
        echo "MAYBE" # encontrado por basename
      else
        echo "NO"
      fi
    fi
  fi
}

# Checa exposición pública (E10) por basename
is_exposed_public() {
  local file="$1"
  local bn
  bn="$(basename "$file")"
  [[ -f "${PUBLIC_DIR}/${bn}" ]]
}

# ============
# Acumuladores
# ============
total_files=0
e1=0; e2=0; e3=0; e4=0; e5=0; e6=0; e7=0; e8=0; e9=0; e10=0; e11=0; e12=0
skipped_atlas=0

TMP_HASHMAP="$(mktemp)"; trap 'rm -f "$TMP_HASHMAP"' EXIT

# CSV header
echo "file,SeedI,SoT,Version,Updated,HASH10,errors" > "$OUT_CSV"

# ============
# Escaneo
# ============
# shellcheck disable=SC2044
while IFS= read -r -d '' f; do
  total_files=$((total_files+1))
  errors=()

  # Progreso visible cada PROGRESS_EVERY archivos
  if (( total_files % PROGRESS_EVERY == 0 )); then
    progress_line "$total_files" "$f"
  fi

  SeedI="$(get_field "$f" "SeedI")"
  SoT="$(get_field "$f" "SoT")"
  Version="$(get_field "$f" "Version")"
  Updated="$(get_field "$f" "Updated")"
  CUE_OK=0; has_cue "$f" && CUE_OK=1

  # E1: front-matter incompleto
  if [[ -z "$SeedI" || -z "$SoT" || -z "$Version" || -z "$Updated" ]]; then
    errors+=("E1"); e1=$((e1+1))
  fi

  # E12: CUE ausente
  if [[ $CUE_OK -eq 0 ]]; then
    errors+=("E12"); e12=$((e12+1))
  fi

  # E2: HASH en EOF
  HASH10="$(get_hash10_eof "$f")"
  if [[ -z "$HASH10" ]]; then
    errors+=("E2"); e2=$((e2+1))
  else
    printf '%s\t%s\n' "$HASH10" "$f" >> "$TMP_HASHMAP"
  fi

  # E11: SoT canónico (heurístico simple)
  if ! echo "$SoT" | grep -Eq '^[A-Z0-9_./-]+$'; then
    if [[ -n "$SoT" ]]; then
      errors+=("E11"); e11=$((e11+1))
    fi
  fi

  # Cruces con ListadoR
  if [[ -f "$LISTADOR" ]]; then
    block="$(listador_find_block "$f" || true)"
    if [[ -z "${block:-}" ]]; then
      # E8: sin presencia en ListadoR
      errors+=("E8"); e8=$((e8+1))
    else
      # E6: ruta discordante (si logra extraer una ruta)
      path_lr="$(extract_path_from_block "$block" || true)"
      if [[ -n "$path_lr" && "$path_lr" != "$f" ]]; then
        errors+=("E6"); e6=$((e6+1))
      fi

      # E4/E5: desalineaciones SeedI/SoT/Version/Updated (solo si se extraen)
      SeedI_lr="$(extract_meta_from_block "$block" "SeedI" || true)"
      SoT_lr="$(extract_meta_from_block "$block" "SoT" || true)"
      Version_lr="$(extract_meta_from_block "$block" "Version" || true)"
      Updated_lr="$(extract_meta_from_block "$block" "Updated" || true)"

      if [[ -n "$SeedI_lr" && -n "$SeedI" && "$SeedI_lr" != "$SeedI" ]]; then
        errors+=("E4"); e4=$((e4+1))
      fi

      local_e5=0
      if [[ -n "$SoT_lr" && -n "$SoT" && "$SoT_lr" != "$SoT" ]]; then local_e5=1; fi
      if [[ -n "$Version_lr" && -n "$Version" && "$Version_lr" != "$Version" ]]; then local_e5=1; fi
      if [[ -n "$Updated_lr" && -n "$Updated" && "$Updated_lr" != "$Updated" ]]; then local_e5=1; fi
      if [[ $local_e5 -eq 1 ]]; then errors+=("E5"); e5=$((e5+1)); fi

      # E7: temporalidad no monótona (Updated < máximo histórico en ListadoR)
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
        u_file="$(to_yyyymmdd "$Updated")"
        if [[ -n "$u_file" && -n "$updates" ]]; then
          u_max=""
          while IFS= read -r u; do
            uu="$(to_yyyymmdd "$u")"
            if [[ -n "$uu" ]]; then
              if [[ -z "$u_max" || "$uu" > "$u_max" ]]; then u_max="$uu"; fi
            fi
          done <<< "$updates"
          if [[ -n "$u_max" && "$u_file" < "$u_max" ]]; then
            errors+=("E7"); e7=$((e7+1))
          fi
        fi
      fi
    fi
  else
    # Sólo avisar una vez que no hay ListadoR
    if [[ $WARNED_LISTADOR -eq 0 ]]; then
      echo "WARN: No se encontró ListadoR en '$LISTADOR' — se omiten E4,E5,E6,E7,E8." >&2
      WARNED_LISTADOR=1
    fi
  fi

  # Atlas (E9)
  atlas_state="$(atlas_has_file "$f")"
  if [[ "$atlas_state" == "SKIP" ]]; then
    skipped_atlas=$((skipped_atlas+1))
  else
    if [[ "$atlas_state" == "NO" ]]; then
      errors+=("E9"); e9=$((e9+1))
    fi
    # "MAYBE" no suma error
  fi

  # Exposición pública (E10) — opcional
  if [[ "$CHECK_PUBLIC" == "1" ]]; then
    if ! is_exposed_public "$f"; then
      errors+=("E10"); e10=$((e10+1))
    fi
  fi

  # Emitir fila CSV
  joined="$(IFS=';'; echo "${errors[*]:-}")"
  printf '"%s","%s","%s","%s","%s","%s","%s"\n' \
    "$f" "$SeedI" "$SoT" "$Version" "$Updated" "$HASH10" "$joined" >> "$OUT_CSV"

done < <(find_target_files)

# Cierra la línea de progreso y salta de línea
if (( total_files > 0 )); then
  progress_line "$total_files" ""
fi
echo >&2

# E3: HASH duplicados (tras recorrer todos los archivos)
if [[ -s "$TMP_HASHMAP" ]]; then
  # Cuenta por HASH
  dup_count=$(awk '{cnt[$1]++} END{c=0; for(h in cnt){if(cnt[h]>1)c+=cnt[h];} print c}' "$TMP_HASHMAP")
  if [[ "${dup_count:-0}" -gt 0 ]]; then
    e3=$((e3+dup_count))
    # Marcar en CSV las filas con esos HASH duplicados (añade E3)
    awk -F',' -v OFS=',' -v map="$TMP_HASHMAP" '
      BEGIN{
        while ((getline < map) > 0) {
          split($0,a,"\t");
          h[a[1]] = h[a[1]] ? h[a[1]] ";" a[2] : a[2];
          cnt[a[1]]++;
        }
      }
      NR==1 { print; next }
      {
        col6=$6; gsub(/^"|"$/,"",col6)  # HASH10
        hash=col6
        if (hash in cnt && cnt[hash] > 1) {
          col7=$7; gsub(/^"|"$/,"",col7)
          errs=col7
          if (errs=="") { errs="E3" }
          else if (errs !~ /(^|;)E3(;$|$)/) { errs=errs ";E3" }
          $7="\"" errs "\""
        }
        print
      }' "$OUT_CSV" > "${OUT_CSV}.tmp" && mv "${OUT_CSV}.tmp" "$OUT_CSV"
  fi
fi

# ==========================
# Métricas y resumen global
# ==========================
N="$total_files"
tc_bad=$((e1+e2+e8+e9+e10))
ti_bad=$((e4+e5+e6+e12))
tt_bad=$((e7))
uh_bad=$((e3))

float_div() { awk -v a="$1" -v b="$2" 'BEGIN{if(b==0)print "1.0000"; else printf "%.4f", (a<0?0:a)/b}' ; }
float_one_minus() { awk -v x="$1" 'BEGIN{printf "%.4f", 1.0 - x}' ; }
float_weighted() { awk -v tc="$1" -v ti="$2" -v tt="$3" -v uh="$4" 'BEGIN{printf "%.4f", 0.40*tc + 0.30*ti + 0.20*tt + 0.10*uh}' ; }

TC="$(float_one_minus "$(float_div "$tc_bad" "$N")")"
TI="$(float_one_minus "$(float_div "$ti_bad" "$N")")"
TT="$(float_one_minus "$(float_div "$tt_bad" "$N")")"
UH="$(float_one_minus "$(float_div "$uh_bad" "$N")")"
IT="$(float_weighted "$TC" "$TI" "$TT" "$UH")"

echo "----------------------------------------"
echo "QEL · Auditoría de Traza"
echo "Archivos auditados: $N"
echo "TC (Traza-Completitud): $TC"
echo "TI (Integridad cruzada): $TI"
echo "TT (Temporalidad): $TT"
echo "UH (Unicidad HASH): $UH"
echo "IT (Índice Global, 0–1): $IT"
echo "----------------------------------------"
printf "E1=%d  E2=%d  E3=%d  E4=%d  E5=%d  E6=%d  E7=%d  E8=%d  E9=%d  E10=%d  E11=%d  E12=%d\n" \
  "$e1" "$e2" "$e3" "$e4" "$e5" "$e6" "$e7" "$e8" "$e9" "$e10" "$e11" "$e12"

if [[ "$skipped_atlas" -gt 0 ]]; then
  echo "Nota: Atlas no encontrado — se omitieron E9 en $skipped_atlas archivo(s). (Ajusta ATLAS_JSONL si aplica)"
fi
if [[ "$CHECK_PUBLIC" != "1" ]]; then
  echo "Nota: E10 desactivado (CHECK_PUBLIC=0). Exporta CHECK_PUBLIC=1 para validar exposición pública por basename."
fi
echo "CSV detallado: $OUT_CSV"

# ==========================
# Informe Markdown (APPEND con fecha)
# ==========================
REPORT_TS="$(date '+%Y-%m-%d %H:%M:%S %Z')"

{
  echo ""
  echo "---"
  echo ""
  echo "### Informe generado: ${REPORT_TS}"
  echo ""
  echo "# QEL · Informe de Trazabilidad"
  echo
  echo "- **Archivos auditados:** $N"
  echo "- **TC (Traza-Completitud):** $TC"
  echo "- **TI (Integridad cruzada):** $TI"
  echo "- **TT (Temporalidad):** $TT"
  echo "- **UH (Unicidad HASH):** $UH"
  echo "- **IT (Índice global de Traza):** $IT"
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
  echo "## Top archivos con más errores"
  echo
  echo "| # errores | archivo | errores |"
  echo "|----------:|---------|---------|"
} >> "$OUT_MD"

# Construir tabla de top archivos a partir del CSV (comando separado del AWK previo)
awk -F',' '
NR>1 {
  f=$1; errs=$7;
  gsub(/^"|"$/,"",f);
  gsub(/^"|"$/,"",errs);
  n=0;
  if (length(errs)>0) { split(errs,a,";"); n=length(a); }
  print n "\t" f "\t" errs;
}' "$OUT_CSV" \
| sort -nr \
| head -n "$TOP_N" \
| while IFS=$'\t' read -r n f errs; do
    if [[ "$n" -gt 0 ]]; then
      printf '| %d | `%s` | %s |\n' "$n" "$f" "$errs" >> "$OUT_MD"
    fi
  done

echo "Informe Markdown: $OUT_MD"
echo "----------------------------------------"
# Fin
