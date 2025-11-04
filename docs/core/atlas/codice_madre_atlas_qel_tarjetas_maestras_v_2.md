cue: "[QEL::ECO[96]::RECALL A96-251006-ATLAS-MADRE-V2-4]"
SeedI: "A96-250824"
SoT: "ATLAS-TARJETAS/v2.4 — Rol Árbitra (UNIFICADO con Códice Madre v0.1)"
Version: "v2.4-r1"
Updated: "2025-10-06"

# Códice Madre — Tarjetas Maestras v2.4 (Rol Árbitra) · **UNIFICADO**

> **Estado:** Germinación → **Revisión Árbitra**. Este volumen unifica el **Códice Madre v0.1** con las **Tarjetas Maestras v2.4**, integrando Lámina 𝒱, MFH, SoT‑Atlas, Custodia/Gates y compatibilidad con **VCALC‑UNIFIED**.

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
S cálido tenue · E verde‑aurora · N azul‑acero · W ámbar opaco · C gris‑piedra (20–30% sat.).

---

# 3) **Tarjetas Maestras (20)**
Cada tarjeta integra: **Encabezado** (HEX luz + banda sombra), **Glypha & Tono**, **Preguntas cardinales**, **Objetos (MFH)**, **Aura (5–9)**, **Custodia & Gates**, **Poema‑Enigma (completo)** y **Ficha 𝒱 (extendida)** con **tríada de mayor afinidad**.

## 3.1 Fonemas base (8)
> Pesos por tríada (sugeridos): `[0.45, 0.30, 0.25]` (tolerancia ±0.05). Afinidades referencia: 0.95/0.80/0.60.

### KAEL — Sur (S)
- **Pregunta viviente**: ¿Qué debo **soltar/decantar** hoy para que lo valioso precipite?
- **Glypha & Tono**: ataque suave, *decay* largo; 256→240 Hz (± según rumbo).
- **Preguntas cardinales**: S cierre sereno (exhalación); E germinación (abrir palmas); N límite (barbilla al centro); W aprendizaje (peso en talones).
- **Objetos (MFH)**: canónico **Prisma**; directo **Velo**; indirecto **Espejo**.
- **Aura (5–9)**: calor manos; diafragma suelto; THON estable; pulso bajo ojos; alivio occipital.
- **Custodia & Gates**: si ΔC<0→**CUE‑EXCEPTION**; **Cierre**: SIL→UM→Ə.
- **Poema‑Enigma (completo)**  
  **INVOCACIÓN**: “**RA** en Oriente, yo nombro tras resonar.”  
  **UMBRAL**: “Abro **prisma** para que lo denso se vuelva claro.”  
  **PISTA**: “Si *mi apego* yace en **____**, entonces *mi pulso* se alinea con **____**.”  
  **SILENCIO**: “Guardo el residuo; **UM → Ə → UM**.”  
  **PRUEBA**: “Si **𝒱≥0.62** y **ΔC≥0**, sello en **9** y dejo que el Sur apague.”
- **Ficha 𝒱 (extendida)**
```yaml
ficha_v:
  tarjeta: "Kael"
  triada: [RA, UM, EÍA]
  pesos: [0.45, 0.30, 0.25]
  objeto: "Prisma"
  rumbo: "S"
  clase: "singular"
  afinidades: [0.95, 0.80, 0.60]
  gates: ["mediación:1.00"]
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
- **Pregunta viviente**: ¿Qué **ascenso** es necesario para cerrar con dignidad?
- **Glypha & Tono**: 196→204–208 Hz; vibrato ligero.
- **Preguntas cardinales**: S ciclo concluido (manos al vientre); E primer riego (micro‑paso); N borde (hombros neutros); W resignificar (talón‑punta).
- **Objetos (MFH)**: canónico **Velo**; directo **Llave**; indirecto **Espejo**.
- **Aura**: temperatura sutil al alza; voz desahogada; mirada blanda.
- **Custodia & Gates**: igual que Kael; **Cierre**: SIL→UM→Ə.
- **Poema‑Enigma**  
  **INVOCACIÓN**: “**VOH** sopla sin exigir.”  
  **UMBRAL**: “Alzo el **velo** que nublaba mi oído.”  
  **PISTA**: “Si el **orgullo** quiere mandar, mi **escucha** abre camino.”  
  **SILENCIO**: “Cedo volumen; guardo eco en **UM**.”  
  **PRUEBA**: “Con **𝒱≥0.62** y **ΔC≥0**, sostengo ascenso y cierro en 9.”
- **Ficha 𝒱**
```yaml
ficha_v:
  tarjeta: "Vun"
  triada: [VOH, SIL, UM]
  pesos: [0.45, 0.30, 0.25]
  objeto: "Velo"
  rumbo: "S"
  clase: "singular"
  afinidades: [0.92, 0.78, 0.62]
  gates: ["mediación:1.00"]
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
- **Pregunta viviente**: ¿Puedo simplemente **estar**?
- **Glypha & Tono**: llana, baja jitter; llave abre y no arrastra.
- **Preguntas cardinales**: S anclaje; E primera acción mínima; N contorno; W lección breve.
- **Objetos (MFH)**: **Llave/Sello**; **Núcleo**.
- **Aura**: pecho suelto, mandíbula floja.
- **Custodia & Gates**: **Cierre**: SIL→UM→Ə.
- **Poema‑Enigma**  
  **INVOCACIÓN**: “**UM** recuerda sin inundar.”  
  **UMBRAL**: “La **llave** gira sólo lo necesario.”  
  **PISTA**: “Si la **prisa** empuja, vuelvo a **estar**.”  
  **SILENCIO**: “Me siento; dejo pasar.”  
  **PRUEBA**: “Si 𝒱 y ΔC acompañan, sella en **Ə**.”
