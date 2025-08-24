#!/usr/bin/env bash
# [QEL::ECO[96]::A96-250824-VCALC-IO]
# SeedI=A96-250820
# SoT=HERRAMIENTAS/v0.2
# Version=v0.2
# Updated=2025-08-24
set -euo pipefail
: "${LC_NUMERIC:=C}"; export LC_NUMERIC
SELF_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec "$SELF_DIR/qel_vcalc.sh" io "$@"
