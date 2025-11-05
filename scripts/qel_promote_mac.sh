#!/usr/bin/env bash
# QEL — Promoción de artefactos: asegura SeedI, HASH(10) canónico, ListadoR, Diario y espejo PREH-NAV.
# Uso:
#   bash scripts/qel_promote_mac.sh \
#     --rubro "CORE/MANUAL" \
#     --file "docs/core/manuales/QEL_Manual_auditoria_v1.2.md" \
#     --titulo "QEL · Manual de Auditoría (v1.2)" \
#     --rumbo "Centro"
#
# Env:
#   QEL_SEED_POLICY=auto|keep|strict  (default: auto)

set -euo pipefail
export LC_ALL=C

DEBUG=false
[ "${DEBUG}" = true ] && set -x || true

ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$ROOT"

DIARIO="docs/core/QEL_Diario_del_Conjurador_v1.2.md"
LISTADOR="docs/core/QEL_ListadoR_master_v1.0.md"
PRENAV="apps/preh-nav-m1/public/docs"

# indexer (moderno primero; fallback a scripts/)
if [[ -f "tools/qel_indexer.py" ]]; then
  INDEXER="tools/qel_indexer.py"
else
  INDEXER="scripts/qel_indexer.py"
fi
INDICES_DIR="docs/core/indices"

log(){ $DEBUG && echo "[DBG] $*" >&2 || true; }

normalize_tmp(){
  local f="$1"; local t
  t="$(mktemp)"; tr -d '\r' < "$f" > "$t" || { echo "No pude normalizar saltos de línea en $f" >&2; exit 2; }
  echo "$t"
}

get_kv(){
  local key="$1" src="$2"
  awk -v k="$key" '
    BEGIN{ bom=sprintf("%c%c%c",239,187,191) }
    { sub("^" bom,"",$0) }
    $0 ~ "^[#[:space:]]*" k "[[:space:]]*=" { sub(/^.*=[[:space:]]*/,""); print; exit }
    $0 ~ "^[#[:space:]]*" k "[[:space:]]*:" { sub(/^.*:[[:space:]]*/,""); print; exit }
  ' "$src"
}

get_cue(){
  local src="$1"
  awk '
    BEGIN{ bom=sprintf("%c%c%c",239,187,191) }
    { sub("^" bom,"",$0) }
    /^[#[:space:]]*\[QEL::ECO/{
      sub("^[#[:space:]]*","",$0); print; exit
    }
  ' "$src"
}

# --- Seed derivation helpers (portables) ---------------------------------
get_eco_from_cue() { # -> "A96" (default A96 si no encuentra)
  local cue="${1-}" n
  n="$(printf "%s" "$cue" | sed -nE 's/.*ECO\[([0-9]+)\].*/\1/p' | head -1)"
  [ -n "$n" ] && printf "A%s\n" "$n" || printf "A96\n"
}

git_first_date_ymd(){ # -> YYMMDD primer commit que añadió el archivo
  local f="$1" d
  d="$(git log --follow --diff-filter=A --format=%cs -- "$f" 2>/dev/null | tail -1)"
  [ -n "$d" ] || return 1
  printf "%s%s%s\n" "${d:2:2}" "${d:5:2}" "${d:8:2}"
}

fs_birth_ymd(){ # -> YYMMDD nacimiento FS
  local f="$1" epoch=""
  if stat -f '%B' "$f" >/dev/null 2>&1; then
    epoch="$(stat -f '%B' "$f")"
  elif stat -c '%W' "$f" >/dev/null 2>&1; then
    epoch="$(stat -c '%W' "$f")"; [ "$epoch" = "0" ] && epoch=""
  fi
  if [ -n "$epoch" ] && [ "$epoch" -gt 0 ] 2>/dev/null; then
    date -u -d "@$epoch" +%y%m%d 2>/dev/null || date -r "$epoch" +%y%m%d
  else
    return 1
  fi
}

fs_mtime_ymd(){ # -> YYMMDD por mtime (último recurso)
  local f="$1"
  date -u -d "@$(stat -c '%Y' "$f" 2>/dev/null)" +%y%m%d 2>/dev/null || \
  date -r "$(stat -f '%m' "$f" 2>/dev/null)" +%y%m%d 2>/dev/null || date +%y%m%d
}

