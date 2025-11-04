#!/usr/bin/env bash
# QEL — Autofix de Traza (E1, E2, E6, E8, E11) + progreso
# Uso:
#   bash scripts/qel_trace_autofix.sh                 # dry-run (no escribe)
#   APPLY=1 bash scripts/qel_trace_autofix.sh         # aplica cambios
# Flags útiles:
#   DOCS_DIRS="docs:memory:README:pub"                # raíces a auditar
#   EXCLUDE_DIRS=".git:node_modules:scripts:out:apps/*/src:apps/*/scripts:apps/*/dist"
#   INCLUDE_EXT="md,MD,txt"                           # extensiones
#   LISTADOR="docs/core/QEL_ListadoR_master_v1.0.md"  # ruta ListadoR
#   ADD_CUE=1                                         # genera CUE si falta
#   ATLAS_ADD=0                                       # (placeholder – sin implementar)

set -euo pipefail

# =========================
# CONFIG
# =========================
APPLY="${APPLY:-0}"
ADD_CUE="${ADD_CUE:-0}"
ATLAS_ADD="${ATLAS_ADD:-0}"  # reservado

DOCS_DIRS="${DOCS_DIRS:-docs:memory:README:pub}"
EXCLUDE_DIRS="${EXCLUDE_DIRS:-.git:node_modules:scripts:tools:out:apps/*/src:apps/*/scripts:apps/*/dist:apps/*/build}"
INCLUDE_EXT="${INCLUDE_EXT:-md,MD}"

LISTADOR="${LISTADOR:-docs/core/QEL_ListadoR_master_v1.0.md}"

# SeedI por defecto si no logramos inferirlo (ciclo vigente tuyo)
DEFAULT_SEEDI="${DEFAULT_SEEDI:-A37-251015}"

# =========================
# Utils
# =========================
ts_now() { date +%s; }
human_bool() { [[ "${1:-0}" == "1" ]] && echo "APPLY" || echo "DRY-RUN"; }

trim_cr() { tr -d '\r'; }

get_field() {
  local file="$1" key="$2"
  local line
  line=$(grep -m1 -E "^${key}=" "$file" 2>/dev/null || true)
  echo "${line#${key}=}"
}

# Reemplaza primera aparición key=... o agrega al final (sin sed -i)
set_field() {
  local file="$1" key="$2" val="$3"
  local tmp; tmp="$(mktemp)"
  awk -v k="$key" -v v="$val" 'BEGIN{re="^"k"="; done=0}
    { if (!done && $0 ~ re) { print k"="v; done=1; next } print }
    END{ if (!done) print k"="v }' "$file" > "$tmp"
  if [[ "$APPLY" == "1" ]]; then mv "$tmp" "$file"; else rm -f "$tmp"; fi
}

upper() { awk '{print toupper($0)}'; }

# SHA-1 → 10 hex del contenido SIN la última línea si ya es hash10
compute_hash10() {
  local file="$1"
  local last; last="$(tail -n1 "$file" | trim_cr)"
  if [[ "$last" =~ ^[0-9a-f]{10}$ ]]; then
    head -n -1 "$file" | shasum -a 1 | awk '{print substr($1,1,10)}'
  else
    shasum -a 1 "$file" | awk '{print substr($1,1,10)}'
  fi
}

ensure_hash10_footer() {
  local file="$1"
  local hash10; hash10="$(compute_hash10 "$file")"
  local last; last="$(tail -n1 "$file" | trim_cr)"
  if [[ "$last" != "$hash10" ]]; then
    if [[ "$APPLY" == "1" ]]; then
      printf "\n%s\n" "$hash10" >> "$file"
    fi
    echo "E2→FIX(hash10)"
    return 0
  fi
  return 1
}

# Deducciones suaves para E1
infer_seed() {
  local p="$1"
  local s
  s="$(echo "$p" | grep -Eo 'A[0-9]{2}-[0-9]{6}' | head -n1 || true)"
  [[ -n "$s" ]] && echo "$s" || echo "$DEFAULT_SEEDI"
}
infer_version() {
  local p="$1"
  local v
  v="$(echo "$p" | grep -Eo 'v[0-9]+(\.[0-9]+)?' | head -n1 || true)"
  [[ -n "$v" ]] && echo "$v" || echo "v1.0"
}
infer_sot() {
  # Si no existe, ponemos UNSET que ya cumple E11 (MAYÚSCULAS y sin espacios)
  echo "UNSET"
}
today_iso() { date +%Y-%m-%d; }

