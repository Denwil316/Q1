#!/usr/bin/env bash
set -euo pipefail

# [QEL::ECO[96]::A96-250820-VCALC-UNIFIED]
# SeedI=A96-250820
# SoT=HERRAMIENTAS/v0.2
# Version=v0.2
# Updated=2025-10-02

# [QEL::ECO[96]::A96-250820-VCALC-IO]
# SeedI=A96-250820
# SoT=HERRAMIENTAS/v0.2
# Version=v0.2
# Updated=2025-08-24

# [QEL::ECO[96]::A96-250820-VCALC-JSON]
# SeedI=A96-250820
# SoT=HERRAMIENTAS/v0.2
# Version=v0.2
# Updated=2025-08-24

# [QEL::ECO[96]::A96-250820-VCALC]
# SeedI=A96-250820
# SoT=HERRAMIENTAS/v0.1
# Version=v0.1
# Updated=2025-08-20

: "${LC_NUMERIC:=C}"; 
export LC_ALL=C
export LC_NUMERIC

# ---------- Utilidades ----------
trim(){ awk '{$1=$1;print}' <<<"$1"; }
lower(){ tr '[:upper:]' '[:lower:]' <<<"$1"; }
upper(){ tr '[:lower:]' '[:upper:]' <<<"$1"; }
json_escape(){ local s=$1; s=${s//\\/\\\\}; s=${s//\"/\\\"}; s=${s//$'\n'/\\n}; echo -n "$s"; }

# ---------- UID ε (determinista; no altera 𝒱_canónica) ----------
uid_hash(){ # $1=key
  if command -v shasum >/dev/null 2>&1; then
    printf "%s" "$1" | shasum -a 1 | awk '{print $1}'
  else
    printf "%s" "$1" | openssl dgst -sha1 | awk '{print $2}'
  fi
}
uid_eps(){ # $1=key  $2=max (def QEL_UID_EPS_MAX o 0.000005)
  local key="$1" max="${2:-${QEL_UID_EPS_MAX:-0.000005}}"
  local h sub n maxn
  h="$(uid_hash "$key")"
  sub="${h:0:6}"                # 24 bits
  n=$((16#$sub))                # 0..16777215
  maxn=$((16#FFFFFF))
  awk -v n="$n" -v maxn="$maxn" -v max="$max" 'BEGIN{printf "%.8f", (n/maxn)*max}'
}

# [QEL::ECO[96]::A96-251107-VCALC-USAGE]
# SeedI=A96-251107
# SoT=HERRAMIENTAS/VCALC/usage-v0.3
# Version=v0.3
# Updated=2025-11-07

usage_core(){
cat <<'USAGE'
Uso (core):
  scripts/qel_vcalc.sh --obj "Fonema/Objeto" --afinidad 0.72 --rumbo N \
    --clase "poco comun|rara|singular|unico|basica|metalica|obsidiana" \
    --gates "mediacion[,doble][,aurora]" \
    --ruido 0.04 --delta-c up|flat|down --delta-s up|flat|down [--emit pretty|quiet|json]

Subcomandos:
  scripts/qel_vcalc.sh io          # modo interactivo
  scripts/qel_vcalc.sh json ...    # modo objeto (lee JSON)

Notas importantes:
  - No uses corchetes ni barras verticales en los valores. Ej.: --afinidad 0.84, --rumbo W
  - Si un valor tiene espacios, enciérralo entre comillas. Ej.: --clase "poco comun"
  - Decimales con punto. Ej.: 0.60, no 0,60.

Flags core:
  --obj "Fonema/Objeto"         (requerido; ej. "Zeh/Lente")
  --afinidad [0..1]             (def=0.60)
  --rumbo N|O|E|W|S|C           (def=C)  # O=Oriente, E=Este (ambos elevan χ_r=1.10)
  --clase <ver lista abajo>     (def=singular)
  --gates "mediacion[,doble][,aurora]"
  --ruido [0..1] (clip 0.15)    (def=0.00)
  --delta-c up|flat|down        (def=flat)
  --delta-s up|flat|down        (def=flat)
  --emit pretty|quiet|json      (def=pretty)

Clases válidas (alias aceptados):
  basica|básica        → H_k=0.50
  "poco comun"|"poco común"|poco-comun|poco-común   → H_k=0.80
  rara|raro|singular|unico|único                    → H_k=1.00
  metalica|metálica    → H_k=1.20
  obsidiana            → H_k=1.60

Gates válidos (producto Π_gates):
  mediacion|mediación
  doble|doble_testigo
  aurora|contacto_aurora
  # Cualquier otro token se ignora (no falla).

Ejemplos:
  scripts/qel_vcalc.sh --obj "Kael/Prisma" --afinidad 0.72 --rumbo O \
    --clase singular --gates "mediacion,doble" --ruido 0.03 --delta-c up --emit json

  echo '{"obj":"Nai/Llave","afinidad":0.72,"rumbo":"W","clase":"unico",\
"gates":["mediacion","aurora"],"ruido":0.12,"delta":{"c":"up","s":"up"}}' \
  | scripts/qel_vcalc.sh json
USAGE
}


# ---------- Tablas SoT (operativas) ----------
chi_r(){ case "$(upper "$1")" in
O|E) echo 1.10;; # Oriente / Este
N) echo 1.05;; # Norte
C) echo 1.00;; # Centro
W) echo 0.95;; # Occidente
S) echo 0.90;; # Sur
*) echo "";;
esac; }

