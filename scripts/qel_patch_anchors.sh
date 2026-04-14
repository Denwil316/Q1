#!/usr/bin/env bash
set -euo pipefail

M="docs/core/QEL_Manual_Operativo.md"
S="docs/core/QEL_Libro_Sombras.md"

backup_once() {
  local f="$1"
  [ -f "${f}.bak" ] || cp -f "$f" "${f}.bak"
}

insert_alias_above() { # file, anchor_id, sed_regex_for_heading
  local f="$1" a="$2" re="$3"
  # si ya existe el alias, no hacemos nada
  if grep -q "id=\"$a\"" "$f"; then
    echo "[=] $f :: $a ya existe"
    return 0
  fi
  # inserta <a id="..."></a> en la línea ANTERIOR a la cabecera encontrada
  # BSD sed (macOS) compatible: -E y -i ''
  /usr/bin/sed -E -i '' "/$re/ i\\
<a id=\"$a\"></a>
" "$f" || {
    echo "[!] No pude insertar alias $a en $f (regex: $re)" >&2
    return 1
  }
  echo "[+] $f :: agregado alias $a"
}

echo "[patch] Anchors — backup inicial"
backup_once "$M"
backup_once "$S"

echo "[patch] Manual Operativo — alias faltante"
# Cap. 3 Lámina 𝒱 — el índice pide 'sec-3-lamina-v' como alias corto
insert_alias_above "$M" "sec-3-lamina-v" "^###[[:space:]]*3[[:space:]]*\\)[[:space:]]*L"

echo "[patch] Libro de Sombras — anchors de capítulos"
# Capítulos H2 (##) canónicos
insert_alias_above "$S" "sec-1-tratado-metahumano"   "^##[[:space:]]*Cap[[:alpha:]]+ 1\\)"
insert_alias_above "$S" "sec-2-cue-aurora"           "^##[[:space:]]*Cap[[:alpha:]]+ 2\\)"
insert_alias_above "$S" "sec-3-casuistica"           "^##[[:space:]]*Cap[[:alpha:]]+ 3\\)"
insert_alias_above "$S" "sec-4-plantillas-de-riesgo" "^##[[:space:]]*Cap[[:alpha:]]+ 4\\)"

echo "[ok] Listo. Vuelve a correr tu linter/índices."
