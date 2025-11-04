#!/usr/bin/env bash
# QEL — Resolver/normalizar SoT a partir de ListadoR, PREH-NAV y reglas de ruta/nombre
# Reporta UNCLASSIFIED (incluye los ya existentes) y genera informe Markdown (append) + CSV.
# Uso:
#   bash scripts/qel_sot_resolve.sh                          # dry-run
#   APPLY=1 bash scripts/qel_sot_resolve.sh                  # aplica cambios
#   FIX_CANONICAL=1 APPLY=1 bash scripts/qel_sot_resolve.sh  # canoniza SoT existentes
#   UPDATE_LISTADOR=1 APPLY=1 bash scripts/qel_sot_resolve.sh# escribe SoT en ListadoR (policy)
set -euo pipefail
export LC_ALL=C

# ---------- CONFIG ----------
ROOTS="${DOCS_DIRS:-docs:memory:README:pub}"
EXCLUDE_DIRS="${EXCLUDE_DIRS:-.git:node_modules:scripts:tools:out:apps/*/src:apps/*/scripts:apps/*/dist:apps/*/build}"
INCLUDE_EXT="${INCLUDE_EXT:-md,MD}"

LISTADOR="${LISTADOR:-docs/core/QEL_ListadoR_master_v1.0.md}"
LISTADOR_POLICY="${LISTADOR_POLICY:-soft}"   # keep | soft | force

APPLY="${APPLY:-0}"
FIX_CANONICAL="${FIX_CANONICAL:-0}"
UPDATE_LISTADOR="${UPDATE_LISTADOR:-0}"

USE_PREHNAV="${USE_PREHNAV:-0}"
PREHNAV_MANIFEST="${PREHNAV_MANIFEST:-apps/preh-nav-m1/public/sot-manifest.json}"

# Nuevo: reportar también los SoT ya marcados como UNCLASSIFIED (sin cambiarlos)
REPORT_EXISTING_UNCLASSIFIED="${REPORT_EXISTING_UNCLASSIFIED:-1}"

OUT_DIR="${OUT_DIR:-out}"
mkdir -p "$OUT_DIR"
SOT_REPORT="${SOT_REPORT:-$OUT_DIR/qel_sot_resolve_report.md}"
SOT_UNCLASSIFIED_CSV="${SOT_UNCLASSIFIED_CSV:-$OUT_DIR/qel_sot_unclassified.csv}"

