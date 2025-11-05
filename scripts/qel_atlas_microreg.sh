#!/usr/bin/env bash
# QEL — Atlas micro-registro (JSONL) con SeedI derivado y actualización opcional de índices
# Uso típico:
#   bash scripts/qel_atlas_microreg.sh \
#     --kind "CORE/MANUAL" \
#     --file "docs/core/manuales/QEL_Manual_auditoria_v1.2.md" \
#     --titulo "QEL · Manual de Auditoría (v1.2)" \
#     --rumbo "Centro"
#
# Flags adicionales:
#   --seed / --seedI <Axx-YYMMDD>  (para forzar SeedI)
#   --hash10 <HASH10>              (si quieres fijar el hash del microregistro)
#   --indices-dir <dir>            (default: docs/core/indices)
#   --indexer <path>               (default: tools/qel_indexer.py o scripts/qel_indexer.py)
#   --microreg <path>              (default: docs/core/atlas_microreg_v1.0.jsonl)

set -euo pipefail
export LC_ALL=C

# --------------------- Config por defecto ---------------------
INDICES_DIR="${INDICES_DIR:-docs/core/indices}"
# preferimos tools/ y caemos a scripts/ si no existe
if [[ -f "tools/qel_indexer.py" ]]; then
  INDEXER_DEFAULT="tools/qel_indexer.py"
else
  INDEXER_DEFAULT="scripts/qel_indexer.py"
fi
INDEXER="${INDEXER:-$INDEXER_DEFAULT}"

LISTADOR="${LISTADOR:-docs/core/QEL_ListadoR_master_v1.0.md}"
MICROREG="${MICROREG:-docs/core/atlas_microreg_v1.0.jsonl}"

# --------------------- Vars (se llenan por flags) -------------
KIND=""; FILE=""; TITLE=""; HASH10=""
RUMBO="${RUMBO:-Centro}"; TRIADA="${TRIADA:-}"; OBJ="${OBJ:-}"; CLASE="${CLASE:-}"; MATERIA="${MATERIA:-}"
V="${V:-}"; TAU="${TAU:-}"; GATES="${GATES:-}"
SEED="${SEED:-${SEEDI:-}}"

# --------------------- Parseo de argumentos -------------------
while [[ $# -gt 0 ]]; do
  case "$1" in
    --kind)        KIND="$2"; shift 2;;
    --file)        FILE="$2"; shift 2;;
    --title|--titulo) TITLE="$2"; shift 2;;
    --hash10)      HASH10="$2"; shift 2;;
    --rumbo)       RUMBO="$2"; shift 2;;
    --triada)      TRIADA="$2"; shift 2;;
    --obj)         OBJ="$2"; shift 2;;
    --clase)       CLASE="$2"; shift 2;;
    --materia)     MATERIA="$2"; shift 2;;
    --V)           V="$2"; shift 2;;
    --tau|--τ)     TAU="$2"; shift 2;;
    --gates)       GATES="$2"; shift 2;;
    --microreg)    MICROREG="$2"; shift 2;;
    --seed|--seedI) SEED="$2"; shift 2;;
    --indices-dir) INDICES_DIR="$2"; shift 2;;
    --indexer)     INDEXER="$2"; shift 2;;
    *) echo "arg desconocido: $1" >&2; exit 2;;
  esac
done

[[ -n "$KIND" ]] || { echo "--kind requerido" >&2; exit 2; }
[[ -n "$FILE" ]] || { echo "--file requerido" >&2; exit 2; }
TITLE="${TITLE:-$(basename "$FILE")}"

# --------------------- Helpers -------------------------------
command -v python3 >/dev/null 2>&1 && QEL_PY=python3 || QEL_PY=python

TMP="$(mktemp)"; trap 'rm -f "$TMP"' EXIT
# normaliza CRLF
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

to_yymmdd() {
  local s="${1:-}"
  if [[ "$s" =~ ^20([0-9]{2})-([0-9]{2})-([0-9]{2})$ ]]; then
    echo "${BASH_REMATCH[1]}${BASH_REMATCH[2]}${BASH_REMATCH[3]}"
  elif [[ "$s" =~ ^20([0-9]{6})$ ]]; then
    echo "${BASH_REMATCH[1]}"
  elif [[ "$s" =~ ^([0-9]{6})$ ]]; then
    echo "${BASH_REMATCH[1]}"
  else
    echo ""
  fi
}

