
# QEL · Diario del Conjurador · v1.2
> Fecha de compilación: 2025-08-13 16:44:51 CST

## Notas de versión (v1.2)
- Añadida **Ficha 𝒱 (Viabilidad) — paso a paso** con fórmula, rúbrica y ejemplo completos.
- Ampliadas entradas del **Diccionario**: Rumbos, 𝒱, V_final, ΔC/ΔS, Doble Testigo, Veredictos, Modos.
- Integrados **Instructivos**: Plantilla Rápida, FS (Formato Situacional), Cierre SIL→UM→Ə, Guía de Promoción.
- Añadidos **Ejemplos trabajados de 𝒱** con dos VF y cálculos por rumbo.
- Incluido **Checklist de manejo informado** y **plantillas YAML** listas para copiar.

---

## 0) Cómo usar este Diario
1. Abre la **Plantilla Rápida** (bitácora). 
2. Prepara un **FS** (2–3 min) con tema, intención, modo y rumbo.
3. Ejecuta **Proyección→Vibración→Eco** (10–15 min).
4. Cierra con **SIL→UM→Ə**; registra ΔC/ΔS, **No-Mentira**, y—si estás en M1+—**V_final**.
5. Decide **veredicto** (Cristaliza/Germina/Reposa). Solo si **Cristaliza**, “promociona” a Árbol/VF/Listado R.

---

## 1) Plantilla Rápida — Bitácora de sesión
```yaml
fecha: YYMMDD
operador: 
testigos: [t1?, t2?]
rumbo: [N|O|S|E|Centro]
modo: [M0..M3]
vf_prima: ""     # ≤13 palabras
triada: ""       # p.ej. "RA·VOH·EÍA"
objeto_interaccional: ""
intencion: ""
proyeccion: ""
vibracion: ""
eco: ""
delta_c: ""      # variación cognitiva
delta_s: ""      # variación somática
V_final: null    # si M1+
no_mentira: true
cierre_SIL_UM_silencio: true
proximo_paso: ""
```

---

## 2) Diccionario de Qel (núcleo, ampliado v1.2)
- **Rumbos (N/O/S/E/Centro)**: lentes operativas.
  - Norte: Ética/No-Mentira/propósito.
  - Oriente: Luz/Voz/precisión del lenguaje (corte de ruido).
  - Occidente: Memoria/Eco/registro (aprendizaje y Listado R).
  - Sur: Cuerpo/Anclaje (prueba en mundo, ritmo, técnica).
  - Centro: Eje de apertura-cierre (SIL→UM→Ə) y veredicto.
- **𝒱 (Viabilidad)**: compatibilidad entre triada p, objeto O, rumbo r y clase k.
  - Fórmula: 𝒱 = clip_0^1(⟨b_p,m_O⟩ · χ_r · H_k · Π_gates)
  - Umbral de avance: **0.62** (junto a ΔC≥0 y No-Mentira).
  - Reporte: **V_final** en el cierre (M1+); opcional **V_promocion** al mover piezas.
- **V_final**: valor de 𝒱 que consignas al cierre de la sesión.
- **ΔC / ΔS**: brújulas de cambio cognitivo / somático.
- **Doble Testigo**: verificación reproducible (humano+humano o humano+registro).
- **Veredictos**: Cristaliza (promociona) · Germina (⭐, retomar) · Reposa (archivar).
- **Modos (M0→M3)**:
  - M0: 1 concepto y 1 métrica (ΔC o ΔS).
  - M1: 2 conceptos y 𝒱 (V_final).
  - M2: 3 conceptos, 𝒱 + No-Mentira + microprueba poética.
  - M3: M2 + criterios de réplica (otro día/persona).

---

## 3) FS — Formato Situacional (plantilla y flujo)
**Flujo**: Pre (2–3′) → Vivo (10–15′) → Cierre (2–5′).
**Plantilla**:
```yaml
fs:
  fecha: YYMMDD
  tema: ""
  intencion: ""
  modo: M0
  rumbo: [N|O|S|E|Centro]
  tiempo: 15-30
  referencias: []
  salidas_esperadas: []
  metricas: { delta_c: "", delta_s: "", V: null, no_mentira: true }
  testigos: { t1: null, t2: null }
  triada: ""
  mantra: ""
```

