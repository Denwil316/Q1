# **Manual Extensivo — Atlas Micro-Registro (scripts/qel\_atlas\_microreg.sh)**

Estado: CRISTALIZADO · Audiencia: operativa · Lenguaje: es-MX  
Compatibilidad: macOS (Bash 3+), sin dependencias GNU-only.  
Estilo: claro, directo, sin paja. Here-docs listos para pegar.  
---

## **1\) Contexto y alcance**

El micro-registro de Atlas es un evento mínimo en JSONL que documenta hitos del sistema QEL: promociones, generación de PE, cristalizaciones de habilidades, cierres rituales, erratas y notas operativas.

Propósitos clave:

* Trazabilidad: quién/qué/cuándo/cómo (archivo, HASH(10), cue, SoT, versión).  
* Auditoría (No-Mentira): cotejar Habilidades ↔ PE ↔ VF con su fuente.  
* Automatización: permitir a preh-nav & scripts graficar y filtrar la historia del Atlas sin parsear Markdown.

Archivo de salida por defecto: docs/core/atlas\_microreg\_v1.0.jsonl (una línea JSON por evento).

---

## **2\) Requisitos y entorno**

* macOS con Bash 3+.  
* shasum o openssl (el script incluye fallback).  
* Opcional para escape JSON robusto: python3 (o python), o jq. El script trae fallback en bash si no hay ninguno.

Sugerido: variables en .qelrc:  
export QEL\_REGISTRY="docs/core/QEL\_SoT\_Manifest\_v0.8.json"  
export QEL\_LISTADOR="docs/core/QEL\_ListadoR\_master\_v1.0.md"  
export QEL\_DIARIO="docs/core/QEL\_Diario\_del\_Conjurador\_v1.5.md"  
export QEL\_PRENAV\_DOCS="apps/preh-nav-m1/public/docs"  
export QEL\_PRENAV\_MANIFEST="apps/preh-nav-m1/public/sot-manifest.json"  
export QEL\_NUTRIA\_DIR="docs/nutria"  
export QEL\_DEFAULT\_RUMBO="C"  
export QEL\_DEFAULT\_TAU="0.62"

* export LC\_ALL="C"

## **3\) Instalación / Setup**

Asegura permisos:

 `chmod +x scripts/qel_atlas_microreg.sh`

1.   
2. Verifica directorios de autoridad y espejo:

   * Autoridad: `docs/core/*`

   * Espejo (preh-nav): `apps/preh-nav-m1/public/docs` y `apps/preh-nav-m1/public/sot-manifest.json`

3. (Opcional) Añade hooks a tus otros scripts:

   * En `qel_promote_mac.sh`: llamar a `qel_atlas_microreg.sh --kind PROMO ...`

   * En `qel_pe_generate.mjs`: llamar a `qel_atlas_microreg.sh --kind PE_GEN` y `--kind HAB_CRYSTAL` si mintas.

---

## **4\) Flags y parámetros**

### **Tabla breve**

| Flag | Tipo | Descripción | Ejemplo |
| ----- | ----- | ----- | ----- |
| `--kind` | req | Tipo de evento: `PROMO`, `PE_GEN`, `HAB_CRYSTAL`, `RITUAL`, `ERRATA`, `NOTE` | `--kind PROMO` |
| `--file` | req | Ruta del archivo implicado | `--file docs/core/manuales/QEL_LLPE_...md` |
| `--title`/`--titulo` | opc | Título legible del evento | `--title "LL-PE v1.4 (Germinación)"` |
| `--hash10` | opc | HASH(10) del doc (si no lo pasas, se calcula) | `--hash10 c528033ebb` |
| `--rumbo` | opc | Rumbo VF (`C`,`N`,`S`,`O/W`,`E/O`) | `--rumbo C` |
| `--triada` | opc | Tríada fonémica | `--triada "Ə·UM·A"` |
| `--obj` | opc | Objeto QEL | `--obj Llave` |
| `--clase` | opc | Clase (`comun`,`raro`,`singular`,`unico`) | `--clase raro` |
| `--materia` | opc | Materia (p.ej. `aire`,`fuego`,`agua`,`tierra`,`éter`) | `--materia aire` |
| `--V` | opc | Viabilidad (0..1) | `--V 0.77` |
| `--tau`/`--τ` | opc | Umbral Idriell | `--tau 0.62` |
| `--gates` | opc | Gates activos separados por coma | `--gates "no_mentira,doble_testigo"` |
| `--microreg` | opc | Archivo JSONL destino | `--microreg docs/core/atlas_microreg_v1.0.jsonl` |

