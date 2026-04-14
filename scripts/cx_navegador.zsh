```zsh
# scripts/cx_navegador.zsh
# PREH · Navegador Codex v0.2 — funciones de conveniencia

# --- util ---
_cx_has() { command -v "$1" >/dev/null 2>&1; }

# --- 1) Árbol en ESTRUCTURA.md ---
cx.tree() {
  local DEPTH="${1:-4}"
  if ! _cx_has tree; then
    echo "Instala 'tree' (macOS: brew install tree | Debian/Ubuntu: sudo apt-get install tree)"
    return 1
  fi
  local TS="$(date '+%Y-%m-%d %H:%M:%S')"
  {
    echo "# Estructura de Codex ($PWD)"
    echo
    echo "_Generado: ${TS}_"
    echo
    echo '```text'
    tree -a -L "$DEPTH" --dirsfirst \
      -I '.git|node_modules|dist|build|.DS_Store|__pycache__|.venv|venv|.idea|.vscode|*.zip|*.tar.gz|*.log|*.tmp|*.pdf|*.docx|*.png|*.jpg|*.jpeg|*.svg|*.mp4'
    echo '```'
  } > ESTRUCTURA.md
  echo "ESCRITO → ESTRUCTURA.md (profundidad $DEPTH)"
}

# --- 2) Búsqueda inteligente ---
cx.find() {
  local Q="$1"; shift || true
  if _cx_has rg; then
    rg -n --hidden --glob '!.git' "$Q" "$@"
  else
    grep -Rni --exclude-dir='.git' --exclude-dir='node_modules' --exclude='*.log' "$Q" .
  fi
}

# --- 3) Último modificado (abre con $EDITOR) ---
cx.last() {
  local F
  F="$(ls -t **/*(.N) 2>/dev/null | head -n 1)"
  [[ -n "$F" ]] && "${EDITOR:-nano}" "$F" || echo "No hallé archivos."
}
```