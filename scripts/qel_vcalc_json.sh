#!/usr/bin/env bash
set -euo pipefail

# [QEL::ECO[96]::RECALL A96-251112-VCALC-JSON]
# SeedI=A96-251112
# SoT=HERRAMIENTAS/VCALC_JSON/v0.3
# Version=v0.3
# Updated=2025-11-12

# Wrapper JSON → llama a qel_vcalc.sh json
# - Acepta entrada por --json, --in o stdin
# - Añade flags MFH en espejo y preserva comportamiento previo
# - No procesa la salida: re-emite el JSON tal cual

usage() {
cat <<'H'
Uso:
  # Fuente JSON directa
  scripts/qel_vcalc_json.sh --json '{"obj":"Kael/Prisma","afinidad":0.72,"rumbo":"O","clase":"singular","gates":["mediacion","doble"],"ruido":0.03,"delta":{"c":"up","s":"flat"}}' [--mfh clip|logistic|auto --mfh-k 12 --mfh-x0 0.62 --mfh-include-gates true|false]

  # Leer de archivo
  scripts/qel_vcalc_json.sh --in vcalc_input.json [--mfh clip|logistic|auto --mfh-k 12 --mfh-x0 0.62 --mfh-include-gates true|false]

  # Leer de stdin
  cat vcalc_input.json | scripts/qel_vcalc_json.sh [--mfh clip|logistic|auto ...]

Flags:
  --json '<obj>'        Cadena JSON directa (comillas simples recomendadas)
  --in <file.json>      Leer JSON desde archivo
  --mfh <mode>          clip|logistic|auto (def=clip)
  --mfh-k <num>         pendiente para logistic (def=12)
  --mfh-x0 <num>        punto medio para logistic (def=0.62)
  --mfh-include-gates   true|false (def=false, MFH sin gates)
  -h|--help             esta ayuda

Salida:
  Re-emite el JSON que produce 'qel_vcalc.sh json', ahora con claves:
    "V" (operativa), "V_mfh" (paralela MFH), y metadatos MFH.
H
}

BASE="$(cd "$(dirname "$0")" && pwd -P)"
VCALC_SH="${BASE}/qel_vcalc.sh"

INPUT=""
MFH_MODE="clip"
MFH_K="12"
MFH_X0="0.62"
MFH_INCLUDE_GATES="false"

while [ $# -gt 0 ]; do
  case "$1" in
    --json) INPUT="$2"; shift 2;;
    --in)   INPUT="$(cat "$2")"; shift 2;;
    --mfh)  MFH_MODE="$2"; shift 2;;
    --mfh-k) MFH_K="$2"; shift 2;;
    --mfh-x0) MFH_X0="$2"; shift 2;;
    --mfh-include-gates) MFH_INCLUDE_GATES="$(printf "%s" "$2" | tr '[:upper:]' '[:lower:]')"; shift 2;;
    -h|--help) usage; exit 0;;
    *)
      echo "Flag desconocida: $1"
      usage
      exit 2
      ;;
  esac
done

# Si no vino por --json/--in, intenta leer stdin (si hay)
if [ -z "${INPUT}" ]; then
  if [ -t 0 ]; then
    echo "Falta entrada JSON (usa --json, --in o stdin)." >&2
    usage
    exit 1
  else
    INPUT="$(cat)"
  fi
fi

# Normaliza decimales (coma→punto) y limpia CR
INPUT="$(printf "%s" "$INPUT" | sed 's/,/./g' | tr -d '\r')"

exec "$VCALC_SH" json \
  --json "$INPUT" \
  --mfh "$MFH_MODE" \
  --mfh-k "$MFH_K" \
  --mfh-x0 "$MFH_X0" \
  --mfh-include-gates "$MFH_INCLUDE_GATES"