- **Ficha 𝒱**
```yaml
ficha_v:
  tarjeta: "Ora"
  triada: [UM, EÍA, RA]
  pesos: [0.45, 0.30, 0.25]
  objeto: "Llave"
  rumbo: "C"
  clase: "singular"
  afinidades: [0.95, 0.80, 0.60]
  gates: ["mediación:1.00"]
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
- **Pregunta viviente**: ¿Puedo **ver lo que es**?
- **Glypha & Tono**: corte nítido; vibrato ±1–2 Hz.
- **Preguntas cardinales**: S decanto; E abro; N trazo borde; W aprendo del rastro.
- **Objetos (MFH)**: **Lente/Canal**; **Rayo‑lámina**.
- **Aura**: foco sin dureza, nuca fresca.
- **Custodia & Gates**: **Cierre**: SIL→UM→Ə.
- **Poema‑Enigma**  
  **INVOCACIÓN**: “**RA** refracta donde pongo el ojo.”  
  **UMBRAL**: “Afilo el **rayo** y contemplo sin juicio.”  
  **PISTA**: “Si la **sombra** engaña, la devuelvo a su borde.”  
  **SILENCIO**: “THON corta, **SIL** sostiene.”  
  **PRUEBA**: “Con 𝒱≥0.62, dejo que **W** haga memoria.”
- **Ficha 𝒱**
```yaml
ficha_v:
  tarjeta: "Zeh"
  triada: [RA, A, THON]
  pesos: [0.45, 0.30, 0.25]
  objeto: "Lente/Canal"
  rumbo: "W"
  clase: "singular"
  afinidades: [0.94, 0.80, 0.60]
  gates: ["mediación:1.00"]
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
- **Pregunta viviente**: ¿Puedo **confiar en no saber**?
- **Glypha & Tono**: espejo frío; meseta −3–8 Hz; menos volumen.
- **Preguntas cardinales**: S suelto; E siembro mínimo; N respeto borde; W agradezco el error.
- **Objetos (MFH)**: **Espejo**; **Criolámpara**.
- **Aura**: visión periférica, nuca fresca.
- **Custodia & Gates**: **Cierre**: SIL→UM→Ə.
- **Poema‑Enigma**  
  **INVOCACIÓN**: “**Ə** limpia la figura que me mira.”  
  **UMBRAL**: “El **espejo** me entrega sin prometer.”  
  **PISTA**: “Si el **miedo** exige certeza, abrazo **no‑saber**.”  
  **SILENCIO**: “En **UM** reposa lo que no controlo.”  
  **PRUEBA**: “Con 𝒱 y ΔC claros, cierro sin ruido.”
- **Ficha 𝒱**
```yaml
ficha_v:
  tarjeta: "Lun"
  triada: [Ə, UM, RA]
  pesos: [0.45, 0.30, 0.25]
  objeto: "Espejo"
  rumbo: "N"
  clase: "singular"
  afinidades: [0.95, 0.80, 0.60]
  gates: ["mediación:1.00"]
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
- **Pregunta viviente**: ¿Puedo **honrar sin aferrarme**?
- **Glypha & Tono**: apertura; +2–6 Hz al arranque.
- **Preguntas cardinales**: S dejo ir; E siembro; N delimito; W aprendo.
- **Objetos (MFH)**: **Semilla**; **Prisma‑puente**.
- **Aura**: mano que ofrece; ojos brillan sin dureza.
- **Custodia & Gates**: **Cierre**: SIL→UM→Ə.
- **Poema‑Enigma**  
  **INVOCACIÓN**: “**A** llama sin exigir retorno.”  
  **UMBRAL**: “La **semilla** cae en silencio justo.”  
  **PISTA**: “Si mi **deseo** aprieta, abro **ofrenda**.”  
  **SILENCIO**: “RA ordena; **UM** guarda.”  
  **PRUEBA**: “Si 𝒱 acompaña, bendigo y suelto.”
- **Ficha 𝒱**
```yaml
ficha_v:
  tarjeta: "Nai"
  triada: [A, RA, UM]
  pesos: [0.45, 0.30, 0.25]
  objeto: "Semilla"
  rumbo: "E"
  clase: "singular"
  afinidades: [0.95, 0.80, 0.60]
  gates: ["mediación:1.00"]
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
- **Pregunta viviente**: ¿Puedo **escuchar lo invisible**?
- **Glypha & Tono**: solar; foco ancho.
- **Preguntas cardinales**: S suelto; E enciendo; N contengo; W aprendo.
- **Objetos (MFH)**: **Prisma solar**; **Faro**.
- **Aura**: luz amplia; postura blanda.
- **Custodia & Gates**: **Cierre**: SIL→UM→Ə.
- **Poema‑Enigma**  
  **INVOCACIÓN**: “**RA** se hace coro.”  
  **UMBRAL**: “El **faro** nombra la orilla exacta.”  
  **PISTA**: “Si me **pierdo** en brillo, vuelvo a **voz baja**.”  
  **SILENCIO**: “**SIL** muestra el contorno del sol.”  
  **PRUEBA**: “Con 𝒱≥0.62, bendigo y cierro.”