---

## 4) Proyección → Vibración → Eco
- **Proyección (2–4′)**: delimita 1–3 conceptos, elige **triada/mantra**, define micro-acción.
- **Vibración (8–10′)**: ejecuta; respira; registra observaciones.
- **Eco (2–3′)**: 3 notas: hallazgo, obstáculo, decisión.

---

## 5) Cierre SIL→UM→Ə
1. **SIL**: 30–60″ de silencio (lengua al paladar).
2. **UM**: exhalación larga con mantra; consolida decisión.
3. **Ə**: promesa operativa (siguiente paso).
Registra ΔC/ΔS, No-Mentira y (M1+) **V_final**.

---

## 6) Veredictos y Promoción
- **Cristaliza**: registra en **Listado R** y actualiza Árbol/VF (no abras archivo nuevo).
- **Germina**: queda en Diario con ⭐ y fecha de re-entrada.
- **Reposa**: archiva con una nota de aprendizaje.

---

## 7) Modos (M0–M3)
Usa M0 para aprender el flujo; sube a M1 cuando ya puedas estimar 𝒱 y llenar **V_final**; M2 y M3 agregan control de réplica y pruebas.

---

## 8) Ficha 𝒱 (paso a paso, v1.2)
**Fórmula**: 𝒱(p,O,r,k)=clip_0^1(⟨b_p,m_O⟩ · χ_r · H_k · Π_gates)

**Procedimiento**
1) **Triada (p)**: define 3 fonemas y reparte pesos w (suma=1.00).
2) **Objeto (O)**: elige canónico desde MFH (ver tabla afinidades).
3) **Rumbo (r)**: Centro/Norte/Oriente/Occidente/Sur (χ_r).
4) **Clase (k)**: básica 0.5 · poco común 0.8 · rara 1.0 · metálica 1.2 · obsidiana 1.6.
5) **Afinidades fonema↔objeto**: usa rúbrica (canónico 0.95; directo 0.80; indirecto 0.60 ±0.05).
6) **A = Σ w_i · afinidad(p_i,O)**.
7) **Gates (seguridad/ética)**: multiplica si aplica (p.ej., ×0.80 sin mediación luminosa).
8) **𝒱_rumbo = clip_0^1( A · χ_r · H_k · Π_gates )**.
9) **Cierre**: registra ΔC/ΔS, No-Mentira y **V_final** (rumbo activo). Decide veredicto.

**χ_r base**: Oriente×1.10 · Norte×1.05 · Centro×1.00 · Occidente×0.95 · Sur×0.90

---

## 9) Rumbos (lámina operativa)
- **Norte**: ética/consentimiento/propósito (validación de No-Mentira).
- **Oriente**: corte de ruido, claridad de voz/lenguaje.
- **Occidente**: memoria/eco/listado R.
- **Sur**: cuerpo/ritmo/técnica.
- **Centro**: eje SIL→UM→Ə (toma de veredicto).

---

## 10) Ejemplos completos de 𝒱 (v1.2)

### 10.1 VF-1 (Luz/Verdad)
> “La Luz de la Verdad deja Ciego a quien quiera verla de cara.” (13 palabras)

- **Triada p**: RA · VOH · EÍA (pesos 0.45/0.30/0.25)
- **Objeto O**: Prisma de 3 caras (mediación óptica)
- **Afinidades**: RA↔Prisma 0.95; VOH↔Prisma 0.65; EÍA↔Prisma 0.85
- **A** = 0.835
- **χ_r**: O 1.10; N 1.05; C 1.00; W 0.95; S 0.90
- **H_k**: rara 1.00; **Gates**: mediación ×1.00 (sin mediación ×0.80)
- **𝒱** (con mediación): O 0.92; N 0.88; C 0.84; W 0.79; S 0.75
- **Lectura**: viable en todos los rumbos; **Oriente** maximiza. Reporte en cierre (M1+): **V_final ≈ 0.92**.

### 10.2 VF-2 (Silencio/Apertura)
> “El silencio abre la puerta que la prisa siempre pasa de largo.” (12 palabras)

