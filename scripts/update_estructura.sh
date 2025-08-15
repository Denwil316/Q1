SeedI=PREH-NAV::M0
SOT=PREH-NAV/v0.2 TARGET=estructura|tree|docs
VERSION=v0.2 UPDATED=2025-08-15

set -euo pipefail
ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$ROOT"

if ! command -v tree >/dev/null 2>&1; then
  echo "Instala 'tree' (macOS: brew install tree)"; exit 1
fi

TS="$(date '+%Y-%m-%d %H:%M:%S')"
{
  echo "# Estructura de Codex ($PWD)"
  echo
  echo "_Generado: ${TS}_"
  echo
  echo '```text'
  tree -a -L 4 --dirsfirst \
    -I '.git|node_modules|dist|build|.DS_Store|__pycache__|.venv|venv|.idea|.vscode|*.zip|*.tar.gz|*.log|*.tmp|*.pdf|*.docx|*.png|*.jpg|*.jpeg|*.svg|*.mp4'
  echo '```'
} > ESTRUCTURA.md

git add ESTRUCTURA.md || true
echo "✅ Actualizado ESTRUCTURA.md"
