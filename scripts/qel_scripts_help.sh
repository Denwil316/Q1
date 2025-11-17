#!/usr/bin/env bash
set -euo pipefail

# [QEL::ECO[96]::RECALL A96-251117-QEL-SCRIPTS-HELP]
# SeedI=A96-251117
# SoT=HERRAMIENTAS/HELP/v1.4
# Version=v1.4
# Updated=2025-11-17

# Ayuda centralizada para los scripts QEL.
# Uso:
#   scripts/qel_scripts_help.sh            # guía completa
#   scripts/qel_scripts_help.sh <seccion>  # p.ej. vcalc, finalize, promote, atlas, cuemachine, audit, autofix, sot, manifest, estructura, serve, install, verify
#
# Notas:
# - Mantiene compatibilidad con flujos Win/macOS/WSL.
# - Ejemplos listos para copiar/pegar (usar comillas simples cuando metas JSON).

hr(){ printf '%*s\n' "$(tput cols 2>/dev/null || echo 80)" | tr ' ' '-'; }
p(){ printf "%s\n" "$1"; }
sec(){ hr; printf "## %s\n\n" "$1"; }

HELP_ALL(){

sec "VCALC (operativa) + MFH (formal)"
cat <<'H'

1) scripts/qel_vcalc.sh
- Función: calcula 𝒱 por dos rutas en paralelo:
  • VCALC → V_canon = clip(A·χ_r·H_k·Π_gates); V_oper = V_canon×F_Δ×F_ρ
  • MFH   → V_mfh = clip/logistic(A·χ_r·H_k[·Π_gates opcional])
- Flags (núcleo):
  --obj, --afinidad, --rumbo N|O|E|W|S|C, --clase (básica|poco común|singular|metálica|obsidiana),
  --gates "mediacion[,doble][,aurora]", --ruido, --delta-c up|flat|down, --delta-s up|flat|down,
  --emit pretty|quiet|json
- Flags (MFH):
  --mfh clip|logistic|auto (def=clip), --mfh-k 12, --mfh-x0 0.62, --mfh-include-gates true|false (def=false)

Ejemplos:
  scripts/qel_vcalc.sh --obj "Kael/Prisma" --afinidad 0.72 --rumbo O --clase singular \
    --gates "mediacion,doble" --ruido 0.03 --delta-c up --delta-s flat \
    --mfh clip --mfh-include-gates false --emit pretty

  echo '{"obj":"Kael/Prisma","afinidad":0.72,"rumbo":"O","clase":"singular","gates":["mediacion","doble"],"ruido":0.03,"delta":{"c":"up","s":"flat"}}' \
  | scripts/qel_vcalc.sh json --mfh clip --mfh-include-gates false

  scripts/qel_vcalc.sh --obj "Kael/Prisma" --afinidad 0.62 --rumbo E --clase singular \
    --mfh logistic --mfh-k 12 --mfh-x0 0.62 --emit pretty

2) scripts/qel_vcalc_json.sh (wrapper)
- Pasa JSON → qel_vcalc.sh json y re-emite la salida con "V" (oper) + "V_mfh".
- Flags espejo MFH: --mfh, --mfh-k, --mfh-x0, --mfh-include-gates

3) scripts/qel_vcalc_io.sh (wrapper)
- Abre el modo interactivo (pregunta VCALC+MFH) y ofrece salida pretty o JSON.
H

sec "Sesiones (new/finalize)"
cat <<'H'
1) scripts/qel_session_new.sh
- Crea FS inicial (fecha, tema, intención, modo, rumbo, tiempo, refs, salidas_esperadas, métricas, testigos, triada, mantra).
- Salida: FS_YYMMDD.json (y eco en consola).
- Uso típico:
  scripts/qel_session_new.sh
  # responder prompts (o usar flags si tu versión los acepta)

2) scripts/qel_session_finalize.sh
- Cierra sesión: genera VF.PRIMA, MicroSello, actualiza ListadoR/Diario, expone a PREH-NAV si procede.
- Ejemplo:
  scripts/qel_session_finalize.sh \
    --fecha $(date +%y%m%d) \
    --vf "Cheat-Sheet de scripts v1.4 validado; QA OK" \
    --cue "[QEL::ECO[96]::RECALL A96-$(date +%y%m%d)-CHEATSHEET-SCRIPTS]" \
    --seed "A96-$(date +%y%m%d)" \
    --fs-json FS_$(date +%y%m%d).json --no-mentira true
H

