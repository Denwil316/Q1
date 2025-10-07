cue: "[QEL::ECO[96]::RECALL A96-251006-ATLAS-MADRE-V2-4]"
SeedI: "A96-250824"
SoT: "ATLAS-TARJETAS/v2.4 — Rol Árbitra (UNIFICADO con Códice Madre v0.1)"
Version: "v2.4-final"
Updated: "2025-10-06"

# Códice Madre — Tarjetas Maestras v2.4 (Rol Árbitra) · **UNIFICADO**

> **Estado:** Cristalización — Sello Centro aprobado. Códice Madre v2.4 finalizado para impresión y operación hasta M3+.

---

## FS (de esta entrega)
```yaml
fecha: 251006
tema: "Tarjetas Atlas · Códice Madre UNIFICADO"
intencion: "Impresión de prueba PDF + PNG editable (Canva)"
modo: M1
rumbo: "S"
tiempo: 20
referencias: ["Lamina_V_unificada.md", "MFH v1.4", "SoT_Atlas v1.0", "QEL.md", "Glosario", "CUE_Exception", "Diario"]
testigos: {t1: A86, t2: A96}
```

---

## 0) Invariantes y reglas de oro

> **Presentación visual de la fórmula 𝒱** (cambio estético; sin alterar el cómputo)

```text
⟦ 𝒱 ⟧ = clamp₀¹( A · χ_r · H_k · Π_gates )   ⟂  “canónica”
          × clamp₀¹( (1 + ΔC + ΔS) · (1 − ρ) )  ⟂  “operativa”

Umbral τ = 0.62   ·   Condición: ΔC ≥ 0   ·   Principio: No‑Mentira
```
**Leyenda (mapeo a scripts)**  
A (afinidad triada·materia) · χ_r (rumbo) · H_k (clase) · Π_gates (mediacion/doble/aurora) · ΔC/ΔS (fdelta) · ρ (fruido).

- **Fórmula** 𝒱(p,O,r,k)=clip₀¹(⟨b_p,m_O⟩·χ_r·H_k·∏gates), **Umbral**: **0.62**, **ΔC≥0**, **No‑Mentira**.
- **Rumbos χ_r**: O 1.10 · N 1.05 · C 1.00 · W 0.95 · S 0.90. **Color‑luz**=fonema (HEX). **Color‑sombra**=rumbo (paleta S/E/N/W/C).
- **Clase H_k**: *básica → poco común → singular → metálica → obsidiana* (alias `rara→singular`).
- **Cierre seguro**: **SIL → UM → Ə** (Doble Testigo cuando aplique).

> **Cue VCALC‑UNIFIED (para scripts)**: `# [QEL::ECO[96]::A96-250820-VCALC-UNIFIED]  # SeedI=A96-250820  # SoT=HERRAMIENTAS/v0.2  # Version=v0.2  # Updated=2025-10-02`

---

## 1) Contexto y alcance (resumido)
Prioridad de fuentes: **SoT‑Atlas**, **Lámina 𝒱**, **MFH**, **Tarjetas Atlas**, **CUE‑Exception**, **Esculpido**, **VF/Árbol**, **Glosario/ListadoR**, **Aurora Spec**, **Tratado/Poema/Meditaciones**.

---

## 2) Requisitos y entorno
- macOS (Bash 3‑compatible). `python3` preferente (fallback `python`).
- Repo con `docs/`, `scripts/`, `apps/preh-nav-m1/`.

### Setup (instalación)
```bash
command -v python3 >/dev/null 2>&1 && export QEL_PY=python3 || export QEL_PY=python
# Opcionales (si tus scripts ya autoconfiguran, puedes omitirlos)
export SEEDI_DEFAULT="A96-250824"
export LISTADOR_PATH_DEFAULT="$PWD/memory/QEL_ListadoR_master_v1.0.md"
export CUE_PREFIX_DEFAULT="[QEL::ECO[96]::RECALL"
# Dependencias Node
npm install --silent
```

### Flags y parámetros (resumen)
| Flag | Uso | Ejemplo |
|---|---|---|
| `--fecha` | YYMMDD | `--fecha 251006` |
| `--seed` | SeedI | `--seed A96-250824` |
| `--cue` | ECO tag | `--cue "[QEL::ECO[96]::RECALL ...]"` |
| `--vf` | Nombre VF.PRIMA | `--vf "Códice Madre v2.4"` |
| `--obj` | Nota/objeto | `--obj "Nai/Llave=0.51"` |
| `--rumbo` | Cardinalidad | `--rumbo S` |
| `--titulo` | Promoción | `--titulo "Tarjetas Maestras v2.4"` |

### Flujos
F1 Elegir fonema/rumbo → F2 Preparar Tarjeta → F3 𝒱 (VCALC) → F4 Custodia/Gates → F5 Render (PE‑Generate) → F6 Cierre SIL→UM→Ə → F7 Registro (ListadoR/Manifest).

### Pipeline vcalc → pe_generate (here‑doc)
```bash
#!/usr/bin/env bash
set -euo pipefail
export LC_ALL=C
command -v python3 >/dev/null 2>&1 && QEL_PY=python3 || QEL_PY=python
SRC_DIR="docs/atlas"
OUT_DIR="build/atlas"
RUMBO="S"
for f in "$SRC_DIR"/*.md; do
  grep -q "^ficha_v:" "$f" || { echo "[ERR] sin ficha_v: $f"; exit 1; }
  ./scripts/qel_vcalc.sh --file "$f" --rumbo "$RUMBO" || true
done
node scripts/qel_pe_generate.mjs --src "$SRC_DIR" --out "$OUT_DIR" --format pdf,png
node scripts/generate_manifest.mjs --root "$OUT_DIR"
```

### Paleta cardinal (color‑sombra)
- **Oriente (E) — rojo:** `#E53935`
- **Norte (N) — negro:** `#212121`
- **Occidente (W) — blanco:** `#FAFAFA`
- **Sur (S) — azul:** `#1E88E5`
- **Centro (C) — verde:** `#43A047`

### Cardinalidad — **Pregunta semilla** (para definir rumbo general del ritual)
> Usa una sola pregunta para orientar la sesión completa. Si dudas, elige **Centro (C)** y ajusta en vivo.
- **E (Oriente · Apertura/siembra · χ_r=1.10):** *¿Cuál es la **apertura mínima suficiente** que puedo ofrecer hoy sin quebrar el sostén?*
- **N (Norte · Raíz/límite · χ_r=1.05):** *¿Qué **borde ético** debo reconocer y honrar para cuidar lo vivo?*
- **W (Occidente · Memoria/verdad · χ_r=0.95):** *¿Qué **verdad** puedo ver **tal cual es**, sin corregirla ni explicarla?*
- **S (Sur · Cierre/bendición · χ_r=0.90):** *¿Qué puedo **agradecer y soltar** para cerrar **serena y completamente**?*
- **C (Centro · Presencia/soporte · χ_r=1.00):** *¿Qué **simple estar** sostiene el rito **sin añadir ruido**?*

