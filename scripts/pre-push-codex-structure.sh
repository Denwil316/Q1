#!/usr/bin/env bash
set -euo pipefail

# [QEL::ECO[96]::RECALL A96-251117-PRE-PUSH-STRUCTURE]
# SeedI=A96-251117
# SoT=HERRAMIENTAS/GIT-HOOKS/v1.0
# Version=v1.0
# Updated=2025-11-17

# Hook pre-push: actualiza la estructura SOLO cuando vas a empujar la rama.
# Instala el hook con:
#   ln -sf ../../scripts/pre-push-codex-structure.sh .git/hooks/pre-push
#
# Config por env:
#   STRUCT_OUT      (def=ESTRUCTURA.md)
#   STRUCT_DEPTH    (def=4)         # 0 = sin límite
#   STRUCT_EXCLUDES (def=.git:node_modules:out:apps/*/dist:apps/*/build:apps/*/public/docs)

STRUCT_OUT="${STRUCT_OUT:-ESTRUCTURA.md}"
STRUCT_DEPTH="${STRUCT_DEPTH:-4}"
STRUCT_EXCLUDES="${STRUCT_EXCLUDES:-.git:node_modules:out:apps/*/dist:apps/*/build:apps/*/public/docs}"

echo "[pre-push] Actualizando estructura → $STRUCT_OUT (DEPTH=$STRUCT_DEPTH)"
OUT_FILE="$STRUCT_OUT" DEPTH="$STRUCT_DEPTH" EXCLUDES="$STRUCT_EXCLUDES" \
  scripts/update_estructura.sh

# Resultado ya quedó 'git add' dentro de update_estructura.sh
echo "[pre-push] ESTRUCTURA lista y staged."
