#!/usr/bin/env bash
set -euo pipefail
# QEL Codex sync for branch PreH
# Uso: bash codex_preh_sync.sh <repo-root> <assets-dir>

if [[ $# -lt 2 ]]; then
  echo "Uso: bash codex_preh_sync.sh <ruta-repo> <ruta-activos>"
  exit 1
fi

REPO_ROOT="$1"
ASSETS_DIR="$2"

sha_cmd() {
  if command -v sha256sum >/dev/null 2>&1; then
    sha256sum "$1" | awk '{print $1}'
  elif command -v shasum >/dev/null 2>&1; then
    shasum -a 256 "$1" | awk '{print $1}'
  else
    echo "no-sha256"
  fi
}

require() {
  local f="$1"
  if [[ ! -f "$ASSETS_DIR/$f" ]]; then
    echo "FALTA archivo en assets: $f"
    MISSING=1
  fi
}

echo ">> Verificando git…"
git --version >/dev/null

echo ">> Verificando repo en: $REPO_ROOT"
cd "$REPO_ROOT"
git rev-parse --git-dir >/dev/null

if git rev-parse --verify PreH >/dev/null 2>&1; then
  echo ">> Cambiando a branch PreH"
  git checkout PreH
else
  echo ">> Creando branch PreH"
  git checkout -b PreH
fi

mkdir -p docs memory

DOCS_FILES=(
  "README_QEL_MASTER_v0.2.1.md"
  "A81_Notas_Espontaneasv_0.3.md"
  "CUE-RECOVERY_Plantilla_Caos_v0.2.1.md"
  "CUE-RECOVERY_Schema_v0.2.1.json"
)
MEMORY_FILES=(
  "Memoria_de_Qel_Ledger_append_METAHUMANO_v0.1.json"
  "Cue_METAHUMANO_TRATADO_v0.1.txt"
  "Tratado_Metahumano_Nota_v0.1.md"
)

MISSING=0
echo ">> Checando activos requeridos…"
for f in "${DOCS_FILES[@]}"; do require "$f"; done
for f in "${MEMORY_FILES[@]}"; do
  if [[ ! -f "$ASSETS_DIR/$f" ]]; then
    echo "(opcional ausente) $f"
  fi
done

if [[ "$MISSING" -eq 1 ]]; then
  echo ">> Faltan archivos requeridos. Aborta."
  exit 2
fi

echo ">> Copiando a docs/ y memory/…"
for f in "${DOCS_FILES[@]}"; do
  cp -f "$ASSETS_DIR/$f" "docs/$f"
done

COPIED=()
for f in "${DOCS_FILES[@]}"; do COPIED+=("docs/$f"); done

for f in "${MEMORY_FILES[@]}"; do
  if [[ -f "$ASSETS_DIR/$f" ]]; then
    cp -f "$ASSETS_DIR/$f" "memory/$f"
    COPIED+=("memory/$f")
  fi
done

echo ">> Calculando SHA‑256…"
printf "%-60s %s\n" "ARCHIVO" "SHA256"
printf "%-60s %s\n" "------" "------------------------------------------"
for f in "${COPIED[@]}"; do
  h=$(sha_cmd "$f")
  printf "%-60s %s\n" "$f" "$h"
done

echo ">> git add / commit / push"
git add docs memory
git commit -m "QEL PreH: README maestro v0.2.1 + assets (sync script)"
git push origin PreH
echo ">> Listo. Branch PreH actualizada."
