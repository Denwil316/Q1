#!/usr/bin/env bash
# qel_session_new.sh — Genera un JSON de Formato Situacional (FS)
# - Interactivo por defecto (prompts).
# - Flags para modo no interactivo (--no-prompt).
# - --from <json> para prellenar (usa jq si está disponible, si no, ignora sin fallar).
# - --stdout para imprimir a STDOUT, o --out <file> para guardar (por defecto: session_YYMMDD.json).
# Compatibilidad: macOS Bash 3.2+ (sin mapfile), Linux Bash.
set -euo pipefail

have_jq=0
if command -v jq >/dev/null 2>&1; then have_jq=1; fi

# -------- util --------
json_escape() {
  # Escapa comillas/backslashes y controla saltos de línea simples
  # Reemplaza \ con \\ y " con \"
  printf '%s' "$1" | sed 's/\\/\\\\/g; s/"/\\"/g'
}

trim() { printf '%s' "$1" | awk '{$1=$1;print}'; }

csv_or_repeat_to_array() {
  # Convierte lista "a,b,c" o valores repetidos en una lista JSON
  # Uso: csv_or_repeat_to_array "${array_values[@]}"  (bash 3.2-friendly)
  local tmp=()
  for item in "$@"; do
    # Split por coma sin mapfile: usa awk para dividir
    if [ -n "$item" ]; then
      awk -v s="$item" 'BEGIN{n=split(s,a,","); for(i=1;i<=n;i++){print a[i];}}'
    fi
  done | while IFS= read -r val; do
    val="$(trim "$val")"
    [ -n "$val" ] && tmp+=("$val")
  done

  # Imprimir como JSON array
  local first=1
  printf '['
  for v in "${tmp[@]:-}"; do
    if [ $first -eq 0 ]; then printf ','; fi
    printf '"%s"' "$(json_escape "$v")"
    first=0
  done
  printf ']'
}

# -------- defaults/flags --------
PROMPT=1
STDOUT=0
OUT_FILE=""
FROM_FILE=""

FECHA=""
TEMA=""
INTENCION=""
MODO=""
RUMBO=""
TIEMPO=""
REF_FLAGS=()
VEREDICTO=""

# resultados.*
ARTEFACTOS=()
MICROSELLOS=()

# meta.*
META_CUE=""
META_SEED=""
META_SOT=""
META_VER=""
META_UPD=""

usage() {
  cat <<USAGE
Uso:
  scripts/qel_session_new.sh [opciones]

Opciones:
  --no-prompt                # sin preguntas interactivas (requiere flags de datos)
  --stdout                   # imprime el JSON por STDOUT
  --out <file>               # guarda el JSON en archivo (por defecto: session_YYMMDD.json)
  --from <session.json>      # prellenar desde JSON previo (usa jq si disponible)

  --fecha YYMMDD             # ej. 251020
  --tema "…"                 
  --intencion "…"
  --modo M0|M1|M2|M3
  --rumbo "N|S|E|O|Centro"   # múltiple como "N,S" → array
  --tiempo <minutos>         
  --refs "a,b,c"             # o repite --refs varias veces
  --veredicto "…"

  --artefacto <path>         # repetir para varios; o "a,b,c"
  --micro "<etiqueta>"       # repetir para varios; o "x,y"

  # meta opcional (trazabilidad)
  --cue "[QEL::...]"         
  --seed "Axx-YYMMDD"
  --sot "DOMINIO/…/vX.Y"
  --version "vX.Y"
  --updated "YYYY-MM-DD"

Ejemplos:
  scripts/qel_session_new.sh                            # modo interactivo
  scripts/qel_session_new.sh --no-prompt --stdout \\
    --fecha 251020 --tema "Curaduría" --intencion "Probar flujo" \\
    --modo M2 --rumbo "Centro" --tiempo 30 --refs "CURADURIA/v1.0,Glosario v1.5" \\
    --veredicto "Listo para cristalizar"
USAGE
}