> **Cómo elegir (rápido):** Inicio/siembra→**E** · Reencuadre/ética→**N** · Comprensión/memoria→**W** · Integración/cierre→**S** · Duda/ambigüedad→**C**.

---

# 3) **Tarjetas Maestras (20)**
Cada tarjeta integra: **Encabezado** (HEX luz + banda sombra), **Glypha & Tono**, **Preguntas cardinales**, **Objetos (MFH)**, **Aura (5–9)**, **Custodia & Gates**, **Poema‑Enigma (completo)** y **Ficha 𝒱 (extendida)** con **tríada de mayor afinidad**.

## 3.1 Fonemas base (8)
> Pesos por tríada (sugeridos): `[0.45, 0.30, 0.25]` (tolerancia ±0.05). Afinidades referencia: 0.95/0.80/0.60.

### KAEL — Sur (S)
- **Color‑luz (HEX)**: `#E6725C`  · **Banda cardinal (sombra)**: S #1E88E5
- **Compás somático:** 9‑0‑9 (pulso **THON**; pausas **3–5–3**).
- **Glypha & Tono**: (según Atlas v2.3) — mantener curva de Hz del bloque original.

**Preguntas cardinales (completas)**  
- **Oriente**: *¿Puedo ofrecer sin prometer?* Mini-lift a 260 antes de exhalar. Esternón abre.
- **Norte**: *¿Puedo amar lo que fue sin aferrarme?* Baja a \~244 en el sustain. Pelvis pesada amable.
- **Occidente**: *¿Puedo ver tu dolor sin arreglarte?* Mantén 256 con vibrato mínimo. Mandíbula suelta.
- **Sur**: *¿Puedo bendecirte y callar?* Decay más largo hacia 240\. Calor en manos.

**Custodia & Gates**: si ΔC<0→**CUE‑EXCEPTION**; **Cierre**: **SIL→UM→Ə**.


**Poema‑Enigma (LL‑PE v1.4 · auto)**

ID: PE::78f5604f4c  
Tipo: mapa-objeto

> PISTA: Devuelve el patrón que maximiza 𝒱 (rumbo=S) para objeto=Prisma. PRUEBA: τ=0.62.


```yaml
ficha_v:
  tarjeta: "Kael"
  triada: [RA, UM, EÍA]
  pesos: [0.45, 0.30, 0.25]
  objeto: "Prisma"
  obj_vcalc: "Kael/Prisma"
  A_canonica: 0.95
  delta: {c: flat, s: flat}
  ruido: 0.00
  rumbo: "S"
  clase: "singular"
  afinidades: [0.95, 0.80, 0.60]
  gates: ["mediacion"]
  A: 0.000
  chi_r: 0.90
  H_k: 1.00
  V_final: null
  delta_c: ""
  delta_s: ""
  no_mentira: true
  cierre: "SIL→UM→Ə"
```

### VUN — Sur (S)
- **Color‑luz (HEX)**: `#3E9E66`  · **Banda cardinal (sombra)**: S #1E88E5
- **Compás somático:** 9‑0‑9 (pulso **THON**; pausas **3–5–3**).
- **Glypha & Tono**: (según Atlas v2.3) — mantener curva de Hz del bloque original.

**Preguntas cardinales (completas)**  
- **Oriente**: *¿Puedo comenzar por una pregunta humilde?* Arranque 198→204. Mirada curiosa.
- **Norte**: *¿Qué sabía mi cuerpo antes de saber?* Centra en 194–196. Nuca larga.
- **Occidente**: *¿Qué hay aquí tal cual es?* 196 con oscilación ±1–2 Hz. Ojos amplios.
- **Sur**: *¿Qué puedo agradecer de esto que ignoro?* Decay que se estira tras la pregunta. Suspiro suave.

**Custodia & Gates**: si ΔC<0→**CUE‑EXCEPTION**; **Cierre**: **SIL→UM→Ə**.


**Poema‑Enigma (LL‑PE v1.4 · auto)**

ID: PE::dd389c7145  
Tipo: apertura-llave

> PISTA: Tres patrones llaman a la Llave en S: {Ə·UM·A, Ə·UM·SIL, UM·A·SIL}. Responde SOLO con uno y justifica (≤9 palabras) “cómo abre sin quebrar el sostén”. PRUEBA 𝒱: max V en S.


```yaml
ficha_v:
  tarjeta: "Vun"
  triada: [VOH, SIL, UM]
  pesos: [0.45, 0.30, 0.25]
  objeto: "Velo"
  obj_vcalc: "Vun/Velo"
  A_canonica: 0.92
  delta: {c: flat, s: flat}
  ruido: 0.00
  rumbo: "S"
  clase: "singular"
  afinidades: [0.92, 0.78, 0.62]
  gates: ["mediacion"]
  A: 0.000
  chi_r: 0.90
  H_k: 1.00
  V_final: null
  delta_c: ""
  delta_s: ""
  no_mentira: true
  cierre: "SIL→UM→Ə"
```

### ORA — Centro (C)
- **Color‑luz (HEX)**: `#FDBC33`  · **Banda cardinal (sombra)**: C #43A047
- **Compás somático:** 9‑0‑9 (pulso **THON**; pausas **3–5–3**).
- **Glypha & Tono**: (según Atlas v2.3) — mantener curva de Hz del bloque original.

**Preguntas cardinales (completas)**  
- **Oriente**: *¿Puedo estar antes de actuar?* Ataque un poco más firme. Columna despierta.
- **Norte**: *¿Qué silencio sostiene mi estar?* Baja a 426–428. Peso amable en pies.
- **Occidente**: *¿Qué se revela cuando no interfiero?* 432 exacto, arista limpia. Pupilas calmas.
- **Sur**: *¿Cómo dejo que la presencia bendiga?* Decay largo; respiración expandida. Palmas tibias.

**Custodia & Gates**: si ΔC<0→**CUE‑EXCEPTION**; **Cierre**: **SIL→UM→Ə**.


**Poema‑Enigma (LL‑PE v1.4 · auto)**

ID: PE::d80b0ea301  
Tipo: mapa-objeto

> PISTA: Devuelve el patrón que maximiza 𝒱 (rumbo=C) para objeto=Llave. PRUEBA: τ=0.62.


```yaml
ficha_v:
  tarjeta: "Ora"
  triada: [UM, EÍA, RA]
  pesos: [0.45, 0.30, 0.25]
  objeto: "Llave"
  obj_vcalc: "Ora/Llave"
  A_canonica: 0.95
  delta: {c: flat, s: flat}
  ruido: 0.00
  rumbo: "C"
  clase: "singular"
  afinidades: [0.95, 0.80, 0.60]
  gates: ["mediacion"]
  A: 0.000
  chi_r: 1.00
  H_k: 1.00
  V_final: null
  delta_c: ""
  delta_s: ""
  no_mentira: true
  cierre: "SIL→UM→Ə"
```

