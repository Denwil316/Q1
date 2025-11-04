SoT=CORE/MANUAL
# **LL-PE v1.4 — Manual Operativo (Germinación)**

cue: `[QEL::ECO[96]::RECALL A96-250829-LLPE-v1-4]`  
 SeedI: `A96-250824`  
 SoT: `LL-PE/v1.4`  
 Version: `v1.4 (Germinación)`  
 Updated: `2025-08-29`

## **1\) Contexto y alcance**

La **Lógica Lingüística del Poema-Enigma (LL-PE)** genera, desde un **Verso Fundador (VF)** y su ficha 𝒱 (Lámina V), un **Poema-Enigma (PE)** determinista que la **Sombra** debe resolver. La respuesta se valida con gates (**No-Mentira, Doble Testigo, Aurora, Excepción**), y métricas **ΔC, ΔS, ρ, χ\_r, H\_k**; si **𝒱≥τ**, se **cristaliza** una **Habilidad** y se registra en el **Árbol de Habilidades**, **Manifest v0.8** y **Listado R**.  
 **Novedades v1.4**:

1. **Nutrición de texto**: el motor puede “beber” de directorios con .md/.txt/.yaml/.json para enriquecer INVOCACIÓN/UMBRAL/PISTA/PRUEBA.

2. **Φ\_adv (fortalezas/debilidades)** triádicas: micro-ajuste (+/−) coherente con MFH y Materia.

3. **`qel ah add`**: alta de habilidades en Árbol \+ actualización de Manifest/Listado R, con metadatos QEL.

---

## **2\) Requisitos y entorno**

* **Invariantes Idriell**: No-Mentira, Doble Testigo, VOH/EÍA cuando aplique, cierre **SIL→UM→Ə**.

* **Lámina 𝒱** activa: `𝒱 = A·χ_r·H_k·Π_gates·F(ΔC,ΔS)·(1−ρ)`; **τ base \= 0.62**.

* **MFH v1.4**: rúbricas de afinidad (canónica/directa/indirecta), objetos, y mapeo **fonema↔acto**.

* **Tratado Metahumano**: criterios de seguridad, contacto **Aurora** y **CUE-EXCEPTION**.

* **Herramientas**: `scripts/qel vcalc`, `scripts/qel_pe_generate.mjs`, **nuevo** `scripts/qel_ah_add.sh`.

* **FS**: Diario abierto; Atlas (Tarjetas v2.4) cargadas.

---

## **3\) Instalación/Setup**

### **3.1 Estructura de carpetas sugerida**

`codex/`  
`├─ scripts/`  
`│  ├─ qel_vcalc.sh`  
`│  ├─ qel_pe_generate.mjs`  
`│  └─ qel_ah_add.sh              # NUEVO`  
`├─ docs/`  
`│  ├─ core/`  
`│  │  ├─ QEL_Lamina_V_Detallada_v1.1.md`  
`│  │  ├─ QEL_MFH_v1.4.md`  
`│  │  ├─ QEL_Tratado_Metahumano_v1.4.md`  
`│  │  ├─ QEL_SoT_Manifest_v0.8.json`  
`│  │  └─ QEL_ListadoR_master_v1.0.md`  
`│  ├─ atlas/`  
`│  │  └─ Tarjetas_Atlas_QEL_v2.4.md`  
`│  ├─ pe/                        # PE generados (md/json)`  
`│  ├─ habilidades/               # Habilidades cristalizadas`  
`│  └─ nutria/                    # NUEVO: textos “nutricia” (*.md *.txt *.yaml *.json)`  
`└─ docs/core/cartas/`  
   `└─ LLPE_Kosmos8_Primera_v1.3.yaml`

### **3.2 Variables y defaults (para scripts)**

* `LC_ALL=C` (fijo) — evita coma decimal.

* `NUTRIA_DIR=docs/nutria` — directorio de nutrición (opcional).

* `REGISTRY=docs/core/QEL_SoT_Manifest_v0.8.json`

* `LISTADOR=docs/core/QEL_ListadoR_master_v1.0.md`

---

## **4\) Flags y parámetros (tabla breve \+ detalle)**