derive_seed_auto(){ # args: <file> <cue> -> "A96-YYMMDD"
  local f="$1" cue="${2-}" eco ymd
  eco="$(get_eco_from_cue "$cue")"
  if ! ymd="$(git_first_date_ymd "$f")"; then
    if ! ymd="$(fs_birth_ymd "$f")"; then
      ymd="$(fs_mtime_ymd "$f")"
    fi
  fi
  printf "%s-%s\n" "$eco" "$ymd"
}

: "${QEL_SEED_POLICY:=auto}"
# -------------------------------------------------------------------------

ensure_seed_in_file(){
  local file="$1" seed="$2"
  # actualiza si existe
  if grep -Eq '^[#[:space:]]*SeedI[[:space:]]*:' "$file"; then
    sed -i '' -E "s/^([#[:space:]]*SeedI[[:space:]]*:[[:space:]]*).*/\1\"$seed\"/" "$file"; return
  fi
  if grep -Eq '^[#[:space:]]*SeedI[[:space:]]*=' "$file"; then
    sed -i '' -E "s/^([#[:space:]]*SeedI[[:space:]]*=[[:space:]]*).*/\1$seed/" "$file"; return
  fi
  # inserta debajo de cue o al inicio
  local tmp; tmp="$(mktemp)"
  awk -v SEED="$seed" '
    BEGIN{ inserted=0; }
    {
      if(!inserted && ($0 ~ /^[#[:space:]]*cue[[:space:]]*[:=]/ || $0 ~ /^[#[:space:]]*\[QEL::ECO/)){
        print $0; print "SeedI: \"" SEED "\""; inserted=1
      } else { print $0 }
    }
    END{ if(!inserted) print "SeedI: \"" SEED "\""}
  ' "$file" > "$tmp" && mv "$tmp" "$file"
}

ensure_diario(){
  local seed="$1"
  mkdir -p "$(dirname "$DIARIO")"
  if [ ! -f "$DIARIO" ]; then
    local TODAY="$(date +%Y-%m-%d)"; local TODAY_COMPACT="$(date +%Y%m%d)"
    cat > "$DIARIO" <<EOF
[QEL::ECO[96]::RECALL A96-${TODAY_COMPACT}-DIARIO]
SeedI=$seed
SoT=CORE/DIARIO
Version=v1.2
Updated=${TODAY}

# Diario del Conjurador (v1.2)
EOF
  else
    sed -i '' -E "1,80s/^([#[:space:]]*SeedI[[:space:]]*=[[:space:]]*).*/\1$seed/" "$DIARIO" || true
  fi
}

# -------- Args --------
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

[ -n "$RUBRO" ]  || { echo "--rubro requerido" >&2; exit 2; }
[ -n "$TITULO" ] || { echo "--titulo requerido" >&2; exit 2; }
[ -n "$FILE" ]   || { echo "--file requerido" >&2; exit 2; }
[ -f "$FILE" ]   || { echo "No existe el archivo: $FILE" >&2; exit 2; }

TMP="$(normalize_tmp "$FILE")"
trap 'rm -f "$TMP"' EXIT

CUE=$(get_kv "cue" "$TMP"); [ -n "$CUE" ] || CUE=$(get_cue "$TMP")
SEED=$(get_kv "SeedI" "$TMP")
SOT=$(get_kv "SoT" "$TMP")
VERSION=$(get_kv "Version" "$TMP")
UPDATED=$(get_kv "Updated" "$TMP")
log "CUE=$CUE"
log "SeedI=$SEED SoT=$SOT Version=$VERSION Updated=$UPDATED"

# SeedI esperado (ECO + fecha de origen)
[ -n "$CUE" ] || CUE="[QEL::ECO[96]::RECALL]"
EXPECTED_SEED="$(derive_seed_auto "$FILE" "$CUE")"

case "$QEL_SEED_POLICY" in
  keep)
    [ -n "$SEED" ] || SEED="$EXPECTED_SEED"
    ;;
  strict)
    SEED="$EXPECTED_SEED"
    ;;
  auto|*)
    if [ -z "$SEED" ]; then
      SEED="$EXPECTED_SEED"
    else
      ECO_PREFIX="$(get_eco_from_cue "$CUE")-"
      case "$SEED" in
        "$ECO_PREFIX"*) : ;;
        *)               SEED="$EXPECTED_SEED" ;;
      esac
    fi
    ;;
esac

