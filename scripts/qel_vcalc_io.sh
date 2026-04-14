#!/usr/bin/env bash
set -euo pipefail

# [QEL::ECO[96]::RECALL A96-251112-VCALC-IO]
# SeedI=A96-251112
# SoT=HERRAMIENTAS/VCALC_IO/v0.3
# Version=v0.3
# Updated=2025-11-12

# Wrapper IO → abre el modo interactivo del core.
# El modo IO del core ya pregunta por MFH (clip/logistic/auto),
# permite include_gates y ofrece salida JSON si se desea.

usage() {
cat <<'H'
Uso:
  scripts/qel_vcalc_io.sh
  # Abre el asistente interactivo (VCALC + MFH) del core

Notas:
  - El modo interactivo del core preguntará por:
      obj, afinidad, rumbo, clase, gates, ruido, delta-c/s
      y además: mfh mode, mfh include_gates, (k, x0 si logistic)
  - Al final puedes elegir salida 'pretty' o re-enviar como JSON.
H
}

if [ "${1-}" = "-h" ] || [ "${1-}" = "--help" ]; then
  usage
  exit 0
fi

BASE="$(cd "$(dirname "$0")" && pwd -P)"
exec "${BASE}/qel_vcalc.sh" io
