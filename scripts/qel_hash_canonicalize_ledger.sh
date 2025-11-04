#!/usr/bin/env bash
# QEL — Canonicaliza EOF hash según ledger (ListadoR/Diario). NO recalcula.
# Política:
#   - Si ListadoR == Diario -> CANÓNICO = ese.
#   - Si sólo uno existe -> CANÓNICO = ese.
#   - Si mismatch -> no toca (a menos que se fuerce).
# Uso:
#   APPLY=0 bash scripts/qel_hash_canonicalize_ledger.sh   # dry run (default)
#   APPLY=1 bash scripts/qel_hash_canonicalize_ledger.sh   # aplica
# Opcionales:
#   ROOTS="docs memory README pub"
#   LISTADOR=docs/core/QEL_ListadoR_master_v1.0.md
#   DIARIO_DIRS="docs/core/diarios:memory/archive:pub/an"
#   FORCE_WHEN_MISMATCH=listador|diario (vacío = no aplica)

set -euo pipefail
export LC_ALL=C

ROOTS="${ROOTS:-docs:memory:README:pub}"
LISTADOR="${LISTADOR:-docs/core/QEL_ListadoR_master_v1.0.md}"
DIARIO_DIRS="${DIARIO_DIRS:-docs/core/diarios:memory/archive:pub/an}"
APPLY="${APPLY:-0}"
FORCE_WHEN_MISMATCH="${FORCE_WHEN_MISMATCH:-}"

listador_block() {
  local f="$1" bn ln s e
  [[ -f "$LISTADOR" ]] || { echo ""; return 0; }
  bn="$(basename "$f")"
  ln=$(grep -n -F "$bn" "$LISTADOR" 2>/dev/null | head -n1 | cut -d: -f1 || true)
  [[ -z "$ln" ]] && { echo ""; return 0; }
  s=$(( ln>4 ? ln-4 : 1 )); e=$(( ln+6 ))
  sed -n "${s},${e}p" "$LISTADOR"
}
listador_hash() {
  local f="$1" block h
  block="$(listador_block "$f")"
  [[ -z "$block" ]] && { echo ""; return 0; }
  h="$(printf "%s\n" "$block" | grep -Eo 'hash\(10\):[[:space:]]*([0-9a-f]{10})' | tail -n1 | awk -F': *' '{print $2}')"
  echo "$h"
}
diario_hash() {
  local f="$1" bn N=12
  IFS=': ' read -r -a DROOTS <<< "$DIARIO_DIRS"
  bn="$(basename "$f")"
  for d in "${DROOTS[@]}"; do
    [[ -d "$d" ]] || continue
    find "$d" -type f -name '*.md' -print0 2>/dev/null | while IFS= read -r -d '' m; do
      local ln s e win h
      ln="$(grep -n -F "$bn" "$m" 2>/dev/null | head -n1 | cut -d: -f1 || true)"
      [[ -z "$ln" ]] && continue
      s=$(( ln>N ? ln-N : 1 )); e=$(( ln+N ))
      win="$(sed -n "${s},${e}p" "$m" 2>/dev/null || true)"
      h="$(printf "%s\n" "$win" | grep -Eo 'hash\(10\):[[:space:]]*([0-9a-f]{10})' | tail -n1 | awk -F': *' '{print $2}')"
      [[ -n "$h" ]] && { echo "$h"; return 0; }
    done
  done
  echo ""
}

decide_canonical() {
  local hl="$1" hd="$2" out=""
  if [[ -n "$hl" && -n "$hd" ]]; then
    [[ "$hl" == "$hd" ]] && out="$hl" || out="MISMATCH"
  elif [[ -n "$hl" || -n "$hd" ]]; then
    out="${hl:-$hd}"
  else
    out=""
  fi
  echo "$out"
}

fix_one() {
  local f="$1" tailhash hl hd can tmp
  tailhash="$(tail -n1 "$f" | tr -d '\r' || true)"
  hl="$(listador_hash "$f")"
  hd="$(diario_hash "$f")"
  can="$(decide_canonical "$hl" "$hd")"

  if [[ -z "$can" ]]; then
    echo "[SKIP] $f :: sin hash en ledger (L='' D='')" >&2
    return 0
  fi
  if [[ "$can" == "MISMATCH" ]]; then
    case "$FORCE_WHEN_MISMATCH" in
      listador) can="$hl" ;;
      diario)   can="$hd" ;;
      *) echo "[HOLD] $f :: mismatch L='$hl' D='$hd' (no FORCE_WHEN_MISMATCH)" >&2; return 0 ;;
    esac
  fi

  # Si EOF ya es canónico, nada que hacer
  if [[ "$tailhash" =~ ^[0-9a-f]{10}$ && "$tailhash" == "$can" ]]; then
    echo "[OK]   $f :: EOF ya canónico ($can)"
    return 0
  fi

  # Borrar hashes en EOF y dejar sólo el canónico
  tmp="$(mktemp)"
  perl -0777 -pe 's/\r//g; s/\n(?:[0-9a-f]{10}\s*)+\z/\n/s' "$f" > "$tmp"
  if [[ "$APPLY" = "1" ]]; then
    cat "$tmp" > "$f"
    printf "%s\n" "$can" >> "$f"
    echo "[SET]  $f :: EOF <= $can"
  else
    echo "[DRY]  $f :: would set EOF <= $can"
  fi
  rm -f "$tmp"
}

IFS=': ' read -r -a roots <<< "$ROOTS"
for r in "${roots[@]}"; do
  [[ -d "$r" ]] || continue
  find "$r" -type f -name '*.md' -print0 | while IFS= read -r -d '' f; do fix_one "$f"; done
done