| Parámetro | ¿Dónde? | Descripción | Ejemplo |
| ----- | ----- | ----- | ----- |
| `VF.PRIMA` | Carta VF | Frase ≤13 palabras | “Silencio sostiene apertura” |
| `p, w` | Carta VF | Tríada `onset·núcleo·coda` y pesos sum=1 | `Ə·UM·A` / `[.40,.35,.25]` |
| `O, r, k` | Carta VF | Objeto, Rumbo (N/O/W/S/C), Clase | `Llave, C, raro` |
| `materia` | Carta VF | Fase/medio (aire/agua/metal/orgánico/…) | `aire` |
| `gates` | Carta VF | `mediacion`, `doble`, `aurora`, `exception` | `["mediacion","doble"]` |
| `tau` | LL-PE | Umbral viabilidad | `0.62` |
| `Φ_adv` | LL-PE | Micropeso triádico por pares fonémicos | ver §8 |
| `--nutria-dir` | qel\_pe\_generate | Dir de textos nutricia | `docs/nutria` |
| `--save` | qel\_pe\_generate | Escribe PE/HAB y registra | `--save` |
| `qel ah add` | nuevo script | Alta en Árbol \+ Manifest \+ Listado R | ver §9 |

**Detalle clave:**

* **A (afinidad)** se estima automático con **materia** y rúbrica MFH (canónica≈0.95, directa≈0.80, indirecta≈0.60), ponderada por `w` y micro-ajustada por **Φ\_adv** (cap ±0.05). Puedes **override** con `--afinidad` en `vcalc`.

* **Aurora** aplica ×0.95 (gate) si hay **contacto**.

* **EXCEPTION** eleva τ (p.ej., 0.68) y exige tutor/condiciones G1..G4.

---

## **5\) Flujos de uso (paso a paso)**

### **Flujo A — Generar PE y cristalizar (Kosmos-8)**

1. **Preparar Carta** (p, w, O, r, k, materia, gates).