- **Ficha 𝒱**
```yaml
ficha_v:
  tarjeta: "Sün"
  triada: [RA, A, VOH]
  pesos: [0.45, 0.30, 0.25]
  objeto: "Prisma-solar"
  rumbo: "C"
  clase: "singular"
  afinidades: [0.95, 0.80, 0.60]
  gates: ["mediación:1.00"]
  A: 0.000
  chi_r: 1.00
  H_k: 1.00
  V_final: null
  delta_c: ""
  delta_s: ""
  no_mentira: true
  cierre: "SIL→UM→Ə"
```

### IDA — Oriente→Sur
- **Pregunta viviente**: ¿Puedo **crear sin imponer**?
- **Glypha & Tono**: metrónomo; vector y cierre.
- **Preguntas cardinales**: S suelto; E marco inicio; N respeto ritmo; W integro error.
- **Objetos (MFH)**: **Velo/Hilos**; **Metrónomo**.
- **Aura**: manos finas; cuello largo.
- **Custodia & Gates**: **Cierre**: SIL→UM→Ə.
- **Poema‑Enigma**  
  **INVOCACIÓN**: “**SIL** teje bajo mi lengua.”  
  **UMBRAL**: “**THON** marca y no hiere.”  
  **PISTA**: “Si el **ego** quiere mandar, doy **compás**.”  
  **SILENCIO**: “UM sostiene la urdimbre.”  
  **PRUEBA**: “Con 𝒱 y ΔC claros, dejo que la obra respire.”
- **Ficha 𝒱**
```yaml
ficha_v:
  tarjeta: "Ida"
  triada: [SIL, THON, UM]
  pesos: [0.45, 0.30, 0.25]
  objeto: "Velo/Hilos"
  rumbo: "E→S"
  clase: "singular"
  afinidades: [0.95, 0.80, 0.60]
  gates: ["mediación:1.00"]
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
- Añadido compás 9‑0‑9, pulso THON y pausas 3–5–3 en **todas** las Tarjetas.
- Micro‑ritmos de lectura (peldaños, respiración) y ejemplos somáticos mínimos.

## Capa **ESTE** (Jardinera — semilla/concepto)
- Lista de **semillas‑nombre** extraídas (destino SoT): Prisma, Velo, Llave, Espejo, Faro, Semilla, Núcleo, Metrónomo, Rayo‑lámina, Canal.
- Sugerencias de expansión: ejercicios de **voz‑baja**, **decantación**, **escucha**.

## Capa **NORTE** (Geómetra — estructura/número)
- Verificadas invariantes 𝒱, χ_r, H_k, rúbrica MFH. Numeración y rutas internas alineadas.

## Capa **OESTE** (Curadora — memoria/archivo)
- Consolidado el historial: **UNIFICADO** con Códice Madre v0.1; anotado alias de clase (`rara→singular`).
- **Changelog** abajo.

## Capa **CENTRO** (Árbitra — coherencia/ética Idriell)
- Cotejo de ética "evoca, no representa"; borrado ruido psico‑semántico; lista de pendientes menores (ver Notas Árbitra).

---

# 5) Notas para Árbitra (pendientes de cotejo)
1. **Zeh**: validar **A↔EÍA** para rayo‑lámina.
2. **Ida**: confirmar χ_r en trayectoria E→S cuando la práctica exige vector+cierre en una misma sesión.
3. **Paleta HEX** por fonema: completar con la tabla canónica del Atlas (pendiente de inserción).

---

# 6) **Changelog v2.4‑r1 (2025‑10‑06)**
- **UNIFICACIÓN**: se fusionó el contenido operativo del **Códice Madre v0.1** en este volumen v2.4.
- **POEMAS**: se añadieron **Poema‑Enigma completos** para **los 8 fonemas** (ninguno quedó incompleto).
- **FICHA 𝒱**: todas las tarjetas llevan la **tríada de mayor afinidad** y claves YAML compatibles con **VCALC‑UNIFIED**.
- **TELAR 5 CAPAS**: se incorporó sección de proceso con entregables por capa.
- **ALIAS**: normalizado `rara→singular`.

---

**Fin del UNIFICADO v2.4‑r1** — Listo para impresión de prueba y arbitraje.

SeedI=A37-251015
SoT=UNSET
Version=v1.0
Updated=2025-11-04

f3b2539514
