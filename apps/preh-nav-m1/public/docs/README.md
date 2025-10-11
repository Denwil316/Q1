# README — Puesta en Marcha del Repositorio QEL

cue: "readme/arranque"

SeedI: "A96-251011"

SoT: "QEL/OPS/ARRANQUE"

Version: "v1.0"

Updated: "2025-10-11"

---

## 1) Contexto y alcance

Guía mínima y operativa para **poner a andar QEL** en **Windows (WSL/PowerShell)**, **macOS** y **Linux**. Cubre: instalación base, activación de Git LFS, instalación de dependencias JS/Python, y arranque de apps (ej. `apps/preh-nav-m1`).

> Esta guía no reemplaza manuales avanzados; es el **arranque reproducible** para cualquier máquina nueva.

---

## 2) Requisitos y entorno

* **Git** ≥ 2.30 y **Git LFS** activado.
* **Node.js LTS** (20.x recomendado) + `npm` y **corepack** (para `pnpm`).
* **Python 3.x** (opcional, si el repo trae utilerías Python) + `venv`/`pip`.
* **Terminal**:

  * **Windows**: se recomienda **WSL2 (Ubuntu/Debian)** para scripts Bash. Git Bash sirve para operaciones simples de Git.
  * **macOS** / **Linux**: shell Bash/Zsh estándar.

Utilidades útiles (opcionales): `jq`, `yq`, `ripgrep (rg)`, `fd`/`fdfind`, `make`.

---

## 3) TL;DR (paso a paso exprés)

```bash
# 3.1 Clonar (si no lo has hecho)
git clone <URL-del-repo> QEL && cd QEL

# 3.2 Cambiar a la rama PreH (trabajo principal)
git fetch --all --prune
# Git ≥ 2.23:
git switch -c PreH --track origin/PreH
# Git clásico (alternativa):
# git checkout -b PreH origin/PreH

# 3.3 Activar LFS y bajar binarios
git lfs install
git lfs pull
git lfs checkout

# 3.4 Instalar dependencias JavaScript/TypeScript (raíz o por app)
# Si hay package-lock.json en raíz:
[ -f package-lock.json ] && npm ci || echo "Sin lock en raíz; instalar por subcarpetas"

# Monorepo: instala donde haya package.json
# (Ajusta rutas si usas Windows sin WSL)
git ls-files | grep -E '^((apps|packages|tools)/.*/)?package\.json$' \
| sed 's#/package\.json##' \
| xargs -I{} bash -lc 'echo "→ Instalando en {}"; cd "{}" && \
    if [ -f pnpm-lock.yaml ]; then (corepack enable 2>/dev/null || true; pnpm install); \
    elif [ -f package-lock.json ]; then npm ci; \
    else npm install; fi'

# 3.5 Arrancar la app PreH-Nav (Vite dev server)
cd apps/preh-nav-m1
npm run dev           # (o: pnpm dev)
# Si usas WSL y no refresca al guardar:
# CHOKIDAR_USEPOLLING=1 npm run dev
```

---

## 4) Instalación por sistema operativo

### 4.1 Windows — vía **WSL** (recomendado)

En **WSL Ubuntu/Debian**:

```bash
sudo apt-get update -y
sudo apt-get install -y git git-lfs curl ca-certificates \
  python3 python3-venv python3-pip \
  jq ripgrep fd-find make build-essential

# yq (si no está en repos):
YQ_VER="v4.44.3"; ARCH=$(uname -m); case "$ARCH" in x86_64|amd64) A="amd64";; aarch64|arm64) A="arm64";; *) A="amd64";; esac
curl -L "https://github.com/mikefarah/yq/releases/download/${YQ_VER}/yq_linux_${A}.tar.gz" | tar xz && sudo mv yq_linux_* /usr/local/bin/yq

# Node LTS 20.x
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs

# Corepack (pnpm)
corepack enable || sudo npm i -g corepack

# Git LFS (filtros)
git lfs install

# Alias para fd en Ubuntu
printf "\nalias fd=fdfind\n" >> ~/.bashrc && source ~/.bashrc
```

### 4.2 Windows — **nativo** (PowerShell + winget)

```powershell
winget install -e --id OpenJS.NodeJS.LTS
winget install -e --id Python.Python.3.12
winget install -e --id Git.Git
winget install -e --id Git.GitLFS
winget install -e --id jqlang.jq
winget install -e --id MikeFarah.yq
winget install -e --id BurntSushi.ripgrep.MSVC
winget install -e --id sharkdp.fd
corepack enable
git lfs install
```

### 4.3 macOS — **Homebrew**

```bash
# Instalar Homebrew si falta: https://brew.sh
brew update
brew install git git-lfs node jq yq ripgrep fd
# (opcional) make
brew install make

# Activar corepack (pnpm)
corepack enable
# Filtros de LFS
git lfs install
```

### 4.4 Linux (Debian/Ubuntu)

Ver sección 4.1 (WSL): es el mismo procedimiento.

