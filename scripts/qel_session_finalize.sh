#!/usr/bin/env bash
# QEL Session Finalizer — v1.1 (FS-aware, JSON template, artifacts)
# cue=[QEL::ECO[96]::RECALL A96-250826-SESSION-FINALIZE-V1-1]
# SeedI=A96-250824
# SoT=HERRAMIENTAS/SESSION-FINALIZE/v1.1
# Version=v1.1
# Updated=2025-08-26

set -euo pipefail
: "${LC_ALL:=C}"; export LC_ALL
: "${QEL_SEED_POLICY:=auto}"   # auto|keep|strict

# Safe init (Bash 3.2)
declare -a ARTEFACTOS MICROS
: "${ARTEFACTOS[@]:-}" >/dev/null 2>&1 || ARTEFACTOS=()
: "${MICROS[@]:-}"     >/dev/null 2>&1 || MICROS=()

need(){ command -v "$1" >/dev/null 2>&1 || { echo "Falta '$1'"; exit 1; }; }
need git; need awk; need shasum; need jq

# ---------- Parseo de flags ----------
FECHA="" ; SEED="" ; CUE="" ; VF=""
UPDATED="$(date '+%Y-%m-%d')"
SOT_SELLO="SELLOS/v1.0"
SOT_DIARIO="TRATADO-METAHUMANO/v1.2"
VEREDICTO="M1 asentado; Árbol/Manifest actualizados; cierres SIL→UM→Ə con Doble Testigo"
DIARIO_FILE="" ; LISTADOR_FILE="" HASH_REF10=""
declare -a OBJ_LIST=() SALIDAS=()

# NUEVOS: FS y contexto operacional
MODO="M0"; TEMA=""; INTENCION=""
RUMBO="Centro"     # string o lista coma
TIEMPO="30"
REFS=""            # coma-separada
DELTA_C=""; DELTA_S=""
NO_MENTIRA="true"
FS_JSON=""

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
    --diario-file) DIARIO_FILE="$2"; shift 2;;
    --listador-file) LISTADOR_FILE="$2"; shift 2;;
    --modo) MODO="$2"; shift 2;;
    --tema) TEMA="$2"; shift 2;;
    --intencion) INTENCION="$2"; shift 2;;
    --rumbo) RUMBO="$2"; shift 2;;
    --tiempo) TIEMPO="$2"; shift 2;;
    --refs) REFS="$2"; shift 2;;
    --delta-c) DELTA_C="$2"; shift 2;;
    --delta-s) DELTA_S="$2"; shift 2;;
    --no-mentira) NO_MENTIRA="$2"; shift 2;;
    --artefacto) ARTEFACTOS+=("$2"); shift 2;;
    --micro) MICROS+=("$2"); shift 2;;
    --fs-json) FS_JSON="$2"; shift 2;;
    --hash-ref) HASH_REF10="$2"; shift 2;;
    --salida) SALIDAS+=("$2"); shift 2;;
    *) echo "Flag desconocida: $1" >&2; exit 2;;
  esac
done

# --- Seed derivation helpers (portable) ---------------------------------
get_eco_from_cue() { # -> "A96" (default A96 si no encuentra)
  local cue="${1-}" n
  n="$(printf "%s" "$cue" | sed -nE 's/.*ECO\[([0-9]+)\].*/\1/p' | head -1)"
  [ -n "$n" ] && printf "A%s\n" "$n" || printf "A96\n"
}

git_first_date_ymd() { # -> YYMMDD del primer commit que añadió el archivo
  local f="$1" d
  d="$(git log --follow --diff-filter=A --format=%cs -- "$f" 2>/dev/null | tail -1)"
  [ -n "$d" ] || return 1                               # %cs = YYYY-MM-DD
  printf "%s%s%s\n" "${d:2:2}" "${d:5:2}" "${d:8:2}"    # -> YYMMDD
}

fs_birth_ymd() { # -> YYMMDD por nacimiento FS (fallback)
  local f="$1" epoch=""
  if stat -f '%B' "$f" >/dev/null 2>&1; then            # macOS (epoch)
    epoch="$(stat -f '%B' "$f")"
  elif stat -c '%W' "$f" >/dev/null 2>&1; then          # GNU (epoch o 0)
    epoch="$(stat -c '%W' "$f")"; [ "$epoch" = "0" ] && epoch=""
  fi
  if [ -n "$epoch" ] && [ "$epoch" -gt 0 ] 2>/dev/null; then
    date -u -d "@$epoch" +%y%m%d 2>/dev/null || date -r "$epoch" +%y%m%d
  else
    return 1
  fi
}

fs_mtime_ymd() { # -> YYMMDD por mtime (último recurso)
  local f="$1"
  date -u -d "@$(stat -c '%Y' "$f" 2>/dev/null)" +%y%m%d 2>/dev/null || \
  date -r "$(stat -f '%m' "$f" 2>/dev/null)" +%y%m%d 2>/dev/null || date +%y%m%d
}

