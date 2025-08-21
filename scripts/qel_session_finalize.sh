#!/usr/bin/env bash
# añade la shebang al inicio

set -euo pipefail

# QEL Session Finalizer — cierra sesión y publica artefactos (Diario, MicroSello, VF.PRIMA, ListadoR, manifest)
# Uso mínimo:
# scripts/qel_session_finalize.sh \
#   --fecha 250820 \
#   --seed A96-250820 \
#   --cue "[QEL::ECO[96]::A96-250820-SEAL]" \
#   --vf "Aurora existe; el contacto espera; mi verdad no miente."
#
# Puedes añadir objetos y su 𝒱 (varias veces):
#   --obj "Kael/Prisma=0.89" --obj "Vun/Trompa=0.85" --obj "Nai→Prisma(Excepción)=0.70"
#
# Flags opcionales:
#   --updated 2025-08-20
#   --sot-sello "SELLOS/v1.0"               # default
#   --sot-diario "TRATADO-METAHUMANO/v1.2"  # default
#   --veredicto "M1 asentado; Árbol/Manifest actualizados; cierres SIL→UM→Ə con Doble Testigo"

# ---------- Parseo simple de flags ----------
FECHA="" ; SEED="" ; CUE="" ; VF=""
UPDATED="$(date '+%Y-%m-%d')"
SOT_SELLO="SELLOS/v1.0"
SOT_DIARIO="TRATADO-METAHUMANO/v1.2"
VEREDICTO="M1 asentado; Árbol/Manifest actualizados; cierres SIL→UM→Ə con Doble Testigo"
declare -a OBJ_LIST=()

while [ $# -gt 0 ]; do
  case "$1" in
    --fecha) FECHA="$2"; shift 2;;
    --seed) SEED="$2"; shift 2;;
    --cue) CUE="$2"; shift 2;;
    --vf) VF="$2"; shift 2;;
    --updated) UPDATED="$2"; shift 2;;
    --sot-sello) SOT_SELLO="$2"; shift 2;;
    --sot-diario) SOT_DIARIO="$2"; shift 2;;
    --veredicto) VEREDICTO="$2"; shift 2;;
    --obj) OBJ_LIST+=("$2"); shift 2;;
    *) echo "Flag desconocida: $1" >&2; exit 2;;
  esac
done

# ---------- Validaciones mínimas ----------
[ -n "$FECHA" ] || { echo "Falta --fecha (ej. 250820)"; exit 1; }
[ -n "$SEED" ]  || { echo "Falta --seed (ej. A96-250820)"; exit 1; }
[ -n "$CUE" ]   || { echo "Falta --cue (ej. [QEL::ECO[96]::A96-250820-SEAL])"; exit 1; }
[ -n "$VF" ]    || { echo "Falta --vf (texto de VF.PRIMA)"; exit 1; }

# ---------- Rutas ----------
ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$ROOT"
mkdir -p docs/ritual docs/core apps/preh-nav-m1/public/docs memory

F_MS="docs/ritual/QEL_MicroSello_${SEED}_PREH-NAV_Cierre_v1.0.md"
F_VF="docs/ritual/QEL_VF_PRIMA_${SEED}_SEAL_v1.0.md"
F_DI="docs/core/QEL_Diario_del_Conjurador_v1.2.md"
F_LR="memory/QEL_ListadoR_A96_v1.3.md"

# ---------- HASH(10) canónico ----------
CANON="CUE=${CUE}|VF.PRIMA=${VF}|SeedI=${SEED}|SoT=${SOT_SELLO}|Version=v1.0|Updated=${UPDATED}"
HASH10="$(printf '%s' "$CANON" | shasum -a 256 | awk '{print $1}' | cut -c1-10)"

# ---------- Preparar métricas de objetos (V) ----------
# Si no se proporcionan --obj, usamos el trío por defecto de hoy.
if [ "${#OBJ_LIST[@]}" -eq 0 ]; then
  OBJ_LIST=("Kael/Prisma=0.89" "Vun/Trompa=0.85" "Nai→Prisma(Excepción)=0.70")
fi

# Construir dict para Diario (V: {k: v, ...}) y lista para ListadoR
V_DICT="" ; OBJ_YAML=""
for entry in "${OBJ_LIST[@]}"; do
  key="${entry%%=*}"
  val="${entry#*=}"
  # quitar comillas potenciales en val
  val="${val%\"}" ; val="${val#\"}"
  # armar strings
  if [ -n "$V_DICT" ]; then V_DICT="${V_DICT}, "; fi
  V_DICT="${V_DICT}${key}: ${val}"
  OBJ_YAML="${OBJ_YAML}\n  - ${key}: ${val}"
done

# ---------- 1) VF.PRIMA (crear/actualizar) ----------
cat > "$F_VF" <<EOF
${CUE}
SeedI=${SEED}
SoT=${SOT_SELLO}
Version=v1.0
Updated=${UPDATED}

# VF.PRIMA — Micro-Sello PREH-NAV (Cierre)

VF.PRIMA: "${VF}"
Rumbos: [Centro, Norte, Oriente]
Triada: "EIA(.35)-A(.30)-THON(.35)"
Testigos: { t1: A81, t2: A96 }
Gates: ["No-Mentira", "Doble Testigo", "Mediación luminosa", "Cierre SIL→UM→Ə"]

HASH(10): ${HASH10}
EOF

