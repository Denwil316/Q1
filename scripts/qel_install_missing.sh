#!/usr/bin/env bash
set -euo pipefail

# cue=[QEL::ECO[96]::RECALL A96-260119-INSTALL-MISSING]
# SeedI=A37-251015
# SoT=HERRAMIENTAS/INSTALL/MISSING/v1.2
# Version=v1.2
# Updated=2026-01-19

# ------------------------------
# QEL Install Missing (Linux Mint/Ubuntu/Debian + macOS)
# - Instala deps base del repo
# - Crea wrapper fd -> fdfind (si aplica)
# - Evita ensuciar el repo (usa /tmp)
# ------------------------------

have(){ command -v "$1" >/dev/null 2>&1; }
log(){ echo; echo "== $* =="; }
ok(){ echo "[OK] $*"; }
warn(){ echo "[WARN] $*"; }
die(){ echo "[ERROR] $*" >&2; exit 2; }

ensure_path_local_bin(){
  mkdir -p "$HOME/.local/bin"
  if ! echo ":$PATH:" | grep -q ":$HOME/.local/bin:"; then
    # bashrc
    if [ -f "$HOME/.bashrc" ] && ! grep -qs 'export PATH="$HOME/.local/bin:$PATH"' "$HOME/.bashrc"; then
      echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
    fi
    # profile
    if [ -f "$HOME/.profile" ] && ! grep -qs 'export PATH="$HOME/.local/bin:$PATH"' "$HOME/.profile"; then
      echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.profile"
    fi
    warn "Agregue ~/.local/bin al PATH (abre una nueva terminal para aplicar)"
  fi
}

ensure_fd_wrapper(){
  # En Ubuntu/Mint: paquete fd-find expone 'fdfind'. Esto crea un wrapper real 'fd'.
  if have fdfind && ! have fd; then
    ensure_path_local_bin
    cat > "$HOME/.local/bin/fd" <<'SH'
#!/usr/bin/env bash
exec fdfind "$@"
SH
    chmod +x "$HOME/.local/bin/fd"
    ok "Wrapper creado: ~/.local/bin/fd -> fdfind"
  fi
}

install_yq_mikefarah_linux(){
  # Instala yq (mikefarah) en /usr/local/bin/yq
  local yq_ver="${1:-v4.44.3}"
  local arch a tmp tarball

  have curl || die "curl es requerido para instalar yq"
  have tar || die "tar es requerido para instalar yq"

  arch="$(uname -m)"
  case "$arch" in
    x86_64|amd64) a="amd64";;
    aarch64|arm64) a="arm64";;
    *) a="amd64"; warn "ARCH no reconocido ($arch). Asumiendo amd64";;
  esac

  tmp="$(mktemp -d /tmp/qel_yq.XXXXXX)"
  tarball="$tmp/yq.tgz"
  trap 'rm -rf "$tmp"' RETURN

  log "Instalando yq (mikefarah) ${yq_ver}"
  curl -L "https://github.com/mikefarah/yq/releases/download/${yq_ver}/yq_linux_${a}.tar.gz" -o "$tarball"
  tar -xzf "$tarball" -C "$tmp"

  if [ -f "$tmp/yq_linux_${a}" ]; then
    sudo install -m 0755 "$tmp/yq_linux_${a}" /usr/local/bin/yq
  else
    # fallback: busca binario
    local candidate
    candidate="$(find "$tmp" -maxdepth 1 -type f -name 'yq_linux_*' | head -n1 || true)"
    [ -n "$candidate" ] || die "No pude localizar el binario de yq en el tar"
    sudo install -m 0755 "$candidate" /usr/local/bin/yq
  fi

  ok "yq instalado: $(yq --version 2>/dev/null || true)"
}

install_debian_like(){
  have apt-get || die "Este script asume Debian/Ubuntu/Mint (apt-get)."

  log "APT update"
  sudo apt-get update -y

  log "APT install base"
  sudo apt-get install -y \
    git git-lfs curl ca-certificates \
    python3 python3-venv python3-pip \
    jq ripgrep fd-find make build-essential \
    unzip zip tar

  log "Git LFS init"
  git lfs install --force || true

  # Node
  if ! have node; then
    log "Node LTS 20.x (NodeSource)"
    curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
    sudo apt-get install -y nodejs
  fi

  # corepack (para pnpm/yarn gestionado)
  if have corepack; then
    corepack enable || true
    ok "corepack habilitado"
  else
    # fallback: instala corepack via npm global
    if have npm; then
      log "Instalando corepack via npm -g (fallback)"
      sudo npm i -g corepack || true
      corepack enable || true
    else
      warn "npm no disponible; no puedo instalar corepack"
    fi
  fi

  # yq: preferimos mikefarah (v4). En Ubuntu el paquete 'yq' puede ser otro.
  if have yq; then
    yq --version || true
    # Si no es mikefarah v4, instala el correcto.
    if ! (yq --version 2>/dev/null | grep -Eq '(mikefarah/yq|version v4\.)'); then
      warn "yq detectado pero no parece mikefarah v4; instalando mikefarah yq"
      install_yq_mikefarah_linux "v4.44.3"
    else
      ok "yq (mikefarah) OK"
    fi
  else
    install_yq_mikefarah_linux "v4.44.3"
  fi

  ensure_fd_wrapper
  ok "Debian/Ubuntu/Mint listo"
}

install_macos(){
  have brew || die "Homebrew no detectado. Instala brew y reintenta."

  log "Homebrew update"
  brew update

  log "Homebrew install base"
  brew install git git-lfs node jq yq ripgrep fd make || true

  git lfs install --force || true
  have corepack && corepack enable || true

  ok "macOS listo"
}

main(){
  local os
  os="$(uname -s)"

  case "$os" in
    Linux) install_debian_like ;;
    Darwin) install_macos ;;
    *) warn "SO no soportado por este script: $os" ;;
  esac

  # Recomendaciones Git (no fallan si no hay git)
  if have git; then
    git config core.autocrlf false || true
    git config core.filemode false || true
  fi

  ok "Instalacion finalizada."
  if [ -x "./scripts/qel_verify_env.sh" ]; then
    echo
    ./scripts/qel_verify_env.sh || true
  else
    warn "No encontre ./scripts/qel_verify_env.sh para validar automaticamente"
  fi
}

main "$@"