**Generar PE** (determinista, con nutrición si existe):

 `node scripts/qel_pe_generate.mjs \`  
  `--vf docs/core/cartas/LLPE_Kosmos8_Primera_v1.3.yaml \`  
  `--materia aire --preset Apertura \`  
  `--ruido 0.00 --delta-c flat --delta-s flat \`  
  `--nutria-dir docs/nutria \`  
  `--emit md --save`

2.   
3. **Responder** el PE (Sombra). El generador valida (mask/calc), calcula **𝒱** (y muestra `V` vs `τ`).

4. Si **𝒱≥τ** y **ΔC≥0** y gates OK ⇒ **Habilidad** mintada, **registrada** (Árbol/Manifest/Listado R).

5. **Cierre**: SIL→UM→Ə \+ Doble Testigo \+ ECO delta-only.

### **Flujo B — Registrar una Habilidad ya calculada (con `qel ah add`)**

Si ya tienes un resultado/JSON, o quieres alta manual:

`scripts/qel_ah_add.sh \`  
  `--vf-cue "QEL|A96|VF|KOSMOS-8|v1.0|Centro — Poeta del Intersticio" \`  
  `--triada "Ə·UM·A" --obj "Llave" --rumbo "C" --clase "raro" \`  
  `--hash10 "0198772adb" --habilidad-id "HAB::K8-LL-APERT-019877" \`  
  `--nombre "Llave de Matrices (Apertura I)" \`  
  `--pe-id "PE::0198772adb" --V "0.77" --tau "0.62" \`  
  `--materia "aire" --efecto "abrir_sello:1,ΔC:+,ρ≤0.02" \`  
  `--save`

El script crea el archivo de Habilidad (MD+metadatos), ubica la **ruta del Árbol** y actualiza **Manifest/Listado R**.

---

## **6\) Ejemplos completos**

### **6.1 Kosmos-8 Preset Apertura (materia=aire)**

* **VF**: `p=Ə·UM·A`, `w=[.40,.35,.25]`, `O=Llave`, `r=C`, `k=raro`, `materia=aire`, gates: mediación+doble.

* **A(auto)** ≈ `0.40·0.80 + 0.35·0.60 + 0.25·0.95` \= **0.77** (antes de Φ\_adv).

* **Φ\_adv**: `UM>A` (+0.02) → **0.79** (cap clip).

* **V** con χ\_r=1.00, H\_k=0.92, gates=1.00, Δ=1, ρ=0: `≈0.79*1*0.92=0.73` → **≥0.62** ⇒ cristaliza.

* **Habilidad**: *Llave de Matrices (Apertura I)*; registra Árbol `/VF/Ə-UM-A/Llave/C/raro/0198772adb`.

### **6.2 Kosmos-8 Preset Puente (materia=orgánico)**

* **VF**: `p=Ə·UM·SIL`…; **A(auto)** por orgánico: `Ə 0.60, UM 0.80, SIL 0.95` → **0.79**.

* **Φ\_adv**: `KA>SIL` no aplica; `SIL>KA` tampoco en esta triada → 0.79.

* **V** ≈ 0.79\*0.92 \= 0.73 ⇒ cristaliza.

* **Habilidad**: *Tejido de Umbral (Nexo I)*.

---

## **7\) Integración con otras herramientas**

* **VCALC** (`scripts/qel_vcalc.sh`): fuente de la 𝒱 “oficial” (el usuario puede corroborar manualmente con Lámina).

* **PE-Generator** (`scripts/qel_pe_generate.mjs`): crea PE, valida, calcula V, “mintea” Habilidad, **opcional** guarda y registra.

[QEL::ECO[96]::RECALL A96-251018-LLPE-PLANTILLAS-V1-4]
SeedI: "A96-251018"
SoT: "LL-PE/MANUAL-PLANTILLAS/v1.4"
Version: "v1.4"
Updated: "2025-10-18"

# LL‑PE v1.4 — Manual Operativo (Germinación) · **Plantillas VF (YAML/JSON)**

> Este anexo amplía el **Manual LL‑PE v1.4** con plantillas **YAML** y **JSON** para las **Cartas VF** que consumen los scripts `qel_pe_generate.mjs` y familia. Está escrito en estilo *human‑readable*, con ejemplos listos para copiar/pegar, validaciones y errores comunes.

---

## 0) Mapa rápido (qué campo es qué)
- **cue**: cadena completa del CUE (opcional pero recomendado).
- **SeedI/Seed**: semilla (opcional); si falta, el script deriva desde el contexto.
- **VF.PRIMA / prima**: verso fundador (≤13 palabras).
- **p / triada**: fonemas `onset·núcleo·coda` (p. ej. `Ə·UM·A`).
- **w / pesos**: pesos triádicos (3 valores, suman ≈1.00), p. ej. `[0.40,0.35,0.25]`.
- **objeto (O)**: objeto resonante (p. ej. `Llave`, `Prisma`).
- **rumbo (r)**: `N|O|W|S|C` (Norte, Oriente, Occidente, Sur, Centro).
- **clase (k)**: `basica|poco-comun|rara|metalica|obsidiana` (tolerancias MFH).
- **materia**: medio/fase principal (p. ej. `aire`, `agua`, `metal`, `orgánico`).
- **gates**: lista de salvaguardas (`mediacion`, `doble`, `aurora`, `exception`).

> **Nota:** Los nombres de campos admiten alias; ver cada plantilla. El generador acepta YAML *o* JSON indistintamente.

---

## 1) Plantilla **YAML** mínima (recomendada)
```yaml
# VF.yaml — mínima, human‑readable
cue: "[QEL::ECO[96]::RECALL A96-YYMMDD-VF-DEMO]"
SeedI: "A96-YYMMDD"
VF.PRIMA: "Silencio sostiene apertura"
triada: "Ə·UM·A"      # alias: p
pesos:  [0.40,0.35,0.25] # alias: w (suma ≈ 1.00)
objeto: "Llave"        # alias: O
rumbo:  "C"            # N,O,W,S,C
clase:  "rara"         # basica|poco-comun|rara|metalica|obsidiana
materia: "aire"
gates: ["mediacion", "doble"]
```

### Variación (nido `vf:`)
```yaml
vf:
  cue: "[QEL::ECO[96]::RECALL A96-YYMMDD-VF-DEMO]"
  Seed: "A96-YYMMDD"      # alias de SeedI
  prima: "Silencio sostiene apertura"
  p: "Ə·UM·A"
  w: [0.40,0.35,0.25]
  O: "Llave"
  r: "C"
  k: "rara"
  materia: "aire"
  gates: [mediacion, doble]