ensure_frontmatter() {
  local file="$1"; local changed=0
  local SeedI SoT Version Updated
  SeedI="$(get_field "$file" "SeedI")"
  SoT="$(get_field "$file" "SoT")"
  Version="$(get_field "$file" "Version")"
  Updated="$(get_field "$file" "Updated")"

  if [[ -z "$SeedI" ]]; then SeedI="$(infer_seed "$file")"; set_field "$file" "SeedI" "$SeedI"; changed=1; fi
  if [[ -z "$SoT" ]]; then SoT="$(infer_sot)"; set_field "$file" "SoT" "$SoT"; changed=1; fi
  if [[ -z "$Version" ]]; then Version="$(infer_version "$file")"; set_field "$file" "Version" "$Version"; changed=1; fi
  if [[ -z "$Updated" ]]; then Updated="$(today_iso)"; set_field "$file" "Updated" "$Updated"; changed=1; fi

  [[ "$changed" == "1" ]] && echo "E1→FIX(front-matter)"
  return 0
}

# Canoniza SoT → E11 (MAYÚSCULAS, espacios→_). Si existe y no cumple, normaliza.
canonize_sot() {
  local file="$1"; local SoT; SoT="$(get_field "$file" "SoT")"
  [[ -z "$SoT" ]] && return 1
  local new; new="$(echo "$SoT" | tr ' ' '_' | upper)"
  if [[ "$new" != "$SoT" ]]; then
    set_field "$file" "SoT" "$new"
    echo "E11→FIX(SoT)"
    return 0
  fi
  return 1
}

# CUE opcional (solo si pides ADD_CUE=1)
ensure_cue() {
  [[ "$ADD_CUE" != "1" ]] && return 1
  local file="$1"
  if ! grep -qm1 -E '^\[QEL::ECO\[[0-9]+\]::RECALL .+\]' "$file"; then
    local bn; bn="$(basename "$file")"
    local id="${bn%.*}"
    if [[ "$APPLY" == "1" ]]; then
      # lo ponemos al inicio
      tmp="$(mktemp)"
      printf "[QEL::ECO[96]::RECALL %s]\n\n" "$id" > "$tmp"
      cat "$file" >> "$tmp"
      mv "$tmp" "$file"
    fi
    echo "E12→ADD(CUE)"
    return 0
  fi
  return 1
}

# =========================
# ListadoR helpers (E8/E6)
# =========================
listador_find_block() {
  local file="$1"
  local bn; bn="$(basename "$file")"
  local ln; ln=$(grep -n -F "$bn" "$LISTADOR" 2>/dev/null | head -n1 | cut -d: -f1 || true)
  [[ -z "$ln" ]] && return 1
  local s e
  s=$(( ln>2 ? ln-2 : 1 )); e=$(( ln+2 ))
  sed -n "${s},${e}p" "$LISTADOR"
  return 0
}
extract_path_from_block() {
  grep -Eo 'docs/[A-Za-z0-9_./-]+\.md' | head -n1 || true
}

# Inserta/actualiza bloque básico al final del ListadoR
listador_upsert_block() {
  local file="$1" hash10="$2"
  [[ -f "$LISTADOR" ]] || return 1

  local bn; bn="$(basename "$file")"
  local block; block="$(listador_find_block "$file" || true)"
  local SeedI SoT Version Updated
  SeedI="$(get_field "$file" "SeedI")"
  SoT="$(get_field "$file" "SoT")"
  Version="$(get_field "$file" "Version")"
  Updated="$(get_field "$file" "Updated")"

  if [[ -z "$block" ]]; then
    # añadir bloque al final
    if [[ "$APPLY" == "1" ]]; then
      {
        echo ""
        echo "SeedI=$SeedI"
        echo "SoT=$SoT"
        echo "Version=$Version"
        echo "Updated=$Updated"
        echo "refs: [$file]"
        echo "hash(10): $hash10"
      } >> "$LISTADOR"
    fi
    echo "E8→FIX(ListadoR+)"
    return 0
  else
    # si existe, al menos asegurar que la ruta coincide
    local p; p="$(echo "$block" | extract_path_from_block || true)"
    if [[ -n "$p" && "$p" != "$file" ]]; then
      # reemplaza primera aparición de la ruta en ese vecindario
      if [[ "$APPLY" == "1" ]]; then
        # Precaución: reemplazo global, pero sobre archivo completo (simple y efectivo)
        tmp="$(mktemp)"
        awk -v old="$p" -v new="$file" '{gsub(old,new)}1' "$LISTADOR" > "$tmp"
        mv "$tmp" "$LISTADOR"
      fi
      echo "E6→FIX(path@ListadoR)"
      return 0
    fi
  fi
  return 1
}