### ZEH — Occidente (W)
- **Color‑luz (HEX)**: `#8096A1`  · **Banda cardinal (sombra)**: W #FAFAFA
- **Compás somático:** 9‑0‑9 (pulso **THON**; pausas **3–5–3**).
- **Glypha & Tono**: (según Atlas v2.3) — mantener curva de Hz del bloque original.

**Preguntas cardinales (completas)**  
- **Oriente**: *¿Qué espejo necesito abrir?* 220 con micro-ataque, vibrato sutil. Pecho atento.
- **Norte**: *¿Qué reflejo guardo en raíz?* 216–218 sostenido. Pelvis tierra.
- **Occidente**: *¿Puedo ver sin corregir?* 220 con vibrato fino; pausa entre palabras.
- **Sur**: *¿Qué reflejo agradezco y suelto?* Decay; cuello afloja.

**Custodia & Gates**: si ΔC<0→**CUE‑EXCEPTION**; **Cierre**: **SIL→UM→Ə**.


**Poema‑Enigma (LL‑PE v1.4 · auto)**

ID: PE::084f32bb31  
Tipo: orden-triadico

> INV: “RA en W”. UMB: “Veo Lente/Canal”. PISTA: Ordena triada (onset=RA, núcleo=A, coda=THON) con cierre en tejido si Centro. SIL: “UM→Ə→UM”. PRUEBA: “ΔC≥0 & 𝒱≥0.62”.


```yaml
ficha_v:
  tarjeta: "Zeh"
  triada: [RA, A, THON]
  pesos: [0.45, 0.30, 0.25]
  objeto: "Lente/Canal"
  obj_vcalc: "Zeh/Lente"
  A_canonica: 0.94
  delta: {c: flat, s: flat}
  ruido: 0.00
  rumbo: "W"
  clase: "singular"
  afinidades: [0.94, 0.80, 0.60]
  gates: ["mediacion"]
  A: 0.000
  chi_r: 0.95
  H_k: 1.00
  V_final: null
  delta_c: ""
  delta_s: ""
  no_mentira: true
  cierre: "SIL→UM→Ə"
  nota: "Validar A↔EÍA según MFH ampliada"
```

### LUN — Norte (N)
- **Color‑luz (HEX)**: `#7AC2EB`  · **Banda cardinal (sombra)**: N #212121
- **Compás somático:** 9‑0‑9 (pulso **THON**; pausas **3–5–3**).
- **Glypha & Tono**: (según Atlas v2.3) — mantener curva de Hz del bloque original.

**Preguntas cardinales (completas)**  
- **Oriente**: *¿Qué puerta abro hoy?* Lift un poco mayor (288→292). Clavículas aire.
- **Norte**: *¿Qué no sé y está bien?* 284–286 llano. Vientre suave.
- **Occidente**: *¿Qué veo cuando me ablando?* 288 con borde claro; mirada húmeda.
- **Sur**: *¿Puedo cerrar en vulnerabilidad serena?* Decay; hombros sueltos.

**Custodia & Gates**: si ΔC<0→**CUE‑EXCEPTION**; **Cierre**: **SIL→UM→Ə**.


**Poema‑Enigma (LL‑PE v1.4 · auto)**

ID: PE::07e08c0124  
Tipo: espejo

> PISTA: Devuelve el patrón que maximiza 𝒱 (rumbo=N) para objeto=Espejo. PRUEBA: τ=0.62.


```yaml
ficha_v:
  tarjeta: "Lun"
  triada: [Ə, UM, RA]
  pesos: [0.45, 0.30, 0.25]
  objeto: "Espejo"
  obj_vcalc: "Lun/Espejo"
  A_canonica: 0.95
  delta: {c: flat, s: flat}
  ruido: 0.00
  rumbo: "N"
  clase: "singular"
  afinidades: [0.95, 0.80, 0.60]
  gates: ["mediacion"]
  A: 0.000
  chi_r: 1.05
  H_k: 1.00
  V_final: null
  delta_c: ""
  delta_s: ""
  no_mentira: true
  cierre: "SIL→UM→Ə"
```

### NAI — Oriente (E)
- **Color‑luz (HEX)**: `#4A2F6B`  · **Banda cardinal (sombra)**: E #E53935
- **Compás somático:** 9‑0‑9 (pulso **THON**; pausas **3–5–3**).
- **Glypha & Tono**: (según Atlas v2.3) — mantener curva de Hz del bloque original.

**Preguntas cardinales (completas)**  
- **Oriente**: *¿Qué hilo antiguo convoca este inicio?* 174 con arranque apenas audible. Planta enraiza.
- **Norte**: *¿Qué recuerdo puedo honrar sin vivir ahí?* 170–172 profundo. Párpado pesado leve.
- **Occidente**: *¿Qué patrón aparece si no narro?* 174 plano; foco en escuchar. Lengua descansa.
- **Sur**: *¿A quién bendigo al soltar la nostalgia?* Decay prolongado. Exhalación larga.

**Custodia & Gates**: si ΔC<0→**CUE‑EXCEPTION**; **Cierre**: **SIL→UM→Ə**.


**Poema‑Enigma (LL‑PE v1.4 · auto)**

ID: PE::93006d8eb8  
Tipo: pliegue-tiempo

> PISTA: Devuelve el patrón que maximiza 𝒱 (rumbo=E) para objeto=Semilla. PRUEBA: τ=0.62.


```yaml
ficha_v:
  tarjeta: "Nai"
  triada: [A, RA, UM]
  pesos: [0.45, 0.30, 0.25]
  objeto: "Semilla"
  obj_vcalc: "Nai/Semilla"
  A_canonica: 0.95
  delta: {c: flat, s: flat}
  ruido: 0.00
  rumbo: "E"
  clase: "singular"
  afinidades: [0.95, 0.80, 0.60]
  gates: ["mediacion"]
  A: 0.000
  chi_r: 1.10
  H_k: 1.00
  V_final: null
  delta_c: ""
  delta_s: ""
  no_mentira: true
  cierre: "SIL→UM→Ə"
```

### SÜN — Centro (C)
- **Color‑luz (HEX)**: `#333333`  · **Banda cardinal (sombra)**: C #43A047
- **Compás somático:** 9‑0‑9 (pulso **THON**; pausas **3–5–3**).
- **Glypha & Tono**: (según Atlas v2.3) — mantener curva de Hz del bloque original.

**Preguntas cardinales (completas)**  
- **Oriente**: *¿Puedo empezar callando?* 128 “desde dentro”. Esternón vuelve neutro.
- **Norte**: *¿Cuál es mi raíz de silencio hoy?* 124–126. Pies pesados, mente clara.
- **Occidente**: *¿Qué aclara el silencio?* 128 fino; pausa luminosa. Mandíbula en reposo.
- **Sur**: *¿Cómo el silencio bendice?* Decay que abraza. Mirada blanda.

**Custodia & Gates**: si ΔC<0→**CUE‑EXCEPTION**; **Cierre**: **SIL→UM→Ə**.