# parse flags
while [ $# -gt 0 ]; do
  case "$1" in
    --no-prompt) PROMPT=0 ;;
    --stdout) STDOUT=1 ;;
    --out) OUT_FILE="${2:-}"; shift ;;
    --from) FROM_FILE="${2:-}"; shift ;;
    --fecha) FECHA="${2:-}"; shift ;;
    --tema) TEMA="${2:-}"; shift ;;
    --intencion) INTENCION="${2:-}"; shift ;;
    --modo) MODO="${2:-}"; shift ;;
    --rumbo) RUMBO="${2:-}"; shift ;;
    --tiempo) TIEMPO="${2:-}"; shift ;;
    --refs) REF_FLAGS+=("${2:-}"); shift ;;
    --veredicto) VEREDICTO="${2:-}"; shift ;;
    --artefacto) ARTEFACTOS+=("${2:-}"); shift ;;
    --micro) MICROSELLOS+=("${2:-}"); shift ;;
    --cue) META_CUE="${2:-}"; shift ;;
    --seed) META_SEED="${2:-}"; shift ;;
    --sot) META_SOT="${2:-}"; shift ;;
    --version) META_VER="${2:-}"; shift ;;
    --updated) META_UPD="${2:-}"; shift ;;
    -h|--help) usage; exit 0 ;;
    *) echo "[warn] flag desconocida: $1" >&2 ;;
  esac
  shift || true
done