H_k(){ case "$(lower "$1")" in
basica|básica) echo 0.50;;
"poco comun"|"poco común"|poco-comun|poco-común) echo 0.80;;
rara|raro|singular|unico|único) echo 1.00;;
metalica|metálica) echo 1.20;;
obsidiana) echo 1.60;;
*) echo "";;
esac; }

gates_product(){
  local gates_raw="$1"
  local MED=0.80 DOB=0.90 AUR=1.00
  IFS=',' read -r -a GA <<< "$gates_raw"
  for g in "${GA[@]}"; do
    g="$(lower "$(trim "$g")")"
    case "$g" in
      mediacion|mediación)    MED=1.00;;
      doble|doble_testigo)    DOB=1.00;;
      aurora|contacto_aurora) AUR=1.00;;
      "" ) :;;
    esac
  done
  awk -v med="$MED" -v dob="$DOB" -v aur="$AUR" 'BEGIN{printf "%.6f", med*dob*aur}'
}

fdelta(){
  local dc="$1" ds="$2" dC=0 dS=0
  case "$(lower "$dc")" in up) dC=0.02;; down) dC=-0.02;; esac
  case "$(lower "$ds")" in up) dS=0.02;; down) dS=-0.02;; esac
  awk -v dC="$dC" -v dS="$dS" 'BEGIN{printf "%.4f", 1 + dC + dS}'
}

fruido(){
  local r="$(printf "%s" "$1" | sed 's/,/./g')"
  local clip
  clip="$(awk -v x="$r" 'BEGIN{ if(x<0)print 0; else if(x>0.15)print 0.15; else print x }')"
  awk -v c="$clip" 'BEGIN{printf "%.4f", 1 - c}'
}

# ---------- Cálculo central ----------
compute_v(){
  local A="$1" XR="$2" HK="$3" GP="$4" FD="$5" FR="$6"
  awk -v A="$A" -v XR="$XR" -v HK="$HK" -v GP="$GP" -v FD="$FD" -v FR="$FR" \
      'BEGIN{ raw=A*XR*HK*GP*FD*FR; if(raw<0)raw=0; if(raw>1)raw=1; printf "%.2f", raw }'
}



