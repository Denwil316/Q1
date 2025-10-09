#!/usr/bin/env bash
set -euo pipefail
export LC_ALL=C
# cue: "[QEL::ECO[96]::RECALL A96-251008-SECRET-INIT]"
# SeedI: "A96-250824"
# SoT: "SECRET/INIT/v1.0"
# Version: "v1.0"
# Updated: "2025-10-08"

# USO:
# scripts/qel_secret_init.sh \
#   --nutria-dir "carpeta_nutria" \
#   --verso "bajo el lago yo vibro" \
#   [--service "QEL_CueMachine_HMAC"] \
#   [--preview]

NUTRIA="carpeta_nutria"; VERSO="bajo el lago yo vibro"
SERVICE="QEL_CueMachine_HMAC"; PREVIEW=0

while [ $# -gt 0 ]; do
  case "$1" in
    --nutria-dir) NUTRIA="$2"; shift 2;;
    --verso)      VERSO="$2"; shift 2;;
    --service)    SERVICE="$2"; shift 2;;
    --preview)    PREVIEW=1; shift;;
    -h|--help)    sed -n '1,140p' "$0"; exit 0;;
    *) echo "[ERR] arg desconocido: $1" >&2; exit 1;;
  esac
done

[ -d "$NUTRIA" ] || { echo "[ERR] no existe $NUTRIA"; exit 2; }

# Parte A: sal nutria (hash estable de contenidos + fecha corta)
SAL_A="$(find "$NUTRIA" -type f -print0 2>/dev/null \
  | xargs -0 shasum -a 256 2>/dev/null \
  | shasum -a 256 | awk '{print $1}')-$(date +%Y%m)"

# Parte B: verso usuario (no se ecoa)
echo "Verso inicial: \"$VERSO ...\""
read -r -s -p "Completa el verso (no se mostrará): " VERSO_B; echo
[ -n "${VERSO_B:-}" ] || { echo "[ERR] verso vacío"; exit 3; }

# Secreto final
SECRET="$(printf "%s:%s" "$SAL_A" "$VERSO_B" \
  | openssl dgst -sha256 -binary | openssl base64)"

# Guardar en Keychain (macOS)
if security find-generic-password -a "$USER" -s "$SERVICE" >/dev/null 2>&1; then
  echo "[WARN] servicio $SERVICE ya existe en Keychain."
  read -r -p "¿Sobrescribir? [y/N] " ans
  case "$ans" in [yY]*) security delete-generic-password -a "$USER" -s "$SERVICE" >/dev/null 2>&1;; *) echo "Abortado."; exit 0;; esac
fi
security add-generic-password -a "$USER" -s "$SERVICE" -w "$SECRET" >/dev/null 2>&1

# hash10 del secreto (para tu cuaderno; no revela el secreto)
h10=$(printf "%s" "$SECRET" | openssl dgst -sha256 | awk '{print $2}' | cut -c1-10)
echo "[OK] secreto guardado en Keychain servicio \"$SERVICE\" | secret_hash10=$h10"
[ $PREVIEW -eq 1 ] && echo "[PREVIEW] SAL_A=${SAL_A}"
