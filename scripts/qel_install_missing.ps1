# cue="install/missing"
# SeedI="A96-251011"
# SoT="QEL/INSTALL/MISSING"
# Version="v1.0"
# Updated="2025-10-11"
param()
$ErrorActionPreference = 'Stop'


Write-Host "== Winget: paquetes base =="
winget install -e --id OpenJS.NodeJS.LTS --silent
winget install -e --id Python.Python.3.12 --silent
winget install -e --id Git.Git --silent
winget install -e --id Git.GitLFS --silent
winget install -e --id jqlang.jq --silent
winget install -e --id MikeFarah.yq --silent
winget install -e --id BurntSushi.ripgrep.MSVC --silent
winget install -e --id sharkdp.fd --silent
# opcional: make con MSYS2
# winget install -e --id MSYS2.MSYS2 --silent


# corepack / pnpm
try { corepack enable } catch {}


# Git LFS
git lfs install --force


# Config Git recomendada para evitar ruido
try { git config core.autocrlf false } catch {}
try { git config core.filemode false } catch {}


Write-Host "✓ Instalación finalizada. Corre: scripts\\qel_verify_env.sh en WSL o revisa con 'git --version' etc."
