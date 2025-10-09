#!/usr/bin/env bash
set -euo pipefail
export LC_ALL=C
# cue: "[QEL::ECO[96]::RECALL A96-251008-CUEMACHINE-CHECK]"
# SeedI: "A96-250824"
# SoT: "CUEMACHINE/CHECK/v1.4"
# Version: "v1.4"
# Updated: "2025-10-08"

CM_FILE=""; SIDECAR_DIR=""
DO_VERIFY=0; DO_UPDATE=0; DO_SIGN=0; DO_VSIG=0; DO_LOCK=0; DO_UNLOCK=0; VERBOSE=0
WITNESS=""

msg(){ [ $VERBOSE -eq 1 ] && echo "[*] $*"; }
err(){ echo "[ERR] $*" >&2; exit 1; }

# --- Resolución de rutas de sidecar ---
_side_dir(){
  # 1) si el usuario pasó --sidecar-dir, úsalo
  if [ -n "$SIDECAR_DIR" ]; then printf "%s" "$SIDECAR_DIR"; return; fi
  # 2) si existe un subdirectorio 'cuemachine' junto al ledger, úsalo
  local base; base="$(dirname "$CM_FILE")"
  if [ -d "$base/cuemachine" ]; then printf "%s" "$base/cuemachine"; return; fi
  # 3) por defecto, junto al ledger
  printf "%s" "$base"
}
_chain_file(){ printf "%s/%s.chain"     "$(_side_dir)" "$(basename "$CM_FILE")"; }
_sig_file()  { printf "%s/%s.sig"       "$(_side_dir)" "$(basename "$CM_FILE")"; }
_meta_file() { printf "%s/%s.sig.meta"  "$(_side_dir)" "$(basename "$CM_FILE")"; }
_state_file(){ printf "%s/%s.state"     "$(_side_dir)" "$(basename "$CM_FILE")"; }

# Secreto HMAC desde ENV o Keychain (macOS)
get_secret(){
  if [ -n "${QEL_CUEMACH_HMAC:-}" ]; then printf "%s" "$QEL_CUEMACH_HMAC"; return 0; fi
  security find-generic-password -a "$USER" -s "QEL_CueMachine_HMAC" -w 2>/dev/null || true
}

# Hash helpers (robustos en macOS)
h_line_b64(){ printf "%s" "$1" | openssl dgst -sha256 -binary | openssl base64; }
h_file_hex(){ openssl dgst -sha256 -r "$1" | awk '{print $1}'; }
hash10_of_file(){ h_file_hex "$1" | cut -c1-10; }

# Construir chain (append-only lógico)
build_chain(){
  local src="$1"; local out="$2"
  mkdir -p "$(dirname "$out")"
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
  local secret; secret="$(get_secret)"; [ -n "$secret" ] || err "no hay secreto HMAC (Keychain o env QEL_CUEMACH_HMAC)"

  mkdir -p "$(dirname "$sig")" "$(dirname "$meta")"

  # Material a firmar: chain + "\nWITNESS:<texto>" si aplica
  local tmp; tmp="$(mktemp)"
  if [ -n "$WITNESS" ]; then
    (cat "$chain"; printf "\nWITNESS:%s\n" "$WITNESS") > "$tmp"
  else
    cp "$chain" "$tmp"
  fi

  openssl dgst -sha256 -hmac "$secret" -binary "$tmp" | openssl base64 > "$sig"
  echo "[OK] firma HMAC escrita en $sig | sig_hash10=$(hash10_of_file "$sig")"
  rm -f "$tmp"

  if [ -n "$WITNESS" ]; then
    printf "witness: %s\n" "$WITNESS" > "$meta"
    msg "witness guardado en $meta"
  fi

  printf "state_hash10=%s\n" "$(hash10_of_file "$chain")" > "$(_state_file)"
  msg "estado registrado en $(_state_file)"
}

