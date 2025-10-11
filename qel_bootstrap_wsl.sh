#!/usr/bin/env bash
set -euo pipefail

# [QEL::BOOTSTRAP]
# cue="bootstrap/wsl"
# SeedI="A96-251011"
# SoT="QEL/BOOTSTRAP/WSL"
# Version="v1.0"
# Updated="2025-10-11"

# Requisitos base (Ubuntu/Debian)
sudo apt-get update -y
sudo apt-get install -y \
  git git-lfs curl ca-certificates build-essential \
  python3 python3-venv python3-pip \
  jq \
  ripgrep fd-find \
  make

# yq (YAML) - binario oficial
if ! command -v yq >/dev/null 2>&1; then
  YQ_VER="v4.44.3"
  ARCH=$(uname -m)
  case "$ARCH" in
    x86_64|amd64) YQ_ARCH="amd64" ;;
    aarch64|arm64) YQ_ARCH="arm64" ;;
    *) YQ_ARCH="amd64" ;;
  esac
  curl -L "https://github.com/mikefarah/yq/releases/download/${YQ_VER}/yq_linux_${YQ_ARCH}.tar.gz" \
    | tar xz && sudo mv yq_linux_* /usr/local/bin/yq
fi

# Node.js LTS (20.x) + corepack/pnpm
if ! command -v node >/dev/null 2>&1; then
  curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
  sudo apt-get install -y nodejs
fi

# Habilita corepack (trae pnpm/yarn administrados por Node)
if command -v corepack >/dev/null 2>&1; then
  corepack enable
fi

# Git LFS
git lfs install

echo "✓ WSL listo. Versiones:"
git --version
git lfs --version
node -v
npm -v
corepack -v || true
python3 --version
jq --version
yq --version
rg --version || true
fdfind --version || true
make -v || true

echo "Nota: en Ubuntu, 'fd' se llama 'fdfind'. Puedes alias:"
echo "  echo 'alias fd=fdfind' >> ~/.bashrc && source ~/.bashrc"