### **Detalle `--kind` (semántica práctica)**

* **PROMO**: promoción de manual/sello/carta (impacta autoridad \+ espejo).

* **PE\_GEN**: generación de **Poema-Enigma** (con o sin cristalizar).

* **HAB\_CRYSTAL**: habilidad **mintada** (incluye ruta en Árbol).

* **RITUAL**: acto de cierre/apertura (anotar ΔC/ΔS/ρ si aplica).

* **ERRATA**: corrección/retractación de un doc o habilidad.

* **NOTE**: nota operativa (no alteradora de estado).

---

## **5\) Flujos de uso (paso a paso)**

### **A) Tras promover un documento (manual/sello)**

`scripts/qel_atlas_microreg.sh \`  
  `--kind PROMO \`  
  `--file "docs/core/manuales/QEL_LLPE_Manual_v1.4.md" \`  
  `--title "LL-PE — Manual Operativo v1.4 (Germinación)" \`  
  `--gates "no_mentira,doble_testigo"`

### **B) Después de generar un PE (aunque no cristalice)**

`scripts/qel_atlas_microreg.sh \`  
  `--kind PE_GEN \`  
  `--file "docs/pe/PE_0198772adb.md" \`  
  `--title "PE::0198772adb (Kosmos-8, Apertura)" \`  
  `--triada "Ə·UM·A" --obj "Llave" --rumbo "C" --materia "aire"`

### **C) Al cristalizar una habilidad (mint)**

`scripts/qel_atlas_microreg.sh \`  
  `--kind HAB_CRYSTAL \`  
  `--file "docs/habilidades/Ə-UM-A/Llave/C/raro/0198772adb.md" \`  
  `--title "Llave de Matrices (Apertura I)" \`  
  `--hash10 "0198772adb" \`  
  `--triada "Ə·UM·A" --obj "Llave" --rumbo "C" --clase "raro" --materia "aire" \`  
  `--V "0.77" --tau "0.62" \`  
  `--gates "no_mentira,doble_testigo,mediacion_luminosa"`

### **D) RITUAL (cierre/apertura)**

`scripts/qel_atlas_microreg.sh \`  
  `--kind RITUAL \`  
  `--file "docs/ritual/QEL_MicroSello_A96-250829_LAB-TECNOALQ_Cristal_v1.0.md" \`  
  `--title "Micro-Sello 2025-08-29 · LAB Tecnoalquímico" \`  
  `--gates "doble_testigo" --rumbo "C"`

---

## **6\) Ejemplos completos**

### **6.1 PROMO del manual LL-PE v1.4 \+ micro-registro**

`scripts/qel_promote_mac.sh \`  
  `--rubro "LL-PE" \`  
  `--file "docs/core/manuales/QEL_LLPE_Manual_v1.4.md" \`  
  `--titulo "LL-PE — Manual Operativo v1.4 (Germinación)" \`  
  `--rumbo "Centro"`

`scripts/qel_atlas_microreg.sh \`  
  `--kind PROMO \`  
  `--file "docs/core/manuales/QEL_LLPE_Manual_v1.4.md" \`  
  `--title "LL-PE — Manual Operativo v1.4 (Germinación)" \`  
  `--gates "no_mentira,doble_testigo"`

`git add docs/core/atlas_microreg_v1.0.jsonl`  
`git commit -m "ATLAS: micro-reg PROMO LL-PE v1.4"`

### **6.2 PE generado \+ Habilidad cristalizada**

`# Generar PE (JSON-first) y nutrir desde docs/nutria`  
`node scripts/qel_pe_generate.mjs \`  
  `--vf docs/core/cartas/LLPE_Kosmos8_Primera_v1.3.yaml \`  
  `--materia aire --preset Apertura \`  
  `--ruido 0.00 --delta-c flat --delta-s flat \`  
  `--answer "Ə·UM·A — abre en A, sostiene en UM" \`  
  `--emit json --save \`  
  `--nutria-dir "${QEL_NUTRIA_DIR:-docs/nutria}"`

`# Registrar PE_GEN`  
`scripts/qel_atlas_microreg.sh \`  
  `--kind PE_GEN \`  
  `--file "docs/pe/PE_0198772adb.json" \`  
  `--title "PE::0198772adb (Kosmos-8, Apertura)" \`  
  `--triada "Ə·UM·A" --obj "Llave" --rumbo "C" --materia "aire"`

`# Si mintó habilidad (ejemplo)`  
`scripts/qel_atlas_microreg.sh \`  
  `--kind HAB_CRYSTAL \`  
  `--file "docs/habilidades/Ə-UM-A/Llave/C/raro/0198772adb.md" \`  
  `--title "Llave de Matrices (Apertura I)" \`  
  `--hash10 "0198772adb" \`  
  `--triada "Ə·UM·A" --obj "Llave" --rumbo "C" --clase "raro" --materia "aire" \`  
  `--V "0.77" --tau "0.62" \`  
  `--gates "no_mentira,doble_testigo,mediacion_luminosa"`

`git add docs/core/atlas_microreg_v1.0.jsonl`  
`git commit -m "ATLAS: micro-reg PE_GEN + HAB_CRYSTAL Kosmos-8"`

---

## **7\) Integración con otras herramientas**

* **`qel_promote_mac.sh`**: añadir llamada a `qel_atlas_microreg.sh --kind PROMO` al final (tras ListadoR/Diario/espejo).

* **`qel_pe_generate.mjs`**: tras escribir PE/Habilidad \+ catálogos, llamar `--kind PE_GEN` y `--kind HAB_CRYSTAL` si mintas.

* **preh-nav**: puede consumir `atlas_microreg_v1.0.jsonl` para **timeline** (no depende de Markdown); o bien seguir leyendo el Manifest autoridad.

---

## **8\) Buenas prácticas**

* **JSON-first** para consumo en UI/TUI (preh-nav).

* **Una línea \= un evento** (JSONL); facilita `grep` y validaciones.

* **HASH(10)** siempre que exista; si no, se calcula a partir de cabecera.

* **No-Mentira**: conserva la línea de **CUE** entre corchetes en los docs fuente.

* **Compat macOS**: `LC_ALL=C`; `sed -i ''`; `openssl` si falta `shasum`.

* **Autoridad** en `docs/core/*` y **espejo** en `apps/preh-nav-m1/public/*`.

---

## **9\) Solución de problemas (FAQ)**

**Error:** `syntax error near unexpected token json.dumps`  
 **Causa:** función `json_escape` con here-doc mal ordenado.  
 **Fix:** usa la variante `python3 - "$s" <<'PY'` (parche aplicado en tu repo).

**No existe el archivo**  
 Verifica la ruta real: `docs/core/manuales/...` (en tu repo es “manuales”).

**No aparece en preh-nav**  
 preh-nav no lee JSONL por defecto; o bien lo integras, o te quedas con manifest espejo.

**Quiero validar el JSONL**

`jq -c . docs/core/atlas_microreg_v1.0.jsonl >/dev/null && echo OK`

---

## **10\) Anexos**

### **10.1 Esquema lógico (campos por evento)**

`ts (ISO8601Z), kind, title, file, hash10,`  
`cue, seed, sot, version, updated,`  
`vf: { triada, obj, rumbo, clase, materia },`  
`metrics: { V, tau },`  
`gates (string coma-separada)`

### **10.2 Snippet de escape JSON robusto (referencia)**

`# json_escape() — fallback: python3 > python > jq > bash`  
`json_escape(){`  
  `local s="${1-}"`  
  `if command -v python3 >/dev/null 2>&1; then`  
    `python3 - "$s" <<'PY'`  
`import sys, json`  
`print(json.dumps(sys.argv[1])[1:-1])`  
`PY`  
  `elif command -v python >/dev/null 2>&1; then`  
    `python - "$s" <<'PY'`  
`import sys, json`  
`print(json.dumps(sys.argv[1])[1:-1])`  
`PY`  
  `elif command -v jq >/dev/null 2>&1; then`  
    `printf '%s' "$s" | jq -Rr @json | sed 's/^"//; s/"$//'`  
  `else`  
    `s=${s//\\/\\\\}; s=${s//\"/\\\"}`  
    `s=${s//$'\n'/\\n}; s=${s//$'\r'/}; s=${s//$'\t'/\\t}`  
    `printf '%s' "$s"`  
  `fi`  
`}`  
HASH(10): 714d48bbaf
