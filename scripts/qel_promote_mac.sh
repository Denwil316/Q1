#!/usr/bin/env bash
set -euo pipefail

export LC_ALL=C

# define DEBUG antes de usarlo (evita "unbound variable" con set -u)
DEBUG=false
# traza si DEBUG=true
[ "${DEBUG}" = true ] && set -x || true

# anclar a raíz del repo (o cwd si no hay git)
ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$ROOT"
DIARIO="docs/core/QEL_Diario_del_Conjurador_v1.2.md"

# imprime si --debug
log(){ $DEBUG && echo "[DBG] $*" >&2 || true; }

# asegura carpeta y archivo Diario (si no existe, lo crea con metadatos mínimos)
ensure_diario(){
  mkdir -p "$(dirname "$DIARIO")"
  if [ ! -f "$DIARIO" ]; then
    local TODAY="$(date +%Y-%m-%d)"
    cat > "$DIARIO" <<EOF
[QEL::ECO[96]::RECALL A96-${TODAY//-/}-DIARIO]
SeedI=A96-250824
SoT=DIARIO/v1.2
Version=v1.2
Updated=${TODAY}

# Diario del Conjurador (v1.2)
EOF
  fi
}


# Args mínimos
RUBRO=""; FILE=""; TITULO=""; RUMBO="Centro"

while [ $# -gt 0 ]; do
  case "$1" in
    --rubro)   RUBRO="$2"; shift 2;;
    --file)    FILE="$2"; shift 2;;
    --titulo)  TITULO="$2"; shift 2;;
    --rumbo)   RUMBO="$2"; shift 2;;
    --debug)   DEBUG=true; shift 1;;
    *) echo "arg desconocido: $1" >&2; exit 2;;
  esac
done
# validaciones estrictas    
[ -n "$RUBRO" ]  || { echo "--rubro requerido" >&2; exit 2; }
[ -n "$TITULO" ] || { echo "--titulo requerido" >&2; exit 2; }
log(){ $DEBUG && echo "[DBG] $*" >&2 || true; }
[ -n "$FILE" ] || { echo "--file requerido" >&2; exit 2; }
[ -f "$FILE" ] || { echo "No existe el archivo: $FILE" >&2; exit 2; }

# Normaliza a LF y elimina BOM en un tmp solo para lectura con awk/grep
SRC="$FILE"
TMP="$(mktemp)"
tr -d '\r' < "$FILE" > "$TMP" || { echo "No pude normalizar saltos de línea en $FILE" >&2; exit 2; }
SRC="$TMP"
trap 'rm -f "$TMP"' EXIT

# Lee cabecera (sin grep -P / flags GNU)
# Lee "Clave=Valor" o "Clave: Valor" y purga BOM si existiera
    get_kv () {
      awk -v k="$1" '
        BEGIN{ bom=sprintf("%c%c%c",239,187,191) }
        { sub("^" bom,"",$0) }
        $0 ~ "^" k "[[:space:]]*=" { sub(/^.*=[[:space:]]*/,""); print; exit }
        $0 ~ "^" k "[[:space:]]*:" { sub(/^.*:[[:space:]]*/,""); print; exit }
      ' "$SRC"
    }
    # Si no hay "cue=", toma la primera línea [QEL::ECO...]
    get_cue () { awk 'BEGIN{ bom=sprintf("%c%c%c",239,187,191) } { sub("^" bom,"",$0) } /^\[QEL::ECO/{print; exit}' "$SRC"; }


CUE=$(get_kv "cue"); [ -n "$CUE" ] || CUE=$(get_cue)
SEED=$(get_kv "SeedI")
SOT=$(get_kv "SoT")
VERSION=$(get_kv "Version")
UPDATED=$(get_kv "Updated")
log "CUE=$CUE"
log "SeedI=$SEED SoT=$SOT Version=$VERSION Updated=$UPDATED"

# Fallback si faltan claves
[ -n "$CUE" ]     || CUE="[QEL::ECO[96]::RECALL]"
[ -n "$SEED" ]    || SEED="A96-$(date +%y%m%d)"
[ -n "$SOT" ]     || SOT="PROMOCION/v1.0"
[ -n "$VERSION" ] || VERSION="v1.0"
[ -n "$UPDATED" ] || UPDATED="$(date +%Y-%m-%d)"

# HASH(10) portable
DATA=$(printf "cue=%s|SeedI=%s|SoT=%s|Version=%s|Updated=%s" \
  "$CUE" "$SEED" "$SOT" "$VERSION" "$UPDATED")
if command -v shasum >/dev/null 2>&1; then
  HASH=$(printf "%s" "$DATA" | shasum -a 1 | awk '{print $1}')
else
  HASH=$(printf "%s" "$DATA" | openssl dgst -sha1 | awk '{print $2}')
fi
HASH10=${HASH:0:10}
log "HASH10=$HASH10"
# Garantiza HASH(10) en el doc
if grep -q '^HASH(10):' "$FILE"; then
  sed -i '' "s/^HASH(10):.*/HASH(10): $HASH10/" "$FILE"
else
  # añade un newline sólo si el archivo no termina en \n
  if [ -s "$FILE" ]; then
    last_char="$(tail -c1 "$FILE" 2>/dev/null || printf '\n')"
    [ "$last_char" = "" ] || [ "$last_char" = $'\n' ] || printf '\n' >> "$FILE"
  fi
  printf "HASH(10): %s\n" "$HASH10" >> "$FILE"
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
echo "[OK] ListadoR actualizado: $LISTADOR"

# --- Actualizar Diario del Conjurador ---
ensure_diario
TODAY_ISO="$(date +%Y-%m-%d)"
FILE_BN="$(basename "$FILE")"
cat >> "$DIARIO" <<EOF

## ${TODAY_ISO} — PROMOCIÓN
- Rubro: ${RUBRO}
- Título: ${TITULO}
- Archivo: ${FILE}
- Copia: apps/preh-nav-m1/public/docs/${FILE_BN}
- Rumbo: ${RUMBO}
- HASH(10): ${HASH10}

_ECO (delta-only):_ Se cristaliza **${TITULO}** con hash **${HASH10}**; se actualiza ListadoR y se publica espejo en preh-nav.
EOF

echo "[OK] Diario actualizado: $DIARIO"

# Espejo + manifests
PRENAV="apps/preh-nav-m1/public/docs"
mkdir -p "$PRENAV"
cp -f "$FILE" "$PRENAV/" || { echo "No pude copiar $FILE a $PRENAV/" >&2; exit 2; }
# Si tienes generadores propios, úsalos; si no, ignorar silenciosamente
[ -x scripts/gen_manifest.sh ]     && scripts/gen_manifest.sh     || true
[ -x scripts/gen_core_manifest.sh ]&& scripts/gen_core_manifest.sh || true

git add "$FILE" "$LISTADOR" "$DIARIO" "$PRENAV/$(basename "$FILE")" || true
git commit -m "QEL($SEED/${RUBRO}): cristaliza — $TITULO · hash=$HASH10" || true
git push origin PreH || true

echo "[OK] Promovido $FILE — HASH(10)=$HASH10"