# ---------- Núcleo (core) ----------
core_main(){
  local OBJ="" A="0.60" RUM="C" K="singular" G="" R="0" DC="flat" DS="flat" EMIT="pretty"

  while [ $# -gt 0 ]; do
    case "$1" in
      --obj) OBJ="$2"; shift 2;;
      --afinidad) A="$2"; shift 2;;
      --rumbo) RUM="$2"; shift 2;;
      --clase) K="$2"; shift 2;;
      --gates) G="$2"; shift 2;;
      --ruido) R="$2"; shift 2;;
      --delta-c) DC="$2"; shift 2;;
      --delta-s) DS="$2"; shift 2;;
      --emit) EMIT="$2"; shift 2;;
      -h|--help) usage_core; exit 0;;
      *) echo "Flag desconocida: $1"; usage_core; exit 2;;
    esac
  done
  [ -n "$OBJ" ] || { echo "Falta --obj"; exit 1; }

  A="$(printf "%s" "$A" | sed 's/,/./g')"
  local XR HK GP FD FR V
  XR="$(chi_r "$RUM")"; [ -n "$XR" ] || { echo "Rumbo inválido: $RUM"; exit 2; }
  HK="$(H_k "$K")";    [ -n "$HK" ] || { echo "Clase inválida: $K"; exit 2; }
  GP="$(gates_product "$G")"
  FD="$(fdelta "$DC" "$DS")"
  FR="$(fruido "$R")"
  V="$(compute_v "$A" "$XR" "$HK" "$GP" "$FD" "$FR")"
  V_CANON="$(awk -v A="$A" -v XR="$XR" -v HK="$HK" -v GP="$GP" 'BEGIN{v=A*XR*HK*GP; if(v<0)v=0; if(v>1)v=1; printf "%.4f", v}')"
  V_OPER="$(awk -v Vc="$V_CANON" -v FD="$FD" -v FR="$FR" 'BEGIN{v=Vc*FD*FR; if(v<0)v=0; if(v>1)v=1; printf "%.4f", v}')"
  
# UID determinista (solo desempate; no usar para τ)
local UID_KEY UID_EPS V_UID_CANON V_UID_OPER
UID_KEY="obj=$(trim "$OBJ")|A=$(awk -v x="$A" 'BEGIN{printf "%.4f", x+0}')|rumbo=$(upper "$RUM")|clase=$(lower "$K")|gates=$(lower "$(echo "$G" | tr -s " ," "," )")"
UID_EPS="$(uid_eps "$UID_KEY")"
V_UID_CANON="$(awk -v v="$V_CANON" -v e="$UID_EPS" 'BEGIN{u=v+e; if(u>1)u=1; printf "%.6f", u}')"
V_UID_OPER="$(awk -v v="$V_OPER"  -v e="$UID_EPS" 'BEGIN{u=v+e; if(u>1)u=1; printf "%.6f", u}')"

  case "$EMIT" in
    quiet) echo "$V";;
   json)
      printf '{'
      printf '"obj":"%s",' "$(json_escape "$OBJ")"
      printf '"A":%s,'   "$(awk -v x="$A"  'BEGIN{printf "%.3f", x+0}')"
      printf '"chi_r":%s,"H_k":%s,' \
            "$(awk -v x="$XR" 'BEGIN{printf "%.2f", x+0}')" \
            "$(awk -v x="$HK" 'BEGIN{printf "%.2f", x+0}')"
      printf '"gates_p":%s,' "$(awk -v x="$GP" 'BEGIN{printf "%.2f", x+0}')"
      printf '"fdelta":%s,"fruido":%s,' \
            "$(awk -v x="$FD" 'BEGIN{printf "%.2f", x+0}')" \
            "$(awk -v x="$FR" 'BEGIN{printf "%.2f", x+0}')"
      printf '"uid_key":"%s",' "$(json_escape "$UID_KEY")"
      printf '"uid_epsilon":%s,' "$(awk -v x="$UID_EPS" 'BEGIN{printf "%.8f", x+0}')"
      printf '"V_canon":%s,' "$(awk -v x="$V_CANON" 'BEGIN{printf "%.4f", x+0}')"
      printf '"V_oper":%s,'  "$(awk -v x="$V_OPER"  'BEGIN{printf "%.4f", x+0}')"
      printf '"V_uid_canon":%s,' "$(awk -v x="$V_UID_CANON" 'BEGIN{printf "%.6f", x+0}')"
      printf '"V_uid_oper":%s'  "$(awk -v x="$V_UID_OPER"  'BEGIN{printf "%.6f", x+0}')"
      printf '}\n'
      ;;
    pretty|*)
      cat <<OUT
