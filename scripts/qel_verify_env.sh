#!/usr/bin/env bash
set -euo pipefail

# [QEL::VERIFY]
# cue="verify/env"
# SeedI="A96-251011"
# SoT="QEL/VERIFY/ENV"
# Version="v1.0"
# Updated="2025-10-11"

ok()  { printf "✓ %s\n" "$*"; }
warn(){ printf "⚠ %s\n" "$*" >&2; }
die() { printf "✗ %s\n" "$*" >&2; exit 1; }

need() {
  if command -v "$1" >/dev/null 2>&1; then ok "$1 $( $1 --version 2>/dev/null | head -n1 )"; else warn "Falta $1"; fi
}

echo "=== QEL Verify Env ==="
uname -a || true
need git
need "git lfs"
need node
need npm
command -v corepack >/dev/null 2>&1 && corepack -v || warn "corepack no disponible"
command -v pnpm    >/dev/null 2>&1 && pnpm -v     || warn "pnpm no disponible"
command -v python3 >/dev/null 2>&1 && python3 --version || command -v python >/dev/null 2>&1 && python --version || warn "Python no disponible"
need jq
command -v yq >/dev/null 2>&1 && yq --version || warn "yq no disponible"
command -v rg >/dev/null 2>&1 && rg --version || warn "ripgrep no disponible"
command -v fd >/dev/null 2>&1 && fd --version || command -v fdfind >/dev/null 2>&1 && fdfind --version || warn "fd/fdfind no disponible"
command -v make >/dev/null 2>&1 && make -v || warn "make no disponible (opcional)"
echo "======================="

# Detección de manifests
echo "Manifests JS/TS:"; git ls-files | grep -E '^((apps|packages|tools)/.*/)?package\.json$' || true
echo "Manifests Python:"; git ls-files | grep -E '(requirements\.txt|pyproject\.toml|Pipfile|environment\.ya?ml)$' || true

ok "Listo. Instala lo faltante según advertencias."
