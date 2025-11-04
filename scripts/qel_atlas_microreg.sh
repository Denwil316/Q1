#!/usr/bin/env bash
set -euo pipefail
# --- QEL Indexer (config + helpers) -----------------------------------------
INDEXER="${INDEXER:-scripts/qel_indexer.py}"
INDEX_SEEDS="docs/core/indices/QEL_Index_Semillas_v1.0.md"
INDEX_ROUTES="docs/core/indices/QEL_Index_Rutas_v1.0.md"

ensure_indices() {
  mkdir -p "docs/core/indices"
  [ -f "$INDEX_SEEDS" ] || cat >"$INDEX_SEEDS" <<'MD'
cue: "[QEL::ECO[96]::RECALL A96-INDEX-SEEDS]"
SeedI: "A37-251015"
SoT: "INDICES/SEMILLAS/v1.0"
Version: "v1.0"
Updated: "$(date +%Y-%m-%d)"

# Índice de Semillas (auto)
MD
  [ -f "$INDEX_ROUTES" ] || cat >"$INDEX_ROUTES" <<'MD'
cue: "[QEL::ECO[96]::RECALL A96-INDEX-ROUTES]"
SeedI: "A37-251015"
SoT: "INDICES/RUTAS/v1.0"
Version: "v1.0"
Updated: "$(date +%Y-%m-%d)"

# Índice de Rutas Internas (auto)
MD
}

update_indexes_from_doc() {
  # uso: update_indexes_from_doc <doc> <title> <seed>
  local doc="$1" title="$2" seed="$3"
  ensure_indices
  if [ -f "$INDEXER" ]; then
    python3 "$INDEXER" \
      --mode add \
      --doc "$doc" \
      --title "$title" \
      --seed "$seed" \
      --update-seeds "$INDEX_SEEDS" \
      --update-routes "$INDEX_ROUTES" \
      || echo "[indexer] (warn) no se pudo actualizar índices, continuando…" >&2
  else
    echo "[indexer] (skip) $INDEXER no existe" >&2
  fi
}
# ---------------------------------------------------------------------------

export LC_ALL=C
command -v python3 >/dev/null 2>&1 && export QEL_PY=python3 || export QEL_PY=python

# [QEL::ECO[96]::RECALL A96-250829-ATLAS-MICROREG]
# SeedI=A96-250824
# SoT=ATLAS/MICROREG/v1.0
# Version=v1.0
# Updated=2025-08-29

KIND=""; FILE=""; TITLE=""; HASH10=""
RUMBO="${RUMBO:-}"; TRIADA="${TRIADA:-}"; OBJ="${OBJ:-}"; CLASE="${CLASE:-}"; MATERIA="${MATERIA:-}"
V="${V:-}"; TAU="${TAU:-}"; GATES="${GATES:-}" # gates coma: no_mentira,doble_testigo
MICROREG="${MICROREG:-docs/core/atlas_microreg_v1.0.jsonl}"
# Actualiza índices a partir del documento microregistrado
# Asume que ya tienes variables: FILE (ruta), TITLE/TITULO (título), SEED (SeedI)
update_indexes_from_doc "$FILE" "${TITLE:-$TITULO}" "${SEED:-A37-251015}"


while [ $# -gt 0 ]; do
  case "$1" in
    --kind)   KIND="$2"; shift 2;;
    --file)   FILE="$2"; shift 2;;
    --title|--titulo)  TITLE="$2"; shift 2;;
    --hash10) HASH10="$2"; shift 2;;
    --rumbo)  RUMBO="$2"; shift 2;;
    --triada) TRIADA="$2"; shift 2;;
    --obj)    OBJ="$2"; shift 2;;
    --clase)  CLASE="$2"; shift 2;;
    --materia)MATERIA="$2"; shift 2;;
    --V)      V="$2"; shift 2;;
    --tau|--τ)TAU="$2"; shift 2;;
    --gates)  GATES="$2"; shift 2;;
    --microreg) MICROREG="$2"; shift 2;;
    *) echo "arg desconocido: $1" >&2; exit 2;;
  esac
done

[ -n "$KIND" ] || { echo "--kind requerido (PROMO|PE_GEN|HAB_CRYSTAL|RITUAL|ERRATA|NOTE...)" >&2; exit 2; }
[ -n "$FILE" ] || { echo "--file requerido" >&2; exit 2; }
TITLE="${TITLE:-$(basename "$FILE")}"

