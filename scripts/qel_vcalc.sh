#!/usr/bin/env bash
set -euo pipefail

# [QEL::ECO[96]::A96-250820-VCALC-UNIFIED]
# SeedI=A96-250820
# SoT=HERRAMIENTAS/v0.2
# Version=v0.2
# Updated=2025-08-24

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

: "${LC_NUMERIC:=C}"; export LC_NUMERIC

# ---------- Utilidades ----------
trim(){ awk '{$1=$1;print}' <<<"$1"; }
lower(){ tr '[:upper:]' '[:lower:]' <<<"$1"; }
upper(){ tr '[:lower:]' '[:upper:]' <<<"$1"; }
json_escape(){ local s=$1; s=${s//\\/\\\\}; s=${s//\"/\\\"}; s=${s//$'\n'/\\n}; echo -n "$s"; }

usage_core(){
cat <<USAGE
Uso (core):
  scripts/qel_vcalc.sh --obj "Kael/Prisma" --afinidad 0.72 --rumbo N \\
    --clase singular --gates "mediacion,doble" --ruido 0.04 \\
    --delta-c up --delta-s flat [--emit quiet|json]

Subcomandos:
  scripts/qel_vcalc.sh io        # modo interactivo (humano)
  scripts/qel_vcalc.sh json ...  # modo objeto (lee JSON)

Flags core:
  --obj "Fonema/Objeto"             (requerido)
  --afinidad [0..1]                 (def=0.60)
  --rumbo N|O|W|S|C                 (def=C)
  --clase comun|raro|singular|unico (def=singular)
  --gates "mediacion[,doble][,aurora]"
  --ruido [0..1] (clip 0.15)        (def=0.00)
  --delta-c up|flat|down            (def=flat)
  --delta-s up|flat|down            (def=flat)
  --emit pretty|quiet|json          (def=pretty)
USAGE
}

# ---------- Tablas SoT (operativas) ----------
chi_r(){ case "$(upper "$1")" in
  N|C) echo 1.00;;
  O|E) echo 0.95;;
  W)   echo 0.90;;
  S)   echo 0.88;;
  *)   echo "";;
esac; }

H_k(){ case "$(lower "$1")" in
  comun|básica|basica)        echo 0.85;;
  raro|poco-comun|poco-común) echo 0.92;;
  singular|rara)              echo 1.00;;
  unico|único)                echo 1.00;;
  *)                          echo "";;
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
      aurora|contacto_aurora) AUR=0.95;;
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

  case "$EMIT" in
    quiet) echo "$V";;
    json)
      printf '{'
      printf '"obj":"%s",' "$(json_escape "$OBJ")"
      printf '"A":%.3f,' "$A"
      printf '"chi_r":%.2f,"H_k":%.2f,' "$XR" "$HK"
      printf '"gates_p":%.2f,' "$GP"
      printf '"fdelta":%.2f,"fruido":%.2f,' "$FD" "$FR"
      printf '"V":%.2f' "$V"
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
𝒱 (clip 0..1): $V
Sugerencia --obj: "${OBJ}=${V}"
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
  V="$(compute_v "$A" "$XR" "$HK" "$GP" "$FD" "$FR")"

  printf '{'
  printf '"obj":"%s",' "$(json_escape "$OBJ")"
  printf '"A":%.3f,' "$A"
  printf '"chi_r":%.2f,"H_k":%.2f,' "$XR" "$HK"
  printf '"gates_p":%.2f,' "$GP"
  printf '"fdelta":%.2f,"fruido":%.2f,' "$FD" "$FR"
  printf '"V":%.2f' "$V"
  printf '}\n'
}

# ---------- Subcomando: io (interactivo) ----------
io_main(){
  echo "┌─ VCALC·IO (SoT HERRAMIENTAS/v0.2)"; echo "└─ valores por defecto entre [ ]"
  read -r -p "obj (Fonema/Objeto) [Kael/Prisma]: " OBJ; OBJ="${OBJ:-Kael/Prisma}"
  read -r -p "afinidad A [0.60]: " A; A="${A:-0.60}"; A="$(echo "$A" | sed 's/,/./g')"
  echo "χ_r (operativo): N/C=1.00, O=0.95, W=0.90, S=0.88"
  read -r -p "rumbo (N/O/W/S/C) [C]: " RUM; RUM="${RUM:-C}"
  echo "H_k: comun 0.85 · raro 0.92 · singular/unico 1.00 (clip ≤1)"
  read -r -p "clase (comun|raro|singular|unico) [singular]: " K; K="${K:-singular}"
  echo "Gates: mediacion(1.00|0.80), doble(1.00|0.90), aurora(0.95)"
  read -r -p "gates (lista coma) []: " G
  read -r -p "ruido ρ [0..0.15] [0]: " R; R="${R:-0}"; R="$(echo "$R" | sed 's/,/./g')"
  read -r -p "delta-c (up|flat|down) [flat]: " DC; DC="${DC:-flat}"
  read -r -p "delta-s (up|flat|down) [flat]: " DS; DS="${DS:-flat}"
  read -r -p "¿Salida JSON? (y/N): " WANTJSON; WANTJSON="${WANTJSON:-N}"

  if [[ "${WANTJSON^^}" == "Y" ]]; then
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