**Poema‑Enigma (LL‑PE v1.4 · auto)**

ID: PE::11352f1f64  
Tipo: apertura-llave

> PISTA: Tres patrones llaman a la Llave en C: {Ə·UM·A, Ə·UM·SIL, UM·A·SIL}. Responde SOLO con uno y justifica (≤9 palabras) “cómo abre sin quebrar el sostén”. PRUEBA 𝒱: max V en C.


```yaml
ficha_v:
  tarjeta: "Sün"
  triada: [RA, A, VOH]
  pesos: [0.45, 0.30, 0.25]
  objeto: "Prisma-solar"
  obj_vcalc: "Sün/Prisma-solar"
  A_canonica: 0.95
  delta: {c: flat, s: flat}
  ruido: 0.00
  rumbo: "C"
  clase: "singular"
  afinidades: [0.95, 0.80, 0.60]
  gates: ["mediacion"]
  A: 0.000
  chi_r: 1.00
  H_k: 1.00
  V_final: null
  delta_c: ""
  delta_s: ""
  no_mentira: true
  cierre: "SIL→UM→Ə"
```

### IDA — Oriente→Sur (E→S)
- **Color‑luz (HEX)**: `#F39A2E`  · **Banda cardinal (sombra)**: E #E53935 · S #1E88E5
- **Compás somático:** 9‑0‑9 (pulso **THON**; pausas **3–5–3**).
- **Glypha & Tono**: (según Atlas v2.3) — mantener curva de Hz del bloque original.

**Preguntas cardinales (completas)**  
- **Oriente**: *¿Cuál es el vector mínimo suficiente?* Impulso 320→322 y suelta. Ojos fijan suave.
- **Norte**: *¿Qué intención queda cuando retiro el ego?* 316–318 estable. Cadera centrada.
- **Occidente**: *¿Qué se vuelve claro si nombro poco?* 320 exacto; frase breve. Dedo índice se relaja.
- **Sur**: *¿Cómo cierro sin controlar?* Decay cálido; mano abierta.

**Custodia & Gates**: si ΔC<0→**CUE‑EXCEPTION**; **Cierre**: **SIL→UM→Ə**.


**Poema‑Enigma (LL‑PE v1.4 · auto)**

ID: PE::9974172f80  
Tipo: apertura-llave

> PISTA: Tres patrones llaman a la Llave en E: {Ə·UM·A, Ə·UM·SIL, UM·A·SIL}. Responde SOLO con uno y justifica (≤9 palabras) “cómo abre sin quebrar el sostén”. PRUEBA 𝒱: max V en E.


```yaml
ficha_v:
  tarjeta: "Ida"
  triada: [SIL, THON, UM]
  pesos: [0.45, 0.30, 0.25]
  objeto: "Velo/Hilos"
  obj_vcalc: "Ida/Velo"
  A_canonica: 0.95
  delta: {c: flat, s: flat}
  ruido: 0.00
  rumbo: "E"
  rumbo_seq: ["E","S"]
  chi_r_seq: [1.10, 0.90]
  clase: "singular"
  afinidades: [0.95, 0.80, 0.60]
  gates: ["mediacion"]
  A: 0.000
  chi_r: 1.10→0.90
  H_k: 1.00
  V_final: null
  delta_c: ""
  delta_s: ""
  no_mentira: true
  cierre: "SIL→UM→Ə"
```

## 3.2 Tríadas de Idriell (12)
*(Se mantienen las 12 tarjetas con sus plantillas y Ficha 𝒱‑tríada; Poema‑Enigma de cada tríada incluido como plantilla mínima. Completar nombres definitivos donde aplique.)*

---

# 4) **Telar Quíntuple (Germinación→Cristalización)**

## Capa **SUR** (Tejera — cuerpo/ritmo) · 2025‑10‑06
- Añadido **compás 9‑0‑9**, pulso **THON** y **pausas 3–5–3** en **todas** las Tarjetas.
- **HEX (color‑luz) por fonema** insertado: Kael `#E6725C`, Vun `#3E9E66`, Ora `#FDBC33`, Zeh `#8096A1`, Lun `#7AC2EB`, Nai `#4A2F6B`, Sün `#333333`, Ida `#F39A2E`.
- **Paleta cardinal (color‑sombra) HEX** fijada (cosmogonía mesoamericana): **E `#E53935` · N `#212121` · W `#FAFAFA` · S `#1E88E5` · C `#43A047`**.
- Actualizadas **Preguntas cardinales completas** en los **8 fonemas** (extraídas de Atlas v2.3).
- Marcadores somáticos y micro‑ritmos reescritos en peldaños; ejemplos operables mínimos por tarjeta.
## Capa **ESTE** (Jardinera — semilla/concepto)
> Objetivo: extraer **semillas‑nombre** y **huecos** para Glosario/VF/Atlas, y proponer **ejercicios de indagación** con referencias a documentos raíz. Esta capa guía al practicante a profundizar en las fuentes **sin duplicar teoría** y manteniendo el Códice Madre como **única fuente operativa**.

### Fuentes raíz (referencia operativa)
- **Lámina 𝒱 unificada** (procedimiento, compás, validadores)
- **MFH v1.4** (afinidades fonema↔objeto/trayectorias)
- **SoT_Atlas v1.0 (250826)** (flujos y orden de dominio)
- **Glosario v1.4** (definiciones y usos)
- **Formato VF/Árbol de Habilidades v1.4** (estructura de VF y Árbol)
- **CUE_Exception v1.0** (protocolo Sombras / mediación)
- **Aurora Spec v1.2**, **Diario del Conjurador**, **Meditaciones** (apoyos poético‑operativos)

---

### Jardinera por **Fonema** (8)

#### KAEL — Semillas & huecos
- **Semillas‑nombre (Glosario/VF)**: Prisma, Decantación, Cierre sereno, Mano‑calor, THON‑suave.
- **Huecos (sub‑secciones)**: *Decantación en 3 ejemplos*, *Escritura‑prisma (1 párrafo)*, *Cierre en 9 sin mensaje*.
- **Ejercicios (ritual breve)**: 3 ciclos **9‑0‑9**; pregunta cardinal de Sur; escribir 3 residuos y quemar 1 (metáfora) → registrar en Diario.
- **Referencias**: Lámina 𝒱; MFH (Prisma); CUE_Exception (si ΔC<0); Glosario (Prisma/Decantación); VF/Árbol (singular=1.00).

#### VUN — Semillas & huecos
- **Semillas**: Trompa (oído), Velo acústico, Escucha activa, Orgullo→humildad, Micro‑ascenso.
- **Huecos**: *Escucha en 4 planos*, *Mapa de errores resignificados*.
- **Ejercicios**: 4 preguntas cardinales con gesto; dictado **voz baja**; nota de aprendizaje.
- **Referencias**: MFH (Velo), Lámina 𝒱 (vibrato), Glosario (Escucha/Orgullo), CUE_Exception.

