#!/usr/bin/env bash
set -euo pipefail
export LC_ALL=C
# cue: "[QEL::ECO[96]::RECALL A96-251008-CUEMACHINE-CHECK]"
# SeedI: "A96-250824"
# SoT: "CUEMACHINE/CHECK/v1.1"
# Version: "v1.1"
# Updated: "2025-10-08"

# USO:
#  scripts/qel_cuemachine_check.sh --cm-file codex/docs/ritual/QEL_CueMachineA96_v1.0.txt --update-chain
#  scripts/qel_cuemachine_check.sh --cm-file ... --verify
#  scripts/qel_cuemachine_check.sh --cm-file ... --sign [--witness "Sello Árbitra 251006"]
#  scripts/qel_cuemachine_check.sh --cm-file ... --verify-sign [--witness "..."]
#  scripts/qel_cuemachine_check.sh --cm-file ... --lock | --unlock

CM_FILE=""; DO_VERIFY=0; DO_UPDATE=0; DO_SIGN=0; DO_VSIG=0; DO_LOCK=0; DO_UNLOCK=0; VERBOSE=0
WITNESS=""

msg(){ [ $VERBOSE -eq 1 ] && echo "[*] $*"; }
err(){ echo "[ERR] $*" >&2; exit 1; }

chain_file(){ printf "%s.chain" "$CM_FILE"; }
sig_file(){ printf "%s.sig" "$CM_FILE"; }
sig_meta(){ printf "%s.sig.meta" "$CM_FILE"; }
state_file(){ printf "%s.state" "$CM_FILE"; }

# Secreto HMAC desde ENV o Keychain (macOS)
get_secret(){
  if [ -n "${QEL_CUEMACH_HMAC:-}" ]; then
    printf "%s" "$QEL_CUEMACH_HMAC"; return 0
  fi
  security find-generic-password -a "$USER" -s "QEL_CueMachine_HMAC" -w 2>/dev/null || true
}

# Hash SHA-256 base64 de una cadena
h_line_b64(){ printf "%s" "$1" | openssl dgst -sha256 -binary | openssl base64; }
# Hash SHA-256 hex de archivo completo
h_file_hex(){ openssl dgst -sha256 "$1" | awk '{print $2}'; }
# hash10 (10 primeras hex)
hash10_of_file(){ h_file_hex "$1" | cut -c1-10; }

# Construir chain (append-only lógico)
build_chain(){
  local src="$1"; local out="$2"
  : > "$out"
  local prev="GENESIS"
  while IFS= read -r L; do
    case "$L" in
      ""|*": "*) continue;;  # cabecera o vacío
      \#*) continue;;
    esac
    local h; h="$(h_line_b64 "$prev|$L")"
    printf "%s\t%s\n" "$h" "$L" >> "$out"
    prev="$h"
  done < "$src"
  echo "[OK] chain actualizada: $out | state_hash10=$(hash10_of_file "$out")"
}

# Verificar chain
verify_chain(){
  local src="$1"; local chain="$2"
  [ -f "$chain" ] || err "no existe chain: $chain (ejecuta --update-chain primero)"
  local prev="GENESIS"; local ok=1; local ln=0
  while IFS=$'\t' read -r h L; do
    [ -z "${h:-}" ] && continue
    ln=$((ln+1))
    local h2; h2="$(h_line_b64 "$prev|$L")"
    if [ "$h" != "$h2" ]; then
      echo "[FAIL] cadena rota en línea $ln: $L"
      ok=0; break
    fi
    prev="$h"
  done < "$chain"
  if [ $ok -eq 1 ]; then
    echo "[OK] chain verificada | state_hash10=$(hash10_of_file "$chain")"
  else
    exit 2
  fi
}

# Firmar (HMAC) la chain (+ witness opcional)
sign_chain(){
  local chain="$1"; local sig="$2"; local meta="$3"
  local secret; secret="$(get_secret)"
  [ -n "$secret" ] || err "no hay secreto HMAC (Keychain o env QEL_CUEMACH_HMAC)"

  # Material a firmar: contenido literal de chain + "\nWITNESS:<texto>"
  local tmp; tmp="$(mktemp)"; trap 'rm -f "$tmp"' EXIT
  if [ -n "$WITNESS" ]; then
    (cat "$chain"; printf "\nWITNESS:%s\n" "$WITNESS") > "$tmp"
  else
    cp "$chain" "$tmp"
  fi

  openssl dgst -sha256 -hmac "$secret" -binary "$tmp" | openssl base64 > "$sig"
  echo "[OK] firma HMAC escrita en $sig | sig_hash10=$(hash10_of_file "$sig")"

  # Guardar witness público (no secreto) como recordatorio
  if [ -n "$WITNESS" ]; then
    printf "witness: %s\n" "$WITNESS" > "$meta"
    msg "witness guardado en $meta"
  fi

  # Persistir estado (hash10) para tus cuadernos
  local sh10; sh10="$(hash10_of_file "$chain")"
  printf "state_hash10=%s\n" "$sh10" > "$(state_file)"
  msg "estado registrado en $(state_file)"
}

