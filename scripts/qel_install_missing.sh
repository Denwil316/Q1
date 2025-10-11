#!/usr/bin/env bash
set -euo pipefail

# cue="install/missing"
# SeedI="A96-251011"
# SoT="QEL/INSTALL/MISSING"
# Version="v1.0"
# Updated="2025-10-11"

need_cmd(){ command -v "$1" >/dev/null 2>&1; }
log(){ printf "\n== %s ==\n" "$*"; }
ok(){ printf "\033[32m✓\033[0m %s\n" "$*"; }
warn(){ printf "\033[33m⚠\033[0m %s\n" "$*"; }

OS="$(uname -s)"

install_debian(){
  log "APT: paquetes base"
  sudo apt-get update -y
  sudo apt-get install -y git git-lfs curl ca-certificates \
    python3 python3-venv python3-pip \
    jq ripgrep fd-find make build-essential

  if ! need_cmd yq; then
    log "Instalando yq"
    YQ_VER="v4.44.3"
    ARCH=$(uname -m); case "$ARCH" in x86_64|amd64) A="amd64";; aarch64|arm64) A="arm64";; *) A="amd64";; esac
    curl -L "https://github.com/mikefarah/yq/releases/download/${YQ_VER}/yq_linux_${A}.tar.gz" | tar xz
    sudo mv yq_linux_* /usr/local/bin/yq
  fi

  if ! need_cmd node; then
    log "Node LTS 20.x"
    curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
    sudo apt-get install -y nodejs
  fi

  if need_cmd corepack; then corepack enable || true; else sudo npm i -g corepack; fi
  git lfs install --force

  # Alias fd → fdfind si aplica
  if need_cmd fdfind && ! need_cmd fd; then
    echo 'alias fd=fdfind' >> ~/.bashrc
  fi

  ok "Debian/Ubuntu listo"
}

install_macos(){
  if ! need_cmd brew; then
    warn "Homebrew no detectado. Instálalo desde https://brew.sh y reintenta."
    return 1
  fi
  log "Homebrew: paquetes base"
  brew update
  brew install git git-lfs node jq yq ripgrep fd make || true
  git lfs install --force
  need_cmd corepack && corepack enable || true
  ok "macOS listo"
}

# Principal
case "$OS" in
  Linux)
    # Detecta WSL por /proc/version
    if grep -qi microsoft /proc/version 2>/dev/null; then
      install_debian
    else
      # Asumimos Debian/Ubuntu. Ajustar si tu distro es distinta.
      install_debian
    fi
    ;;
  Darwin)
    install_macos
    ;;
  *)
    warn "SO no soportado por este script. Usa PowerShell: scripts/qel_install_missing.ps1"
    ;;
esac

# Recomendaciones de Git en este repo
if need_cmd git; then
  git config core.autocrlf false || true
  git config core.filemode false || true
fi

ok "Instalación finalizada. Ejecuta ./scripts/qel_verify_env.sh para validar."