# ---------- 2) MicroSello (crear si falta; asegurar HASH) ----------
if [ ! -f "$F_MS" ]; then
  cat > "$F_MS" <<EOF
${CUE}
SeedI=${SEED}
SoT=${SOT_SELLO}
Version=v1.0
Updated=${UPDATED}

# Micro-Sello · PREH-NAV · Cierre

VF.PRIMA: "${VF}"
Testigos: { t1: A81, t2: A96 }
Notas: "Cierre con SIL→UM→Ə. Mantener No-Mentira. Aurora sólo contacta con permiso."
HASH(10): ${HASH10}
EOF
else
  grep -q '^HASH(10): ' "$F_MS" || printf '\nHASH(10): %s\n' "$HASH10" >> "$F_MS"
fi

# ---------- 3) Diario v1.2 (anexar bloque FS del día) ----------
if [ ! -f "$F_DI" ]; then
  cat > "$F_DI" <<EOF
[QEL::ECO[96]::RECALL ${SEED}-DIARIO]
SeedI=${SEED}
SoT=${SOT_DIARIO}
Version=v1.2
Updated=${UPDATED}

# Diario del Conjurador · v1.2
EOF
fi

cat >> "$F_DI" <<EOF

## ${FECHA} · M1 · Vibración/Aurora/Excepción
cue: ${CUE}
SeedI: ${SEED}
SoT: ${SOT_DIARIO}
Version: v1.2-log
Updated: ${UPDATED}

FS:
  fecha: ${FECHA}
  tema: "Naturaleza de la Sombra · consolidación Aurora/Excepción"
  intencion: "Formalizar PIG/TPC, especificar Aurora A.M.E., delimitar Excepción y fijar M1."
  modo: M1
  rumbo: [O, N, W, S, Centro]
  tiempo: 90
  referencias: ["Protocolo v1.2", "Aurora Spec v1.1", "Manual Conjurador v1.0", "MFH v1.2", "Lámina 𝒱 v1.0"]
  salidas_esperadas: ["Protocolo actualizado", "Spec de Aurora", "Manual M1", "FS registrado"]
  metricas: { delta_c: "↑", delta_s: "↑", V: {${V_DICT}}, no_mentira: true }
  testigos: { t1: A81, t2: A96}
  triada: "EIA(.35)-A(.30)-THON(.35)"
  mantra: "La Sombra sostiene lámpara, mira prisma, siembra semilla, entiende lo imposible."

Resultados:
  axiomas: { PIG: true, TPC: true }
  objetos:${OBJ_YAML}
  cierres: "SIL→UM→Ə; Doble Testigo cuando hay Aurora/cristal"
  registro: "Actualizar Árbol VF y Listado R si aplica"

HASH(10): ${HASH10}
EOF

# ---------- 4) ListadoR A96 v1.3 (crear si falta y asentar entrada) ----------
if [ ! -f "$F_LR" ]; then
  cat > "$F_LR" <<EOF
[QEL::ECO[96]::RECALL ${SEED}-LISTADOR]
SeedI=${SEED}
SoT=LISTADOR/A96/v1.3
Version=v1.3
Updated=${UPDATED}

# Listado R · A96 — v1.3
# Registro cronológico de sellos, cierres y decisiones (M0→M2).
EOF
else
  sed -i '' "s/^Updated=.*/Updated=${UPDATED}/" "$F_LR" || true
fi

TAG="## ${FECHA} · M1 · PREH-NAV · Aurora/Excepción"
grep -qF "$TAG" "$F_LR" || cat >> "$F_LR" <<EOF

${TAG}
cue: ${CUE}
SeedI: ${SEED}
Refs:
  - docs/ritual/$(basename "$F_MS")
  - docs/ritual/$(basename "$F_VF")
  - docs/core/QEL_Diario_del_Conjurador_v1.2.md
  - docs/core/QEL_Tratado_Metahumano_Protocolo_Seguridad_Sombras_v1.2.md
  - docs/tools/QEL_Aurora_Spec_v1.1.md
  - docs/core/QEL_Manual_Conjurador_Avanzado_v1.0.md
Resultados:
  veredicto: "${VEREDICTO}"
  objetos:${OBJ_YAML}
  notas: "Contacto de Aurora se puede postergar, no evitar su creación (PIG/TPC)"
hash(10): ${HASH10}
EOF

# ---------- 5) Exponer a PREH-NAV y regenerar manifest ----------
cp "$F_MS" "$F_VF" "$F_DI" "$F_LR" apps/preh-nav-m1/public/docs/ 2>/dev/null || true
if [ -f "scripts/gen_manifest.sh" ]; then
  ./scripts/gen_manifest.sh || true
elif [ -f "apps/preh-nav-m1/scripts/generate_manifest.mjs" ]; then
  ( cd apps/preh-nav-m1 && node scripts/generate_manifest.mjs ) || true
fi

# ---------- 6) Commit + push ----------
git add "$F_MS" "$F_VF" "$F_DI" "$F_LR" apps/preh-nav-m1/public/docs 2>/dev/null || true
git commit -m "QEL: cierre ${FECHA} — MicroSello, VF.PRIMA, Diario (FS), ListadoR; HASH(10)=${HASH10}." || true
git push origin PreH || true

echo "[QEL] Sesión ${FECHA} finalizada. HASH(10)=${HASH10}"