---

## 5) Dependencias del repo

### 5.1 Git LFS

```bash
git lfs install
git lfs pull
git lfs checkout
```

* Si ves miles de `deleted:` **no confirmados**:

```bash
git status
# si tu clon es nuevo y no tienes cambios propios:
git reset --hard HEAD
git lfs pull && git lfs checkout
```

* EOL en Windows (evitar cambios falsos por CRLF):

```bash
git config core.autocrlf false
```

### 5.2 Node / JS

* Para lockfile `npm`: `npm ci`.
* Para monorepo: instala en cada subcarpeta con `package.json` (ver TL;DR 3.4).
* **pnpm**: si el proyecto trae `pnpm-lock.yaml`, usa `pnpm install` (tras `corepack enable`).

### 5.3 Python (si aplica)

```bash
# crear y activar venv (WSL/macOS/Linux)
python3 -m venv .venv
source .venv/bin/activate

# Windows PowerShell
# python -m venv .venv
# .\.venv\Scripts\Activate.ps1

# Instalar dependencias
pip install -U pip
[ -f requirements.txt ] && pip install -r requirements.txt || true
```

---

## 6) Flujos de uso

### 6.1 Primer arranque

```bash
git fetch --all --prune
git switch -c PreH --track origin/PreH
git lfs install && git lfs pull && git lfs checkout
npm ci || true  # si hay lock en raíz
```

### 6.2 Actualizar a futuro

```bash
git pull --ff-only
git lfs pull  # asegura binarios
# reinstalar dependencias si cambió lockfile
npm ci || pnpm install --frozen-lockfile || true
```

### 6.3 Levantar `apps/preh-nav-m1`

```bash
cd apps/preh-nav-m1
npm run dev          # o pnpm dev
# WSL (watch por polling):
# CHOKIDAR_USEPOLLING=1 npm run dev
```

* Puerto típico: `5173`. Si está ocupado:

```bash
npm run dev -- --port 5175
```

### 6.4 Compilar (si aplica)

```bash
npm run build
```

---

## 7) Mantenimiento y seguridad (nota sobre esbuild)

Algunos auditores marcan **esbuild ≤ 0.24.2** por una CVE del *dev server* de esbuild. **Vite no usa** ese dev server, pero si deseas “limpiar” el reporte sin saltos de versión:

**Override sugerido en `package.json`:**

```json
{
  "overrides": {
    "esbuild": "^0.25.0",
    "vite": { "esbuild": "^0.25.0" }
  }
}
```

Luego:

```bash
npm install
npm ls esbuild   # debería mostrar 0.25.x
npm audit        # debe quedar limpio
```

> Actualizar Vite mayor (p. ej., 7.x) se recomienda en rama aparte y revisando Node requerido.

---

## 8) Buenas prácticas

* **Windows**: usa **WSL** para scripts Bash complejos.
* **Git LFS** siempre activo en máquinas nuevas (`git lfs install`).
* **No confirmes borrados masivos** sin revisar `git status`.
* **Watchers en WSL**: usa `CHOKIDAR_USEPOLLING=1` si no refresca.
* Cierra y reabre la terminal tras instalar con `winget`/`brew` para refrescar `PATH`.

---

## 9) Solución de problemas (FAQ)

**P1.** “Git LFS initialized” pero no descarga nada.

> Asegura `git lfs pull && git lfs checkout`.

**P2.** Al cerrar me pide **borrar miles de archivos**.

> Cancela, corre `git status`. Si no hiciste cambios, `git reset --hard HEAD` y luego `git lfs pull && git lfs checkout`.

**P3.** El dev server no refresca al guardar en WSL.

> `CHOKIDAR_USEPOLLING=1 npm run dev`.

**P4.** `npm audit` marca esbuild.

> Aplica el override de la sección 7 o actualiza Vite de forma controlada.

**P5.** “pointer file” en lugar de binario.

> `git lfs pull && git lfs checkout`. Si persiste, `git reset --hard HEAD` y repite.

---

## 10) Anexos (fragmentos listos para pegar)

### 10.1 Instalación monorepo (JS/TS) por subcarpetas

```bash
git ls-files | grep -E '^((apps|packages|tools)/.*/)?package\.json$' \
| sed 's#/package\.json##' \
| xargs -I{} bash -lc 'echo "→ Instalando en {}"; cd "{}" && \
    if [ -f pnpm-lock.yaml ]; then (corepack enable 2>/dev/null || true; pnpm install); \
    elif [ -f package-lock.json ]; then npm ci; \
    else npm install; fi'
```

### 10.2 Activación rápida de LFS

```bash
git lfs install && git lfs pull && git lfs checkout
```

### 10.3 Arranque directo de PreH-Nav

```bash
cd apps/preh-nav-m1 && npm run dev
# Alternativa pnpm:
# cd apps/preh-nav-m1 && pnpm dev
```

---

> Fin del README (arranque reproducible).
HASH(10): 591dfcbe8c