derive_seed_auto() { # args: <file> <cue>  -> "A96-YYMMDD"
  local f="$1" cue="${2-}" eco ymd
  eco="$(get_eco_from_cue "$cue")"
  if ! ymd="$(git_first_date_ymd "$f")"; then
    if ! ymd="$(fs_birth_ymd "$f")"; then
      ymd="$(fs_mtime_ymd "$f")"
    fi
  fi
  printf "%s-%s\n" "$eco" "$ymd"
}

# -----------------------------------------------------------------------

# --- Fallback SEED desde artefacto (o derivado) -------------------------
# Usa el primer artefacto si existe; si no, deriva desde FILE/cwd
if [ -z "${SEED:-}" ]; then
  if [ "${#ARTEFACTOS[@]}" -gt 0 ] && [ -f "${ARTEFACTOS[0]}" ]; then
    ARTE="${ARTEFACTOS[0]}"
    TMP="$(mktemp)"; trap 'rm -f "$TMP"' EXIT
    tr -d '\r' < "$ARTE" > "$TMP"

    # Intenta leer cue/SeedI del artefacto
    SEED_IN="$(awk '/^[#[:space:]]*SeedI[[:space:]]*[:=]/{sub(/^.*[:=][[:space:]]*/,"");print;exit}' "$TMP")"
    CUE_IN="$(awk '/^\[QEL::ECO/{print;exit}' "$TMP")"
    [ -n "$CUE" ] || CUE="$CUE_IN"

    if [ -n "$SEED_IN" ]; then
      case "${QEL_SEED_POLICY:-auto}" in
        strict) SEED="$(derive_seed_auto "$ARTE" "$CUE")" ;;
        keep)   SEED="$SEED_IN" ;;
        auto|*) ECO_PREFIX="$(get_eco_from_cue "$CUE")-"
                case "$SEED_IN" in
                  "$ECO_PREFIX"*) SEED="$SEED_IN" ;;
                  *)              SEED="$(derive_seed_auto "$ARTE" "$CUE")" ;;
                esac
                ;;
      esac
    else
      SEED="$(derive_seed_auto "$ARTE" "$CUE")"
    fi
  else
    BASE_FILE="${FILE:-.}"
    SEED="$(derive_seed_auto "$BASE_FILE" "$CUE")"
  fi
fi
# -----------------------------------------------------------------------


# ---------- Validaciones mínimas ----------
[ -n "$FECHA" ] || { echo "Falta --fecha (ej. 250826)"; exit 1; }
[ -n "$CUE" ]   || { echo "No encontré CUE (pasa --cue o incluye [QEL::ECO...] en el artefacto)"; exit 1; }
[ -n "$SEED" ]  || { echo "No pude derivar SeedI; pasa --seed o --artefacto <archivo>"; exit 1; }
[ -n "$VF" ]    || { echo "Falta --vf (texto VF.PRIMA)"; exit 1; }

# ---------- Rutas ----------
ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$ROOT"
mkdir -p docs/ritual docs/core apps/preh-nav-m1/public/docs memory scripts

SEED_PREFIX="$(printf "%s" "$SEED" | cut -d- -f1)"
F_MS="docs/ritual/microsellos/QEL_MicroSello_${SEED}_PREH-NAV_Cierre_v1.0.md"
F_VF="docs/ritual/vf/QEL_VF_PRIMA_${SEED}_SEAL_v1.0.md"
F_DI="${DIARIO_FILE:-docs/core/QEL_Diario_del_Conjurador_v1.2.md}"
F_LR="${LISTADOR_FILE:-memory/listador/QEL_ListadoR_${SEED_PREFIX}_v1.3.md}"

# ---------- FS desde JSON (si se provee y existe) ----------
if [ -n "$FS_JSON" ] && [ -f "$FS_JSON" ]; then
  FECHA="$(jq -r '.fecha // empty' "$FS_JSON")" || true
  TEMA="$(jq -r '.tema // empty' "$FS_JSON")" || true
  INTENCION="$(jq -r '.intencion // empty' "$FS_JSON")" || true
  MODO="$(jq -r '.modo // empty' "$FS_JSON")" || true
  RUMBO="$(jq -r '(.rumbo | if type=="array" then join(",") else . end) // empty' "$FS_JSON")" || true
  TIEMPO="$(jq -r '.tiempo // empty' "$FS_JSON")" || true
  REFS="$(jq -r '(.referencias | if type=="array" then join(",") else . end) // empty' "$FS_JSON")" || true
  VEREDICTO="$(jq -r '.veredicto // empty' "$FS_JSON")" || true
  # arrays → bash (sin mapfile, compatible con bash 3.2)
  while IFS= read -r a; do [ -n "$a" ] && ARTEFACTOS+=("$a"); done < <(jq -r '.resultados.artefactos[]? // empty' "$FS_JSON")
  while IFS= read -r m; do [ -n "$m" ] && MICROS+=("$m"); done < <(jq -r '.resultados.micro_sellos[]? // empty' "$FS_JSON")
  while IFS= read -r s; do [ -n "$s" ] && SALIDAS+=("$s"); done < <(jq -r '.salidas_esperadas[]? // empty' "$FS_JSON")