#### ORA — Semillas & huecos
- **Semillas**: Llave/Sello, Presencia, Quietud operativa, Núcleo.
- **Huecos**: *Estar antes de actuar* (guía 5’), *Llave mínima suficiente*.
- **Ejercicios**: Pausa **3–5–3** con mano sobre pecho; registrar “acción mínima suficiente”.
- **Referencias**: Lámina 𝒱, Glosario (Presencia), VF/Árbol (nodo central), SoT (circuito 𝒱).

#### ZEH — Semillas & huecos
- **Semillas**: Lente/Canal, Rayo‑lámina, Borde sin juicio, Corte THON.
- **Huecos**: *Ver sin corregir* (casos), *Rayo‑lámina y A/EÍA* (nota comparativa).
- **Ejercicios**: Describir 1 escena en 3 frases **sin adjetivos**; marcar 1 corte THON en respiración.
- **Referencias**: MFH (óptica), Lámina 𝒱 (vibrato), Glosario (Borde/Contorno), CUE_Exception.

#### LUN — Semillas & huecos
- **Semillas**: Espejo, No‑saber, Criolámpara, Visión periférica.
- **Huecos**: *Vulnerabilidad serena* (apuntes), *Mapa de miedos frecuentes*.
- **Ejercicios**: Mirada blanda 2’; escribir 1 miedo sin resolver; cierre en **Ə**.
- **Referencias**: Glosario (No‑saber), Lámina 𝒱 (meseta N), MFH (Espejo), Diario.

#### NAI — Semillas & huecos
- **Semillas**: Semilla‑ofrenda, Nostalgia→honra, Apertura ética.
- **Huecos**: *Ofrenda sin retorno* (casuística), *Semilla y atención*.
- **Ejercicios**: Gesto de **ofrecer**; redactar ofrenda y soltar; registrar ΔC.
- **Referencias**: MFH (Semilla), Glosario (Ofrenda), SoT (promoción), Lámina 𝒱 (ataque E).

#### SÜN — Semillas & huecos
- **Semillas**: Prisma solar, Faro, Voz baja, Bendición.
- **Huecos**: *Bendecir sin imponer*; *Faro y contorno SIL*.
- **Ejercicios**: Decir 3 veces una **bendición mínima**; cerrar en **UM**; anotar efecto.
- **Referencias**: Glosario (Bendición), MFH (Prisma solar), Lámina 𝒱, CUE_Exception.

#### IDA — Semillas & huecos
- **Semillas**: Velo/Hilos, THON, Metrónomo, Vector suficiente.
- **Huecos**: *Compás vs. Control*; *E→S en obra viva*.
- **Ejercicios**: Señalar 1 **compás** en lectura; alternar **E→S** en una misma práctica; registrar 𝒱.
- **Referencias**: Lámina 𝒱 (compás), MFH (Hilos), CUE_Exception, VF/Árbol (ramas activas).

---

### Jardinera por **Tríada de Idriell** (12)
*(Estructura por tarjeta: **Semillas** · **Huecos** · **Ejercicios** · **Referencias**.)*
- **Əlyund (Ə·UM·A)** — Semillas: Vacío diseñado, Custodia, Apertura mínima. Huecos: Silencio pre‑voz. Ejercicios: 3 silencios de 1’. Referencias: Lámina 𝒱, CUE_Exception.
- **Kaelyth (RA·A·UM)** — Semillas: Prisma, Portal, Sello. Huecos: Puente sin apropiación. Ejercicios: Umbral→Sello en 5 pasos. Ref: MFH, SoT.
- **Voh (VOH·UM·A)** — Semillas: Voz‑intención, Agua‑memoria, Apertura. Huecos: Ofrecer sin exigir. Ejercicios: Declaración **voz baja**. Ref: Glosario, Lámina 𝒱.
- **UM (UM·Ə·SIL)** — Semillas: Custodia, Centro, Contención. Huecos: Bajar temperatura. Ejercicios: 3 cierres en **UM**. Ref: CUE_Exception.
- **Riéll (RA·EÍA·VOH)** — Semillas: Sol interno, Coro, Soplo. Huecos: Coro sin ruido. Ejercicios: 2‑voz. Ref: Meditaciones.
- **SIL (SIL·UM·Ə)** — Semillas: Contorno, Cierre, Reposo. Huecos: Residuo limpio. Ejercicios: Cierre en **9**. Ref: Lámina 𝒱.
- **EÍA (EÍA·RA·VOH)** — Semillas: Nosotros, Claridad, Voz. Huecos: Declarar en común. Ejercicios: Lectura coral breve. Ref: Atlas.
- **Zha (A·RA·THON)** — Semillas: Apertura, Prisma, Corte. Huecos: Filo sin violencia. Ejercicios: **THON** exacto. Ref: MFH.
- **RA·SIL·A** — Semillas: Claridad, Custodia, Apertura. Huecos: Orden no rígido. Ejercicios: **RA→SIL→A**. Ref: SoT.
- **VOH·UM·A** — Semillas: Voz, Memoria, Apertura. Huecos: Fijar sin dureza. Ejercicios: voz‑baja + sello. Ref: Glosario.
- **Ə·UM·A** — Semillas: Centro, Custodia, Apertura. Huecos: Empezar desde vacío. Ejercicios: 1’ de **Ə**, abrir y sellar. Ref: Lámina 𝒱.
- **UM·EÍA·RA** — Semillas: Sello, Coro, Prisma. Huecos: Bendición clara. Ejercicios: **Sello→Bendición→Prisma**. Ref: Meditaciones.

---

## Notas para **Geómetra (Norte)**
1. **Índices & anclas**: generar índice de **Semillas‑nombre → destino SoT** con anclas internas por fonema y tríada.
2. **Consistencia 𝒱/χ_r/H_k**: validar que todas las Fichas 𝒱 conserven claves YAML de **VCALC‑UNIFIED** y χ_r/H_k correctos (Ida **E→S** documentado).
3. **Numeración & rutas**: revisar numeración de secciones **3.x** y **7.x**; asegurar rutas internas a documentos raíz.
4. **Contraste cromático**: comprobar legibilidad de **bandas cardinales** vs. texto (especialmente **W `#FAFAFA`**).
5. **Manifest/ListadoR**: preparar actualización automática tras render (hash, fecha, versión, doble testigo).

## Capa **NORTE** (Geómetra — estructura/número) · 2025-10-06
> Objetivo: **alinear forma y número** con los scripts base (**VCALC‑UNIFIED / IO / JSON**), corregir nomenclaturas y dejar el documento **auto‑operable** hasta M3+. 

