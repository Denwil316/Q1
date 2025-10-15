#!/usr/bin/env bash
cd "$(repo_root)" || die "No se pudo ubicar la raíz del repo"


echo "=== QEL Verify Env ==="
uname -a || true


HR=0


# Git y LFS
need git || HR=1
if need git lfs; then git lfs version || true; else HR=1; fi


# Node, npm, corepack/pnpm
need node || HR=1
need npm || HR=1
if command -v corepack >/dev/null 2>&1; then corepack -v || true; else warn "corepack no disponible"; HR=1; fi
if command -v pnpm >/dev/null 2>&1; then pnpm -v || true; else warn "pnpm no disponible (opcional)"; fi


# Python
if command -v python3 >/dev/null 2>&1; then python3 --version; ok "python3 OK"; elif command -v python >/dev/null 2>&1; then python --version; ok "python OK"; else warn "Python no disponible"; HR=1; fi


# Utilidades
need jq || HR=1
if command -v yq >/dev/null 2>&1; then yq --version; ok "yq OK"; else warn "yq no disponible"; HR=1; fi
if command -v rg >/dev/null 2>&1; then rg --version; ok "ripgrep OK"; else warn "ripgrep no disponible"; fi
if command -v fd >/dev/null 2>&1; then fd --version; ok "fd OK"; elif command -v fdfind >/dev/null 2>&1; then fdfind --version; ok "fdfind OK (alias sugerido)"; else warn "fd/fdfind no disponible"; fi
if command -v make >/dev/null 2>&1; then make -v | head -n1; ok "make OK"; else warn "make no disponible (opcional)"; fi


# VS Code (opcional)
if command -v code >/dev/null 2>&1; then code --version | head -n1 | xargs ok; else warn "VS Code no detectado en PATH (opcional)"; fi


hr


# Config Git recomendada en Windows/WSL
EOL=$(git config --get core.autocrlf || echo "")
FM=$(git config --get core.filemode || echo "")
[ "$EOL" = "false" ] || warn "Sugerencia: git config core.autocrlf false"
[ "$FM" = "false" ] || warn "Sugerencia: git config core.filemode false"


# LFS: estado rápido
if command -v git >/dev/null 2>&1; then
echo "-- LFS status --"; git lfs status || true
fi


# Detección de manifests
echo "-- Manifests JS/TS --"
(git ls-files | grep -E '^((apps|packages|tools)/.*/)?package\\.json$' || true) | sed -n '1,30p'


echo "-- Manifests Python --"
(git ls-files | grep -E '(requirements\\.txt|pyproject\\.toml|Pipfile|environment\\.ya?ml)$' || true) | sed -n '1,30p'


# Pistas para WSL (watchers)
if grep -qi microsoft /proc/version 2>/dev/null; then
warn "WSL detectado: si Vite no refresca, usa CHOKIDAR_USEPOLLING=1 npm run dev"
fi


hr
if [ "$HR" -eq 0 ]; then ok "Verificación completada (OK)"; exit 0; else warn "Verificación completada con pendientes"; exit 1; fi