# ---------- FIND (idéntico a auditoría) ----------
find_newline() {
  IFS=': ' read -r -a ROOT_ARR <<< "$ROOTS"
  IFS=': ' read -r -a EXCS     <<< "$EXCLUDE_DIRS"
  IFS=','   read -r -a EXTS     <<< "$INCLUDE_EXT"

  local name_expr=()
  for ext in "${EXTS[@]}"; do name_expr+=( -name "*.${ext}" -o ); done
  [[ ${#name_expr[@]} -gt 0 ]] && unset 'name_expr[${#name_expr[@]}-1]'

  for root in "${ROOT_ARR[@]}"; do
    [[ -d "$root" ]] || continue
    local excl=( -path "*/apps/*/public/docs/*" )
    for p in "${EXCS[@]}"; do
      excl+=( -o -path "*/${p}/*" )
      excl+=( -o -path "${p}/*" )
    done
    find "$root" \
      \( "${excl[@]}" \) -prune -o \
      \( -type f \( "${name_expr[@]}" \) -print \)
  done
}
find_null(){ find_newline | tr '\n' '\0'; }

# ---------- Helpers de lectura/escritura ----------
get_field(){ local f="$1" k="$2" line; line=$(grep -m1 -E "^${k}=" "$f" 2>/dev/null || true); echo "${line#${k}=}"; }

write_kv() {
  local file="$1" key="$2" val="$3"
  local tmp; tmp="$(mktemp)"
  awk -v K="$key" -v V="$val" '
    BEGIN { done=0 }
    $0 ~ ("^" K "=") && done==0 { print K "=" V; done=1; next }
    { lines[NR]=$0; n=NR }
    END {
      if (done==1) {
        for (i=1;i<=n;i++) print lines[i]
      } else {
        insert_at=0
        for (i=1;i<=n;i++) if (lines[i] ~ /^SeedI=/) { insert_at=i; break }
        if (insert_at>0) {
          for (i=1;i<=n;i++) { print lines[i]; if (i==insert_at) print K "=" V }
        } else {
          print K "=" V
          for (i=1;i<=n;i++) print lines[i]
        }
      }
    }
  ' "$file" > "$tmp" && mv "$tmp" "$file"
}
write_sot(){ write_kv "$1" "SoT" "$2"; }

# ---------- Canon + fuentes ----------
canonize_sot(){
  local s="${1// /}"; s="$(echo "$s" | sed -E 's#/v[0-9]+(\.[0-9]+)*$##I')"
  s="$(echo "$s" | tr '[:lower:]' '[:upper:]')"
  s="$(echo "$s" | sed -E 's#^PE$#PE/POEMA-ENIGMA#')"
  echo "$s"
}

infer_sot_by_path(){
  local f="$1" bn
  case "$f" in
    # CORE
    docs/core/manuales/*|memory/archive/*Manual*.md|memory/archive/QEL_Manual_*.md|pub/manuales/*) echo "CORE/MANUAL"; return;;
    docs/core/atlas/*|memory/archive/*Atlas*.md|memory/archive/*Tarjetas_Atlas*.md|pub/atlas/*)    echo "CORE/ATLAS"; return;;
    docs/core/diarios/*|memory/archive/*Diario_del_Conjurador*.md)                                echo "CORE/DIARIO"; return;;
    docs/core/indices/*)                                                                          echo "CORE/INDICE"; return;;
    memory/listador/*ListadoR*.md|memory/listador/*Listado*.md)                                   echo "CORE/LISTADOR"; return;;
    memory/archive/*Glosario*.md)                                                                 echo "CORE/GLOSARIO"; return;;
    memory/archive/*Lamina_V*.md|memory/archive/*Lámina_V*.md)                                   echo "CORE/LAMINA"; return;;
    memory/archive/*SoT_Manifest*.json)                                                           echo "CORE/SOT-MANIFEST"; return;;

    # RITUAL
    docs/ritual/vf/*)                                                                             echo "RITUAL/VF/PRIMA"; return;;
    docs/ritual/microsellos/*)                                                                    echo "RITUAL/MICROSELLO"; return;;
    docs/ritual/cuemachine/*|*/QEL_CueMachineA96_*.txt)                                           echo "RITUAL/CUEMACHINE"; return;;
    memory/cue-recovery/*|pub/cue-recovery/*)                                                     echo "RITUAL/CUE-RECOVERY"; return;;
    docs/ritual/*Meditacion*|docs/ritual/*Meditaciones*)                                          echo "RITUAL/MEDITACION"; return;;

    # NUTRIA / PE / HABILIDADES / FS
    docs/nutria/*|pub/ecri/*)                                                                     echo "NUTRIA/TEXTO"; return;;
    docs/pe/PE*.md)                                                                               echo "PE/POEMA-ENIGMA"; return;;
    docs/habilidades/*)                                                                           echo "HABILIDAD/LLAVE"; return;;
    docs/fs/*.json)                                                                               echo "FS/SESSION"; return;;

    # READMEs
    README/*.md|*/README_*.md)                                                                    echo "DOC/README"; return;;
  esac
  bn="$(basename "$f")"
  case "$bn" in
    QEL_MicroSello_*.md) echo "RITUAL/MICROSELLO"; return;;
    QEL_Sello_*.md)      echo "RITUAL/SELLO"; return;;
    QEL_VF_PRIMA_*.md)   echo "RITUAL/VF/PRIMA"; return;;
  esac
  echo ""
}

sot_from_listador(){
  local f="$1" bn ln s e block sot
  bn="$(basename "$f")"
  ln=$(grep -n -F "$bn" "$LISTADOR" 2>/dev/null | head -n1 | cut -d: -f1 || true)
  [[ -z "$ln" ]] && { echo ""; return; }
  s=$(( ln>2 ? ln-2 : 1 )); e=$(( ln+2 ))
  block="$(sed -n "${s},${e}p" "$LISTADOR")"
  sot="$(echo "$block" | grep -m1 -E '^SoT=' | sed -E 's/^SoT=//')"
  [[ -z "${sot//[[:space:]]/}" || "$sot" == "UNSET" ]] && { echo ""; return; }
  echo "$sot"
}

sot_from_prehnav(){
  [[ "$USE_PREHNAV" != "1" ]] && { echo ""; return; }
  [[ ! -f "$PREHNAV_MANIFEST" ]] && { echo "WARN_PREHNAV"; return; }
  local f="$1" bn; bn="$(basename "$f")"
  if command -v jq >/dev/null 2>&1; then
    jq -r --arg f "$f" --arg bn "$bn" '
      .. | objects | select(has("sot"))
      | select((.path?==$f) or (.file?==$bn) or (.basename?==$bn) or (.name?==$bn))
      | .sot
    ' "$PREHNAV_MANIFEST" 2>/dev/null | head -n1
  else
    awk -v BN="$bn" '
      BEGIN{IGNORECASE=1}
      {buf[NR]=$0}
      END{
        for(i=1;i<=NR;i++){
          if(index(buf[i], BN)){
            for(j=i-3;j<=i+3;j++){
              if(j>=1 && j<=NR){
                if(match(buf[j], /"sot"[[:space:]]*:[[:space:]]*"([^"]+)"/, m)){ print m[1]; exit }
              }
            }
          }
        }
      }' "$PREHNAV_MANIFEST"
  fi
}