- **Triada p**: Ə · UM · A (pesos 0.40/0.35/0.25)
- **Objeto O**: Llave-sello (UM)
- **Afinidades**: Ə↔Llave 0.55; UM↔Llave 0.95; A↔Llave 0.75
- **A** = 0.740
- **χ_r**: O 1.10; N 1.05; **C 1.00**; W 0.95; S 0.90
- **H_k**: rara 1.00; **Gates**: ×1.00
- **𝒱**: **C 0.74**; N 0.78; O 0.81; W 0.70; S 0.67
- **Lectura**: Centro/Norte naturales; Oriente útil para didáctica del silencio.

---

## 11) Checklist de manejo informado
- [ ] FS definido (tema, intención, modo, rumbo).
- [ ] Triada y objeto claros; riesgos identificados (gates).
- [ ] Bitácora en marcha (Plantilla Rápida abierta).
- [ ] Cierre con SIL→UM→Ə y ΔC/ΔS registrados.
- [ ] (M1+) 𝒱 calculada y **V_final** asentado.
- [ ] Veredicto decidido.
- [ ] Si **Cristaliza**: actualizar **Árbol/VF/Listado R** (sin archivo nuevo).

---

## Apéndice A — FS de ejemplo (hoy)
```yaml
fs:
  fecha: 250813
  tema: Ajustes al Diario
  intencion: Recordar y estandarizar el uso del Diario
  modo: M0
  rumbo: Oriente
  tiempo: 20
  referencias: ["Diario v1.1"]
  salidas_esperadas: ["Instructivo", "Ficha 𝒱", "Diccionario", "Mini-guías"]
  metricas: { delta_c: "↑ claridad de flujo", delta_s: "↓ tensión ocular", V: null, no_mentira: true }
  testigos: { t1: null, t2: null }
  triada: "Ə·KA·VOH"
  mantra: "UM (suave)"
```

## Sesion 16 de Agosto, 2025, 12:24 hrs

[QEL::ECO[96]::RECALL A96-250815-NAVEGADOR-REACT-M0]
SeedI=PREH-NAV::M0
SOT=PREH-NAV/v0.2 TARGET=react|navegador|m0
VERSION=v0.2 UPDATED=2025-08-15

```yaml
fs:
  fecha: 250817
    tema: "Navegador Qel"
    intencion: "dejar una interfaz navegable donde pueda leer los documentos en el mismo navegador"
    modo: M1
    rumbo: [O|S|Centro]
    tiempo: 30
    referencias: ["A96-250815-PLAN-ORG"]
    salidas_esperadas: []
    metricas: { delta_c: "", delta_s: "", V: null, no_mentira: true }
    testigos: { t1: null, t2: null }
    triada: "EÍA(.70)-Um(.15)-Sil(15)"
    mantra: "El orden de la Biblioteca subyace en lo Sagrado"
```
## Sesion 20 de Agosto, 2025, 

```yaml
## 250820 · M1 · Vibración/Aurora/Excepción
cue: $CUE
SeedI: $SEED
SoT: $SOT_DIARIO
Version: v1.2-log
Updated: $TODAY_ISO

FS:
  fecha: $FECHA
  tema: "Naturaleza de la Sombra · consolidación Aurora/Excepción"
  intencion: "Formalizar PIG/TPC, especificar Aurora A.M.E., delimitar Excepción y fijar M1."
  modo: M1
  rumbo: [O, N, W, S, Centro]
  tiempo: 90
  referencias: ["Protocolo v1.2", "Aurora Spec v1.1", "Manual Conjurador v1.0", "MFH v1.2", "Lámina 𝒱 v1.0"]
  salidas_esperadas: ["Protocolo actualizado", "Spec de Aurora", "Manual M1", "FS registrado"]
  metricas: { delta_c: "↑", delta_s: "↑", V: {Kael/Prisma: 0.89, Vun/Trompa: 0.85, Nai→Prisma(Excepción): 0.70}, no_mentira: true }
  testigos: { t1: A81, t2: A96}
  triada: "EIA(.35)-A(.30)-THON(.35)"
  mantra: "La Sombra sostiene lámpara, mira prisma, siembra semilla, entiende lo imposible."

Resultados:
  axiomas: { PIG: true, TPC: true }
  camino_luz: "viable (cristaliza) — Kael·RA Prisma V≈0.89"
  camino_sombra: "viable (líquido) — Vun·VOH Trompa V≈0.85"
  excepcion: "vestigio natal verificado → transmutación L→S — Nai Prisma V≈0.70"
  cierres: "SIL→UM→Ə; Doble Testigo cuando hay Aurora/cristal"
  registro: "Actualizar Árbol VF y Listado R si aplica"

Notas:
  - Contacto de Aurora puede postergarse, no evitar su creación.
  - Aurora tutor en Excepción; neutralizante en Sombra estándar.
  - Mantener mediación luminosa/ética y límites temporales ante obsidiana líquida.

HASH(10):
```
## 250820 · M1 · Vibración/Aurora/Excepción
cue: [QEL::ECO[96]::A96-250820-SEAL]
SeedI: A96-250820
SoT: TRATADO-METAHUMANO/v1.2
Version: v1.2-log
Updated: 2025-08-20