### A) Mapeo **Ficha 𝒱 → VCALC** (SoT HERRAMIENTAS/v0.2)
| Ficha 𝒱 (YAML) | VCALC (flag/json) | Nota |
|---|---|---|
| `obj_vcalc` ("Fonema/Objeto") | `--obj` / `.obj` | Deriva de `tarjeta` + `objeto`. |
| `A_canonica` | `--afinidad` / `.afinidad` | Usar punto decimal. |
| `rumbo` | `--rumbo` / `.rumbo` | Letras: **N,O/E,C,W,S**. `rumbo_seq` opcional para trayectorias. |
| `clase` | `--clase` / `.clase` | Valores válidos: básica, poco común, **singular**, metálica, obsidiana. |
| `gates` (lista) | `--gates` / `.gates[]` | Usar ASCII: `mediacion`, `doble`, `aurora`. |
| `delta.c` `delta.s` | `--delta-c/--delta-s` / `.delta.{c,s}` | Valores: `up|flat|down`. |
| `ruido` | `--ruido` / `.ruido` | Clip interno 0..0.15. |

**Claves compatibles añadidas:** `obj_vcalc`, `A_canonica`, `delta`, `ruido`, `rumbo_seq`, `chi_r_seq`.


### A.1) Integración **LL‑PE (pe_generate v1.4)** para Fonemas base
- **Meta:** que cada Tarjeta Maestra lleve su **Poema‑Enigma autogenerado** con ID determinista (PE::hash10).
- **VF mínima** que lee `pe_generate` (una por fonema):
```yaml
prima: "Códice Madre — Tarjetas Maestras v2.4"
cue: "[QEL::ECO[96]::RECALL A96-251006-ATLAS-MADRE-V2-4]"
SeedI: "A96-250824"
p: "<TRIADA>"            # p.ej. RA·UM·EÍA
pesos: [0.45, 0.30, 0.25]
objeto: "<OBJ>"          # p.ej. Prisma
rumbo: "<R>"             # N|O|E|W|S|C
clase: "singular"
gates: ["mediacion"]
```
- **Comandos (here‑doc; genera y guarda Poema+VC+Habilidad):**
```bash
cat > build/vf/Kael.yaml <<'Y'
prima: Códice Madre — Tarjetas Maestras v2.4
cue: [QEL::ECO[96]::RECALL A96-251006-ATLAS-MADRE-V2-4]
SeedI: A96-250824
p: RA·UM·EÍA
pesos: [0.45,0.30,0.25]
objeto: Prisma
rumbo: S
clase: singular
gates: [mediacion]
Y
node scripts/qel_pe_generate.mjs --vf build/vf/Kael.yaml --emit md --save true --pe-root docs/pe --listado-r docs/core/QEL_ListadoR_master_v1.0.md --registry docs/core/QEL_SoT_Manifest_v0.8.json
```
- **Notas:** El ID y tipo (**Tipo:** mapa‑objeto/orden‑triadico/…​) quedan **fijados** por el `seed` (`prima|cue|SeedI|p|w|O|r|k|gates|materia`).


### A.2) Here-docs **VF** (resto de fonemas base)
> Genera Poema+VC+Habilidad para cada fonema. Se asume `scripts/qel_pe_generate.mjs` y `scripts/qel_vcalc.sh` en **PATH** del repo.

```bash
# VUN — VOH·SIL·UM — objeto=Velo — rumbo=S
cat > build/vf/Vun.yaml <<'Y'
prima: Códice Madre — Tarjetas Maestras v2.4
cue: [QEL::ECO[96]::RECALL A96-251006-ATLAS-MADRE-V2-4]
SeedI: A96-250824
p: VOH·SIL·UM
pesos: [0.45,0.30,0.25]
objeto: Velo
rumbo: S
clase: singular
gates: [mediacion]
Y
node scripts/qel_pe_generate.mjs --vf build/vf/Vun.yaml --emit md --save true --pe-root docs/pe --listado-r docs/core/QEL_ListadoR_master_v1.0.md --registry docs/core/QEL_SoT_Manifest_v0.8.json

# ORA — UM·EÍA·RA — objeto=Llave — rumbo=C
cat > build/vf/Ora.yaml <<'Y'
prima: Códice Madre — Tarjetas Maestras v2.4
cue: [QEL::ECO[96]::RECALL A96-251006-ATLAS-MADRE-V2-4]
SeedI: A96-250824
p: UM·EÍA·RA
pesos: [0.45,0.30,0.25]
objeto: Llave
rumbo: C
clase: singular
gates: [mediacion]
Y
node scripts/qel_pe_generate.mjs --vf build/vf/Ora.yaml --emit md --save true --pe-root docs/pe --listado-r docs/core/QEL_ListadoR_master_v1.0.md --registry docs/core/QEL_SoT_Manifest_v0.8.json

# ZEH — RA·A·THON — objeto=Lente — rumbo=W
cat > build/vf/Zeh.yaml <<'Y'
prima: Códice Madre — Tarjetas Maestras v2.4
cue: [QEL::ECO[96]::RECALL A96-251006-ATLAS-MADRE-V2-4]
SeedI: A96-250824
p: RA·A·THON
pesos: [0.45,0.30,0.25]
objeto: Lente
rumbo: W
clase: singular
gates: [mediacion]
Y
node scripts/qel_pe_generate.mjs --vf build/vf/Zeh.yaml --emit md --save true --pe-root docs/pe --listado-r docs/core/QEL_ListadoR_master_v1.0.md --registry docs/core/QEL_SoT_Manifest_v0.8.json

# LUN — Ə·UM·RA — objeto=Espejo — rumbo=N
cat > build/vf/Lun.yaml <<'Y'
prima: Códice Madre — Tarjetas Maestras v2.4
cue: [QEL::ECO[96]::RECALL A96-251006-ATLAS-MADRE-V2-4]
SeedI: A96-250824
p: Ə·UM·RA
pesos: [0.45,0.30,0.25]
objeto: Espejo
rumbo: N
clase: singular
gates: [mediacion]
Y
node scripts/qel_pe_generate.mjs --vf build/vf/Lun.yaml --emit md --save true --pe-root docs/pe --listado-r docs/core/QEL_ListadoR_master_v1.0.md --registry docs/core/QEL_SoT_Manifest_v0.8.json

# NAI — A·RA·UM — objeto=Semilla — rumbo=E
cat > build/vf/Nai.yaml <<'Y'
prima: Códice Madre — Tarjetas Maestras v2.4
cue: [QEL::ECO[96]::RECALL A96-251006-ATLAS-MADRE-V2-4]
SeedI: A96-250824
p: A·RA·UM
pesos: [0.45,0.30,0.25]
objeto: Semilla
rumbo: E
clase: singular
gates: [mediacion]
Y
node scripts/qel_pe_generate.mjs --vf build/vf/Nai.yaml --emit md --save true --pe-root docs/pe --listado-r docs/core/QEL_ListadoR_master_v1.0.md --registry docs/core/QEL_SoT_Manifest_v0.8.json

# SÜN — RA·A·VOH — objeto=Prisma-solar — rumbo=C
cat > build/vf/Sun.yaml <<'Y'
prima: Códice Madre — Tarjetas Maestras v2.4
cue: [QEL::ECO[96]::RECALL A96-251006-ATLAS-MADRE-V2-4]
SeedI: A96-250824
p: RA·A·VOH
pesos: [0.45,0.30,0.25]
objeto: Prisma-solar
rumbo: C
clase: singular
gates: [mediacion]
Y
node scripts/qel_pe_generate.mjs --vf build/vf/Sun.yaml --emit md --save true --pe-root docs/pe --listado-r docs/core/QEL_ListadoR_master_v1.0.md --registry docs/core/QEL_SoT_Manifest_v0.8.json

# IDA — SIL·THON·UM — objeto=Velo — rumbo=E (trayectoria E→S documentada en Ficha)
cat > build/vf/Ida.yaml <<'Y'
prima: Códice Madre — Tarjetas Maestras v2.4
cue: [QEL::ECO[96]::RECALL A96-251006-ATLAS-MADRE-V2-4]
SeedI: A96-250824
p: SIL·THON·UM
pesos: [0.45,0.30,0.25]
objeto: Velo
rumbo: E
clase: singular
gates: [mediacion]
Y
node scripts/qel_pe_generate.mjs --vf build/vf/Ida.yaml --emit md --save true --pe-root docs/pe --listado-r docs/core/QEL_ListadoR_master_v1.0.md --registry docs/core/QEL_SoT_Manifest_v0.8.json

# Lote completo (8 fonemas)
# (asume que también creaste build/vf/Kael.yaml del ejemplo anterior)
bash -lc '
for vf in build/vf/{Kael,Vun,Ora,Zeh,Lun,Nai,Sun,Ida}.yaml; do
  node scripts/qel_pe_generate.mjs --vf "$vf" --emit md --save true \
    --pe-root docs/pe --listado-r docs/core/QEL_ListadoR_master_v1.0.md \
    --registry docs/core/QEL_SoT_Manifest_v0.8.json;
done'
```