# -------- prefill desde --from (si jq) --------
if [ -n "$FROM_FILE" ] && [ $have_jq -eq 1 ] && [ -f "$FROM_FILE" ]; then
  # sólo completa si el destino aún está vacío
  FECHA="${FECHA:-"$(jq -r '.fecha // empty' "$FROM_FILE" 2>/dev/null || true)"}"
  TEMA="${TEMA:-"$(jq -r '.tema // empty' "$FROM_FILE" 2>/dev/null || true)"}"
  INTENCION="${INTENCION:-"$(jq -r '.intencion // empty' "$FROM_FILE" 2>/dev/null || true)"}"
  MODO="${MODO:-"$(jq -r '.modo // empty' "$FROM_FILE" 2>/dev/null || true)"}"
  RUMBO="${RUMBO:-"$(jq -r 'if (.rumbo|type=="array") then (join(",")) else .rumbo end // empty' "$FROM_FILE" 2>/dev/null || true)"}"
  TIEMPO="${TIEMPO:-"$(jq -r '.tiempo // empty' "$FROM_FILE" 2>/dev/null || true)"}"
  # refs → lista CSV
  if [ ${#REF_FLAGS[@]} -eq 0 ]; then
    mapfile -t _refs < <(jq -r '.referencias[]? // empty' "$FROM_FILE" 2>/dev/null || true)
    for r in "${_refs[@]:-}"; do REF_FLAGS+=("$r"); done
  fi
  VEREDICTO="${VEREDICTO:-"$(jq -r '.veredicto // empty' "$FROM_FILE" 2>/dev/null || true)"}"
  # resultados.*
  mapfile -t _arts < <(jq -r '.resultados.artefactos[]? // empty' "$FROM_FILE" 2>/dev/null || true)
  for p in "${_arts[@]:-}"; do ARTEFACTOS+=("$p"); done
  mapfile -t _micros < <(jq -r '.resultados.micro_sellos[]? // empty' "$FROM_FILE" 2>/dev/null || true)
  for m in "${_micros[@]:-}"; do MICROSELLOS+=("$m"); done
  # meta.*
  META_CUE="${META_CUE:-"$(jq -r '.meta.cue // empty' "$FROM_FILE" 2>/dev/null || true)"}"
  META_SEED="${META_SEED:-"$(jq -r '.meta.SeedI // empty' "$FROM_FILE" 2>/dev/null || true)"}"
  META_SOT="${META_SOT:-"$(jq -r '.meta.SoT // empty' "$FROM_FILE" 2>/dev/null || true)"}"
  META_VER="${META_VER:-"$(jq -r '.meta.Version // empty' "$FROM_FILE" 2>/dev/null || true)"}"
  META_UPD="${META_UPD:-"$(jq -r '.meta.Updated // empty' "$FROM_FILE" 2>/dev/null || true)"}"
fi

# -------- prompts (si no flag/no-prompt) --------
ask() { # $1=label $2=varname $3=default
  local label="$1" var="$2" def="${3:-}"
  local inp=""
  printf "%s%s: " "$label" "${def:+ [$def]}"
  IFS= read -r inp || true
  if [ -z "$inp" ]; then inp="$def"; fi
  eval "$var=\$inp"
}

if [ $PROMPT -eq 1 ]; then
  [ -n "$FECHA" ] || ask "fecha (YYMMDD)" FECHA "$(date +%y%m%d)"
  [ -n "$TEMA" ] || ask "tema" TEMA ""
  [ -n "$INTENCION" ] || ask "intencion" INTENCION ""
  [ -n "$MODO" ] || ask "modo (M0|M1|M2|M3)" MODO "M1"
  [ -n "$RUMBO" ] || ask "rumbo (p.ej. Centro o N,S)" RUMBO "Centro"
  [ -n "$TIEMPO" ] || ask "tiempo (min)" TIEMPO "30"
  # refs (CSV)
  if [ ${#REF_FLAGS[@]} -eq 0 ]; then
    local _r=""; ask "referencias (CSV, 4–7 entradas)" _r ""
    [ -n "$_r" ] && REF_FLAGS+=("$_r")
  fi
  [ -n "$VEREDICTO" ] || ask "veredicto (breve)" VEREDICTO ""
  # resultados.*
  if [ ${#ARTEFACTOS[@]} -eq 0 ]; then
    local _a=""; ask "artefactos (CSV)" _a ""
    [ -n "$_a" ] && ARTEFACTOS+=("$_a")
  fi
  if [ ${#MICROSELLOS[@]} -eq 0 ]; then
    local _m=""; ask "micro_sellos (CSV, opcional)" _m ""
    [ -n "$_m" ] && MICROSELLOS+=("$_m")
  fi
  # meta (opc.)
  [ -n "$META_CUE" ]  || ask "meta.cue (opcional)" META_CUE ""
  [ -n "$META_SEED" ] || ask "meta.SeedI (opcional)" META_SEED ""
  [ -n "$META_SOT" ]  || ask "meta.SoT (opcional)" META_SOT ""
  [ -n "$META_VER" ]  || ask "meta.Version (opcional)" META_VER ""
  [ -n "$META_UPD" ]  || ask "meta.Updated (opcional YYYY-MM-DD)" META_UPD ""
fi

# -------- construir JSON --------
# rumbo: si contiene coma → array; si no → string
rumbo_json() {
  if printf '%s' "$RUMBO" | grep -q ','; then
    csv_or_repeat_to_array "$RUMBO"
  else
    printf '"%s"' "$(json_escape "$RUMBO")"
  fi
}

refs_json() { csv_or_repeat_to_array "${REF_FLAGS[@]:-}"; }
artefactos_json() { csv_or_repeat_to_array "${ARTEFACTOS[@]:-}"; }
micros_json() { csv_or_repeat_to_array "${MICROSELLOS[@]:-}"; }

# nombre de salida (respeta QEL_FS_DIR si existe)
if [ -z "${OUT_FILE:-}" ] && [ $STDOUT -eq 0 ]; then
  _d="${FECHA:-"$(date +%y%m%d)"}"
  OUT_DIR="${QEL_FS_DIR:-.}"
  mkdir -p "$OUT_DIR"
  OUT_FILE="${OUT_DIR%/}/FS_${_d}.json"
fi

# imprimir JSON
build_json() {
  cat <<JSON
{
  "fecha": "$(json_escape "$FECHA")",
  "tema": "$(json_escape "$TEMA")",
  "intencion": "$(json_escape "$INTENCION")",
  "modo": "$(json_escape "$MODO")",
  "rumbo": $(rumbo_json),
  "tiempo": "$(json_escape "$TIEMPO")",
  "referencias": $(refs_json),
  "veredicto": "$(json_escape "$VEREDICTO")",
  "resultados": {
    "artefactos": $(artefactos_json),
    "micro_sellos": $(micros_json)
  },
  "meta": {
    "cue": "$(json_escape "$META_CUE")",
    "SeedI": "$(json_escape "$META_SEED")",
    "SoT": "$(json_escape "$META_SOT")",
    "Version": "$(json_escape "$META_VER")",
    "Updated": "$(json_escape "$META_UPD")"
  }
}
JSON
}

if [ $STDOUT -eq 1 ]; then
  build_json
else
  build_json > "$OUT_FILE"
  echo "[ok] Escrito: $OUT_FILE"
fi