# Verificar firma (requiere mismo witness si se usó)
verify_signature(){
  local chain="$1"; local sig="$2"; local meta="$3"
  [ -f "$sig" ] || err "no hay firma: $sig"
  local secret; secret="$(get_secret)"
  [ -n "$secret" ] || err "no hay secreto HMAC para verificar"

  local tmp; tmp="$(mktemp)"; trap 'rm -f "$tmp"' EXIT
  if [ -n "$WITNESS" ]; then
    (cat "$chain"; printf "\nWITNESS:%s\n" "$WITNESS") > "$tmp"
  else
    # Si no se pasa --witness, pero existe meta, la usamos como ayuda
    if [ -f "$meta" ]; then
      local w; w="$(sed -n 's/^witness: //p' "$meta")"
      if [ -n "$w" ]; then (cat "$chain"; printf "\nWITNESS:%s\n" "$w") > "$tmp"
      else cp "$chain" "$tmp"; fi
    else
      cp "$chain" "$tmp"
    fi
  fi

  local tmp2; tmp2="$(mktemp)"; trap 'rm -f "$tmp2"' EXIT
  openssl dgst -sha256 -hmac "$secret" -binary "$tmp" | openssl base64 > "$tmp2"
  if cmp -s "$tmp2" "$sig"; then
    echo "[OK] firma HMAC válida | state_hash10=$(hash10_of_file "$chain")"
  else
    err "firma HMAC inválida (witness incorrecto o chain alterada)"
  fi
}

LOCK_NOTE="(usa --unlock para permitir edición; vuelve a --lock al cerrar)"

# Parseo de flags
while [ $# -gt 0 ]; do
  case "$1" in
    --cm-file) CM_FILE="$2"; shift 2;;
    --update-chain) DO_UPDATE=1; shift;;
    --verify) DO_VERIFY=1; shift;;
    --sign) DO_SIGN=1; shift;;
    --verify-sign) DO_VSIG=1; shift;;
    --witness) WITNESS="$2"; shift 2;;
    --lock) DO_LOCK=1; shift;;
    --unlock) DO_UNLOCK=1; shift;;
    --verbose) VERBOSE=1; shift;;
    -h|--help) sed -n '1,260p' "$0"; exit 0;;
    *) err "arg desconocido: $1";;
  esac
done

[ -n "$CM_FILE" ] || err "falta --cm-file"
[ -f "$CM_FILE" ] || err "no existe $CM_FILE"

if [ $DO_LOCK -eq 1 ]; then
  chflags uchg "$CM_FILE" && echo "[OK] bloqueado $CM_FILE $LOCK_NOTE" || err "no pude bloquear (chflags)"
  exit 0
fi
if [ $DO_UNLOCK -eq 1 ]; then
  chflags nouchg "$CM_FILE" && echo "[OK] desbloqueado $CM_FILE" || err "no pude desbloquear (chflags)"
  exit 0
fi

if [ $DO_UPDATE -eq 1 ]; then
  build_chain "$CM_FILE" "$(chain_file)"
fi
if [ $DO_VERIFY -eq 1 ]; then
  verify_chain "$CM_FILE" "$(chain_file)"
fi
if [ $DO_SIGN -eq 1 ]; then
  sign_chain "$(chain_file)" "$(sig_file)" "$(sig_meta)"
fi
if [ $DO_VSIG -eq 1 ]; then
  verify_signature "$(chain_file)" "$(sig_file)" "$(sig_meta)"
fi

if [ $DO_UPDATE -eq 0 ] && [ $DO_VERIFY -eq 0 ] && [ $DO_SIGN -eq 0 ] && [ $DO_VSIG -eq 0 ] && [ $DO_LOCK -eq 0 ] && [ $DO_UNLOCK -eq 0 ]; then
  echo "[INFO] Nada que hacer. Usa --update-chain, --verify, --sign, --verify-sign, --lock o --unlock."
fi