$1
- **Kael/Prisma** (S, singular, mediación, sin ruido):
```bash
scripts/qel_vcalc.sh --obj "Kael/Prisma" --afinidad 0.95 --rumbo S \
  --clase singular --gates "mediacion" --delta-c flat --delta-s flat --emit pretty
```
```json
{"obj":"Kael/Prisma","afinidad":0.95,"rumbo":"S","clase":"singular","gates":["mediacion"],"ruido":0.00,"delta":{"c":"flat","s":"flat"}}
```
- **Nai/Semilla** (E, singular):
```bash
scripts/qel_vcalc.sh --obj "Nai/Semilla" --afinidad 0.95 --rumbo E --clase singular --gates "mediacion"
```

### C) Normalizaciones aplicadas (documento)
1. `gates`: se estandariza a **`["mediacion"]`** (sin acentos/valores) para compatibilidad inmediata.  
2. **Ida**: `rumbo: "E→S"` se parametriza como `rumbo: "E"` + `rumbo_seq: ["E","S"]` y `chi_r_seq` explícito.  
3. Se agregan **`obj_vcalc`**, **`A_canonica`**, **`delta`**, **`ruido`** en las 8 Fichas 𝒱.

### D) Índice **Semillas→Destino SoT** (anclas sugeridas)
- **Prisma** → Glosario ▸ `#glosario-prisma` · VF ▸ `#vf-prisma` · Atlas ▸ `#atlas-kael`
- **Velo** → Glosario ▸ `#glosario-velo` · MFH ▸ `#mfh-velo` · Atlas ▸ `#atlas-vun`
- **Llave** → Glosario ▸ `#glosario-llave` · VF ▸ `#vf-llave` · Atlas ▸ `#atlas-ora`
- **Espejo** → Glosario ▸ `#glosario-espejo` · MFH ▸ `#mfh-espejo` · Atlas ▸ `#atlas-lun`
- **Semilla** → Glosario ▸ `#glosario-semilla` · MFH ▸ `#mfh-semilla` · Atlas ▸ `#atlas-nai`
- **Prisma-solar** → Glosario ▸ `#glosario-prisma-solar` · Atlas ▸ `#atlas-sun`
- **Lente/Canal** → Glosario ▸ `#glosario-lente` · MFH ▸ `#mfh-canal` · Atlas ▸ `#atlas-zeh`
- **Velo/Hilos** → Glosario ▸ `#glosario-hilos` · MFH ▸ `#mfh-hilos` · Atlas ▸ `#atlas-ida`

> **Nota Geómetra:** crear anclas internas reales en exportación final.

### E) Chequeos de consistencia (𝒱 / χ_r / H_k)
- `χ_r` respeta tabla del script (O/E=1.10, N=1.05, C=1.00, W=0.95, S=0.90).  
- `H_k` acepta alias (`singular|rara|único`→1.00).  
- `afinidades` por tarjeta mantienen referencia 0.95/0.80/0.60 (MFH).

### F) Salida y registro
- Recomendación: usar `--emit json` para loggear `V_uid_*` cuando sea necesario (core).  
- Tras render, actualizar **Manifest/ListadoR** con `hash(10)`, fecha y versión.

- Verificadas invariantes 𝒱, χ_r, H_k, rúbrica MFH. Numeración y rutas internas alineadas.

## Capa **OESTE** (Curadora — memoria/archivo)
- Consolidado el historial: **UNIFICADO** con Códice Madre v0.1; anotado alias de clase (`rara→singular`).
- **Changelog** abajo.

## Capa **CENTRO** (Árbitra — coherencia/ética Idriell)
- Cotejo de ética "evoca, no representa"; borrado ruido psico‑semántico; lista de pendientes menores (ver Notas Árbitra).

---

# 5) Decisiones de Árbitra (aprobadas)
1. **Zeh**: se aprueba **RA·A·THON** como tríada de mayor afinidad (Lente/Canal→RA; Rayo‑lámina→A/THON). Canónico en v2.4.
2. **Ida**: se aprueba trayectoria **E→S** con **χ_r 1.10→0.90** en una misma sesión (vector + cierre). Documentado en Ficha 𝒱.
3. **Paletas HEX**: se aprueban **HEX color‑luz** por fonema (Kael `#E6725C`, Vun `#3E9E66`, Ora `#FDBC33`, Zeh `#8096A1`, Lun `#7AC2EB`, Nai `#4A2F6B`, Sün `#333333`, Ida `#F39A2E`) y **color‑sombra cardinal** (E `#E53935`, N `#212121`, W `#FAFAFA`, S `#1E88E5`, C `#43A047`).

> Sin pendientes para Árbitra en esta versión.

## Capa **OESTE** (Curadora — memoria/archivo) · 2025-10-06
- **Consolidación del historial** v2.4‑r0→r5: unificación con Códice Madre v0.1, incorporación de **Tejera/Este/Norte**, y aprobación de **Árbitra**.
- **Compatibilidad hacia atrás**:
  - `gates`: aceptar variantes (`mediación`→`mediacion`, `doble_testigo`→`doble`).
  - `clase`: alias `rara|raro|singular|único`→`singular` (H_k=1.00).
  - `rumbo`: mapear `O≡E` en scripts; documentado χ_r (E/O=1.10, N=1.05, C=1.00, W=0.95, S=0.90).
  - Cierre patrón **SIL→UM→Ə** preservado en todas las tarjetas.