# =========================
# Find (cobertura multi-raíz)
# =========================
find_target_files() {
  IFS=': ' read -r -a ROOTS <<< "$DOCS_DIRS"
  IFS=': ' read -r -a EXCS  <<< "$EXCLUDE_DIRS"
  IFS=',' read -r -a EXTS <<< "$INCLUDE_EXT"

  local name_expr=()
  for ext in "${EXTS[@]}"; do name_expr+=( -name "*.${ext}" -o ); done
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

# =========================
# Main
# =========================
echo "QEL · Autofix  —  $(human_bool "$APPLY")"
echo "Raíces: $DOCS_DIRS"
echo "Exclusiones: $EXCLUDE_DIRS"
echo "Extensiones: $INCLUDE_EXT"
echo "ListadoR: $LISTADOR"
[[ "$ADD_CUE" == "1" ]] && echo "ADD_CUE=ON" || echo "ADD_CUE=OFF"
echo "----------------------------------------"

start="$(ts_now)"
count=0
fix_e1=0; fix_e2=0; fix_e11=0; fix_e8=0; fix_e6=0; fix_e12=0

# shellcheck disable=SC2044
while IFS= read -r -d '' f; do
  count=$((count+1))
  # feedback cada 20 archivos
  if (( count % 20 == 0 )); then
    now="$(ts_now)"; dt=$((now-start)); dt=$((dt>0?dt:1))
    rate=$(awk -v c="$count" -v t="$dt" 'BEGIN{printf "%.1f", c/t}')
    echo "… procesados $count archivos (${rate}/s)"
  fi

  # E1
  if msg="$(ensure_frontmatter "$f")"; then [[ "$msg" == "" ]] || { echo "[$f] $msg"; fix_e1=$((fix_e1+1)); }; fi
  # E11
  if msg="$(canonize_sot "$f")"; then [[ "$msg" == "" ]] || { echo "[$f] $msg"; fix_e11=$((fix_e11+1)); }; fi
  # (opcional) E12
  if msg="$(ensure_cue "$f")"; then [[ "$msg" == "" ]] || { echo "[$f] $msg"; fix_e12=$((fix_e12+1)); }; fi
  # E2
  if msg="$(ensure_hash10_footer "$f")"; then [[ "$msg" == "" ]] || { echo "[$f] $msg"; fix_e2=$((fix_e2+1)); }; fi
  # E8/E6 (ListadoR)
  if [[ -f "$LISTADOR" ]]; then
    h="$(tail -n1 "$f" | trim_cr)"
    if [[ ! "$h" =~ ^[0-9a-f]{10}$ ]]; then h="$(compute_hash10 "$f")"; fi
    if msg="$(listador_upsert_block "$f" "$h")"; then
      case "$msg" in
        *E8*) fix_e8=$((fix_e8+1));;
        *E6*) fix_e6=$((fix_e6+1));;
      esac
      [[ "$msg" == "" ]] || echo "[$f] $msg"
    fi
  fi

done < <(find_target_files)

elapsed=$(( $(ts_now) - start ))
elapsed=$((elapsed>0?elapsed:1))
rate=$(awk -v c="$count" -v t="$elapsed" 'BEGIN{printf "%.1f", c/t}')

echo "----------------------------------------"
echo "Archivos procesados: $count  (${rate}/s)"
echo "FIX E1: $fix_e1   FIX E2: $fix_e2   FIX E11: $fix_e11   FIX E8: $fix_e8   FIX E6: $fix_e6   ADD CUE: $fix_e12"
echo "Modo: $(human_bool "$APPLY")"
echo "Hecho."
