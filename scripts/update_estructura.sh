#!/usr/bin/env bash
set -euo pipefail

# [QEL::ECO[96]::RECALL A96-251117-ESTRUCTURA-DEPTH]
# SeedI=A96-251117
# SoT=HERRAMIENTAS/ESTRUCTURA/v1.1
# Version=v1.1
# Updated=2025-11-17

# Genera un árbol del repo en un archivo markdown.
# Variables:
#   OUT_FILE (def=ESTRUCTURA.md)         # p.ej. ESTRUCTURA_full.md
#   DEPTH    (def=4; 0 = sin límite)     # profundidad de niveles
#   EXCLUDES (def=.git:node_modules:out:apps/*/dist:apps/*/build:apps/*/public/docs)
# Uso:
#   scripts/update_estructura.sh
#   OUT_FILE=ESTRUCTURA_full.md DEPTH=0 scripts/update_estructura.sh

OUT_FILE="${OUT_FILE:-ESTRUCTURA.md}"
DEPTH="${DEPTH:-4}"
EXCLUDES="${EXCLUDES:-.git:node_modules:out:apps/*/dist:apps/*/build:apps/*/public/docs}"

header() {
  printf "# Estructura de Codex (%s)\n\n_Generado: %s_\n\n\`\`\`text\n" \
    "$(pwd -P)" "$(date '+%Y-%m-%d %H:%M:%S')"
}
footer(){ printf "\n\`\`\`\n"; }

if command -v tree >/dev/null 2>&1; then
  IFS=': ' read -r -a EX <<<"$EXCLUDES"
  IGNORE="$(printf '%s|' "${EX[@]}")"; IGNORE="${IGNORE%|}"
  header >"$OUT_FILE"
  if [[ "$DEPTH" = "0" ]]; then
    tree -a -I "$IGNORE" >>"$OUT_FILE"
  else
    tree -a -L "$DEPTH" -I "$IGNORE" >>"$OUT_FILE"
  fi
  footer >>"$OUT_FILE"
else
  # Fallback find+awk (BSD/macOS friendly)
  header >"$OUT_FILE"
  IFS=': ' read -r -a EX <<<"$EXCLUDES"
  find . -type d \( $(printf ' -path "%s" -o' "${EX[@]}") -false \) -prune -o -print \
  | awk -v depth="$DEPTH" '
      BEGIN{FS="/"}
      {
        n=split($0,a,"/"); if($0=="." && n==1) {print "."; next}
        lvl=n-1; if(depth>0 && lvl>depth) next
        ind=""; for(i=0;i<lvl;i++) ind=ind "  "
        print ind a[n]
      }' >>"$OUT_FILE"
  footer >>"$OUT_FILE"
fi

git add "$OUT_FILE" >/dev/null 2>&1 || true
echo "Estructura escrita en $OUT_FILE (DEPTH=$DEPTH; EXCLUDES=$EXCLUDES)"