# ---------- ListadoR (update en ventana) ----------
update_listador_block(){
  local f="$1" ns="$2" bn ln s e cur
  [[ "${UPDATE_LISTADOR}" != "1" ]] && return 0
  [[ ! -f "$LISTADOR" ]] && return 0
  bn="$(basename "$f")"
  ln=$(grep -n -F "$bn" "$LISTADOR" 2>/dev/null | head -n1 | cut -d: -f1 || true)
  [[ -z "$ln" ]] && return 0
  s=$(( ln>2 ? ln-2 : 1 )); e=$(( ln+2 ))
  cur="$(sed -n "${s},${e}p" "$LISTADOR" | awk -F= '/^SoT=/{print $2; exit}')"
  cur="${cur:-}"; [[ -z "${cur//[[:space:]]/}" ]] && cur=""
  case "$LISTADOR_POLICY" in
    keep|soft|*) [[ -n "$cur" && "$cur" != "UNSET" ]] && return 0 ;;
    force) : ;;
  esac
  if [[ "${APPLY}" != "1" ]]; then
    echo "[LISTADOR] $(basename "$f") :: '${cur:-∅}' -> '${ns}' (policy=${LISTADOR_POLICY})"
    return 0
  fi
  if sed -n "${s},${e}p" "$LISTADOR" | grep -q -m1 -E '^SoT='; then
    awk -v S="$s" -v E="$e" -v NS="$ns" '
      NR<S || NR>E { print; next }
      { gsub(/^SoT=.*/,"SoT="NS); print }
    ' "$LISTADOR" > "$LISTADOR.tmp" && mv "$LISTADOR.tmp" "$LISTADOR"
  else
    awk -v S="$s" -v E="$e" -v NS="$ns" '
      NR<S || NR>E { print; next }
      { print; if ($0 ~ /^SeedI=/) print "SoT=" NS }
    ' "$LISTADOR" > "$LISTADOR.tmp" && mv "$LISTADOR.tmp" "$LISTADOR"
  fi
}

# ---------- Acumuladores ----------
scanned=0; changes=0
resolved_listador=0; resolved_prehnav=0; resolved_path=0; resolved_canon=0
unclassified_count=0; declare -a unclassified_list=()

warned_prehnav_missing=0

# ---------- Recorrido principal (sin subshell: process substitution) ----------
while IFS= read -r -d '' f; do
  scanned=$((scanned+1))
  cur="$(get_field "$f" "SoT" || true)"
  cur_trim="${cur//[[:space:]]/}"

  # Reportar UNCLASSIFIED ya existentes (sin tocarlos)
  if [[ "$REPORT_EXISTING_UNCLASSIFIED" == "1" && "$cur_trim" == "UNCLASSIFIED" ]]; then
    unclassified_count=$((unclassified_count+1))
    unclassified_list+=("$f")
    continue
  fi

  act=0; reason=""
  if [[ -z "$cur_trim" || "$cur_trim" == "UNSET" ]]; then
    act=1; reason="missing_or_unset"
  elif [[ "${FIX_CANONICAL}" = "1" ]]; then
    if ! echo "$cur_trim" | grep -Eq '^[A-Z0-9_./-]+$' || echo "$cur_trim" | grep -Eq '/v[0-9]'; then
      act=1; reason="noncanonical"
    fi
  fi
  [[ "$act" = "0" ]] && continue

  src=""; cand=""

  # 1) ListadoR
  cand="$(sot_from_listador "$f")"
  if [[ -n "$cand" ]]; then cand="$(canonize_sot "$cand")"; src="LISTADOR"; fi

  # 1.5) PREH-NAV
  if [[ -z "$cand" ]]; then
    cand="$(sot_from_prehnav "$f" || true)"
    if [[ "$cand" == "WARN_PREHNAV" ]]; then
      if [[ "$warned_prehnav_missing" -eq 0 ]]; then
        echo "WARN: PREH-NAV manifest no encontrado en '$PREHNAV_MANIFEST' (USE_PREHNAV=1)." >&2
        warned_prehnav_missing=1
      fi
      cand=""
    fi
    if [[ -n "$cand" ]]; then cand="$(canonize_sot "$cand")"; src="PREHNAV"; fi
  fi

  # 2) Reglas por ruta/nombre
  if [[ -z "$cand" ]]; then cand="$(infer_sot_by_path "$f")"; [[ -n "$cand" ]] && src="PATH"; fi

  # 2.5) Canonizar existente (si procede)
  if [[ -z "$cand" && -n "$cur_trim" && "${FIX_CANONICAL}" = "1" ]]; then
    canon="$(canonize_sot "$cur_trim")"
    if [[ "$canon" != "$cur_trim" ]]; then cand="$canon"; src="CANON"; fi
  fi

  # 3) Si sigue vacío → UNCLASSIFIED
  if [[ -z "$cand" ]]; then cand="UNCLASSIFIED"; src="UNCLASSIFIED"; fi

  cand="$(canonize_sot "$cand")"
  [[ "$cur_trim" == "$cand" ]] && continue

  echo "[SOT] $reason :: $(basename "$f") :: '${cur_trim:-∅}'  ->  '${cand}'  [via ${src}]"

  case "$src" in
    LISTADOR) resolved_listador=$((resolved_listador+1));;
    PREHNAV)  resolved_prehnav=$((resolved_prehnav+1));;
    PATH)     resolved_path=$((resolved_path+1));;
    CANON)    resolved_canon=$((resolved_canon+1));;
    UNCLASSIFIED)
      unclassified_count=$((unclassified_count+1))
      unclassified_list+=("$f")
      ;;
  esac

  if [[ "${APPLY}" == "1" && "$src" != "UNCLASSIFIED" ]]; then
    write_sot "$f" "$cand"
    update_listador_block "$f" "$cand"
    changes=$((changes+1))
  else
    : # DRY-RUN o UNCLASSIFIED → no tocar archivos
  fi