Objeto: $OBJ
A (afinidad): $A
χ_r (rumbo $(upper "$RUM")): $XR
H_k (clase $K): $HK
Π_gates: $GP   (from: $G)
ΔC/ΔS factor: $FD   | Ruido factor: $FR
-----------------------------------------------
𝒱_canónica: $V_CANON
𝒱_operativa (×Δ,×ruido): $V_OPER
UID ε: $UID_EPS  |  𝒱_uid (canon): $V_UID_CANON
-----------------------------------------------
Sugerencia --obj: "${OBJ}=${V_CANON}"
OUT
      ;;
  esac
}

# ---------- Subcomando: json ----------
json_main(){
  local INPUT=""
  while [ $# -gt 0 ]; do
    case "$1" in
      --json) INPUT="$2"; shift 2;;
      --in)   INPUT="$(cat "$2")"; shift 2;;
      -h|--help)
        cat <<H
Uso:
  echo '{"obj":"Nai/Llave","afinidad":0.72,"rumbo":"W","clase":"unico",
          "gates":["mediacion","aurora"],"ruido":0.12,
          "delta":{"c":"up","s":"up"}}' | scripts/qel_vcalc.sh json
Flags:
  --json '<obj>'  Cadena JSON directa
  --in file.json  Leer JSON de archivo
Salida: JSON con: obj, A, chi_r, H_k, gates_p, fdelta, fruido, V
H
        exit 0;;
      *) echo "{\"error\":\"Flag desconocida: $1\"}"; exit 2;;
    esac
  done
  [ -n "$INPUT" ] || INPUT="$(cat || true)"
  INPUT="$(printf "%s" "$INPUT" | sed 's/,/./g' | tr -d '\r')"

  # Parse con jq si está; si no, fallback simple
  jget(){ if command -v jq >/dev/null 2>&1; then printf "%s" "$INPUT" | jq -r "$1 // empty"; else awk -v k="$1" 'BEGIN{gsub(/\./,"",k);sub(/^\./,"",k)} {gsub(/"|{|}|\[|\]/,"")} {for(i=1;i<=NF;i++) if($i~k":"){print $(i+1)}}' <<<"$INPUT" | head -n1; fi; }

  local OBJ A RUM K R DC DS G
  OBJ="$(jget '.obj')" ;           [ -n "$OBJ" ] || OBJ="Kael/Prisma"
  A="$(jget '.afinidad')" ;        A="${A:-0.60}"
  RUM="$(jget '.rumbo')" ;         RUM="${RUM:-C}"
  K="$(jget '.clase')" ;           K="${K:-singular}"
  R="$(jget '.ruido')" ;           R="${R:-0}"
  DC="$(jget '.delta.c')";         DC="${DC:-flat}"
  DS="$(jget '.delta.s')";         DS="${DS:-flat}"
  if command -v jq >/dev/null 2>&1; then
    G="$(printf "%s" "$INPUT" | jq -r '[.gates[]?] | join(",")')"
  else
    G="$(printf "%s" "$INPUT" | sed -n 's/.*gates[^[]*\[\([^]]*\)\].*/\1/p' | tr -d '"' | tr -d ' ' | sed 's/, */,/g')"
  fi

  # Calcula usando el mismo núcleo
  local XR HK GP FD FR V
  A="$(printf "%s" "$A" | sed 's/,/./g')"
  XR="$(chi_r "$RUM")"; [ -n "$XR" ] || { echo "{\"error\":\"Rumbo inválido\"}"; exit 2; }
  HK="$(H_k "$K")";    [ -n "$HK" ] || { echo "{\"error\":\"Clase inválida\"}"; exit 2; }
  GP="$(gates_product "$G")"
  FD="$(fdelta "$DC" "$DS")"
  FR="$(fruido "$R")"
  V6=$(awk -v A="$A" -v XR="$XR" -v HK="$HK" -v GP="$GP" -v FD="$FD" -v FR="$FR" 'BEGIN{v=A*XR*HK*GP*FD*FR; if(v<0)v=0; if(v>1)v=1; printf "%.6f", v}')
  
  printf '{'
  printf '"obj":"%s",' "$(json_escape "$OBJ")"
  printf '"A":%.3f,' "$A"
  printf '"chi_r":%.2f,"H_k":%.2f,' "$XR" "$HK"
  printf '"gates_p":%.2f,' "$GP"
  printf '"fdelta":%.2f,"fruido":%.2f,' "$FD" "$FR"
  printf '"V":%s' "$V6"
  printf '}\n'
}

