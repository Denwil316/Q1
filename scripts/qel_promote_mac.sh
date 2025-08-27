#!/usr/bin/env bash
set -euo pipefail

# Args mínimos
RUBRO=""; FILE=""; TITULO=""; RUMBO="Centro"
while [ $# -gt 0 ]; do
  case "$1" in
    --rubro)   RUBRO="$2"; shift 2;;
    --file)    FILE="$2"; shift 2;;
    --titulo)  TITULO="$2"; shift 2;;
    --rumbo)   RUMBO="$2"; shift 2;;
    *) echo "arg desconocido: $1" >&2; exit 2;;
  esac
done

[ -n "$FILE" ] || { echo "--file requerido"; exit 2; }

# Lee cabecera (sin grep -P / flags GNU)
get_kv () { awk -F= -v k="$1" '$1==k{print $2; exit}' "$FILE"; }

CUE=$(get_kv "cue")
SEED=$(get_kv "SeedI")
SOT=$(get_kv "SoT")
VERSION=$(get_kv "Version")
UPDATED=$(get_kv "Updated")

# Fallback si faltan claves
[ -n "$CUE" ]     || CUE="[QEL::ECO[96]::RECALL]"
[ -n "$SEED" ]    || SEED="A96-$(date +%y%m%d)"
[ -n "$SOT" ]     || SOT="PROMOCION/v1.0"
[ -n "$VERSION" ] || VERSION="v1.0"
[ -n "$UPDATED" ] || UPDATED="$(date +%Y-%m-%d)"

# HASH(10) portable
HASH10=$(printf "cue=%s|SeedI=%s|SoT=%s|Version=%s|Updated=%s" \
  "$CUE" "$SEED" "$SOT" "$VERSION" "$UPDATED" | shasum | awk '{print substr($1,1,10)}')
# Garantiza HASH(10) en el doc
if grep -q '^HASH(10):' "$FILE"; then
  sed -i '' "s/^HASH(10):.*/HASH(10): $HASH10/" "$FILE"
else
  printf "\nHASH(10): %s\n" "$HASH10" >> "$FILE"
fi

# ListadoR
LISTADOR="docs/core/QEL_ListadoR_master_v1.0.md"
mkdir -p "$(dirname "$LISTADOR")"
DATE_ISO=$(date +%Y-%m-%d)
cat >> "$LISTADOR" <<EOF

- ($DATE_ISO) $RUBRO | $SEED | $SOT | $TITULO (CRISTAL @ $RUMBO)
  refs: [$FILE]
  hash(10): $HASH10
EOF

# Espejo + manifests
PRENAV="apps/preh-nav-m1/public/docs"
mkdir -p "$PRENAV"
cp -f "$FILE" "$PRENAV/"
scripts/qel manifest build || true
scripts/qel manifest core  || true

git add "$FILE" "$LISTADOR" "$PRENAV" || true
git commit -m "QEL($SEED/${RUBRO}): cristaliza — $TITULO · hash=$HASH10" || true
git push origin PreH || true

echo "[OK] Promovido $FILE — HASH(10)=$HASH10"
