#!/usr/bin/env bash
set -euo pipefail

# [QEL::ECO[96]::A96-250820-VCALC]
# SeedI=A96-250820
# SoT=HERRAMIENTAS/v0.1
# Version=v0.1
# Updated=2025-08-20

OBJ=""         # ej. "Kael/Prisma"
AFINIDAD="0.60" # 0..1 (MFH)
RUMBO="C"      # N|O|W|S|C
CLASE="singular"  # comun|raro|singular|unico
GATES=""       # ej. "mediacion,doble,aurora"
RUIDO="0.00"   # 0..1 (porción de ruido percibido)
DELTAC="flat"  # up|flat|down
DELTAS="flat"  # up|flat|down
QUIET="0"

usage() {
  cat <<USAGE
Uso:
  scripts/qel_vcalc.sh --obj "Kael/Prisma" --afinidad 0.72 --rumbo N --clase singular \\
    --gates "mediacion,doble" --ruido 0.04 --delta-c up --delta-s flat [--quiet]

Flags:
  --obj        "Fonema/Objeto"                (requerido)
  --afinidad   [0..1] Afinidad MFH A          (def=0.60)
  --rumbo      N|O|W|S|C                      (def=C)
  --clase      comun|raro|singular|unico      (def=singular)
  --gates      lista coma: mediacion,doble,aurora
  --ruido      [0..1]                         (def=0.00; penaliza hasta 0.15)
  --delta-c    up|flat|down                   (def=flat)
  --delta-s    up|flat|down                   (def=flat)
  --quiet      sólo imprime 𝒱 con 2 decimales
USAGE
}

# Parse
while [ $# -gt 0 ]; do
  case "$1" in
    --obj) OBJ="$2"; shift 2;;
    --afinidad) AFINIDAD="$2"; shift 2;;
    --rumbo) RUMBO="$2"; shift 2;;
    --clase) CLASE="$2"; shift 2;;
    --gates) GATES="$2"; shift 2;;
    --ruido) RUIDO="$2"; shift 2;;
    --delta-c) DELTAC="$2"; shift 2;;
    --delta-s) DELTAS="$2"; shift 2;;
    --quiet) QUIET="1"; shift 1;;
    -h|--help) usage; exit 0;;
    *) echo "Flag desconocida: $1"; usage; exit 2;;
  esac
done

[ -n "$OBJ" ] || { echo "Falta --obj"; usage; exit 1; }

# χ_r por rumbo
case "$RUMBO" in
  N) XR=1.00;;
  O) XR=0.95;;
  W) XR=0.90;;
  S) XR=0.88;;
  C) XR=1.00;;
  *) echo "Rumbo inválido: $RUMBO"; exit 2;;
esac

# H_k por clase
case "$CLASE" in
  comun)     HK=0.85;;
  raro)      HK=0.92;;
  singular)  HK=1.00;;
  unico)     HK=1.05;;  # se clippeará
  *) echo "Clase inválida: $CLASE"; exit 2;;
esac

# Gates multiplicadores (presencia; si faltan, penalizan)
MEDIACION=0.80  # penalización por falta; si está presente, sube a 1.00
DOBLE=0.90      # penalización por falta; si está presente, sube a 1.00
AURORA=1.00     # si se declara gate de contacto Aurora, aplicamos 0.95 por cautela
IFS=',' read -r -a GA <<< "${GATES}"
for g in "${GA[@]}"; do
  g="$(echo "$g" | tr '[:upper:]' '[:lower:]' | xargs)"
  case "$g" in
    mediacion) MEDIACION=1.00;;
    doble|doble_testigo) DOBLE=1.00;;
    aurora|contacto_aurora) AURORA=0.95;;
    "" ) :;;
    *) :;; # ignorar otros
  esac
done

# Factor tendencia ΔC/ΔS
dC=0; dS=0
case "$DELTAC" in up) dC=0.02;; down) dC=-0.02;; esac
case "$DELTAS" in up) dS=0.02;; down) dS=-0.02;; esac
FDELTA=$(printf '%.4f' "$(echo "1 + $dC + $dS" | bc -l)")

# Ruido (máx 0.15)
RCLIP=$(printf '%.4f' "$(echo "$RUIDO" | awk '{if($1<0)print 0; else if($1>0.15)print 0.15; else print $1}')")
FRUIDO=$(printf '%.4f' "$(echo "1 - $RCLIP" | bc -l)")

# Unicidad clip
if awk "BEGIN{exit !($HK>1.0)}"; then
  HK=$(printf '%.4f' "$(echo "if($HK>1)1 else $HK" | bc -l)")
fi

# Producto gates
GATES_P=$(printf '%.6f' "$(echo "$MEDIACION * $DOBLE * $AURORA" | bc -l)")

# 𝒱
VRAW=$(printf '%.6f' "$(echo "$AFINIDAD * $XR * $HK * $GATES_P * $FDELTA * $FRUIDO" | bc -l)")
# clip 0..1
V=$(printf '%.2f' "$(echo "if($VRAW<0)0 else if($VRAW>1)1 else $VRAW" | bc -l)")

if [ "$QUIET" = "1" ]; then
  echo "$V"
else
  cat <<OUT
Objeto: $OBJ
A (MFH afinidad): $AFINIDAD
χ_r (rumbo $RUMBO): $XR
H_k (clase $CLASE): $HK
Π_gates (mediacion=$MEDIACION, doble=$DOBLE, aurora=$AURORA) → $GATES_P
ΔC/ΔS factor: $FDELTA   | Ruido factor: $FRUIDO
-----------------------------------------------
𝒱 (clip 0..1): $V
Sugerencia --obj: "${OBJ}=${V}"
OUT
fi