#!/usr/bin/env bash
# qel_shadow_profile.sh — Wrapper para Perfilación de Sombras
# Uso:
#   bash scripts/qel_shadow_profile.sh \
#     --file docs/nutria/Vun_Oriente_Puente_Entrada_v0.1.md \
#     --fs FS_251106.json \
#     --seed A96-251106 \
#     [--id sombra01] [--out-dir docs/shadows]
#
# Salidas:
#   docs/shadows/perfiles/QEL_Sombra_<seed>_<id>_perfil_v1.0.json
#   docs/shadows/misiones/QEL_Sombra_<seed>_<id>_misiones_v1.0.md

set -euo pipefail
: "${LC_ALL:=C}"; export LC_ALL

FILE=""
FS_JSON=""
SEED=""
SID="auto"
OUT_DIR="docs/shadows"
ENGINE="${ENGINE:-scripts/qel_shadow_engine.py}"

while [ $# -gt 0 ]; do
  case "$1" in
    --file) FILE="$2"; shift 2;;
    --fs|--fs-json) FS_JSON="$2"; shift 2;;
    --seed) SEED="$2"; shift 2;;
    --id) SID="$2"; shift 2;;
    --out-dir) OUT_DIR="$2"; shift 2;;
    -h|--help)
      grep '^# ' "$0" | sed 's/^# //'; exit 0;;
    *) echo "[err] flag desconocida: $1" >&2; exit 2;;
  esac
done

[ -n "$FILE" ]   || { echo "[err] --file requerido"; exit 2; }
[ -n "$FS_JSON" ]|| { echo "[err] --fs requerido"; exit 2; }
[ -n "$SEED" ]   || { echo "[err] --seed requerido"; exit 2; }
[ -f "$FILE" ]   || { echo "[err] no existe $FILE"; exit 2; }
[ -f "$FS_JSON" ]|| { echo "[err] no existe $FS_JSON"; exit 2; }
[ -f "$ENGINE" ] || { echo "[err] falta motor $ENGINE"; exit 2; }

# Derivar ID corto si es "auto"
if [ "$SID" = "auto" ]; then
  if command -v shasum >/dev/null 2>&1; then
    SID="$(printf '%s' "$(basename "$FILE")$SEED" | shasum -a 1 | cut -c1-6)"
  else
    SID="$(date +%H%M%S)"
  fi
fi

PERF_DIR="${OUT_DIR%/}/perfiles"
MIS_DIR="${OUT_DIR%/}/misiones"
mkdir -p "$PERF_DIR" "$MIS_DIR"

PERF_OUT="${PERF_DIR}/QEL_Sombra_${SEED}_${SID}_perfil_v1.0.json"
MIS_OUT="${MIS_DIR}/QEL_Sombra_${SEED}_${SID}_misiones_v1.0.md"

# Ejecuta motor
python3 "$ENGINE" \
  --file "$FILE" \
  --fs "$FS_JSON" \
  --seed "$SEED" \
  --perfil-out "$PERF_OUT" \
  --misiones-out "$MIS_OUT"

echo "[ok] perfil → $PERF_OUT"
echo "[ok] misiones → $MIS_OUT"
echo "[tip] Puedes promover el .md de misiones con qel_promote_mac.sh y micro-registrar ambos."
