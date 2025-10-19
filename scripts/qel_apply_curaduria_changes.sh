#!/usr/bin/env bash
set -euo pipefail

# ---- Config (ajústalo si usas otras rutas/nombres) ----
SEED="A37-251015"
MANUAL="docs/core/QEL_Manual_Operativo.md"
SOMBRAS="docs/core/QEL_Libro_Sombras.md"
MEM_DIR="memory"
INDICES_DIR="docs/core/indices"

mkdir -p "$MEM_DIR" "$INDICES_DIR"

ensure_file() {
  [ -f "$1" ] || { echo "No existe: $1" >&2; exit 2; }
}

# ---- 1) Normalizar SeedI en cabeceras ----
fix_seed() {
  local f="$1"
  # Quita comillas duplicadas, normaliza formatos (= o :) y fija el valor a SEED
  # Soporta líneas tipo: SeedI: "Axx-yyy" | SeedI="Axx-yyy" | SeedI: ""Axx-yyy""
  perl -0777 -i -pe '
    s/^\s*SeedI\s*[:=]\s*""?A\d{2}-\d{6}""?\s*$/SeedI: "'$SEED'"/m;
    s/^\s*SeedI\s*[:=]\s*"?(A\d{2}-\d{6})"?\s*$/SeedI: "'$SEED'"/m;
  ' "$f"
}

# ---- 2) Normalizar encabezados del Manual (anchors canónicos) ----
#   "## Capítulo 3 ..." -> "## 3. ..." ; también "### 1) ..." -> "### 1. ..."
normalize_manual_heads() {
  local f="$1"
  # Prefijos "Capítulo|Capitulo <n>" -> "<n>. "
  perl -0777 -i -pe 's/^(##+)\s+Cap[ií]tulo\s+([0-9]+)[\.\):-]?\s*/$1 $2. /mg' "$f"
  # Subniveles "### 1) Título" -> "### 1. Título"
  perl -0777 -i -pe 's/^(###+)\s+([0-9]+)\)\s+/$1 $2. /mg' "$f"
}

# ---- 3) Extraer bloque histórico duplicado del Manual (si existe) ----
#   Corta desde la 2ª cabecera "cue:" o "[QEL::ECO" hasta el final, lo guarda en memory/ y lo quita del Manual
split_historic_block() {
  local src="$1" out="$2"
  # Detecta índice de la 2ª coincidencia
  local idx
  idx="$(awk '
    BEGIN{c=0}
    /^[[:space:]]*cue:[[:space:]]*\"?\[QEL::ECO/ || /^\[QEL::ECO/ {c++; if(c==2){print NR; exit}}
  ' "$src" || true)"
  [ -n "${idx:-}" ] || { echo "[i] No se detectó segundo bloque histórico en $src"; return 0; }

  echo "[i] Bloque histórico detectado a partir de línea $idx en $src"
  # Parte histórica -> out ; documento principal -> queda sin la parte histórica
  awk -v start="$idx" 'NR>=start{print > "'"$out"'"; next} {print > "'"$src"'.tmp"}' "$src"
  mv "$src.tmp" "$src"
}

# ---- 4) Actualizar referencias de versiones en Libro de Sombras ----
patch_refs_libro() {
  local f="$1"
  # Ejemplos comunes de mención de versiones
  perl -0777 -i -pe '
    s/\bMFH\s+v1\.0\b/MFH v1.4/g;
    s/\bGlosario\s+v1\.0\b/Glosario v1.4/g;
  ' "$f"
}

