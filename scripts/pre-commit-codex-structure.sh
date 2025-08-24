#!/usr/bin/env bash
# PREH · pre-commit — generar/actualizar ESTRUCTURA.md
set -euo pipefail

ROOT="$(git rev-parse --show-toplevel 2>/dev/null || echo ".")"
cd "$ROOT"

if command -v tree >/dev/null 2>&1; then
  TS="$(date '+%Y-%m-%d %H:%M:%S')"
  {
    echo "# Estructura de Codex ($PWD)"
    echo
    echo "_Generado: ${TS}_"
    echo
    echo '```text'
    tree -a -L 4 --dirsfirst       -I '.git|node_modules|dist|build|.DS_Store|__pycache__|.venv|venv|.idea|.vscode|*.zip|*.tar.gz|*.log|*.tmp|*.pdf|*.docx|*.png|*.jpg|*.jpeg|*.svg|*.mp4'
    echo '```'
  } > ESTRUCTURA.md
  git add ESTRUCTURA.md || true
fi

if git diff --cached --name-only | grep -q '^docs/core/'; then
  echo "[PRE-COMMIT] Cambios en docs/core → publish + manifest"
  scripts/qel nav publish --mode copy || true
fi