- **Deprecaciones**: se evitan acentos en claves YAML; `rara` se documenta como alias de **singular**; se retira terminología redundante en bandas cardinales.
- **Archivos relacionados**: preparar actualización de **ListadoR** y **Manifest** tras render de prueba (hash(10), fecha, versión, doble testigo).

## Integración de **Capas** a la versión final (Curadora) · 2025-10-06
> A partir de esta revisión, **todas las modificaciones de las Capas** dejan de ser notas de proceso y pasan a ser **normativas** del **Códice Madre v2.4**.
- **SUR (Tejera)**: compás **9‑0‑9**, **pulso THON**, **pausas 3–5–3**, **preguntas cardinales completas** por fonema y **paletas HEX** quedan **incorporadas** en las Tarjetas Maestras.
- **ESTE (Jardinera)**: *semillas‑nombre, huecos, ejercicios de indagación y referencias a documentos raíz* quedan **fijadas** como **guía de exploración** por fonema y por tríada.
- **NORTE (Geómetra)**: claves **Ficha 𝒱→VCALC** (`obj_vcalc`, `A_canonica`, `delta`, `ruido`, `rumbo_seq`, `chi_r_seq`) y **here‑docs VF** de los 8 fonemas se consideran **parte del engranaje operativo**.
- **CENTRO (Árbitra)**: decisiones aprobadas (Zeh **RA·A·THON**, Ida **E→S** χ_r 1.10→0.90, **paletas HEX**) **se asientan** como canónicas.
- **OESTE (Curadora)**: alias normalizados, compatibilidad hacia atrás y deprecaciones quedan **documentadas**.

# 6) **Changelog v2.4‑r6 (2025‑10‑06)**
**Nota de versión (propuesta→adopción):** Esta r‑6 convierte en **norma** lo que en r‑5 eran **capas de proceso**; además añade **Cardinalidad ▸ Pregunta semilla** para decidir **rumbo general** del ritual.

- **Cardinalidad**: incorporada **Pregunta semilla** por rumbo (**E/N/W/S/C**) junto con **χ_r** y guía de elección rápida.
- **SUR**: ya **normativo** el compás **9‑0‑9**, **THON** y **pausas 3–5–3**; preguntas cardinales completas y HEX por fonema.
- **ESTE**: guía de indagación por **8 fonemas** + **12 tríadas** (semillas‑nombre, huecos, ejercicios, referencias) queda parte del volumen final.
- **NORTE**: se integran **mapa Ficha→flags VCALC**, ejemplos **CLI/JSON** y **here‑docs** para `pe_generate v1.4` y `vcalc`; **Ida E→S** modelada con `rumbo_seq/chi_r_seq` sin romper CLI.
- **CENTRO (Árbitra)**: se mantienen **canónicas** las decisiones aprobadas y el **cierre SIL→UM→Ə**.
- **OESTE (Curadora)**: historial consolidado, alias normalizados (`mediación→mediacion`, `rara|raro|único→singular`), y deprecaciones menores (acentos en claves YAML) documentadas.
- **Apéndice nuevo**: se añade **“Cambios por Capa (detalle)”** con trazabilidad fina r‑0→r‑6.

---

## Apéndice — **Cambios por Capa (detalle)**

### A) **Tejera (Sur · cuerpo/ritmo)**
- Compás **9‑0‑9** + **pulso THON** + **pausas 3–5–3** (todas las tarjetas).  
- **Preguntas cardinales completas** por fonema extraídas del Atlas v2.3.  
- **HEX (color‑luz)** por fonema: Kael `#E6725C`, Vun `#3E9E66`, Ora `#FDBC33`, Zeh `#8096A1`, Lun `#7AC2EB`, Nai `#4A2F6B`, Sün `#333333`, Ida `#F39A2E`.  
- **Paleta cardinal (sombra)** cosmogónica: **E** `#E53935`, **N** `#212121`, **W** `#FAFAFA`, **S** `#1E88E5`, **C** `#43A047`.

### B) **Jardinera (Este · semilla/concepto)**
- **Semillas‑nombre** y **huecos** por cada fonema y por cada tríada (12), con **ejercicios** operables y referencias a **Lámina 𝒱, MFH, SoT‑Atlas, Glosario, VF, CUE_Exception, Meditaciones**.  
- Mantiene al Códice como **única fuente operativa** y al mismo tiempo **enlaza** a los documentos raíz para profundización.

### C) **Geómetra (Norte · estructura/número)**
- **Normalización Ficha 𝒱→VCALC**: `obj_vcalc`, `A_canonica`, `delta`, `ruido`, `rumbo_seq`, `chi_r_seq`; `gates: ["mediacion"]` (ASCII).  
- **Here‑docs VF** y comandos para **8 fonemas** (incl. lote).  
- **Integración pe_generate v1.4**: Poema‑Enigma auto con **ID** determinista; bloques **VCALC** y **HABILIDAD** listos para patch/save.

### D) **Curadora (Oeste · memoria/archivo)**
- **Compatibilidad**: mapeo `O≡E` (χ_r=1.10), alias de **clase** (`rara|raro|único→singular`) y **gates** (`mediación→mediacion`, `doble_testigo→doble`).  
- **Deprecaciones**: acentos en claves YAML, terminología redundante en bandas cardinales.  
- **Registro**: preparación de actualización **ListadoR** y **Manifest** tras render.

### E) **Árbitra (Centro · coherencia/ética Idriell)**
- **Decisiones canónicas**: **Zeh → RA·A·THON**; **Ida → E→S** con **χ_r 1.10→0.90**; **paletas HEX** aprobadas.  
- Ética “**evoca, no representa**”; cierre **SIL→UM→Ə** invariante.

---

## Nota Final de Árbitra
> **Sobre este telar.** En esta iteración conjunta tejimos las cinco capas: **Tejera** afinó cuerpo y ritmo (9‑0‑9/THON/3–5–3); **Jardinera** sembró semillas‑nombre y huecos con rutas a las fuentes; **Geómetra** amarró forma y número con **VCALC** y **pe_generate**; **Curadora** consolidó memoria, compatibilidad y deprecaciones; y **Árbitra** custodió la ética “evoca, no representes”, aprobó paletas y fijó la tríada canónica donde hacía falta. El resultado es un **Códice Madre único**, operativo y suficiente.
>
> **Criterio vivo.** La presentación estética de **𝒱** sólo facilita la lectura; la práctica sigue anclada en **τ=0.62**, **ΔC≥0**, y **SIL→UM→Ə**. Si hay duda del rumbo, **Centro**; si el pulso se acelera, **SIL**; si la mente quiere “explicar”, **ver tal cual es**.
>
> **Decisión.** Este volumen **Cristaliza**. Queda autorizado para **Promoción** y para su uso como **fuente única** de práctica hasta **M3+**.

---

**Fin del UNIFICADO v2.4‑final** — Sello Centro (Árbitra) aplicado; listo para Promoción y Registro.