done < <(find_null)

# ---------- Reporte (append) ----------
ts="$(date '+%Y-%m-%d %H:%M:%S')"
{
  echo "## QEL · SoT Resolve — $ts"
  echo
  echo "- ROOTS: \`$ROOTS\`"
  echo "- EXCLUDE_DIRS: \`$EXCLUDE_DIRS\`"
  echo "- INCLUDE_EXT: \`$INCLUDE_EXT\`"
  echo "- LISTADOR: \`$LISTADOR\` (policy=\`$LISTADOR_POLICY\`)"
  echo "- USE_PREHNAV=\`$USE_PREHNAV\` · PREHNAV_MANIFEST: \`$PREHNAV_MANIFEST\`"
  echo "- APPLY=\`$APPLY\` · FIX_CANONICAL=\`$FIX_CANONICAL\` · UPDATE_LISTADOR=\`$UPDATE_LISTADOR\`"
  echo "- REPORT_EXISTING_UNCLASSIFIED=\`$REPORT_EXISTING_UNCLASSIFIED\`"
  echo
  echo "**Métricas**"
  echo "- Archivos escaneados: **$scanned**"
  echo "- Cambios (aplicados o en dry-run): **$changes**"
  echo "- Resueltos por ListadoR: **$resolved_listador**"
  echo "- Resueltos por PREH-NAV: **$resolved_prehnav**"
  echo "- Resueltos por reglas de ruta: **$resolved_path**"
  echo "- Sólo canonizados: **$resolved_canon**"
  echo "- **UNCLASSIFIED** (incluye ya existentes): **$unclassified_count**"
  echo
  if (( unclassified_count > 0 )); then
    echo "### UNCLASSIFIED (pendientes)"
    echo "| # | archivo | basename | carpeta |"
    echo "|-:|---------|----------|---------|"
    idx=0
    for uf in "${unclassified_list[@]}"; do
      idx=$((idx+1)); bn="$(basename "$uf")"; dir="$(dirname "$uf")"
      echo "| $idx | \`$uf\` | \`$bn\` | \`$dir\` |"
    done
    echo
  fi
  echo "---"
  echo
} >> "$SOT_REPORT"

# CSV de UNCLASSIFIED (append)
if (( unclassified_count > 0 )); then
  [[ -f "$SOT_UNCLASSIFIED_CSV" ]] || echo "file,basename,dir,ts" > "$SOT_UNCLASSIFIED_CSV"
  for uf in "${unclassified_list[@]}"; do
    bn="$(basename "$uf")"; dir="$(dirname "$uf")"
    printf '"%s","%s","%s","%s"\n' "$uf" "$bn" "$dir" "$ts" >> "$SOT_UNCLASSIFIED_CSV"
  done
fi

# Epílogo
if [[ "${APPLY}" == "1" ]]; then
  echo "Hecho. Archivos actualizados: $changes"
else
  echo "Dry-run. Archivos a actualizar: $changes (usa APPLY=1 para aplicar)."
fi
echo "Reporte SoT (append): $SOT_REPORT"
(( unclassified_count > 0 )) && echo "UNCLASSIFIED CSV (append): $SOT_UNCLASSIFIED_CSV"
