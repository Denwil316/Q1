#!/usr/bin/env bash
# qel_session_new.sh — Genera un JSON de Formato Situacional (FS) alineado con Diario/Finalize
# - Interactivo por defecto (prompts).
# - Flags para modo no interactivo (--no-prompt).
# - --from <json> para prellenar (usa jq si está disponible, si no, ignora sin fallar).
# - --stdout para imprimir a STDOUT, o --out <file> para guardar (por defecto: FS_YYMMDD.json).
# Compatibilidad: macOS Bash 3.2+ y Linux (sin mapfile ni bashisms modernos).

set -euo pipefail

have_jq=0
if command -v jq >/dev/null 2>&1; then have_jq=1; fi

# -------- util --------
json_escape() {
  # Escapa \, " y controla saltos de línea/tabs/CR de forma portable
  local s="${1-}"
  s=${s//\\/\\\\}
  s=${s//\"/\\\"}
  s=${s//$'\n'/\\n}
  s=${s//$'\r'/}
  s=${s//$'\t'/\\t}
  printf '%s' "$s"
}
trim() { printf '%s' "$1" | awk '{$1=$1;print}'; }

flatten_args_to_csv() {
  # Junta argumentos (y valores CSV) en un solo CSV
  local combined=""
  for item in "$@"; do
    [ -n "$item" ] || continue
    if [ -z "$combined" ]; then combined="$item"; else combined="$combined,$item"; fi
  done
  printf '%s' "$combined"
}

to_json_array() {
  # Convierte "a,b,c" + args repetidos → ["a","b","c"] (Bash 3.2-friendly)
  local combined; combined="$(flatten_args_to_csv "$@")"
  local arr=()
  if [ -n "$combined" ]; then
    IFS=',' read -r -a arr <<< "$combined"
  fi
  local out="[" first=1 v esc
  for v in "${arr[@]:-}"; do
    v="$(trim "$v")"
    [ -n "$v" ] || continue
    esc="$(json_escape "$v")"
    if [ $first -eq 1 ]; then out="$out\"$esc\""; first=0; else out="$out,\"$esc\""; fi
  done
  out="$out]"
  printf '%s' "$out"
}

to_json_bool() {
  case "$(printf '%s' "${1:-}" | tr '[:upper:]' '[:lower:]')" in
    1|true|yes|y|on)  printf 'true' ;;
    0|false|no|n|off) printf 'false' ;;
    *)                printf 'true' ;; # default seguro
  esac
}

# k=v,k2=v2 → {"k":"v","k2":"v2"}  (sin tipos; segura en Bash 3)
csv_kv_to_json_object() {
  local combined="${1:-}"
  local out="{" first=1
  local IFS=',' part k v
  for part in $combined; do
    [ -n "$part" ] || continue
    k="${part%%=*}"; v="${part#*=}"
    k="$(trim "$k")"; v="$(trim "$v")"
    [ -n "$k" ] || continue
    k="$(json_escape "$k")"; v="$(json_escape "$v")"
    if [ $first -eq 1 ]; then
      out="$out\"$k\":\"$v\""
      first=0
    else
      out="$out,\"$k\":\"$v\""
    fi
  done
  out="$out}"
  printf '%s' "$out"
}

# k=v,k2=v2 → [{"k":"v"},{"k2":"v2"}]  (para Resultados.objetos estilo "lista de singletons")
csv_kv_to_json_singleton_array() {
  local combined="${1:-}"
  local out="[" first_o=1
  local IFS=',' part k v
  for part in $combined; do
    [ -n "$part" ] || continue
    k="${part%%=*}"; v="${part#*=}"
    k="$(trim "$k")"; v="$(trim "$v")"
    [ -n "$k" ] || continue
    k="$(json_escape "$k")"; v="$(json_escape "$v")"
    if [ $first_o -eq 1 ]; then
      out="$out{\"$k\":\"$v\"}"
      first_o=0
    else
      out="$out,{\"$k\":\"$v\"}"
    fi
  done
  out="$out]"
  printf '%s' "$out"
}

# a,b,c → {"a":true,"b":true,"c":true}
csv_keys_true_object() {
  local combined; combined="$(flatten_args_to_csv "$@")"
  local out="{" first=1
  local IFS=',' k
  for k in $combined; do
    k="$(trim "$k")"
    [ -n "$k" ] || continue
    k="$(json_escape "$k")"
    if [ $first -eq 1 ]; then
      out="$out\"$k\":true"
      first=0
    else
      out="$out,\"$k\":true"
    fi
  done
  out="$out}"
  printf '%s' "$out"
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

# nuevos campos FS
SALIDAS=()          # salidas_esperadas
DELTA_C=""          # metricas.delta_c
DELTA_S=""          # metricas.delta_s
V_PAIRS=()          # metricas.V  (k=v CSV y/o repetidos)
NO_MENTIRA="true"   # metricas.no_mentira
T1="A86"            # testigos.t1 (default alinea finalize)
T2="A96"            # testigos.t2
TRIADA="KA-THON-SIL"
MANTRA="Los fonemas tienen sombras que se perciben por todos los sentidos"

# resultados.*
ARTEFACTOS=()
MICROSELLOS=()
AXIOMAS=()         # para resultados.axiomas (keys→true)
OBJETOS=()         # para resultados.objetos (k=v)

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
  --no-prompt                     # sin preguntas interactivas
  --stdout                        # imprime el JSON por STDOUT
  --out <file>                    # guarda el JSON en archivo (por defecto: FS_YYMMDD.json)
  --from <session.json>           # prellenar desde JSON previo (usa jq si disponible)

  --fecha YYMMDD                  # ej. 251112
  --tema "…"
  --intencion "…"
  --modo M0|M1|M2|M3
  --rumbo "N|S|E|O|Centro"        # múltiple como "N,S" → array
  --tiempo <minutos>
  --refs "a,b,c"                  # o repite --refs varias veces
  --veredicto "…"

  --salida "…"                    # agrega a salidas_esperadas (repetible o CSV)
  --delta-c "↑|→|↓"               # metricas.delta_c
  --delta-s "↑|→|↓"               # metricas.delta_s
  --V "k=v"                       # metricas.V (repetible o CSV: Kael/Prisma=0.89, Vun/Trompa=0.85)
  --no-mentira true|false         # metricas.no_mentira
  --t1 Axx                        # testigos.t1 (default A86)
  --t2 Axx                        # testigos.t2 (default A96)
  --triada "KA-THON-SIL"          # triada
  --mantra "…"                    # mantra

  --axioma "PIG"                  # resultados.axiomas (repetible o CSV; marca true)
  --obj "k=v"                     # resultados.objetos (repetible o CSV)
  --cierres "…"                   # resultados.cierres
  --registro "…"                  # resultados.registro

  --artefacto <path>              # repetir para varios; o "a,b,c"
  --micro "<etiqueta>"            # repetir para varios; o "x,y"

  # meta opcional (trazabilidad)
  --cue "[QEL::...]"         
  --seed "Axx-YYMMDD"
  --sot "DOMINIO/…/vX.Y"
  --version "vX.Y"
  --updated "YYYY-MM-DD"
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
    --salida) SALIDAS+=("${2:-}"); shift ;;
    --delta-c) DELTA_C="${2:-}"; shift ;;
    --delta-s) DELTA_S="${2:-}"; shift ;;
    --V) V_PAIRS+=("${2:-}"); shift ;;
    --no-mentira) NO_MENTIRA="${2:-}"; shift ;;
    --t1) T1="${2:-}"; shift ;;
    --t2) T2="${2:-}"; shift ;;
    --triada) TRIADA="${2:-}"; shift ;;
    --mantra) MANTRA="${2:-}"; shift ;;
    --axioma) AXIOMAS+=("${2:-}"); shift ;;
    --obj) OBJETOS+=("${2:-}"); shift ;;
    --cierres) CIERRES="${2:-}"; shift ;;
    --registro) REGISTRO="${2:-}"; shift ;;
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
  FECHA="${FECHA:-"$(jq -r '.fecha // empty' "$FROM_FILE" 2>/dev/null || true)"}"
  TEMA="${TEMA:-"$(jq -r '.tema // empty' "$FROM_FILE" 2>/dev/null || true)"}"
  INTENCION="${INTENCION:-"$(jq -r '.intencion // empty' "$FROM_FILE" 2>/dev/null || true)"}"
  MODO="${MODO:-"$(jq -r '.modo // empty' "$FROM_FILE" 2>/dev/null || true)"}"
  RUMBO="${RUMBO:-"$(jq -r 'if (.rumbo|type=="array") then (join(",")) else .rumbo end // empty' "$FROM_FILE" 2>/dev/null || true)"}"
  TIEMPO="${TIEMPO:-"$(jq -r '.tiempo // empty' "$FROM_FILE" 2>/dev/null || true)"}"
  if [ ${#REF_FLAGS[@]} -eq 0 ]; then
    while IFS= read -r _r; do [ -n "$_r" ] && REF_FLAGS+=("$_r"); done < <(jq -r '.referencias[]? // empty' "$FROM_FILE" 2>/dev/null || true)
  fi
  VEREDICTO="${VEREDICTO:-"$(jq -r '.veredicto // empty' "$FROM_FILE" 2>/dev/null || true)"}"

  # nuevos campos
  if [ ${#SALIDAS[@]} -eq 0 ]; then
    while IFS= read -r s; do [ -n "$s" ] && SALIDAS+=("$s"); done < <(jq -r '.salidas_esperadas[]? // empty' "$FROM_FILE" 2>/dev/null || true)
  fi
  DELTA_C="${DELTA_C:-"$(jq -r '.metricas.delta_c // empty' "$FROM_FILE" 2>/dev/null || true)"}"
  DELTA_S="${DELTA_S:-"$(jq -r '.metricas.delta_s // empty' "$FROM_FILE" 2>/dev/null || true)"}"
  if [ ${#V_PAIRS[@]} -eq 0 ]; then
    # reconstruir V como CSV k=v
    if jq -e '.metricas.V? | type=="object"' "$FROM_FILE" >/dev/null 2>&1; then
      while IFS= read -r kv; do
        [ -n "$kv" ] && V_PAIRS+=("$kv")
      done < <(jq -r '.metricas.V | to_entries[] | "\(.key)=\(.value)"' "$FROM_FILE")
    fi
  fi
  NO_MENTIRA="${NO_MENTIRA:-"$(jq -r '.metricas.no_mentira // empty' "$FROM_FILE" 2>/dev/null || true)"}"
  T1="${T1:-"$(jq -r '.testigos.t1 // empty' "$FROM_FILE" 2>/dev/null || true)"}"
  T2="${T2:-"$(jq -r '.testigos.t2 // empty' "$FROM_FILE" 2>/dev/null || true)"}"
  TRIADA="${TRIADA:-"$(jq -r '.triada // empty' "$FROM_FILE" 2>/dev/null || true)"}"
  MANTRA="${MANTRA:-"$(jq -r '.mantra // empty' "$FROM_FILE" 2>/dev/null || true)"}"

  if [ ${#AXIOMAS[@]} -eq 0 ]; then
    while IFS= read -r ax; do [ -n "$ax" ] && AXIOMAS+=("$ax"); done < <(jq -r '.resultados.axiomas | to_entries[]? | select(.value==true) | .key' "$FROM_FILE" 2>/dev/null || true)
  fi
  if [ ${#OBJETOS[@]} -eq 0 ]; then
    if jq -e '.resultados.objetos? | type=="array"' "$FROM_FILE" >/dev/null 2>&1; then
      while IFS= read -r kv; do [ -n "$kv" ] && OBJETOS+=("$kv"); done < <(jq -r '.resultados.objetos[]? | to_entries[] | "\(.key)=\(.value)"' "$FROM_FILE")
    fi
  fi
  CIERRES="${CIERRES:-"$(jq -r '.resultados.cierres // empty' "$FROM_FILE" 2>/dev/null || true)"}"
  REGISTRO="${REGISTRO:-"$(jq -r '.resultados.registro // empty' "$FROM_FILE" 2>/dev/null || true)"}"

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

  if [ ${#REF_FLAGS[@]} -eq 0 ]; then
    _r=""; ask "referencias (CSV, 4–7 entradas)" _r ""
    [ -n "$_r" ] && REF_FLAGS+=("$_r")
  fi
  [ -n "$VEREDICTO" ] || ask "veredicto (breve)" VEREDICTO ""

  # salidas esperadas
  if [ ${#SALIDAS[@]} -eq 0 ]; then
    _s=""; ask "salidas_esperadas (CSV)" _s ""
    [ -n "$_s" ] && SALIDAS+=("$_s")
  fi

  # metricas
  [ -n "$DELTA_C" ] || ask "metricas.delta_c (↑|→|↓)" DELTA_C "↑"
  [ -n "$DELTA_S" ] || ask "metricas.delta_s (↑|→|↓)" DELTA_S "↑"
  if [ ${#V_PAIRS[@]} -eq 0 ]; then
    _v=""; ask "metricas.V (CSV k=v, p.ej. Kael/Prisma=0.89,Vun/Trompa=0.85)" _v ""
    [ -n "$_v" ] && V_PAIRS+=("$_v")
  fi
  _nm=""; ask "metricas.no_mentira (true/false)" _nm "true"; [ -n "$_nm" ] && NO_MENTIRA="$_nm"

  # testigos / triada / mantra
  [ -n "$T1" ] || ask "testigos.t1" T1 "A86"
  [ -n "$T2" ] || ask "testigos.t2" T2 "A96"
  [ -n "$TRIADA" ] || ask "triada" TRIADA "KA-THON-SIL"
  [ -n "$MANTRA" ] || ask "mantra" MANTRA "Los fonemas tienen sombras que se perciben por todos los sentidos"

  # resultados.artefactos/micro_sellos/axiomas/objetos/cierres/registro
  if [ ${#ARTEFACTOS[@]} -eq 0 ]; then
    _a=""; ask "artefactos (CSV)" _a ""
    [ -n "$_a" ] && ARTEFACTOS+=("$_a")
  fi
  if [ ${#MICROSELLOS[@]} -eq 0 ]; then
    _m=""; ask "micro_sellos (CSV, opcional)" _m ""
    [ -n "$_m" ] && MICROSELLOS+=("$_m")
  fi
  if [ ${#AXIOMAS[@]} -eq 0 ]; then
    _x=""; ask "axiomas (CSV de claves verdaderas, p.ej. PIG,TPC)" _x ""
    [ -n "$_x" ] && AXIOMAS+=("$_x")
  fi
  if [ ${#OBJETOS[@]} -eq 0 ]; then
    _o=""; ask "objetos (CSV k=v, p.ej. Kael/Prisma=0.89,Nai→Prisma(Excepción)=0.70)" _o ""
    [ -n "$_o" ] && OBJETOS+=("$_o")
  fi
  [ -n "${CIERRES:-}" ] || ask "cierres (texto)" CIERRES "SIL→UM→Ə; Doble Testigo si hay Cristalización"
  [ -n "${REGISTRO:-}" ] || ask "registro (texto)" REGISTRO "Actualizar Árbol VF y Listado R si aplica"

  # meta opcional
  [ -n "$META_CUE" ]  || ask "meta.cue (opcional)" META_CUE ""
  [ -n "$META_SEED" ] || ask "meta.SeedI (opcional)" META_SEED ""
  [ -n "$META_SOT" ]  || ask "meta.SoT (opcional)" META_SOT ""
  [ -n "$META_VER" ]  || ask "meta.Version (opcional)" META_VER ""
  [ -n "$META_UPD" ]  || ask "meta.Updated (opcional YYYY-MM-DD)" META_UPD ""
fi

# -------- construir JSON --------
rumbo_json() {
  case "$RUMBO" in
    *","*) to_json_array "$RUMBO" ;;
    *)     printf '"%s"' "$(json_escape "$RUMBO")" ;;
  esac
}
refs_json()        { to_json_array "${REF_FLAGS[@]:-}"; }
salidas_json()     { to_json_array "${SALIDAS[@]:-}"; }
artefactos_json()  { to_json_array "${ARTEFACTOS[@]:-}"; }
micros_json()      { to_json_array "${MICROSELLOS[@]:-}"; }

metricas_V_json()  { csv_kv_to_json_object "$(flatten_args_to_csv "${V_PAIRS[@]:-}")"; }
axiomas_json()     { csv_keys_true_object "${AXIOMAS[@]:-}"; }
objetos_json()     { csv_kv_to_json_singleton_array "$(flatten_args_to_csv "${OBJETOS[@]:-}")"; }

# nombre de salida (respeta QEL_FS_DIR si existe)
if [ -z "${OUT_FILE:-}" ] && [ $STDOUT -eq 0 ]; then
  _d="${FECHA:-"$(date +%y%m%d)"}"
  OUT_DIR="${QEL_FS_DIR:-.}"
  mkdir -p "$OUT_DIR"
  OUT_FILE="${OUT_DIR%/}/FS_${_d}.json"
fi

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
  "salidas_esperadas": $(salidas_json),
  "metricas": {
    "delta_c": "$(json_escape "$DELTA_C")",
    "delta_s": "$(json_escape "$DELTA_S")",
    "V": $(metricas_V_json),
    "no_mentira": $(to_json_bool "$NO_MENTIRA")
  },
  "testigos": { "t1": "$(json_escape "$T1")", "t2": "$(json_escape "$T2")" },
  "triada": "$(json_escape "$TRIADA")",
  "mantra": "$(json_escape "$MANTRA")",
  "veredicto": "$(json_escape "$VEREDICTO")",
  "resultados": {
    "axiomas": $(axiomas_json),
    "objetos": $(objetos_json),
    "cierres": "$(json_escape "${CIERRES:-}")",
    "registro": "$(json_escape "${REGISTRO:-}")",
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
# -------- fin --------