TMP="$(mktemp)"; trap 'rm -f "$TMP"' EXIT
tr -d '\r' < "$FILE" > "$TMP"

get_kv () {
  awk -v k="$1" '
    BEGIN{ bom=sprintf("%c%c%c",239,187,191) }
    { sub("^" bom,"",$0) }
    $0 ~ "^" k "[[:space:]]*=" { sub(/^.*=[[:space:]]*/,""); print; exit }
    $0 ~ "^" k "[[:space:]]*:" { sub(/^.*:[[:space:]]*/,""); print; exit }
  ' "$TMP"
}
get_cue () { awk 'BEGIN{b=sprintf("%c%c%c",239,187,191)} {sub("^"b,"",$0)} /^\[QEL::ECO/{print; exit}' "$TMP"; }

CUE="$(get_kv 'cue')"; [ -n "$CUE" ] || CUE="$(get_cue)"
SEED="$(get_kv 'SeedI')"
SOT="$(get_kv 'SoT')"
VER="$(get_kv 'Version')"
UPD="$(get_kv 'Updated')"

if [ -z "$HASH10" ]; then
  DATA=$(printf "cue=%s|SeedI=%s|SoT=%s|Version=%s|Updated=%s" "$CUE" "$SEED" "$SOT" "$VER" "$UPD")
  if command -v shasum >/dev/null 2>&1; then
    HASH=$(printf "%s" "$DATA" | shasum -a 1 | awk '{print $1}')
  else
    HASH=$(printf "%s" "$DATA" | openssl dgst -sha1 | awk '{print $2}')
  fi
  HASH10=${HASH:0:10}
fi

TS=$(date -u +%FT%TZ)
mkdir -p "$(dirname "$MICROREG")"

# Construir JSON (sin jq), cuidando comas opcionales
json_escape(){ 
  local s="${1-}"
  if command -v python3 >/dev/null 2>&1; then
    python3 - "$s" <<'PY'
import sys, json
print(json.dumps(sys.argv[1])[1:-1])
PY
  elif command -v python >/dev/null 2>&1; then
    python - "$s" <<'PY'
import sys, json
print(json.dumps(sys.argv[1])[1:-1])
PY
  elif command -v jq >/dev/null 2>&1; then
    # jq @json envuelve con comillas; las retiramos
    printf '%s' "$s" | jq -Rr @json | sed 's/^"//; s/"$//'
  else
    # fallback en puro bash (cubre comillas, backslash y saltos)
    s=${s//\\/\\\\}
    s=${s//\"/\\\"}
    s=${s//$'\n'/\\n}
    s=${s//$'\r'/}
    s=${s//$'\t'/\\t}
    printf '%s' "$s"
  fi
 }

F_ESC="$(json_escape "$FILE")"
T_ESC="$(json_escape "$TITLE")"
C_ESC="$(json_escape "$CUE")"
S_ESC="$(json_escape "${SEED:-}")"
SO_ESC="$(json_escape "${SOT:-}")"
V_ESC="$(json_escape "${VER:-}")"
U_ESC="$(json_escape "${UPD:-}")"
R_ESC="$(json_escape "${RUMBO:-}")"
TR_ESC="$(json_escape "${TRIADA:-}")"
O_ESC="$(json_escape "${OBJ:-}")"
K_ESC="$(json_escape "${CLASE:-}")"
M_ESC="$(json_escape "${MATERIA:-}")"
G_ESC="$(json_escape "${GATES:-}")"

# Arma línea JSON
LINE="{\"ts\":\"$TS\",\"kind\":\"$KIND\",\"title\":\"$T_ESC\",\"file\":\"$F_ESC\",\"hash10\":\"$HASH10\",\
\"cue\":\"$C_ESC\",\"seed\":\"$S_ESC\",\"sot\":\"$SO_ESC\",\"version\":\"$V_ESC\",\"updated\":\"$U_ESC\",\
\"vf\":{\"triada\":\"$TR_ESC\",\"obj\":\"$O_ESC\",\"rumbo\":\"$R_ESC\",\"clase\":\"$K_ESC\",\"materia\":\"$M_ESC\"},\
\"metrics\":{\"V\":\"$V\",\"tau\":\"$TAU\"},\"gates\":\"$G_ESC\"}"

echo "$LINE" >> "$MICROREG"
echo "[OK] Atlas micro-registro → $MICROREG"