# ---------- Subcomando: io (interactivo) ----------
io_main(){
  echo "┌─ VCALC·IO (SoT HERRAMIENTAS/v0.2)"; echo "└─ valores por defecto entre [ ]"
  read -r -p "obj (Fonema/Objeto) [Kael/Prisma]: " OBJ; OBJ="${OBJ:-Kael/Prisma}"
  read -r -p "afinidad A [0.60]: " A; A="${A:-0.60}"; A="$(echo "$A" | sed 's/,/./g')"
  echo "χ_r (operativo): O/E=1.10, N=1.05, C=1.00, W=0.95, S=0.90"
  read -r -p "rumbo (N/O/E/W/S/C) [C]: " RUM; RUM="${RUM:-C}"
  echo "H_k: básica 0.50 · poco común 0.80 · rara/singular/único 1.00 · metálica 1.20 · obsidiana 1.60"
  echo "Gates: mediacion(1.00|0.80), doble(1.00|0.90), aurora(1.00)"
  read -r -p "gates (lista coma) []: " G
  read -r -p "ruido ρ [0..0.15] [0]: " R; R="${R:-0}"; R="$(echo "$R" | sed 's/,/./g')"
  read -r -p "delta-c (up|flat|down) [flat]: " DC; DC="${DC:-flat}"
  read -r -p "delta-s (up|flat|down) [flat]: " DS; DS="${DS:-flat}"
  read -r -p "¿Salida JSON? (y/N): " WANTJSON; WANTJSON="${WANTJSON:-N}"

WANTJSON_UP="$(printf '%s' "$WANTJSON" | tr '[:lower:]' '[:upper:]')"
  if [ "$WANTJSON_UP" = "Y" ]; then
    printf '%s' "{\"obj\":\"$OBJ\",\"afinidad\":$A,\"rumbo\":\"$RUM\",\"clase\":\"$K\",\"gates\":[${G:+\"${G//,/\",\"}\"}],\"ruido\":$R,\"delta\":{\"c\":\"$DC\",\"s\":\"$DS\"}}" \
    | "$0" json
  else
    "$0" --obj "$OBJ" --afinidad "$A" --rumbo "$RUM" --clase "$K" \
         --gates "$G" --ruido "$R" --delta-c "$DC" --delta-s "$DS"
  fi
}

# ---------- Router ----------
case "${1-}" in
  json) shift; json_main "$@"; exit 0;;
  io)   shift; io_main "$@"; exit 0;;
  ""|-h|--help) usage_core; exit 0;;
  *) core_main "$@"; exit 0;;
esac