# Verificar firma (requiere mismo witness si se usó)
verify_signature(){
  local chain="$1"; local sig="$2"; local meta="$3"
  [ -f "$sig" ] || err "no hay firma: $sig"
  local secret; secret="$(get_secret)"; [ -n "$secret" ] || err "no hay secreto HMAC para verificar"

  local tmp;  tmp="$(mktemp)"
  if [ -n "$WITNESS" ]; then
    (cat "$chain"; printf "\nWITNESS:%s\n" "$WITNESS") > "$tmp"
  else
    if [ -f "$meta" ]; then
      local w; w="$(sed -n 's/^witness: //p' "$meta")"
      if [ -n "$w" ]; then (cat "$chain"; printf "\nWITNESS:%s\n" "$w") > "$tmp"
      else cp "$chain" "$tmp"; fi
    else
      cp "$chain" "$tmp"
    fi
  fi

  local tmp2; tmp2="$(mktemp)"
  openssl dgst -sha256 -hmac "$secret" -binary "$tmp" | openssl base64 > "$tmp2"
  if cmp -s "$tmp2" "$sig"; then
    echo "[OK] firma HMAC válida | state_hash10=$(hash10_of_file "$chain")"
  else
    err "firma HMAC inválida (witness incorrecto o chain alterada)"
  fi
  rm -f "$tmp" "$tmp2"
}

# -------- Parseo
while [ $# -gt 0 ]; do
  case "$1" in
    --cm-file) CM_FILE="$2"; shift 2;;
    --sidecar-dir) SIDECAR_DIR="$2"; shift 2;;
    --update-chain) DO_UPDATE=1; shift;;
    --verify) DO_VERIFY=1; shift;;
    --sign) DO_SIGN=1; shift;;
    --verify-sign) DO_VSIG=1; shift;;
    --witness) WITNESS="$2"; shift 2;;
    --lock) DO_LOCK=1; shift;;
    --unlock) DO_UNLOCK=1; shift;;
    --verbose) VERBOSE=1; shift;;
    -h|--help) sed -n '1,340p' "$0"; exit 0;;
    *) err "arg desconocido: $1";;
  esac
done

[ -n "$CM_FILE" ] || err "falta --cm-file"
[ -f "$CM_FILE" ] || err "no existe $CM_FILE"

# -------- Orden: UNLOCK → acciones → LOCK
if [ $DO_UNLOCK -eq 1 ]; then
  chflags nouchg "$CM_FILE" && echo "[OK] desbloqueado $CM_FILE" || err "no pude desbloquear (chflags)"
fi

# (1) update (si se pidió)
[ $DO_UPDATE -eq 1 ] && build_chain "$CM_FILE" "$(_chain_file)"

# (2) sign (si se pidió) — si no existe chain, se construye
if [ $DO_SIGN -eq 1 ]; then
  [ -f "$(_chain_file)" ] || build_chain "$CM_FILE" "$(_chain_file)"
  sign_chain "$(_chain_file)" "$(_sig_file)" "$(_meta_file)"
fi

# (3) verify (si se pidió)
[ $DO_VERIFY -eq 1 ] && verify_chain "$CM_FILE" "$(_chain_file)"
[ $DO_VSIG -eq 1 ]   && verify_signature "$(_chain_file)" "$(_sig_file)" "$(_meta_file)"

# (4) lock al final (si se pidió)
if [ $DO_LOCK -eq 1 ]; then
  chflags uchg "$CM_FILE" && echo "[OK] bloqueado $CM_FILE (usa --unlock para editar)" || err "no pude bloquear (chflags)"
fi

# Nada que hacer
if [ $DO_UPDATE -eq 0 ] && [ $DO_VERIFY -eq 0 ] && [ $DO_SIGN -eq 0 ] && [ $DO_VSIG -eq 0 ] && [ $DO_LOCK -eq 0 ] && [ $DO_UNLOCK -eq 0 ]; then
  echo "[INFO] Nada que hacer. Flags: --sidecar-dir, --update-chain, --sign, --verify, --verify-sign, --lock, --unlock."
fi