[ -n "$SOT" ]     || SOT="CORE/DOCUMENTO"   # no pisamos SoT reales; fallback neutro
[ -n "$VERSION" ] || VERSION="v1.0"
[ -n "$UPDATED" ] || UPDATED="$(date +%Y-%m-%d)"

# 1) Garantiza SeedI correcto en el archivo
ensure_seed_in_file "$FILE" "$SEED"

# 2) HASH(10) canónico (solo metadatos clave → estable hasta nueva Version)
DATA=$(printf "cue=%s|SeedI=%s|SoT=%s|Version=%s" "$CUE" "$SEED" "$SOT" "$VERSION")
if command -v shasum >/dev/null 2>&1; then
  HASH=$(printf "%s" "$DATA" | shasum -a 1 | awk '{print $1}')
else
  HASH=$(printf "%s" "$DATA" | openssl dgst -sha1 | awk '{print $2}')
fi
HASH10=${HASH:0:10}
log "HASH10=$HASH10"

# 3) Asegura HASH(10) como ÚLTIMA línea (reemplaza si ya había una)
TMP_FOOT="$(mktemp)"
awk 'NR==1{prev=$0; next} {print prev; prev=$0} END{ if (prev !~ /^HASH\(10\):[[:space:]]*[0-9a-fA-F]+$/) print prev }' "$FILE" > "$TMP_FOOT" \
  || { echo "No pude preparar footer HASH(10) en $FILE" >&2; exit 2; }
mv "$TMP_FOOT" "$FILE"
# salto de línea si falta y luego el HASH
if [ -s "$FILE" ]; then last_char="$(tail -c1 "$FILE" 2>/dev/null || printf '\n')"; else last_char=""; fi
[ "$last_char" = "" ] || [ "$last_char" = $'\n' ] || printf '\n' >> "$FILE"
printf "HASH(10): %s\n" "$HASH10" >> "$FILE"

# 4) ListadoR (append humano-legible)
mkdir -p "$(dirname "$LISTADOR")"
DATE_ISO=$(date +%Y-%m-%d)
cat >> "$LISTADOR" <<EOF

- ($DATE_ISO) $RUBRO | $SEED | $SOT | $TITULO (CRISTAL @ $RUMBO)
  refs: [$FILE]
  hash(10): $HASH10
EOF
echo "[OK] ListadoR actualizado: $LISTADOR"

# 5) Diario (SoT canónico del Diario)
ensure_diario "$SEED"
TODAY_ISO="$(date +%Y-%m-%d)"
cat >> "$DIARIO" <<EOF

## ${TODAY_ISO} — PROMOCIÓN
- Rubro: ${RUBRO}
- Título: ${TITULO}
- Archivo: ${FILE}
- Copia: ${PRENAV}/${FILE}
- Rumbo: ${RUMBO}
- HASH(10): ${HASH10}
- SeedI: ${SEED}

_ECO (delta-only):_ Se cristaliza **${TITULO}** con hash **${HASH10}**; se actualiza ListadoR y espejo.
EOF
echo "[OK] Diario actualizado: $DIARIO"

# 6) Espejo PREH-NAV (preserva arbol de rutas)
DEST="${PRENAV}/${FILE}"
mkdir -p "$(dirname "$DEST")"
cp -f "$FILE" "$DEST" || { echo "No pude copiar $FILE a $DEST" >&2; exit 2; }

# 7) Indexador (moderno → fallback). No fatal si falla.
if [[ -f "$INDEXER" ]]; then
  if ! python3 "$INDEXER" --file "$FILE" --indices-dir "$INDICES_DIR" --update all --seedI "$SEED"; then
    if ! python3 "$INDEXER" \
          --mode add \
          --doc "$FILE" \
          --title "$TITULO" \
          --seed "$SEED" \
          --update-seeds "$INDICES_DIR/QEL_Index_Semillas_v1.0.md" \
          --update-routes "$INDICES_DIR/QEL_Index_Rutas_v1.0.md"; then
      echo "[indexer] aviso: no se pudo actualizar índices (no fatal)" >&2
    fi
  fi
fi

# 8) Git (suave)
git add "$FILE" "$LISTADOR" "$DIARIO" "$DEST" || true
git commit -m "QEL($SEED/${RUBRO}): cristaliza — $TITULO · hash=$HASH10" || true
git push origin PreH || true

echo "[OK] Promovido $FILE — HASH(10)=$HASH10 — SeedI=$SEED"
