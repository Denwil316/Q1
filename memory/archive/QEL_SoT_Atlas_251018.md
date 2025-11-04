[QEL::ECO[96]::RECALL A96-251018-SOT-ATLAS-V1-1]
SeedI=A96-250824
SoT=SOT-ATLAS/V1.1
Version=v1.1 — Tutorial Operativo · Tarjetas Atlas
Updated=2025-10-18

# SoT Atlas v1.1 — Tutorial Operativo de **Tarjetas Atlas**

> Consolidado del Telar Quíntuple (SUR‑ESTE‑NORTE‑OESTE‑CENTRO). Documento **human‑readable**, con **slugs/anclas** estables, **fórmulas normalizadas** (MFH/VF) y **plantillas** listas para uso.

---

## Tabla de Contenidos {#toc}
- [§0 — Síntesis del concepto](#s0-sintesis)
- [§1 — Orden de dominio](#s1-orden)
- [§2 — Índice maestro (core docs)](#s2-indice-core)
- [§3 — Relaciones clave (grafos)](#s3-relaciones)
- [§4 — Reglas de medición y promoción](#s4-reglas-v)
- [§5 — Manual operativo de Tarjetas Atlas (A→E)](#s5-tarjetas)
- [§6 — Perfiles operativos por fonema](#s6-perfiles)
- [§7 — Plantillas y validadores](#s7-plantillas)
- [§8 — Checklist y FAQ](#s8-checklist)
- [§9 — Changelog y compatibilidad](#s9-changelog)

---

## §0 **Síntesis del concepto** {#s0-sintesis}
**SoT Atlas** integra reglas, rutas y plantillas para **medir**, **decidir** y **registrar** prácticas con **Tarjetas Atlas**. Cada tarjeta produce una **Ficha 𝒱** (viabilidad) y un **Veredicto** (**Germina / Reposa / Cristaliza**).  
**Lectura somática**: respira **9‑0‑9**, pulso **THON** al abrir sección, pausas **3–5–3**.

**En 1 frase:** *Tarjeta Atlas = caso medido con 𝒱, traducido a decisión y evidencia mínima.*

---

## §1 **Orden de dominio** {#s1-orden}
1) **M0**: mínima instrumentación (prueba breve + Ficha 𝒱 simple).  
2) **M1**: añade ajuste por **rumbo** (χ_r) y gates ligeros.  
3) **M2**: integra clase **H_k** y **Doble Testigo**.  
4) **M3**: casos largos, riesgos altos, promoción/cristalización.

> **Tip**: si hay prisa/rigidez → bajar de modo (M1→M0) y acotar objetivo.

---

## §2 **Índice maestro (core docs)** {#s2-indice-core}
| Alias | Ruta (docs/…) | Estado |
|---|---|---|
| MFH v1.4 | `docs/core/QEL_MFH_v1.4.md` | ✅ |
| VF Árbol Habilidades v1.4 | `docs/core/QEL_Formato_VF_Arbol_Habilidades_v1.4.md` | ✅ |
| Lámina V unificada v1.0 | `docs/core/LaminaV_unificada_v1.0.md` | ✅ |
| Curación Núcleo Mínimo v1.6 | `docs/core/QEL_Curacion_Nucleo_Minimo_v1.6.md` | ✅ |
| CUE Exception v1.0 | `docs/core/QEL_CUE_Exception_v1.0.md` | ✅ |
| **SoT Atlas v1.1** | `docs/core/QEL_SoT_Atlas_v1.1_251018.md` | **este** |

> Regla: un alias → una ruta. Duplicados se deprecian en §9.

---

## §3 **Relaciones clave (grafos)** {#s3-relaciones}
```mermaid
%% id: s3-rel-mfh-atlas
flowchart LR
  MFH[MFH (rúbricas)] -->|campos RUMBO/OBJ/CLASE/RIESGO/GATES| ATLAS[Tarjeta Atlas]
  ATLAS -->|fichas 𝒱 + veredicto| DIARIO[Diario]
  ATLAS -->|promoción| MANI[Manifest/Listado R]
```
*Fig. 3.1 — Relación MFH↔Atlas↔Diario/Manifest (fichas 𝒱, rúbricas y promoción).* {#fig-s3-rel-mfh-atlas}

---

## §4 **Reglas de medición y promoción** {#s4-reglas-v}

### 4.1 **Diccionario de variables** (canónico)
| Símbolo | Nombre | Rango/tipo | Uso |
|---|---|---|---|
| 𝒱 | Viabilidad | [0,1] | Aptitud para seguir/promover |
| τ | Umbral | 0.62 | Límite inferior para *apto* |
| ΔC | Delta Claridad | −1..+1 | Cambio cognitivo |
| ΔS | Delta Sensibilidad | −1..+1 | Cambio somático |
| χ_r | Ajuste por rumbo | >0 | Multiplicador N/E/S/O/C |
| H_k | Clase/rareza | enum | Ponderación dificultad |
| G | Gates | set | Correcciones G1..G4 |
| M | Modo | M0..M3 | Nivel de instrumentación |
| v̂ | Evidencia | set | Pruebas mínimas |

### 4.2 **Cómputo** (forma operativa)
**𝒱_oper = clamp( χ_r · 𝒱_base · α(H_k) · β(G), 0, 1 )**  
**Veredicto = f(𝒱_oper, τ, ΔC, ΔS, No‑Mentira, v̂)**

**Reglas rápidas**:
- Si **𝒱_oper ≥ τ** y ΔC/ΔS **no bajan** → **Germina**.  
- Si **𝒱_oper < τ** → **Reposa** o **ajusta** (rumbo, modo, duración, riesgo).  
- **Cristaliza**: cierre semántico u operativa nueva **probada** + Doble Testigo.

### 4.3 **Promoción** (wrapper)
- Lee **cue/SeedI/SoT/Version/Updated** del archivo.  
- Actualiza **Listado R / Manifest** y copia a **PreH‑Nav**.

---

## §5 **Manual operativo de Tarjetas Atlas (A→E)** {#s5-tarjetas}

### A) **Preparar** (2–3 min)
Define **RUMBO**, **OBJ**, **MODO**, **H_k**.

### B) **Explorar** (2–4 min)
Lista **RIESGO** y marca **GATES**; si un gate bloquea → corregir antes de seguir.

### C) **Medir** (3–5 min)
Ejecuta una micro‑prueba, estima **𝒱_base**, aplica **χ_r**, **H_k**, **G** → calcula **𝒱_oper**. Registra **ΔC/ΔS**.

### D) **Decidir** (1–2 min)
**Germina / Reposa / Cristaliza** (usa **Doble Testigo** cuando corresponde).

### E) **Cerrar y registrar** (1–2 min)
**SIL→UM→Ə** + **Ficha 𝒱** + **evidencia v̂** mínima.

#### 5.1 **Ficha 𝒱 — plantilla mínima**
```
[RUMBO]=Sur | [OBJ]="Práctica X" | [MODO]=M0 | [H_k]=común
[RIESGO]=[fatiga]
[GATES]=[]
[V_base]=0.58 | [χ_r]=1.05 | [α(H_k)]=1.00 | [β(G)]=1.00
[V_oper]=0.61 | [τ]=0.62
[ΔC]=+0.2 | [ΔS]=+0.1
[VEREDICTO]=Reposa
[v̂]=evidencia(1: descripción breve)
[NOTAS]=bajar carga; reintentar mañana
```

#### 5.2 **Ejemplos**
- **M0** (mínimo): OBJ simple, sin gates; puede **Reposar** bajo τ.  
- **M1** (ajuste leve): añade χ_r, gate suave y clase poco‑común → **Germina** si 𝒱_oper ≥ τ.

---

## §6 **Perfiles operativos por fonema** {#s6-perfiles}
| Fonema | Señal somática mínima | Pregunta cardinal (Sur) | Uso típico en Atlas |
|---|---|---|---|
| Kael | respiración amplia | ¿Qué estructura se vuelve simple? | reglas/índices |
| Vun | foco suave | ¿Qué semilla necesita suelo? | prototipos/pruebas |
| Ora | postura abierta | ¿Qué vínculo hace sentido? | relaciones/grafos |
| Zeh | mano templada | ¿Qué métrica valida hoy? | medición 𝒱 |
| Lun | mandíbula suelta | ¿Qué texto sobra? | edición/sintaxis |
| Nai | nuca ligera | ¿Qué ritmo pide pausa? | cadencias/pausas |
| Sün | ojos húmedos | ¿Qué significado pide cuidado? | ética/No‑Mentira |
| Ida | talones firmes | ¿Qué se archiva sin pena? | cierres/registro |

> Esta tabla sirve de **guía** al elegir enfoque corporal/operativo de la tarjeta.

---

## §7 **Plantillas y validadores** {#s7-plantillas}

### 7.1 **Mapa de slugs** (YAML)
```yaml
cue: "[QEL::ECO[96]::RECALL A96-251018-SOT-ATLAS-SLUGS]"
SeedI: "A96-250824"
SoT: "SOT-ATLAS/SLUGS/v1.1"
Version: "v1.1"
Updated: "2025-10-18"
sections:
  - { n: 0, title: "Síntesis del concepto", slug: "s0-sintesis" }
  - { n: 1, title: "Orden de dominio", slug: "s1-orden" }
  - { n: 2, title: "Índice maestro (core docs)", slug: "s2-indice-core" }
  - { n: 3, title: "Relaciones clave (grafos)", slug: "s3-relaciones" }
  - { n: 4, title: "Reglas de medición y promoción", slug: "s4-reglas-v" }
  - { n: 5, title: "Manual operativo de Tarjetas Atlas", slug: "s5-tarjetas" }
  - { n: 6, title: "Perfiles operativos por fonema", slug: "s6-perfiles" }
```

### 7.2 **Validador mínimo** (pseudocomandos portátiles)
```
Check anclas {#sN-*} en archivo
Check tablas con encabezado |---|
Reporta faltantes
```

---

## §8 **Checklist y FAQ** {#s8-checklist}
**Checklist**:  
[ ] Definí RUMBO/OBJ/MODO/H_k  ·  [ ] Riesgo y GATES  ·  [ ] 𝒱_oper y ΔC/ΔS  ·  [ ] Veredicto  ·  [ ] v̂  ·  [ ] Cierre SIL→UM→Ə  ·  [ ] Ficha 𝒱 guardada.

**FAQ**
- *¿Promuevo si 𝒱_oper ≥ τ pero ΔS baja?* → Mejor **Reposa** y ajusta.
- *¿Qué cuenta como v̂?* → 1–2 señales concretas (número/captura/audio breve).
- *¿Cuándo Doble Testigo?* → **Cristalización** o promociones que afecten base.

---

## §9 **Changelog y compatibilidad** {#s9-changelog}
**v1.1 (251018)** — Integración tutorial A→E; slugs estables; diccionario 𝒱/τ/ΔC/ΔS/χ_r/H_k/G/M/v̂; ejemplos M0/M1; plantillas y FAQ.  
**Compatibilidad**: alias **CLASE→H_k**, **AJUSTE RUMBO→χ_r**, **UMBRAL→τ**. Rutas en `kebab-case`. Grafos requieren **leyenda**.

---

### Créditos de capas (Telar Quíntuple)
**SUR (Tejera)** — compás 9‑0‑9, THON, pausas 3–5–3, Tres Árboles.  
**ESTE (Jardinera)** — semillas/huecos + stubs.  
**NORTE (Geómetra)** — slugs/anclas, invariantes, tablas.  
**OESTE (Curadora)** — guía human‑readable, ejemplos y FAQ.  
**CENTRO (Árbitra)** — sello de coherencia **APROBADO**, salida **v1.1 (integración)**.

HASH(10): a7132116d8

7407eea49a