# ---- 5) Crear índices (si no existen) con front-matter correcto ----
emit_indices() {
  # Semillas
  local f1="$INDICES_DIR/QEL_Index_Semillas_v1.0.md"
  if [ ! -f "$f1" ]; then
    cat > "$f1" <<'MD'
cue: "[QEL::ECO[96]::RECALL A96-251015-INDEX-SEMILLAS]"
SeedI: "A37-251015"
SoT: "INDICES/SEMILLAS/v1.0"
Version: "v1.0"
Updated: "2025-10-15"

# Índice de Semillas (Capa ESTE → NORTE)

| semilla (slug)       | definición breve                             | SoT destino | enlace canónico |
|----------------------|----------------------------------------------|-------------|-----------------|
| »ficha-v-riesgo      | checklist mínima para gates y señales 9      | VF          | /docs/core/QEL_Libro_Sombras.md#sec-4-plantillas-de-riesgo |
| »senales-9           | indicadores somáticos/atencionales (≥5/9)    | Glosario    | /docs/core/QEL_Manual_Operativo.md#sec-3-lamina-v         |
| »deltac-deltas       | variaciones de claridad/silencio             | Glosario    | /docs/core/QEL_Manual_Operativo.md#sec-3-lamina-v         |
| »h_k-clases          | tipología de dificultad (básica→obsidiana)   | Glosario    | /docs/core/QEL_Manual_Operativo.md#sec-3-lamina-v         |
| »gates-g1-g4         | niveles de excepción/contención              | Glosario    | /docs/core/QEL_Libro_Sombras.md#sec-2-cue-aurora          |
| »thon                | pulso de inicio/cierre                       | Glosario    | /docs/core/QEL_Manual_Operativo.md#sec-0-alcance-y-reglas-de-oro |
| »9-0-9               | compás respiratorio                          | Glosario    | /docs/core/QEL_Manual_Operativo.md#sec-0-alcance-y-reglas-de-oro |
| »3-5-3               | pauta de legibilidad corporal                | Glosario    | /docs/core/QEL_Manual_Operativo.md#sec-0-alcance-y-reglas-de-oro |
| »wrapper-promocion   | script para ListadoR/Manifest                | Atlas       | /scripts/wrappers/qel_promote_wrapper.sh                   |
| »indice-semillas-vf  | índice maestro de semillas (formulario)      | VF          | /docs/core/indices/QEL_Index_Semillas_v1.0.md             |
| »rutas-internas      | breadcrumbs Manual + Sombras                 | Atlas       | /docs/core/indices/QEL_Index_Rutas_v1.0.md                |
MD
    echo "[ok] Creado $f1"
  else
    echo "[i] Ya existe $f1 (no se sobrescribe)"
  fi

  # Rutas
  local f2="$INDICES_DIR/QEL_Index_Rutas_v1.0.md"
  if [ ! -f "$f2" ]; then
    cat > "$f2" <<'MD'
cue: "[QEL::ECO[96]::RECALL A96-251015-INDEX-RUTAS]"
SeedI: "A37-251015"
SoT: "INDICES/RUTAS/v1.0"
Version: "v1.0"
Updated: "2025-10-15"

# Índice de Rutas Internas

- R1: 0→3→5 (Reglas→Lámina 𝒱→Gobernanza)
  - [/docs/core/QEL_Manual_Operativo.md#sec-0-alcance-y-reglas-de-oro]
  - [/docs/core/QEL_Manual_Operativo.md#sec-3-lamina-v]
  - [/docs/core/QEL_Manual_Operativo.md#sec-5-gobernanza]
- R2: 2→4→5 (Idriell→SoT/Atlas→Gobernanza)
  - [/docs/core/QEL_Manual_Operativo.md#sec-2-lengua-idriell]
  - [/docs/core/QEL_Manual_Operativo.md#sec-4-sot-atlas]
  - [/docs/core/QEL_Manual_Operativo.md#sec-5-gobernanza]
- R3: 3→ApdxA→ApdxB (Lámina 𝒱→VF→Capa SUR)
  - [/docs/core/QEL_Manual_Operativo.md#sec-3-lamina-v]
  - [/docs/core/QEL_Manual_Operativo.md#apdx-a-formato-vf-arbol]
  - [/docs/core/QEL_Manual_Operativo.md#apdx-b-capa-sur-micro-ritmo]

- S1: 1→2→4 (Tratado→CUE/Aurora→Plantillas)
  - [/docs/core/QEL_Libro_Sombras.md#sec-1-tratado-metahumano]
  - [/docs/core/QEL_Libro_Sombras.md#sec-2-cue-aurora]
  - [/docs/core/QEL_Libro_Sombras.md#sec-4-plantillas-de-riesgo]
- S2: 3→2→cierre (Casuística→CUE/Aurora→SIL→UM→Ə)
  - [/docs/core/QEL_Libro_Sombras.md#sec-3-casuistica]
  - [/docs/core/QEL_Libro_Sombras.md#sec-2-cue-aurora]
  - [/docs/core/QEL_Libro_Sombras.md#sec-4-plantillas-de-riesgo]
MD
    echo "[ok] Creado $f2"
  else
    echo "[i] Ya existe $f2 (no se sobrescribe)"
  fi
}

# ---- 6) Lint de anchors (verifica que existan en los destinos) ----
check_anchors() {
  local index_file="$1"
  echo "[lint] Checando anchors en $index_file"
  # Extrae /ruta#anchor de líneas con [/docs...#anchor]
  awk '
    match($0, /\[\/docs\/[^#\]]*#[^)\]]+\]/) {
      s=substr($0,RSTART+1,RLENGTH-2);
      print s
    }
  ' "$index_file" | while IFS="#" read -r path anchor; do
      anchor="${anchor%%]*}" # limpia ] si quedara
      [ -f ".$path" ] || { echo "  ✗ Falta archivo: .$path"; continue; }
      if grep -q "$anchor" ".$path"; then
        echo "  ✓ $path#$anchor"
      else
        echo "  ✗ Anchor no encontrado en $path -> $anchor"
      fi
  done
}

# ------------------ EJECUCIÓN ------------------
ensure_file "$MANUAL"
ensure_file "$SOMBRAS"

echo "[1/6] Normalizando SeedI…"
fix_seed "$MANUAL"
fix_seed "$SOMBRAS"

echo "[2/6] Normalizando encabezados del Manual…"
normalize_manual_heads "$MANUAL"

echo "[3/6] Extrayendo bloque histórico (si aplica)…"
HIST_OUT="$MEM_DIR/QEL_Manual_Operativo_historico.md"
split_historic_block "$MANUAL" "$HIST_OUT"

echo "[4/6] Parcheando referencias en Libro de Sombras…"
patch_refs_libro "$SOMBRAS"

echo "[5/6] Emite índices (si no existen)…"
emit_indices

echo "[6/6] Lint de anchors…"
check_anchors "$INDICES_DIR/QEL_Index_Rutas_v1.0.md"
check_anchors "$INDICES_DIR/QEL_Index_Semillas_v1.0.md"

echo "[ok] Curaduría aplicada. Revisa diffs y promueve cuando estés conforme."
