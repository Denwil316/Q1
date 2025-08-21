#!/usr/bin/env bash
set -euo pipefail
# [QEL::ECO[96]::RECALL A96-250821-HELP]
# SeedI=A96-250821
# SoT=HERRAMIENTAS/v0.1
# Version=v0.1
# Updated=2025-08-21

# Imprime guía de uso de los scripts del repo Codex (vista rápida y ejemplos).
# Uso:
#   scripts/qel_scripts_help.sh            # guía completa
#   scripts/qel_scripts_help.sh <script>   # sección específica (ej: qel_vcalc.sh)

SECTIONS=(
  "qel_vcalc.sh"
  "qel_session_finalize.sh"
  "apply_qel_update.sh"
  "gen_manifest.sh"
  "serve_preh_nav.sh"
  "update_estructura.sh"
  "fix_prehnav_layout.sh"
  "cx_navegador.zsh"
  "pre-commit-codex-structure.sh"
  "apps/preh-nav-m1/scripts/generate_manifest.mjs"
  "apps/preh-nav-m1/scripts/watch_manifest.mjs"
)

print_section() {
  case "$1" in
    qel_vcalc.sh)
cat <<'EOS'
[qel_vcalc.sh] — Calcula 𝒱 (viabilidad) por objeto
Propósito: obtener un número 0..1 para decidir cristal (≥0.85), líquido (0.70–0.84) o germinar (<0.70).
Uso:
  scripts/qel_vcalc.sh --obj "Kael/Prisma" --afinidad 0.90 --rumbo N \
    --clase singular --gates "mediacion,doble" --ruido 0.03 --delta-c up --delta-s up
Flags: --obj, --afinidad [0..1], --rumbo N|O|W|S|C, --clase comun|raro|singular|unico,
       --gates (coma), --ruido [0..1], --delta-c up|flat|down, --delta-s up|flat|down, --quiet
Tip: añade --quiet para imprimir sólo el número y encadenarlo al botón rojo.
EOS
;;
    qel_session_finalize.sh)
cat <<'EOS'
[qel_session_finalize.sh] — Botón rojo de cierre de sesión (VF.PRIMA, MicroSello, Diario, ListadoR, manifest)
Uso mínimo:
  scripts/qel_session_finalize.sh --fecha 250820 --seed A96-250820 \
    --cue "[QEL::ECO[96]::A96-250820-SEAL]" \
    --vf "Aurora existe; el contacto espera; mi verdad no miente."
Puedes repetir --obj varias veces para registrar 𝒱:
  --obj "Kael/Prisma=0.89" --obj "Vun/Trompa=0.85" --obj "Nai→Prisma(Excepción)=0.70"
Salida: crea/actualiza en docs/ritual/, docs/core/ y memory/, expone a public/ y lanza git (rama PreH).
EOS
;;
    apply_qel_update.sh)
cat <<'EOS'
[apply_qel_update.sh] — Aplica un ZIP de actualización QEL
Uso:
  scripts/apply_qel_update.sh --zip ~/Downloads/qel_update_*.zip [--branch PreH] [--expose-public] [--no-git]
Hace backup .bak, copia docs/core|tools y memory/, regenera manifest y (opcional) publica a public/docs/.
EOS
;;
    gen_manifest.sh)
cat <<'EOS'
[gen_manifest.sh] — Genera/elabora sot-manifest.json para PREH-NAV
Uso:
  scripts/gen_manifest.sh
Requisitos: Node y/o jq según tu implementación. Busca en docs/ y exporta a apps/preh-nav-m1/public/sot-manifest.json.
EOS
;;
    serve_preh_nav.sh)
cat <<'EOS'
[serve_preh_nav.sh] — Levanta el navegador PREH-NAV (vite dev server típico)
Uso:
  scripts/serve_preh_nav.sh
Tip: asegúrate de estar en el root del repo; instala deps con npm/yarn si es la primera vez.
EOS
;;
    update_estructura.sh)
cat <<'EOS'
[update_estructura.sh] — Recalcula y guarda ESTRUCTURA.md (árbol del repo)
Uso:
  scripts/update_estructura.sh
Salida: actualiza ESTRUCTURA.md con la hora de generación.
EOS
;;
    fix_prehnav_layout.sh)
cat <<'EOS'
[fix_prehnav_layout.sh] — Ajustes de layout/estilos del PREH-NAV (parches rápidos)
Uso:
  scripts/fix_prehnav_layout.sh
Aplica sed/patch para corregir detalles de UI cuando cambian dependencias.
EOS
;;
    cx_navegador.zsh)
cat <<'EOS'
[cx_navegador.zsh] — Atajos zsh para flujo del navegador (alias/funciones)
Uso:
  source scripts/cx_navegador.zsh
Provee alias para arrancar, limpiar cache, y abrir rutas frecuentes del PREH-NAV.
EOS
;;
    pre-commit-codex-structure.sh)
cat <<'EOS'
[pre-commit-codex-structure.sh] — Hook de verificación de estructura antes del commit
Uso:
  scripts/pre-commit-codex-structure.sh
Tip: integra con git hooks para bloquear commits si faltan docs clave.
EOS
;;
    apps/preh-nav-m1/scripts/generate_manifest.mjs)
cat <<'EOS'
[apps/preh-nav-m1/scripts/generate_manifest.mjs] — Generador JS del manifest en la app
Uso:
  (cd apps/preh-nav-m1 && node scripts/generate_manifest.mjs)
Lee docs/, compone JSON y escribe public/sot-manifest.json. Respeta CWD de la app.
EOS
;;
    apps/preh-nav-m1/scripts/watch_manifest.mjs)
cat <<'EOS'
[apps/preh-nav-m1/scripts/watch_manifest.mjs] — Watcher del manifest (dev)
Uso:
  (cd apps/preh-nav-m1 && node scripts/watch_manifest.mjs)
Observa cambios en docs/ y regenera manifest automáticamente durante el desarrollo.
EOS
;;
    *) echo "(sin sección para $1)";;
  esac
}

if [ $# -eq 0 ]; then
  echo "=== QEL · Instructivo de scripts (Codex) ==="
  echo "(ejecuta: scripts/qel_scripts_help.sh <script> para ver sección específica)"
  echo
  for s in "${SECTIONS[@]}"; do
    print_section "$s"
    echo
  done
else
  print_section "$1"
fi
