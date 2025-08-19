#!/usr/bin/env bash
# [QEL::ECO[96]::RECALL A96-250817-PREH-NAV-FIX]
# SOT=PREH-NAV/v0.2 TARGET=react|navegador|m1
# VERSION=v0.2 UPDATED=2025-08-17
set -euo pipefail

echo ">> (1) Detectando package.json dentro de 2 niveles..."
PKG="$(find . -maxdepth 2 -name package.json | head -n1 || true)"
if [[ -z "${PKG}" ]]; then
  echo "No se encontró package.json en ./ o a 2 niveles. Asegura que el ZIP esté descomprimido aquí."
  exit 1
fi
PKGDIR="$(dirname "${PKG}")"
echo "   Detectado en: ${PKGDIR}"

if [[ "${PKGDIR}" != "." ]]; then
  echo ">> (2) Aplanando contenido desde ${PKGDIR}/ hacia ./"
  rsync -a "${PKGDIR}/" "./"
  rm -rf "${PKGDIR}"
fi

echo ">> (3) Normalizando nombres/rutas del visor"
mkdir -p src/components
# Variantes posibles a corregir
if [[ -f "DocsViewer.tsx" && ! -f "src/components/DocViewer.tsx" ]]; then mv "DocsViewer.tsx" "src/components/DocViewer.tsx"; fi
if [[ -f "DocViewer.tsx"  && ! -f "src/components/DocViewer.tsx" ]]; then mv "DocViewer.tsx"  "src/components/DocViewer.tsx";  fi
if [[ -f "src/DocsViewer.tsx" && ! -f "src/components/DocViewer.tsx" ]]; then mv "src/DocsViewer.tsx" "src/components/DocViewer.tsx"; fi
if [[ -f "src/DocViewer.tsx"  && ! -f "src/components/DocViewer.tsx" ]]; then mv "src/DocViewer.tsx"  "src/components/DocViewer.tsx";  fi
if [[ -f "src/components/DocsViewer.tsx" && ! -f "src/components/DocViewer.tsx" ]]; then mv "src/components/DocsViewer.tsx" "src/components/DocViewer.tsx"; fi

# Ajustar import si estaba con 'DocsViewer'
if [[ -f "src/main.tsx" ]]; then
  if grep -q "DocsViewer" src/main.tsx; then
    # BSD sed (macOS) compatible
    sed -i '' 's/DocsViewer/DocViewer/g' src/main.tsx || sed -i 's/DocsViewer/DocViewer/g' src/main.tsx
  fi
fi

echo ">> (4) Verificación de archivos clave:"
ls -la package.json || true
ls -la vite.config.ts || true
ls -la tsconfig.json || true
ls -la src/main.tsx || true
ls -la src/components/DocViewer.tsx || true

echo ">> (5) Instalando dependencias..."
if ! command -v npm >/dev/null 2>&1; then
  echo "npm no encontrado. Instala Node.js 18+."
  exit 1
fi
npm i

cat <<'TIP'

✔ Instalación lista. Para arrancar:
  npm run dev

Luego copia tu manifest y docs para ver contenido:
  # desde el root de tu repo (ajusta rutas si cambian)
  cp ../../docs/core/QEL_SoT_Manifest_v0.7.json public/sot-manifest.json
  rsync -av --delete ../../docs/ public/docs/

TIP
