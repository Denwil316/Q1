#!/usr/bin/env bash
set -euo pipefail
export LC_ALL=C
# cue: "[QEL::ECO[96]::RECALL A96-251008-CUEMACHINE-ADD]"
# SeedI: "A96-250824"
# SoT: "CUEMACHINE/ADD/v1.1"
# Version: "v1.1"
# Updated: "2025-10-08"

VERBOSE=0; ALLOW_DUP=0
CM_FILE=""; CUE=""; SEED=""; SOT=""; VERSION=""; UPDATED=""; TARGET=""

err(){ echo "[ERR] $*" >&2; exit 1; }
msg(){ [ $VERBOSE -eq 1 ] && echo "[*] $*"; }

while [ $# -gt 0 ]; do
  case "$1" in
    --cm-file) CM_FILE="$2"; shift 2;;
    --cue)     CUE="$2"; shift 2;;
    --seed)    SEED="$2"; shift 2;;
    --sot)     SOT="$2"; shift 2;;
    --version) VERSION="$2"; shift 2;;
    --updated) UPDATED="$2"; shift 2;;
    --target)  TARGET="$2"; shift 2;;
    --allow-duplicate) ALLOW_DUP=1; shift;;
    --verbose) VERBOSE=1; shift;;
    -h|--help) sed -n '1,160p' "$0"; exit 0;;
    *) err "arg desconocido: $1";;
  esac
done

[ -n "$CM_FILE" ]  || err "falta --cm-file"
[ -n "$CUE" ]      || err "falta --cue"
[ -n "$SEED" ]     || err "falta --seed"
[ -n "$SOT" ]      || err "falta --sot"
[ -n "$VERSION" ]  || err "falta --version"
[ -n "$UPDATED" ]  || err "falta --updated"

mkdir -p "$(dirname "$CM_FILE")"
touch "$CM_FILE"

if [ $ALLOW_DUP -ne 1 ] && grep -Fq "$CUE" "$CM_FILE"; then
  echo "[SKIP] Ya existe esa CUE en $CM_FILE"; exit 0
fi

if [ ! -s "$CM_FILE" ]; then
  {
    echo "cue: \"[QEL::ECO[96]::RECALL A96-251008-CUEMACHINE-A96]\""
    echo "SeedI: \"$SEED\""
    echo "SoT: \"CUEMACHINE/A96/v1.0\""
    echo "Version: \"v1.0\""
    echo "Updated: \"$(date +%Y-%m-%d)\""
    echo
  } >> "$CM_FILE"
  msg "Inicialicé cabecera en $CM_FILE"
fi

line="[$CUE] SOT=$SOT"
[ -n "$TARGET" ] && line="$line TARGET=$TARGET"
printf "%s\n" "$line" >> "$CM_FILE"

# hash10 robusto (openssl -r imprime el hash primero)
h10=$(printf "%s" "$line" | openssl dgst -sha256 -r | awk '{print $1}' | cut -c1-10)
echo "[OK] Añadida entrada a $CM_FILE | hash10(linea)=$h10"