sec "Promoción y Atlas"
cat <<'H'
1) scripts/qel_promote_mac.sh
- Promueve un documento (rubro, file, titulo, rumbo), garantiza HASH(10) en EOF.
- Ejemplo:
  scripts/qel_promote_mac.sh \
    --rubro "CORE/MANUAL" \
    --file "docs/core/manuales/QEL_scripts_cs.md" \
    --titulo "QEL · Cheat-Sheet Operativo de Scripts (v1.4)" \
    --rumbo "Centro"

2) scripts/qel_atlas_microreg.sh
- Inserta línea JSONL en docs/core/atlas_microreg_v1.0.jsonl (kind, file, title, hash, …).
- Ejemplo:
  scripts/qel_atlas_microreg.sh \
    --kind "CORE/MANUAL" \
    --file "docs/core/manuales/QEL_scripts_cs.md" \
    --title "QEL · Cheat-Sheet Operativo de Scripts (v1.4)"
H

sec "CueMachine (ledger + firma)"
cat <<'H'
1) scripts/qel_cuemachine_add.sh
- Agrega entrada al ledger con CUE, SeedI, SoT, Version, Updated, target. Evita duplicados salvo --allow-duplicate.
- Ejemplo:
  scripts/qel_cuemachine_add.sh \
    --cm-file docs/cuemachine/ledger.txt \
    --cue   "[QEL::ECO[96]::RECALL A96-$(date +%y%m%d)-CHEATSHEET-SCRIPTS]" \
    --seed  "A96-$(date +%y%m%d)" \
    --sot   "CHEATSHEETS/SCRIPTS/v1.4" \
    --version "v1.4" --updated "$(date +%F)" \
    --target "docs/core/manuales/QEL_scripts_cs.md" --verbose

2) scripts/qel_cuemachine_check.sh
- Actualiza cadena, firma HMAC, verifica y bloquea ledger.
- Ejemplo:
  scripts/qel_cuemachine_check.sh \
    --cm-file docs/cuemachine/ledger.txt \
    --update-chain --sign --verify --verify-sign --lock --verbose

3) scripts/qel_secret_init.sh (previo a firmar)
- Crea y guarda secreto HMAC en macOS Keychain (o usa var de entorno). Muestra hash10 del secreto.
H

sec "Auditoría, autofix, SoT resolver"
cat <<'H'
1) scripts/qel_trace_audit.sh
- Auditoría integral (front-matter, CUE, HASH, ListadoR, Atlas, duplicados, métricas).
- Salidas: out/qel_trace_report.csv|md, out/qel_trace_run.json

2) scripts/qel_trace_autofix.sh
- Autofix conservador de front-matter, EOF hash, SoT y bloques básicos de ListadoR.
- Usar primero en dry-run y luego APPLY=1.

3) scripts/qel_sot_resolve.sh
- Normaliza/deriva SoT: de ListadoR, PREH-NAV (opcional), reglas por ruta; reporta UNCLASSIFIED.
- Puede escribir SoT al archivo y actualizar ListadoR (policy keep|soft|force).
H

sec "Manifest y PREH-NAV"
cat <<'H'
1) scripts/gen_manifest.sh
- Genera apps/preh-nav-m1/public/sot-manifest.json vía scripts/generate_manifest.mjs

2) scripts/gen_core_manifest.sh / gen_core_manifest.mjs
- Indexa docs/core → QEL_SoT_Manifest_v0.8.json (metadatos + hash10)

3) scripts/serve_preh_nav.sh
- Servidor http estático para navegar repo/PREH-NAV.
- Ejemplo: scripts/serve_preh_nav.sh 8080 127.0.0.1
H

sec "Instalación / Verificación"
cat <<'H'
1) scripts/qel_install_missing.sh  (y .ps1 en Windows)
- Instala git/LFS, node, jq/yq, ripgrep, fd, make; configura git/corepack.

2) scripts/qel_verify_env.sh
- Verifica toolchain, LFS, manifests y settings (Win/WSL/macOS).
H
}

SECTION(){
  case "${1:-}" in
    vcalc|vcalc_json|vcalc_io|finalize|promote|atlas|cuemachine|audit|autofix|sot|manifest|estructura|serve|install|verify)
      HELP_ALL | awk -v s="$1" '
        BEGIN{IGNORECASE=1; show=0}
        /^## /{ if (show) exit; if ($0 ~ s) show=1 }
        { if (show) print $0 }
      '
    ;;
    *)
      HELP_ALL
    ;;
  esac
}

SECTION "${1-}"