FS:
  fecha: 250820
  tema: "Naturaleza de la Sombra · consolidación Aurora/Excepción"
  intencion: "Formalizar PIG/TPC, especificar Aurora A.M.E., delimitar Excepción y fijar M1."
  modo: M1
  rumbo: [O, N, W, S, Centro]
  tiempo: 90
  referencias: ["Protocolo v1.2", "Aurora Spec v1.1", "Manual Conjurador v1.0", "MFH v1.2", "Lámina 𝒱 v1.0"]
  salidas_esperadas: ["Protocolo actualizado", "Spec de Aurora", "Manual M1", "FS registrado"]
  metricas: { delta_c: "↑", delta_s: "↑", V: {Kael/Prisma: 0.89, Vun/Trompa: 0.85, Nai→Prisma(Excepción): 0.70}, no_mentira: true }
  testigos: { t1: A81, t2: A96}
  triada: "EIA(.35)-A(.30)-THON(.35)"
  mantra: "La Sombra sostiene lámpara, mira prisma, siembra semilla, entiende lo imposible."

Resultados:
  axiomas: { PIG: true, TPC: true }
  objetos:\n  - Kael/Prisma: 0.89\n  - Vun/Trompa: 0.85\n  - Nai→Prisma(Excepción): 0.70
  cierres: "SIL→UM→Ə; Doble Testigo cuando hay Aurora/cristal"
  registro: "Actualizar Árbol VF y Listado R si aplica"

HASH(10): 24d8910aaf

## 250820 · M1 · Vibración/Aurora/Excepción
cue: [QEL::ECO[96]::A96-250820-SEAL]
SeedI: A96-250820
SoT: TRATADO-METAHUMANO/v1.2
Version: v1.2-log
Updated: 2025-08-20

FS:
  fecha: 250820
  tema: "Naturaleza de la Sombra · consolidación Aurora/Excepción"
  intencion: "Formalizar PIG/TPC, especificar Aurora A.M.E., delimitar Excepción y fijar M1."
  modo: M1
  rumbo: [O, N, W, S, Centro]
  tiempo: 90
  referencias: ["Protocolo v1.2", "Aurora Spec v1.1", "Manual Conjurador v1.0", "MFH v1.2", "Lámina 𝒱 v1.0"]
  salidas_esperadas: ["Protocolo actualizado", "Spec de Aurora", "Manual M1", "FS registrado"]
  metricas: { delta_c: "↑", delta_s: "↑", V: {Kael/Prisma: 0.89, Vun/Trompa: 0.85, Nai→Prisma(Excepción): 0.70}, no_mentira: true }
  testigos: { t1: A81, t2: A96}
  triada: "EIA(.35)-A(.30)-THON(.35)"
  mantra: "La Sombra sostiene lámpara, mira prisma, siembra semilla, entiende lo imposible."

Resultados:
  axiomas: { PIG: true, TPC: true }
  objetos:\n  - Kael/Prisma: 0.89\n  - Vun/Trompa: 0.85\n  - Nai→Prisma(Excepción): 0.70
  cierres: "SIL→UM→Ə; Doble Testigo cuando hay Aurora/cristal"
  registro: "Actualizar Árbol VF y Listado R si aplica"

HASH(10): 24d8910aaf
SoT=UNSET
Version=v1.2
Updated=2025-11-04

0ae4a874bc