```

---

## 2) Plantilla **JSON** mínima (equivalente)
```json
{
  "cue": "[QEL::ECO[96]::RECALL A96-YYMMDD-VF-DEMO]",
  "SeedI": "A96-YYMMDD",
  "VF.PRIMA": "Silencio sostiene apertura",
  "triada": "Ə·UM·A",
  "pesos": [0.40, 0.35, 0.25],
  "objeto": "Llave",
  "rumbo": "C",
  "clase": "rara",
  "materia": "aire",
  "gates": ["mediacion", "doble"]
}
```

### Variación con alias y nido `vf`
```json
{
  "vf": {
    "cue": "[QEL::ECO[96]::RECALL A96-YYMMDD-VF-DEMO]",
    "Seed": "A96-YYMMDD",
    "prima": "Silencio sostiene apertura",
    "p": "Ə·UM·A",
    "w": [0.40, 0.35, 0.25],
    "O": "Llave",
    "r": "C",
    "k": "rara",
    "materia": "aire",
    "gates": ["mediacion", "doble"]
  }
}
```

---

## 3) Ejemplo **completo** (con comentarios y campos extra)
```yaml
# VF_Kosmos8_Apertura.yaml
cue: "[QEL::ECO[96]::RECALL A96-251018-VF-KOSMOS-8]"
SeedI: "A96-251018"
VF.PRIMA: "Desde el Silencio, soplo el puente y recuerdo mi sol"  # ≤13 palabras
triada: "Ə·UM·A"     # onset·núcleo·coda
pesos:  [0.40,0.35,0.25]
objeto: "Llave"
rumbo:  "C"
clase:  "rara"
materia: "aire"       # → afinidad de materia que usa el generador
# opcional: gates puede ser lista *o* mapa booleado
#gates: [mediacion, doble]
gates:
  mediacion: true
  doble: true
  aurora: false
  exception: false
# campos informativos (no obligatorios; ignorados por el builder si no aplican)
notas: "Preset Apertura; apto para Árbol /Llave/C/rara"
```

```json
{
  "cue": "[QEL::ECO[96]::RECALL A96-251018-VF-KOSMOS-8]",
  "SeedI": "A96-251018",
  "VF.PRIMA": "Desde el Silencio, soplo el puente y recuerdo mi sol",
  "triada": "Ə·UM·A",
  "pesos": [0.40, 0.35, 0.25],
  "objeto": "Llave",
  "rumbo": "C",
  "clase": "rara",
  "materia": "aire",
  "gates": { "mediacion": true, "doble": true, "aurora": false, "exception": false },
  "notas": "Preset Apertura; apto para Árbol /Llave/C/rara"
}
```

---

## 4) Cómo usar las plantillas con `qel_pe_generate.mjs`

### 4.1 Generar **Poema‑Enigma** (MD, con VCALC + HABILIDAD)
```bash
node scripts/qel_pe_generate.mjs \
  --vf docs/core/cartas/VF_Kosmos8_Apertura.yaml \
  --materia aire \
  --preset Apertura \
  --ruido 0.00 --delta-c flat --delta-s flat \
  --nutria-dir docs/nutria \
  --emit md --save
```
> Produce `docs/pe/PExxxxxxxxxx.md` **con** bloques `VCALC` y `HABILIDAD CRISTALIZADA` y, si `--save`, también un archivo de habilidad en `docs/habilidades/<triada>/<obj>/<r>/<k>/<hash10>.md`.

### 4.2 Variantes y utilidades
- **Entrada JSON**: `--vf docs/core/cartas/VF_Kosmos8_Apertura.json` (mismo contenido que YAML).
- **Sin nutrición**: omite `--nutria-dir`.
- **Reparchado** de un PE existente (añadir VCALC/HAB a un MD específico):
```bash
node scripts/qel_pe_generate.mjs \
  --vf docs/core/cartas/VF_Kosmos8_Apertura.yaml \
  --materia aire --emit md \
  --patch-file docs/pe/PEe2c82e10e1.md
```
- **Búsqueda por HASH** del PE (si solo tienes el hash10 en mano):
```bash
node scripts/qel_pe_generate.mjs \
  --vf docs/core/cartas/VF_Kosmos8_Apertura.yaml \
  --emit md --patch-hash 0198772adb