elif [ -n "$FS_JSON" ] && [ ! -f "$FS_JSON" ]; then
  echo "[WARN] FS JSON no encontrado, ignoro: $FS_JSON" >&2
fi

# ---------- HASH(10) canónico ----------
CANON="CUE=${CUE}|VF.PRIMA=${VF}|SeedI=${SEED}|SoT=${SOT_SELLO}|Version=v1.0|Updated=${UPDATED}"
HASH10="$(printf '%s' "$CANON" | shasum -a 256 | awk '{print $1}' | cut -c1-10)"

# ---------- Métricas de objetos (V) ----------

V_DICT="" ; 
# --- construir OBJ_YAML de forma segura (sin defaults) ---
OBJ_YAML=""
# Si OBJ_LIST NO está definida, no la usamos (evita unbound var con set -u)
if [ -n "${OBJ_LIST+x}" ] && [ "${#OBJ_LIST[@]}" -gt 0 ]; then
  for pair in "${OBJ_LIST[@]}"; do
    k="${pair%%=*}"
    v="${pair#*=}"
    # Ajusta el formato de salida a tu estilo actual:
    # ejemplo: 2 espacios de indent, una línea por objeto
    printf -v OBJ_YAML '%s  - "%s: %s"\n' "$OBJ_YAML" "$k" "$v"
  done
fi

# ---------- Helpers YAML ----------
yaml_list_from_csv(){
  IFS=',' read -r -a arr <<< "${1:-}"
  for it in "${arr[@]}"; do
    it="$(printf "%s" "$it" | xargs)"
    [ -n "$it" ] && printf "  - %s\n" "$it"
  done
}
yaml_list_from_array(){
  for it in "$@"; do
    it="$(printf "%s" "$it" | xargs)"
    [ -n "$it" ] && printf "  - %s\n" "$it"
  done
}
rumbo_list_bracket(){
  if [[ "${RUMBO}" == *","* ]]; then
    IFS=',' read -r -a arr <<< "$RUMBO"
    local out="[" first=1
    for r in "${arr[@]}"; do
      r="$(printf "%s" "$r" | xargs)"
      if [ $first -eq 1 ]; then out="${out}${r}"; first=0; else out="${out}, ${r}"; fi
    done
    echo "${out}]"
  else
    echo "[${RUMBO}]"
  fi
}

# ---------- 1) VF.PRIMA ----------
cat > "$F_VF" <<EOF
${CUE}
SeedI=${SEED}
SoT=${SOT_SELLO}
Version=v1.0
Updated=${UPDATED}

# VF.PRIMA — PREH-NAV (Cierre)

VF.PRIMA: "${VF}"
Rumbos: $(rumbo_list_bracket)
Triada: "KA-THON-SIL"
Testigos: { t1: A86, t2: A96 }
Gates: ["No-Mentira", "Doble Testigo", "Mediación luminosa", "Cierre SIL→UM→Ə"]

HASH(10): ${HASH10}
${HASH_REF10:+HASH_REF(10): ${HASH_REF10}}
EOF

# ---------- 2) MicroSello ----------
if [ ! -f "$F_MS" ]; then
  cat > "$F_MS" <<EOF
${CUE}
SeedI=${SEED}
SoT=${SOT_SELLO}
Version=v1.0
Updated=${UPDATED}

# Micro-Sello · PREH-NAV · Cierre

VF.PRIMA: "${VF}"
Testigos: { t1: A86, t2: A96 }
Notas: "Cierre con SIL→UM→Ə. Mantener No-Mentira."
HASH(10): ${HASH10}
${HASH_REF10:+- HASH_REF(10): ${HASH_REF10}}
EOF
else
  grep -q '^HASH(10): ' "$F_MS" || printf '\nHASH(10): %s\n' "$HASH10" >> "$F_MS"
fi

# ---------- 3) Diario v1.2 ----------
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

## ${FECHA} · ${MODO} · ${TEMA}
cue: ${CUE}
SeedI: ${SEED}
SoT: ${SOT_DIARIO}
Version: v1.2-log
Updated: ${UPDATED}

FS:
  fecha: ${FECHA}
  tema: "${TEMA}"
  intencion: "${INTENCION}"
  modo: ${MODO}
  rumbo: ${RUMBO}
  tiempo: ${TIEMPO}
  referencias:
$( [ -n "${REFS}" ] && { printf "  referencias:\n"; yaml_list_from_csv "${REFS}"; } )
$( [ ${#SALIDAS[@]} -gt 0 ] && { printf "  salidas_esperadas:\n"; yaml_list_from_array "${SALIDAS[@]}"; } )
  metricas:
    delta_c: "${DELTA_C}"
    delta_s: "${DELTA_S}"
$( [ -n "${V_DICT}" ] && printf "    V: { %s }\n" "${V_DICT}" )
    no_mentira: ${NO_MENTIRA}
  testigos: { t1: A86, t2: A96 }
  triada: "KA-THON-SIL"
  mantra: "Los fonemas tienen sombras que se perciben por todos los sentidos"

Resultados:
  artefactos:
$(yaml_list_from_array "${ARTEFACTOS[@]:-}")
  objetos:
$( [ -n "${OBJ_YAML}" ] && printf "  objetos:\n%s\n" "${OBJ_YAML}" )
  cierres: "SIL→UM→Ə; Doble Testigo si hay Cristalización"
  micro_sellos:
$(yaml_list_from_array "${MICROS[@]:-}")
  veredicto: "${VEREDICTO}"

HASH(10): ${HASH10}
${HASH_REF10:+- HASH_REF(10): ${HASH_REF10}}

EOF

# ---------- 4) ListadoR ----------
if [ ! -f "$F_LR" ]; then
  cat > "$F_LR" <<EOF
[QEL::ECO[96]::RECALL ${SEED}-LISTADOR]
SeedI=${SEED}
SoT=LISTADOR/${SEED_PREFIX}/v1.3
Version=v1.3
Updated=${UPDATED}

# Listado R · ${SEED_PREFIX} — v1.3
# Registro cronológico de sellos, cierres y decisiones (M0→M2).
EOF
else
  # BSD/GNU sed
  (sed -i '' "s/^Updated=.*/Updated=${UPDATED}/" "$F_LR" 2>/dev/null) || sed -i "s/^Updated=.*/Updated=${UPDATED}/" "$F_LR" || true
fi

TAG="## ${FECHA} · ${MODO} · ${TEMA}"
if ! grep -qF "$TAG" "$F_LR"; then
  {
    echo
    echo "${TAG}"
    echo "cue: ${CUE}"
    echo "SeedI: ${SEED}"
    echo "Refs:"
    echo "  - docs/ritual/$(basename "$F_MS")"
    echo "  - docs/ritual/$(basename "$F_VF")"
    echo "  - docs/core/$(basename "$F_DI")"
    for a in "${ARTEFACTOS[@]:-}"; do [ -n "$a" ] && printf "  - %s\n" "$a"; done
    cat <<EOF2
Resultados:
  veredicto: "${VEREDICTO}"
  objetos:
${OBJ_YAML}
  notas: "Cierre según FS; mantener No-Mentira y Doble Testigo cuando cristaliza."
hash(10): ${HASH10}
${HASH_REF10:+hash_ref(10): ${HASH_REF10}}
EOF2
  } >> "$F_LR"
fi

# ---------- 5) Exponer a PREH-NAV y manifest ----------
cp "$F_MS" "$F_VF" "$F_DI" "$F_LR" apps/preh-nav-m1/public/docs/ 2>/dev/null || true
for a in "${ARTEFACTOS[@]:-}"; do
  if [ -f "$a" ]; then
    cp -f "$a" "apps/preh-nav-m1/public/docs/$(basename "$a")" 2>/dev/null || true
  fi
done

if [ -f "scripts/gen_manifest.sh" ]; then
  ./scripts/gen_manifest.sh || true
elif [ -f "apps/preh-nav-m1/scripts/generate_manifest.mjs" ]; then
  ( cd apps/preh-nav-m1 && node scripts/generate_manifest.mjs ) || true
fi

if [ -f "scripts/gen_core_manifest.sh" ]; then
  ./scripts/gen_core_manifest.sh || true
elif [ -f "scripts/gen_core_manifest.mjs" ]; then
  node scripts/gen_core_manifest.mjs || true
fi

# ---------- 6) Commit + push ----------
git add "$F_MS" "$F_VF" "$F_DI" "$F_LR" apps/preh-nav-m1/public/docs 2>/dev/null || true
for a in "${ARTEFACTOS[@]:-}"; do git add "$a" 2>/dev/null || true; done
git add docs/core/QEL_SoT_Manifest_v0.8.json 2>/dev/null || true

git commit -m "QEL: cierre ${FECHA} — FS(${MODO}/${TEMA}); VF.PRIMA, MicroSello, Diario, ListadoR; HASH(10)=${HASH10}." || true
git push origin PreH || true

echo "[QEL] Sesión ${FECHA} finalizada. HASH(10)=${HASH10}"