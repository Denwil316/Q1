#!/usr/bin/env bash
set -euo pipefail

# cue=[QEL::ECO[96]::RECALL A96-260119-VERIFY-ENV]
# SeedI=A37-251015
# SoT=HERRAMIENTAS/VERIFY-ENV/v1.4
# Version=v1.4
# Updated=2026-01-19

# ------------------------------
# QEL Verify Env (Linux/Mac)
# - Siempre imprime resultado
# - Lista faltantes (core vs opcional)
# - "fd" inteligente: binario | wrapper | alias en dotfiles
# ------------------------------

die(){ echo "[QEL][verify][ERROR] $*" >&2; exit 2; }
hr(){ echo "----------------------------------------"; }
ok(){ echo "[OK] $*"; }
warn(){ echo "[WARN] $*"; }
miss(){ echo "[MISSING] $*"; }

have(){ command -v "$1" >/dev/null 2>&1; }

repo_root(){
  local script_dir
  script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
  (cd "$script_dir/.." && git rev-parse --show-toplevel 2>/dev/null) || (cd "$script_dir/.." && pwd)
}

REQ_MISSING=()
OPT_MISSING=()

req(){
  local cmd="$1"; shift || true
  local label="${1:-$cmd}"
  if have "$cmd"; then ok "$label"; return 0; fi
  miss "$label"; REQ_MISSING+=("$label"); return 1
}

opt(){
  local cmd="$1"; shift || true
  local label="${1:-$cmd}"
  if have "$cmd"; then ok "$label"; return 0; fi
  warn "$label"; OPT_MISSING+=("$label"); return 1
}

check_yq_mikefarah(){
  # yq requerido: el binario Go de mikefarah (v4.x)
  if ! have yq; then
    miss "yq (mikefarah, v4.x)"; REQ_MISSING+=("yq (mikefarah, v4.x)"); return 1
  fi
  local v
  v="$(yq --version 2>/dev/null || true)"
  if echo "$v" | grep -Eq '(mikefarah/yq|version v4\.)'; then
    ok "yq (mikefarah)"; echo "$v"; return 0
  fi
  warn "yq detectado, pero no parece ser mikefarah/v4: $v"
  miss "yq (mikefarah, v4.x)"; REQ_MISSING+=("yq (mikefarah, v4.x)"); return 1
}

check_fd_smart(){
  # En scripts NO se heredan aliases del shell interactivo.
  # Checamos, en orden:
  #  1) binario fd en PATH
  #  2) wrapper ~/.local/bin/fd (si existe)
  #  3) alias fd=... en dotfiles (bash/zsh/fish) -> OK con warning
  #  4) fdfind disponible pero sin wrapper/alias -> sugerencia

  if have fd; then
    ok "fd"; fd --version 2>/dev/null || true; return 0
  fi

  if [ -x "$HOME/.local/bin/fd" ]; then
    warn "fd wrapper existe en ~/.local/bin/fd, pero no esta en PATH para este script"
    warn "Solucion: export PATH=\"$HOME/.local/bin:$PATH\" (o abre una terminal nueva)"
    OPT_MISSING+=("fd (PATH)")
    return 0
  fi

  # Buscar alias en dotfiles (heuristica)
  if [ -f "$HOME/.bashrc" ] && grep -Eq '^[[:space:]]*alias[[:space:]]+fd=' "$HOME/.bashrc"; then
    warn "fd parece existir como alias en ~/.bashrc (solo interactivo). Recomendado: wrapper ~/.local/bin/fd"
    return 0
  fi
  if [ -f "$HOME/.zshrc" ] && grep -Eq '^[[:space:]]*alias[[:space:]]+fd=' "$HOME/.zshrc"; then
    warn "fd parece existir como alias en ~/.zshrc (solo interactivo). Recomendado: wrapper ~/.local/bin/fd"
    return 0
  fi
  if [ -f "$HOME/.config/fish/config.fish" ] && grep -Eq '^[[:space:]]*alias[[:space:]]+fd' "$HOME/.config/fish/config.fish"; then
    warn "fd parece existir como alias en fish config (solo interactivo). Recomendado: wrapper ~/.local/bin/fd"
    return 0
  fi

  if have fdfind; then
    warn "fdfind presente; sugerido wrapper 'fd' -> 'fdfind' en ~/.local/bin"
    OPT_MISSING+=("fd (wrapper)")
    return 1
  fi

  warn "fd/fdfind"; OPT_MISSING+=("fd/fdfind")
  return 1
}

ROOT="$(repo_root)" || die "No pude localizar la raiz del repo"
cd "$ROOT" || die "No pude entrar al repo: $ROOT"

echo "=== QEL Verify Env ==="
echo "Repo: $ROOT"
echo "Fecha: $(date -Iseconds)"

uname -a || true
if [ -r /etc/os-release ]; then
  # shellcheck disable=SC1091
  . /etc/os-release
  echo "Distro: ${PRETTY_NAME:-unknown}"
fi

hr

echo "-- CORE (requerido) --"
req git "git" || true
req git-lfs "git-lfs" || true
req node "node" || true
req npm "npm" || true

if have python3; then
  ok "python3"; python3 --version || true
elif have python; then
  warn "python (fallback; recomendado: python3)"; python --version || true
else
  miss "python3"; REQ_MISSING+=("python3")
fi

req jq "jq" || true
check_yq_mikefarah || true

hr

echo "-- OPCIONALES (recomendados) --"
opt corepack "corepack" || true
opt pnpm "pnpm" || true
opt rg "ripgrep (rg)" || true

check_fd_smart || true

opt make "make" || true
opt curl "curl" || true
opt unzip "unzip" || true
opt code "VS Code (code)" || true

hr

echo "-- REPO --"
if have git && git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Branch: $(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo '-')"
  local_changes="$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')"
  if [ "$local_changes" -gt 0 ]; then
    warn "Working tree con cambios: $local_changes"
  else
    ok "Working tree limpio"
  fi

  if have git-lfs; then
    echo "-- LFS status --"
    git lfs status || true
  fi
else
  warn "No pude leer estado de git (no es repo o git falla)."
fi

hr

echo "-- RESUMEN --"
if [ "${#REQ_MISSING[@]}" -eq 0 ]; then
  ok "Chequeo core: EXITOSO"
  if [ "${#OPT_MISSING[@]}" -gt 0 ]; then
    warn "Opcionales faltantes (${#OPT_MISSING[@]}):"
    for x in "${OPT_MISSING[@]}"; do echo "  - $x"; done
  fi
  exit 0
fi

miss "Chequeo core: FALL0 (faltan ${#REQ_MISSING[@]} requeridos)"
for x in "${REQ_MISSING[@]}"; do echo "  - $x"; done

exit 1