```

---

## 5) Validaciones y errores comunes (y cómo resolverlos)

- **Pesos no suman ~1.00** → el generador normaliza a `[0.40,0.35,0.25]`. Revisa `pesos`/`w`.
- **Rumbo inválido** (`rumbo: Centro` en lugar de `C`) → usa código **N/O/W/S/C**.
- **Clase fuera de catálogo** → usa `basica|poco-comun|rara|metalica|obsidiana`.
- **`gates` mal formateado** → pon una lista (`[mediacion, doble]`) o un mapa booleado.
- **`VF.PRIMA` >13 palabras** → ajusta (el Árbol y las tarjetas esperan ≤13).
- **Sin `cue`/`SeedI`** → no es crítico; la semilla se deriva; incluye `cue` para mejor trazabilidad.
- **Materia no reconocida** → el generador la mapea por *afinidad de materia*; usa etiquetas básicas (`aire`, `agua`, `metal`, `orgánico`…).

> **Reglas Idriell** siempre activas: **No‑Mentira**, **Doble Testigo**, cierre **SIL→UM→Ə**.

---

## 6) Checklist antes de correr
- [ ] `VF.PRIMA` ≤13 palabras y triada correcta `onset·núcleo·coda`.
- [ ] `pesos` con 3 valores (suman ~1.00).
- [ ] `objeto`, `rumbo (N/O/W/S/C)`, `clase` y `materia` asignados.
- [ ] `gates` definidos (mínimo `mediacion` + `doble`).
- [ ] Directorios: `docs/pe`, `docs/habilidades`, `docs/core/cartas`, `docs/nutria`.

---

## 7) Apéndice — **Esquema** (informal)

### 7.1 YAML/JSON Schema (informal)
```yaml
# Campos y alias admitidos por LL‑PE (v1.4)
# (⋆) opcional — el builder funciona sin ellos
(
  cue: string⋆,
  SeedI|Seed: string⋆,
  VF.PRIMA|prima: string,           # ≤13 palabras
  p|triada: string,                 # "X·Y·Z"
  w|pesos: [number,number,number],  # suma ≈ 1.00
  O|objeto: string,
  r|rumbo: "N|O|W|S|C",
  k|clase: "basica|poco-comun|rara|metalica|obsidiana",
  materia: string⋆,
  gates: [string…] | {string:boolean}⋆,
  vf: { …campos anteriores… }⋆,
  notas: any⋆
)
```

### 7.2 Campos derivados por el generador (no declararlos manualmente)
- `pe.id` (prefijo `PE::hash10`), `vf.A_auto` (afinidad), `VCALC` (bloque), `HABILIDAD` (bloque), rutas de guardado y línea para ListadoR cuando `--save`.

---

## 8) Ejemplos listos (copiar/pegar)

### 8.1 Apertura (Llave/C/rara)
```yaml
cue: "[QEL::ECO[96]::RECALL A96-251018-VF-APERTURA]"
SeedI: "A96-251018"
VF.PRIMA: "Desde el Silencio, soplo el puente y recuerdo mi sol"
triada: "Ə·UM·A"
pesos: [0.40,0.35,0.25]
objeto: "Llave"
rumbo: "C"
clase: "rara"
materia: "aire"
gates: [mediacion, doble]
```

### 8.2 Puente (Tejido/C/rara)
```yaml
cue: "[QEL::ECO[96]::RECALL A96-251018-VF-PUENTE]"
SeedI: "A96-251018"
VF.PRIMA: "Lo que me une habla sin herir"
triada: "Ə·UM·SIL"
pesos: [0.40,0.35,0.25]
objeto: "Tejido"
rumbo: "C"
clase: "rara"
materia: "orgánico"
gates: [mediacion, doble]
```

---

## 9) Integración con registro (Árbol/Manifest/Listado R)

Con `--save`, el generador:
1) guarda **PE.md** + **Habilidad.md**
2) actualiza `docs/core/QEL_SoT_Manifest_v0.8.json` (si existe)
3) agrega línea al **Listado R** maestro.

> Para altas manuales (o revisar una habilidad existente), usa `scripts/qel_ah_add.sh` con los metadatos que imprime `qel_pe_generate.mjs`.

---

## 10) Changelog (anexo plantillas)
- v1.4 (2025‑10‑18): se agregan plantillas **YAML/JSON**, ejemplos completos, checklist, esquema informal y guía de errores; compatible con `qel_pe_generate.mjs` v1.4.



HASH(10): eb85a6c0a9

SeedI=A37-251015

Version=v1.4
Updated=2025-11-04

eb85a6c0a9