derive_seed_from_doc() {
  local f="$1" seed="" bn ln s e block eco updated yymmdd cue
  # 1) SeedI= en el doc
  seed="$(get_kv 'SeedI')"
  [[ -n "$seed" ]] && { echo "$seed"; return; }

  # 2) CUE: [QEL::ECO[96]::RECALL A96-251104]
  cue="$(get_cue)"
  if [[ -z "$cue" ]]; then cue="$(get_kv 'cue')"; fi
  if [[ -n "$cue" ]]; then
    seed="$(sed -E 's/.*RECALL[[:space:]]+([A-Za-z][0-9]+-[0-9]{6}).*/\1/' <<<"$cue")"
    [[ "$seed" != "$cue" && -n "$seed" ]] && { echo "$seed"; return; }
  fi

  # 3) ListadoR (ventana alrededor del basename)
  if [[ -f "$LISTADOR" ]]; then
    bn="$(basename "$f")"
    ln=$(grep -n -F "$bn" "$LISTADOR" 2>/dev/null | head -n1 | cut -d: -f1 || true)
    if [[ -n "$ln" ]]; then
      s=$(( ln>2 ? ln-2 : 1 )); e=$(( ln+2 ))
      block="$(sed -n "${s},${e}p" "$LISTADOR")"
      seed="$(echo "$block" | grep -m1 -E '^SeedI=' | sed -E 's/^SeedI=//')"
      [[ -n "$seed" ]] && { echo "$seed"; return; }
    fi
  fi

  # 4) ECO + Updated → A<ECO>-<YYMMDD>
  if [[ -n "$cue" ]]; then
    eco="$(sed -E 's/^\[QEL::ECO\[([0-9]+)\].*/\1/' <<<"$cue")"
    [[ -n "$eco" ]] && eco="A${eco}"
  else
    eco="$(awk '/^\[QEL::ECO\[[0-9]+\]/{print; exit}' "$TMP" | sed -E 's/^\[QEL::ECO\[([0-9]+)\].*/A\1/')" || true
  fi
  updated="$(get_kv 'Updated')"
  yymmdd="$(to_yymmdd "$updated")"
  if [[ -n "$eco" && -n "$yymmdd" ]]; then
    echo "${eco}-${yymmdd}"
  else
    echo ""
  fi
}

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
    printf '%s' "$s" | jq -Rr @json | sed 's/^"//; s/"$//'
  else
    s=${s//\\/\\\\}; s=${s//\"/\\\"}; s=${s//$'\n'/\\n}; s=${s//$'\r'/}; s=${s//$'\t'/\\t}
    printf '%s' "$s"
  fi
}

# --------------------- Extraer metadatos del doc -------------
CUE="$(get_kv 'cue')"; [[ -n "$CUE" ]] || CUE="$(get_cue)"
SOT="$(get_kv 'SoT')"
VER="$(get_kv 'Version')"
UPD="$(get_kv 'Updated')"

# SeedI (respeta flag explícita, si no deriva)
if [[ -z "$SEED" ]]; then
  SEED="$(derive_seed_from_doc "$FILE")"
  [[ -z "$SEED" ]] && echo "[atlas] (warn) no se pudo derivar SeedI; usa --seed Axx-YYMMDD si aplica" >&2
fi

# HASH10 del micro-registro (no toca el hash canónico del documento)
if [[ -z "$HASH10" ]]; then
  DATA=$(printf "cue=%s|SeedI=%s|SoT=%s|Version=%s|Updated=%s" "${CUE:-}" "${SEED:-}" "${SOT:-}" "${VER:-}" "${UPD:-}")
  if command -v shasum >/dev/null 2>&1; then
    HASH=$(printf "%s" "$DATA" | shasum -a 1 | awk '{print $1}')
  else
    HASH=$(printf "%s" "$DATA" | openssl dgst -sha1 | awk '{print $2}')
  fi
  HASH10=${HASH:0:10}
fi

# Título por defecto si no viene
TITLE="${TITLE:-$(basename "$FILE")}"

# --------------------- Emitir línea JSONL --------------------
TS=$(date -u +%FT%TZ)
mkdir -p "$(dirname "$MICROREG")"

F_ESC="$(json_escape "$FILE")"
T_ESC="$(json_escape "$TITLE")"
C_ESC="$(json_escape "${CUE:-}")"
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

LINE="{\"ts\":\"$TS\",\"kind\":\"$KIND\",\"title\":\"$T_ESC\",\"file\":\"$F_ESC\",\"hash10\":\"$HASH10\",\
\"cue\":\"$C_ESC\",\"seed\":\"$S_ESC\",\"sot\":\"$SO_ESC\",\"version\":\"$V_ESC\",\"updated\":\"$U_ESC\",\
\"vf\":{\"triada\":\"$TR_ESC\",\"obj\":\"$O_ESC\",\"rumbo\":\"$R_ESC\",\"clase\":\"$K_ESC\",\"materia\":\"$M_ESC\"},\
\"metrics\":{\"V\":\"$V\",\"tau\":\"$TAU\"},\"gates\":\"$G_ESC\"}"

echo "$LINE" >> "$MICROREG"
echo "[OK] Atlas micro-registro → $MICROREG"

# --------------------- Actualizar índices (si indexer existe) ------------
if [[ -f "$INDEXER" ]]; then
  # intento moderno (según --help que viste)
  if ! "$QEL_PY" "$INDEXER" \
        --file "$FILE" \
        --indices-dir "$INDICES_DIR" \
        --update all \
        ${SEED:+--seedI "$SEED"}; then
    # fallback: sintaxis antigua (por compatibilidad)
    if ! "$QEL_PY" "$INDEXER" \
          --mode add \
          --doc "$FILE" \
          --title "$TITLE" \
          ${SEED:+--seed "$SEED"} \
          --update-seeds "$INDICES_DIR/QEL_Index_Semillas_v1.0.md" \
          --update-routes "$INDICES_DIR/QEL_Index_Rutas_v1.0.md"; then
      echo "[indexer] (warn) no se pudo actualizar índices, continuando…" >&2
    fi
  fi
else
  echo "[indexer] (skip) $INDEXER no encontrado; continuando…" >&2
fi
