#!/usr/bin/env bash
set -euo pipefail
# [QEL::ECO[96]::RECALL A96-250821-APPLY]
# SeedI=A96-250821
# SoT=HERRAMIENTAS/v0.2
# Version=v0.2
# Updated=2025-08-21

# Aplica un paquete ZIP con documentos QEL actualizados.
# - Hace backup .bak si el archivo ya existe.
# - Copia docs/core, docs/tools y memory.
# - (Opcional) expone en apps/preh-nav-m1/public/docs/
# - Regenera manifest (gen_manifest.sh o generate_manifest.mjs)
# - (Opcional) git add/commit/push a la rama indicada.
#
# Uso:
#   scripts/apply_qel_update.sh --zip /ruta/al/qel_update_*.zip [--branch PreH] [--expose-public] [--no-git]
#
# Ejemplo:
#   scripts/apply_qel_update.sh --zip ~/Downloads/qel_update_M1_2025-08-21.zip --branch PreH --expose-public

ZIP=""
BRANCH="PreH"
EXPOSE_PUBLIC="0"
DO_GIT="1"

while [ $# -gt 0 ]; do
  case "$1" in
    --zip) ZIP="$2"; shift 2;;
    --branch) BRANCH="$2"; shift 2;;
    --expose-public) EXPOSE_PUBLIC="1"; shift 1;;
    --no-git) DO_GIT="0"; shift 1;;
    -h|--help)
      echo "Uso: $0 --zip <archivo.zip> [--branch PreH] [--expose-public] [--no-git]"
      exit 0;;
    *) echo "Flag desconocida: $1"; exit 2;;
  end esac
done

if [ -z "${ZIP}" ]; then
  echo "Falta --zip <archivo.zip>"; exit 1
fi
if [ ! -f "${ZIP}" ]; then
  echo "No encuentro ZIP: ${ZIP}"; exit 1
fi

ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$ROOT"

TMP="$(mktemp -d /tmp/qel_update.XXXXXX)"
trap 'rm -rf "$TMP"' EXIT

echo "[QEL] Descomprimiendo paquete en: ${TMP}"
unzip -o "${ZIP}" -d "${TMP}" >/dev/null

# Función copia con backup
copy_with_backup() {
  local src="$1"; local dst="$2"
  local dst_dir; dst_dir="$(dirname "$dst")"
  mkdir -p "$dst_dir"
  if [ -f "$dst" ]; then
    cp -f "$dst" "${dst}.bak.$(date +%Y%m%d%H%M%S)"
  fi
  cp -f "$src" "$dst"
  echo " + $(basename "$dst")"
}

echo "[QEL] Aplicando docs/core..."
if [ -d "${TMP}/docs/core" ]; then
  while IFS= read -r -d '' f; do
    rel="${f#"${TMP}/"}"
    copy_with_backup "$f" "$ROOT/${rel}"
  done < <(find "${TMP}/docs/core" -type f -print0)
else
  echo " (sin docs/core en paquete)"
fi

echo "[QEL] Aplicando docs/tools..."
if [ -d "${TMP}/docs/tools" ]; then
  while IFS= read -r -d '' f; do
    rel="${f#"${TMP}/"}"
    copy_with_backup "$f" "$ROOT/${rel}"
  done < <(find "${TMP}/docs/tools" -type f -print0)
else
  echo " (sin docs/tools en paquete)"
fi

echo "[QEL] Aplicando memory/..."
if [ -d "${TMP}/memory" ]; then
  while IFS= read -r -d '' f; do
    rel="${f#"${TMP}/"}"
    copy_with_backup "$f" "$ROOT/${rel}"
  done < <(find "${TMP}/memory" -type f -print0)
else
  echo " (sin memory/ en paquete)"
fi

if [ "$EXPOSE_PUBLIC" = "1" ]; then
  echo "[QEL] Exponiendo a apps/preh-nav-m1/public/docs/..."
  mkdir -p apps/preh-nav-m1/public/docs
  # Expón piezas clave si existen
  for f in \
    docs/core/QEL_Diario_del_Conjurador_v1.3.md \
    docs/core/QEL_Tratado_Metahumano_Protocolo_Seguridad_Sombras_v1.3.md \
    memory/QEL_ListadoR_A96_v1.4.md
  do
    [ -f "$f" ] && cp -f "$f" apps/preh-nav-m1/public/docs/
  done
fi

echo "[QEL] Regenerando manifest (si existe generador)..."
if [ -f "scripts/gen_manifest.sh" ]; then
  ./scripts/gen_manifest.sh || true
elif [ -f "apps/preh-nav-m1/scripts/generate_manifest.mjs" ]; then
  ( cd apps/preh-nav-m1 && node scripts/generate_manifest.mjs ) || true
else
  echo " (no se encontró generador de manifest)"
fi

if [ "$DO_GIT" = "1" ]; then
  echo "[QEL] Registrando cambios en git (rama ${BRANCH})..."
  git add docs/core docs/tools memory apps/preh-nav-m1/public/docs 2>/dev/null || true
  git commit -m "QEL: aplica paquete ZIP — docs y memory actualizados." || true
  git push origin "$BRANCH" || true
else
  echo "[QEL] Saltando git (flag --no-git)."
fi

echo "[QEL] Listo. Revisa backups .bak.* si quieres comparar."
