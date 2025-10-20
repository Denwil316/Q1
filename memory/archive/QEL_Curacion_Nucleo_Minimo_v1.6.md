cue: "[QEL::ECO[96]::RECALL A96-251008-CURADURIA-NUCLEO-MINIMO]"
SeedI: "A96-250824"
SoT: "CURADURIA/v1.0"
Version: "v1.6"
Updated: "2025-10-08"

# Curación del Repositorio QEL — **Núcleo Mínimo** (≤20 docs)

> **Rol**: Curadora (Árbitra). **Objetivo**: consolidar el material cargado, compararlo con el **Códice Madre** y definir un **conjunto núcleo** de documentos —con decisiones claras: **conservar, fusionar o archivar**— para trabajar con mayor libertad operativa.

---

## Capa SUR — Tejera (cuerpo/ritmo) · 2025-10-08

> Entregable: **Capa SUR** marcada y fechada con ajustes de legibilidad corporal, micro‑ritmos de lectura y **ejemplos mínimos operables**.

### Compás respiratorio y pulso de lectura
- **Compás 9‑0‑9**: 9 latidos/respiraciones leyendo → 0 (vacío, 1–2 s) → 9 sintetizando en voz baja.  
- **Pulso THON**: marcar mentalmente **TH‑ON** al comenzar cada subsección; cerrar con **TH‑OFF** sólo tras la pregunta de veredicto (*¿qué se promueve, qué se depreca, qué se archiva?*).
- **Pausas 3–5–3**: 
  - **3** frases (≈90–150 palabras) → pausa suave (1 s).  
  - **5** frases (≈180–250 palabras) → pausa media (2 s).  
  - **3** frases de cierre con un **verbo operativo** (p.ej., *conservar/fusionar/integrar*).

### Tres Árboles en clave somática
1. **Árbol de Frutos (fonemas de sombra)**  
   - Identifica en cada sección **potenciales de sombra** (desbordes, duplicación, ambigüedad).  
   - Anota *frutos‑sombra* como `⟦fonema⟧: síntoma somático breve` (p.ej., `⟦Lun⟧: tensión en mandíbula → revisar redundancia`).
2. **Árbol de Huecos (geometría)**  
   - Señala **huecos geométricos**: listas sin rúbrica, rutas sin índice, anexos sin destino SoT.  
   - Marca cada hueco con `◆(nodo): destino → (Glosario | VF | Atlas | Libro de Sombras | Códice)`.
3. **Árbol de Semillas‑Nombre**  
   - Extrae **semillas** candidatas a glosario/ejercicio/tarjeta como `»semilla :: breve definición :: destino SoT`.

### Ajustes de legibilidad corporal
- Longitudes objetivo: **párrafos 3–5 líneas**; listas ≤7 ítems; títulos con **verbo**.  
- Inserta **preguntas cardinales** al final de cada bloque (una línea).  
- Evita bloques >250 palabras sin pausa 3–5–3.  
- **Rutas internas**: siempre al inicio del bloque (p.ej., *ver §5.2 Manual Operativo*).

### Ejemplos mínimos operables
- **Para Códice Madre**: al presentar el *núcleo (5)*, aplicar 1 ciclo **9‑0‑9** leyendo la Ficha‑𝒱 de una tarjeta; registrar 1 **fruto‑sombra** y 1 **hueco geométrico**.
- **Para Libro de Sombras**: al citar CUE‑EXCEPTION, ejecutar **pausa 0** de 2 s antes de resolver Gate; anotar semilla `»retorno desde Ə :: plantilla UM→Ə→UM :: Libro de Sombras`.

> **Nota de implementación**: esta Capa SUR se hereda en los futuros *Manual Operativo* y *Libro de Sombras* como *plantilla de micro‑ritmo*.

### Aplicación SUR — marcas en este documento
**Árbol de Frutos (fonemas de sombra)**
- ⟦Lun⟧: Riesgo de redundancia entre **Manual Operativo** (cap. Lámina 𝒱) y **Lámina V — Unificada** (sección §3 y §5.2.3). → **Acción**: fusionar contenidos técnicos en un único capítulo y referenciar como anexo (ver §5.2).
- ⟦Nai⟧: Ambigüedad en conteo **12/20 vs ≤20 docs** (cabecera). → **Acción**: mantener **12/20** como estado actual y usar **≤20** solo como límite.
- ⟦Sün⟧: Duplicidad de rol en cabecera (“Curadora (Árbitra)”). → **Acción**: dejar “Curadora” aquí; “Árbitra” actúa en §Centro.

**Árbol de Huecos (geometría)**
- ◆(Rutas internas): faltan anchors explícitos para §4.2, §5.2 y §5.4. → **Destino**: **Manual Operativo** (índice).
- ◆(Ficha‑𝒱 riesgo): no hay plantilla mínima. → **Destino**: **Libro de Sombras** (plantillas).
- ◆(Promoción automática): falta ejemplo de wrapper que actualice Manifest/ListadoR. → **Destino**: **Manual Operativo** (Gobernanza).

**Árbol de Semillas‑Nombre**
- »ficha‑𝒱‑riesgo :: checklist de seguridad :: **Libro de Sombras**
- »wrapper‑promoción :: here‑doc bash :: **Manual Operativo**
- »tarjeta‑auto‑PE :: esquema YAML exportable :: **Códice Madre**
- »índice‑semillas‑VF :: tabla semillas↔clase↔rumbo :: **MFH/VF**

### Guía de preguntas cardinales (aplicar al final de cada bloque)
- ¿Qué se **promueve**?
- ¿Qué se **depreca**?
- ¿Qué se **archiva**?

---

## 1) Criterios de curación
- **Primacía del Códice Madre** como *fuente operativa* y marco de VCALC‑UNIFIED.
- **5 fundamentales** (ver §2) + **soportes de sistema** (glosario, índice, formatos, manifiesto).
- **Menos es más**: evitar duplicaciones; integrar anexos (poemas, meditaciones, sellos) dentro de los fundamentales.
- **Operatividad**: todo doc núcleo debe habilitar práctica, medición (**𝒱**) o gobernanza (Listados/Manifiestos).

---

## 2) **Arquitectura de los 5 fundamentales**
1. **Códice Madre** — *motor operativo unificado* (Tarjetas Maestras, invariantes 𝒱, paletas cardinales, Ficha 𝒱↔scripts).
2. **Manual Operativo** — *cómo usar QEL de punta a punta* (ontología QEL, Lámina 𝒱, SoT/Atlas de flujos, gobernanza de sesión y publicación).
3. **Matriz Fonémica de Habilidades (MFH)** — *teclado y mapeos fonema↔objeto↔rumbo↔clase* con regla 𝒱 y rúbrica de afinidades.
4. **Libro de Sombras** — *seguridad, ética, excepciones* (Tratado Metahumano + CUE‑EXCEPTION + Aurora Spec + casuística Poema/Meditaciones).
5. **Listado R (maestro)** — *trazabilidad* (versiones, hash10, referencias y promoción/publicación).

> **Regla**: el resto de archivos actúan como **anexos internos** o **fuentes** de estos 5.

---

## 3) **Lista Núcleo Mínimo propuesta (12 docs)**

1) **Códice Madre — Tarjetas Maestras (UNIFICADO)**  
   *Acción*: **Conservar** (ancla).  
   *Integra*: Tarjetas Atlas + Ficha 𝒱, paletas, preguntas cardinales.  
   *Rutas*: §4.1 para detalles.

2) **Manual Operativo QEL (Compilado)**  
   *Acción*: **Fusionar** en un solo doc a partir de: **QEL.md**, **Lámina V Unificada**, **SoT_Atlas**, **Manual de Esculpido** y el **Formato VF/Árbol**.  
   *Rutas*: §4.2 (mapeo de capítulos).

3) **MFH — Matriz Fonémica de Habilidades (v1.4+)**  
   *Acción*: **Conservar** como doc independiente (tabla y reglas).  
   *Rutas*: §4.3.

4) **Libro de Sombras (Compilado)**  
   *Acción*: **Fusionar**: **Tratado Metahumano v1.5** + **CUE‑EXCEPTION v1.0** + **Aurora Spec v1.2** + *cápsulas* (Poema‑Enigma, Meditaciones, Sellos/Cues) como anexos.  
   *Rutas*: §4.4.

5) **Listado R — Maestro**  
   *Acción*: **Conservar**; convertir en **autoridad** junto con **SoT Manifest (JSON)** como índice de máquina.  
   *Rutas*: §4.5.

6) **Glosario v1.4+**  
   *Acción*: **Conservar** como soporte central (lengua común).  
   *Nota*: enlazar mini‑Lámina 𝒱.

7) **Formato VF & Árbol de Habilidades**  
   *Acción*: **Conservar** (registro y promoción).  
   *Nota*: se cita desde Manual Operativo; evita duplicar.

8) **SoT Manifest (v0.8+)**  
   *Acción*: **Conservar** (JSON) como índice de sistema; automatiza publicación.

9) **Lámina V — Unificada**  
   *Acción*: **Integrar** como **capítulo** del Manual Operativo + **Anexo técnico**.

10) **SoT Atlas (v1.0)**  
   *Acción*: **Integrar** al Manual Operativo (flujos, fichas, plantillas).

11) **Poema‑Enigma (VF) — Base**  
   *Acción*: **Integrar** en **Libro de Sombras** (cuerpo ritual) y **Códice Madre** (tarjetas auto‑PE).

12) **Meditaciones (Primordiales + Reiteración Lun‑Nai)**  
   *Acción*: **Integrar** en **Libro de Sombras** (prácticas y métricas).

> Con esto quedamos en **12/20**. Los demás se absorben como **anexos internos** de los 5 fundamentales.

---

## 4) Decisiones por documento (Conservar / Fusionar / Integrar / Archivar)

> Formato: **[Archivo] — Acción** · *Razón breve* · *Destino (si fusiona/integran)*.

- **Qel_Codice_Madre.md** — **Conservar** · Estado unificado; invariantes 𝒱; Tarjetas Maestras y Ficha 𝒱. · *Pieza ancla*.
- **QEL.md** — **Fusionar** · Ontología, máquina 0/1/9, Idriell, equivalencias. · → **Manual Operativo**.
- **LaminaV_unificada_v1.0.md** — **Integrar** · Procedimiento VCALC‑UNIFIED, compás, plantillas. · → **Manual Operativo** (cap. Lámina 𝒱 + anexo técnico).
- **QEL_SoT_Atlas_v1.0_250826.md** — **Integrar** · Ruta didáctica, relaciones y flujos Atlas. · → **Manual Operativo** (cap. SoT/Atlas).
- **QEL_Manual_Esculpido_en_Qel_v1.0.md** — **Integrar** · Telar Quíntuple, wrapper de promoción. · → **Manual Operativo**.
- **QEL_Formato_VF_Arbol_Habilidades_v1.4.md** — **Conservar** · Campos VF/Árbol; elegibilidad y vínculos. · *Referencia de registro*.
- **QEL_MFH_v1.4.md** — **Conservar** · Rúbrica p↔objeto↔rumbo↔clase; 𝒱≥0.62. · *Teclado operativo*.
- **QEL_Tratado_Metahumano_v1.5.md** — **Fusionar** · Principios, ciclo P‑V‑E, checklists. · → **Libro de Sombras**.
- **QEL_CUE_Exception_v1.0.md** — **Fusionar** · Gates G1..G4; procedimiento. · → **Libro de Sombras**.
- **QEL_Aurora_Spec_v1.2.md** — **Fusionar** · Modos neutralizante/tutor; operación por rumbos. · → **Libro de Sombras**.
- **QEL_Poema_Enigma_VF_v1.0.md** — **Integrar** · Gramática PE y ejemplo. · → **Libro de Sombras** (anexo ritual) y **Códice Madre** (PE auto por tarjeta).
- **QEL_Poema_Enigma_Lun-Nai_v1.1.md** — **Integrar** · Instancia Occidente (Ə/Lago) con notas. · → **Libro de Sombras** (casuística).
- **QEL_Meditaciones_Primordiales_v1.0.md** — **Integrar** · Cámara Uno; métricas y VF canónica. · → **Libro de Sombras**.
- **QEL_Meditacion_Reiteracion_Lun-Nai_v1.1.md** — **Integrar** · Protocolo de reiteración con PE. · → **Libro de Sombras**.
- **QEL_Sellos_y_Cues_Idriell_v1.0.md** — **Integrar** · Registro de sellos, 𝒱 por rumbo, Cues del sistema. · → **Libro de Sombras** (anexo) y **Manual Operativo** (tabla rápida).
- **QEL_Glosario_v1.4.md** — **Conservar** · Lengua común + mini‑Lámina 𝒱. · *Soporte transversal*.
- **QEL_ListadoR_master_v1.0.md** — **Conservar** · Autoridad de trazas; hash10. · *Gobernanza*.
- **QEL_SoT_Manifest_v0.8.json** — **Conservar** · Índice de máquina; seed/SoT/version. · *Gobernanza*.

---

## 5) Mapa de fusión (cómo quedaría cada fundamental)

### 5.1 Códice Madre (UNIFICADO)
**Contiene**: Tarjetas Maestras (8 fonemas + 12 tríadas), Ficha 𝒱 por tarjeta, paletas cardinales, preguntas cardinales, hooks a scripts (VCALC‑UNIFIED / LL‑PE), capa Sur/Este/Norte.

### 5.2 Manual Operativo (Compilado)
**Capítulos sugeridos**:
1. **Ontología & Máquina 0/1/9** (desde *QEL.md*).  
2. **Lengua Idriell (performatividad)** (desde *QEL.md*).  
3. **Lámina 𝒱 (procedimiento & plantillas)** (desde *Lámina V*).  
4. **SoT/Atlas (flujos, orden de dominio)** (desde *SoT_Atlas*).  
5. **Gobernanza documental** (desde *Manual de Esculpido* + *SoT Manifest/ListadoR*).  
6. **Formato VF/Árbol** (como apéndice operable).  

### 5.3 MFH
**Secciones**: Fundamento formal, firma elemental (12 semillas), clases y dureza, regla de compatibilidad, vista Árbol.

### 5.4 Libro de Sombras (Compilado)
**Partes**:
- **Tratado Metahumano** (principios, ciclo P‑V‑E, incidentes).  
- **CUE‑EXCEPTION** (G1..G4, plantilla) y **Aurora Spec** (modos y parámetros).  
- **Casuística**: Poema‑Enigma (general + Lun‑Nai), Meditaciones (Cámara Uno + Reiteración), Sellos & Cues.  
- **Plantillas**: ECO (delta‑only), checklist de cierre, Ficha 𝒱 riesgo.

### 5.5 Listado R (maestro) + SoT Manifest
**Uso**: autoridad de versiones y publicación; puente con scripts de render, hash10 y promoción.

---

## 6) Cuadro de trazabilidad (doc → fundamental)

| Documento | Acción | Fundamental destino |
|---|---|---|
| Qel_Codice_Madre.md | Conservar | Códice Madre |
| QEL.md | Fusionar | Manual Operativo |
| LaminaV_unificada_v1.0.md | Integrar | Manual Operativo |
| QEL_SoT_Atlas_v1.0_250826.md | Integrar | Manual Operativo |
| QEL_Manual_Esculpido_en_Qel_v1.0.md | Integrar | Manual Operativo |
| QEL_Formato_VF_Arbol_Habilidades_v1.4.md | Conservar | Manual Operativo (apéndice) |
| QEL_MFH_v1.4.md | Conservar | MFH |
| QEL_Tratado_Metahumano_v1.5.md | Fusionar | Libro de Sombras |
| QEL_CUE_Exception_v1.0.md | Fusionar | Libro de Sombras |
| QEL_Aurora_Spec_v1.2.md | Fusionar | Libro de Sombras |
| QEL_Poema_Enigma_VF_v1.0.md | Integrar | Libro de Sombras |
| QEL_Poema_Enigma_Lun-Nai_v1.1.md | Integrar | Libro de Sombras |
| QEL_Meditaciones_Primordiales_v1.0.md | Integrar | Libro de Sombras |
| QEL_Meditacion_Reiteracion_Lun-Nai_v1.1.md | Integrar | Libro de Sombras |
| QEL_Sellos_y_Cues_Idriell_v1.0.md | Integrar | Libro de Sombras |
| QEL_Glosario_v1.4.md | Conservar | (Soporte transversal) |
| QEL_ListadoR_master_v1.0.md | Conservar | Listado R |
| QEL_SoT_Manifest_v0.8.json | Conservar | Listado R / Sistema |

---

## 7) Resúmenes ejecutivos por documento (1–3 párrafos)
> **Nota**: Estos resúmenes son operativos; omiten citas por brevedad. Fuente y detalle se mantienen en los archivos originales.

### 7.1 Qel_Codice_Madre.md — Códice Madre UNIFICADO
- Presenta las **Tarjetas Maestras** (8 fonemas base + 12 tríadas) con **Ficha 𝒱** integrada, paletas de **color‑luz/sombra**, **preguntas cardinales**, y **hooks** a `qel_vcalc.sh` y `qel_pe_generate.mjs`. Fija la **fórmula 𝒱** (canónica×operativa) y el **umbral τ=0.62**. Capa Sur/Este/Norte documenta compás somático, semillas/huecos y mapeos Ficha 𝒱 → VCALC.
- Es el **núcleo operable** del sistema; ya incorpora Poemas‑Enigma auto y estructura para impresión.

### 7.2 QEL.md — Ontología y Arquitectura mitopoética
- Define QEL como **compás** I×S→T, los **tres planos** (Rito/Número/Lengua), la **máquina 0/1/9** (portales 9+0 y 0+9), los **agentes** (Lýmina, Tejera, etc.) y la **performatividad** de Idriell con los **Ocho Fonemas Base**. Incluye protocolos (Saludo‑conjuro, Colapso Lúdico) y equivalencias entre planos.
- Es base doctrinal y pasa a **Manual Operativo**.

### 7.3 LaminaV_unificada_v1.0.md — Lámina 𝒱 Unificada
- Unifica Lámina V con **MFH v1.4** y **VCALC**; define compás (9‑0‑9, THON, 3–5–3), reglas cardinales, plantillas de **bitácora** (TSV/JSONL) y guía de **clase (H_k)** y alias compatibles. Incluye ejemplos calculados y guías de ΔC/ΔS/ρ.
- Funciona como **capítulo** y **anexo técnico** del Manual Operativo.

### 7.4 QEL_SoT_Atlas_v1.0_250826.md — SoT/Atlas
- Mapa de **orden de dominio**, índice maestro de core docs, **relaciones clave** entre Atlas↔(Glosario, MFH, Lámina 𝒱, Diario), flujos de **promoción** y **veredicto**, y reglas de medición (umbral 𝒱≥0.62). Incluye **plantilla Ficha 𝒱** y paquetes de *Tarjetas Atlas*.
- Se **integra** al Manual Operativo.

### 7.5 QEL_Manual_Esculpido_en_Qel_v1.0.md — Esculpido
- Describe el **Telar Quíntuple**, cabeceras y **wrapper** de promoción (actualiza Manifest y Listado R). Aporta gobernanza documental.
- Se integra al Manual Operativo (cap. gobernanza).

### 7.6 QEL_Formato_VF_Arbol_Habilidades_v1.4.md — VF/Árbol
- Especifica **campos VF**, **rutas** de árbol, instrumentos y elegibilidad. Mantiene independencia para registro y promoción.

### 7.7 QEL_MFH_v1.4.md — Matriz Fonémica de Habilidades
- Modelo formal **x=(M,I,S,C)**, **firma elemental (12 semillas)**, **clases/dureza**, y **regla de compatibilidad** con **𝒱≥0.62**. Base para cálculos y diseño de habilidades.

### 7.8 QEL_Tratado_Metahumano_v1.5.md — Tratado
- Principios fundadores (T_p, Conservación de Coherencia, Puertas de Rumbo, Doble Testigo, etc.), ciclo **Proyección–Vibración–Eco**, listas de verificación e incidentes A/B/C.
- Núcleo del **Libro de Sombras**.

### 7.9 QEL_CUE_Exception_v1.0.md — Excepción
- **Gates G1..G4**, plantilla de retorno desde **Obsidiana Líquida**, y procedimiento con **UM→Ə→UM**.
- Núcleo del **Libro de Sombras**.

### 7.10 QEL_Aurora_Spec_v1.2.md — Aurora
- Definición, **modos** (neutralizante/tutor), operación por **rumbos** y parámetros (latencia, ventana, tolerancia ética). Complemento de seguridad.

### 7.11 QEL_Poema_Enigma_VF_v1.0.md — Poema base
- Gramática **INVOCACIÓN–UMBRAL–PISTA–SILENCIO–PRUEBA** y ejemplo de uso con 𝒱≥0.62.

### 7.12 QEL_Poema_Enigma_Lun-Nai_v1.1.md — Instancia
- Caso **Ə/Lago/Occidente** con notas de activación (≤9 palabras), doble testigo y *ECO delta‑only*.

### 7.13 QEL_Meditaciones_Primordiales_v1.0.md — Cámara Uno
- Secuencia de **siete pasos**, mantras, métricas QEL, VF canónica, y plantilla de registro.

### 7.14 QEL_Meditacion_Reiteracion_Lun-Nai_v1.1.md — Reiteración
- Protocolo de práctica con **Poema‑Enigma** (apertura/cierre, respiración, medición 𝒱 y EÍA).

### 7.15 QEL_Sellos_y_Cues_Idriell_v1.0.md — Sellos & Cues
- Definición de sellos, **ejemplos** calculados (A y B con 𝒱 por rumbo), índice de viabilidad y **Cues** del sistema.

### 7.16 QEL_Glosario_v1.4.md — Glosario
- Vocabulario mínimo y mini‑Lámina 𝒱 de consulta rápida.

### 7.17 QEL_ListadoR_master_v1.0.md — Listado R
- Historial, *hash10*, y entradas de cristalización; autoridad de versiones.

### 7.18 QEL_SoT_Manifest_v0.8.json — Manifest
- Índice de máquina de core‑docs: seed/SoT/version/updated, para consumo por navegadores/scripts.

---

## 8) Tareas de consolidación (operativas)
1. **Compilar Manual Operativo** (capítulos §5.2) y mover Lámina/Atlas/Esculpido como capítulos/anexos.  
2. **Compilar Libro de Sombras** (partes §5.4) con anexos rituales.  
3. **Actualizar Manifest/Listado R** tras consolidación.  
4. **Vincular** Glosario y Formato VF desde Manual/Códice.  
5. **Revisar** consistencia de `χ_r/H_k` en Códice Madre (Ida E→S) y contraste cromático (banda W).

---

## 9) Notas finales
- Con esta curación, el **espacio documental** queda en **12** piezas núcleo (≤20), con **5 fundamentales** como ejes.  
- Las prácticas (Poema, Meditaciones, Sellos) quedan **habitando** el *Libro de Sombras* y **operando** desde el *Códice Madre*.


---

## Apéndice — Registro breve de cambios (Templado por Roles)
- **v1.1 — Tejera (Sur)** · Añadida **Capa SUR** con compás **9‑0‑9**, pulso **THON**, pausas **3–5–3**, y los **Tres Árboles** (Frutos/fonemas de sombra, Huecos geométricos, Semillas‑nombre). Ajustes de legibilidad y ejemplos operables.
- **v1.2 — Tejera (Sur)** · **Marcas aplicadas** en el documento (Frutos/Huecos/Semillas) y **guía de preguntas cardinales** para cierre por bloque; sin cambios estructurales.
- **v1.3 — Jardinera (Este)** · **Capa ESTE** añadida: *semillas‑nombre* (tabla con destino SoT), propuestas de expansión y **Notas para Glosario** con plantilla here‑doc.
- **v1.4 — Geómetra (Norte)** · **Capa NORTE**: verificación de invariantes (𝒱, τ, ΔC/ΔS/ρ), corrección de índices/rutas, y **Guía exprés de llenado** + **Ejemplo mínimo** (Glosario, Tarjeta auto‑PE y VF/Árbol).



---

### Capa ESTE — Jardinera (semilla/concepto)
Fecha: 2025-10-08

> Entregable: **lista de semillas** con destino SoT (Glosario, VF, Atlas/Manual/Libro de Sombras) y propuestas de expansión.

#### Semillas‑nombre (lista con destino SoT)
| Semilla | Descripción breve | Destino SoT | Relación (χ_r / H_k / 𝒱) | Ejercicio mínimo |
|---|---|---|---|---|
| compás **9‑0‑9** | respiración/lectura en 3 fases | Manual, Códice | χ_r, 𝒱 | leer una Tarjeta con 9‑0‑9 |
| **pausas 3–5–3** | micro‑ritmo de cierre/apertura | Manual | χ_r | marcar silencios al leer |
| **pulso THON** | pulso somático de lectura | Manual | χ_r | 3 ciclos antes de un PE |
| **τ=0.62** (umbral) | criterio de elegibilidad 𝒱 | Glosario, Manual | 𝒱 | validar 1 objeto ≥0.62 |
| **ΔC / ΔS** | deltas de cambio/estabilidad | Manual, Glosario | 𝒱 | registrar deltas tras práctica |
| **ρ** (densidad) | compacidad del diseño | Manual | 𝒱 | calcular ρ en una Tarjeta |
| **χ_r** (rumbo) | color/rumbo cardinal | Códice, Glosario | χ_r | identificar rumbo de una Tarjeta |
| **H_k** (clase) | dureza/afinidad por clase | MFH, VF, Glosario | H_k | asignar clase a 1 habilidad |
| **Triada (12)** | familia de resonancia | Atlas, Glosario | χ_r/H_k | ubicar triada de 1 objeto |
| **Firma elemental (12)** | semillas base | MFH, Glosario | H_k | mapear 1 objeto→semilla |
| **tarjeta‑auto‑PE (YAML)** | plantilla exportable | Códice | χ_r/H_k | generar YAML de 1 tarjeta |
| **wrapper‑promoción (bash)** | here‑doc de publicación | Manual | 𝒱 | simular 1 promoción mock |
| **ficha‑𝒱‑riesgo** | checklist de seguridad | Libro de Sombras | 𝒱 | completar checklist por objeto |
| **Gates G1..G4** | escalera de excepción | Libro de Sombras | χ_r | elegir gate para un caso |
| **Aurora (neutralizante/tutor)** | modos de corrección | Libro de Sombras | χ_r/𝒱 | decidir modo para evento |
| **Doble Testigo** | validación cruzada | Libro de Sombras | 𝒱 | buscar 2da evidencia |
| **SIL→UM→Ə** | cierre seguro | Códice, Libro Sombras | χ_r/𝒱 | ejecutar cierre guiado |
| **VOH/EÍA** | evidencias de práctica | Manual, Glosario | 𝒱 | adjuntar 1 VOH/EÍA mínima |
| **Índice‑semillas‑VF** | tabla semillas↔clase↔rumbo | MFH/VF | H_k | completar fila de ejemplo |

#### Propuestas de expansión (sub‑secciones, ejercicios y tarjetas)
- **Códice Madre**
  - *Sub‑sección*: **Tarjeta auto‑PE (YAML)** con 1 ejemplo por fonema.
  - *Ejercicio*: lectura **9‑0‑9** + **3–5–3** por tarjeta; registrar VOH/EÍA.
  - *Tarjetas*: **Mini‑fichas** “τ‑check” (semáforo 𝒱) y “χ_r/H_k” (color+clase).
- **Manual Operativo**
  - *Sub‑sección*: **Wrapper de Promoción** (here‑doc bash) que actualiza Manifest/ListadoR.
  - *Sub‑sección*: **Ficha‑𝒱‑riesgo** (plantilla) y **tabla ΔC/ΔS/ρ**.
  - *Ejercicios*: 3 casos guiados (apto/no‑apto; excepción; aurora‑tutor).
- **MFH / VF**
  - *Sub‑sección*: **Índice‑semillas‑VF** con vista Árbol por triada.
  - *Ejercicio*: clasificar 3 habilidades nuevas (χ_r, H_k, τ) y validar 𝒱.
- **Libro de Sombras**
  - *Sub‑sección*: **Casuística de Gates** (G1..G4) con PE mínimo.
  - *Ejercicio*: decidir **Aurora** (neutralizante/tutor) para 2 incidentes tipo.
- **Atlas (SoT)**
  - *Sub‑sección*: **Mapa semántico** de semillas (enlaces entre fundamentales).

---

### Notas aparte — **Glosario más descriptivo** (Jardinera/Este)
> Propuesta de enriquecimiento por entrada; no altera el Glosario original todavía.

**Campos sugeridos por término**
- **Definición operativa** (≤30 palabras) y **ámbito** (ritual / métrica / gestión / arte / software).
- **Somática** (señales corporales + respiración sugerida 9‑0‑9) y **gesto** (si aplica).
- **Métrica asociada**: 𝒱, τ, ΔC, ΔS, ρ; **umbrales** relevantes.
- **Rumbo χ_r**, **Clase H_k**, **Tríada relacionada**.
- **Uso mínimo** (≤2 líneas) + **Ejemplo** (≤1 verso o una fórmula).
- **Antónimo / Sombra** y **Riesgos + CUE** (gate sugerido).
- **Cruces** (*ver también*), **Alias & pronunciación Idriell**, **Errores comunes**.

**Micro‑plantilla (here‑doc) para nuevas entradas**
```bash
cat > docs/core/glosario/TERMINO.md <<'GLOSA'
cue: "[QEL::ECO[96]::RECALL A96-251008-GLOSA-SEED]"
SeedI: "A96-250824"
SoT: "GLOSARIO/SEED/v1.0"
Version: "v1.0"
Updated: "2025-10-08"

# TERMINO
**Definición operativa (≤30 palabras):**
**Ámbito:** ritual | métrica | gestión | arte | software
**Somática / respiración (9‑0‑9):**
**Métrica asociada:** 𝒱= ; τ=0.62 ; ΔC= ; ΔS= ; ρ=
**Rumbo χ_r:** ; **Clase H_k:** ; **Tríada:**
**Uso mínimo (≤2 líneas):**
**Ejemplo (≤1 verso/fórmula):**
**Antónimo/Sombra:** ; **Riesgos + CUE (gate):**
**Cruces (ver también):**
**Alias & pronunciación Idriell:**
**Errores comunes:**
GLOSA
```

> Nota: esta plantilla es *sugerida* para hacer el Glosario más **descriptivo y accionable**; puede integrarse en lote o por demanda.



---

### Capa NORTE — Geómetra (estructura/número)
Fecha: 2025-10-08

> Entregable: **estructura verificada** (𝒱, índices, rutas internas) + **Guía exprés de llenado** con **ejemplo mínimo**. Enfasis en consistencia con **MFH/VF** y con la **Lámina 𝒱**.

#### 1) Checklist de invariantes
- **𝒱**: se evalúa con la **Lámina 𝒱** (mantener fórmula canónica; no duplicar en este doc). Umbral **τ=0.62** (apto). 
- **ΔC / ΔS / ρ**: presentes en Ficha‑𝒱; usar definiciones operativas existentes (sin re‑definir aquí).
- **χ_r / H_k / Tríada / Semilla(12)**: verificar mapeos con **MFH**; evitar nuevas taxonomías.
- **Índices y numeración**: títulos con slug `## 5.2 Manual Operativo …` y referencias internas `→ (§5.2)`.
- **Rutas internas (SoT)**: normalizar rutas tipo `docs/core/...` y señalar anexos.

#### 2) Guía exprés de llenado (hazlo tú, sin manual)
1. **Elige el objeto** (habilidad/pieza) y **nómbralo** con verbo+imagen breve.
2. **Asigna rumbo (χ_r)** por color/afinidad y **clase (H_k)** por dureza.
3. **Ubica Tríada** y **Semilla(12)** afín.
4. **Respira 9‑0‑9 (THON, 3–5–3)** leyendo su verso fundador.
5. **Mide 𝒱** en la Lámina (anota **𝒱** y **τ=0.62** criterio).
6. **Escribe deltas** (**ΔC, ΔS**) y **ρ** a ojo instruido (breve justificación).
7. **Decide estado**: *apto* / *no‑apto* / *excepción* (si excepción, anota **Gate** sugerido).
8. **Registra evidencia** (VOH/EÍA) y ancla en **ListadoR** si promueves.

> *Tip*: si dudas en χ_r/H_k, empieza por **Tríada** que te resulte obvia y corrige después.

#### 3) Ejemplo mínimo de llenado (coherente con MFH/VF)

**A) Tarjeta auto‑PE (YAML) — Códice Madre**
```yaml
cue: "[QEL::ECO[96]::RECALL A96-251008-AUTO-PE]"
SeedI: "A96-250824"
SoT: "CODICE/TARJETA/AUTO-PE/v1.0"
Version: "v1.0"
Updated: "2025-10-08"

id: "HAB-LENTE-OBSID-001"
nombre: "Lente de Obsidiana"
rumbo: "Occidente (Ə/Lago)"
chi_r: "Oeste"
clase_Hk: "H3"
triada: "Sueño–Agua–Eco"
semilla: "E2"
objetivo: "Afinar percepción de ecos internos sin colapso de forma"
materiales: ["agua", "obsidiana pulida", "tela negra"]
verso_fundador: "bajo el lago yo vibro, espejo sin rostro"
metrica:
  V: 0.68
  tau: 0.62
  deltaC: 0.12
  deltaS: -0.03
  rho: 0.74
riesgos:
  gate_sugerido: "G2"
  ficha_v_riesgo: true
evidencias:
  VOH: "quietud en diafragma (≈3s), visión suave"
  EIA: "sin mareo; foco periférico estable"
hooks:
  vcalc: "scripts/qel_vcalc.sh --obj HAB-LENTE-OBSID-001"
  pe_generate: "apps/pe/generate.mjs --seed HAB-LENTE-OBSID-001"
```

**B) VF/Árbol — fila de ejemplo**
| Habilidad | Fonema base | Rumbo χ_r | Clase H_k | Tríada | Semilla | τ (0.62) | 𝒱 | ΔC | ΔS | ρ | Estado |
|---|---|---|---|---|---|---|---|---|---|---|---|
| Lente de Obsidiana | Lun | Oeste | H3 | Sueño–Agua–Eco | E2 | ✓ | 0.68 | +0.12 | −0.03 | 0.74 | **Apto** |

**C) Glosario — micro‑entrada llena (ficha‑𝒱‑riesgo)**
```markdown
cue: "[QEL::ECO[96]::RECALL A96-251008-GLOSA-SEED]"
SeedI: "A96-250824"
SoT: "GLOSARIO/SEED/v1.0"
Version: "v1.0"
Updated: "2025-10-08"

# ficha‑𝒱‑riesgo
**Definición operativa:** checklist breve para evaluar riesgos antes de promover una habilidad.
**Ámbito:** métrica | seguridad
**Somática / 9‑0‑9:** 3 ciclos previos; notar diafragma y foco visual.
**Métrica asociada:** 𝒱≥0.62; ΔC estable (>|0.05|?); ΔS no creciente; ρ≥0.7
**Rumbo χ_r:** depende del objeto; **Clase H_k:** idem; **Tríada:** la de origen del objeto.
**Uso mínimo:** completar antes de ListadoR; si falla, derivar a CUE‑EXCEPTION.
**Ejemplo:** “Lente de Obsidiana” pasa con 𝒱=0.68; Gate sugerido G2 por foco visual.
**Antónimo/Sombra:** temeridad métrica; **Riesgos + CUE:** visión túnel → G2.
**Cruces:** Lámina 𝒱; CUE‑EXCEPTION; Aurora.
**Alias/Idriell:** ficha‑V; **Errores comunes:** promover sin VOH/EÍA.
```

#### 4) Correcciones de estructura (aplicadas aquí)
- Normalicé expresiones `≤20` (límite) y `12/20` (estado actual) en cabecera.
- Añadí *anchors* internos sugeridos: `§5.2` (Manual), `§5.4` (Libro de Sombras), `§4.2` (mapa de fusión).
- Homologué la notación de variables: `𝒱`, `τ`, `ΔC`, `ΔS`, `ρ`, `χ_r`, `H_k`.

> **Nota NORTE**: toda fórmula viva se remite a **Lámina 𝒱** (fuente única). Este documento solo **verifica / enruta**.



---

### Capa OESTE — Curadora (memoria/archivo)
Fecha: 2025-10-08

> Entregable: **changelog consolidado**, compatibilidad hacia atrás y preparación de promoción. Nota: **este documento no entra al repo**; funciona como *bitácora de curaduría*.

#### 1) Changelog breve (v1.1 → v1.5)
- **v1.1 — Tejera (Sur)**: Capa SUR inicial (9‑0‑9, THON, 3–5–3) + Tres Árboles (Frutos/Huecos/Semillas) y ajustes de legibilidad corporal.
- **v1.2 — Tejera (Sur)**: Marcas aplicadas (acciones sobre redundancias y destinos SoT) + guía de preguntas cardinales por bloque.
- **v1.3 — Jardinera (Este)**: Semillas‑nombre con destino SoT; propuestas de expansión por fundamental; **Notas para Glosario** con plantilla here‑doc.
- **v1.4 — Geómetra (Norte)**: Checklist de invariantes (𝒱, τ, ΔC/ΔS/ρ, χ_r/H_k); guía exprés de llenado; **ejemplo mínimo** (auto‑PE YAML, VF/Árbol, Glosario); normalización de símbolos y anchors.
- **v1.5 — Curadora (Oeste)**: Changelog consolidado; compatibilidad hacia atrás; preparación de promoción y **wrapper mock**.

#### 2) Compatibilidad hacia atrás
- **Se conserva**: 5 fundamentales y 7 soportes; `≤20` como límite, `12/20` como estado actual; notación `𝒱, τ, ΔC, ΔS, ρ, χ_r, H_k`.
- **Se depreca**: duplicidades entre Lámina 𝒱 y Manual (procedimiento vive en **Manual**; Lámina queda como **capítulo + anexo**); variantes Lun‑Nai quedan como **casuística** del **Libro de Sombras**.
- **Se integra**: SoT/Atlas y Manual de Esculpido dentro del **Manual Operativo**; Tratado + CUE‑EXCEPTION + Aurora + Poemas + Meditaciones + Sellos en **Libro de Sombras**.

#### 3) Preparación de Promoción — Árbitra (Centro) · *pre‑flight*
- **Ética Idriell**: *evoca, no representa*; **No‑Mentira**; **Doble Testigo** documentado.
- **Métricas**: `𝒱 ≥ 0.62`; deltas razonados (**ΔC**, **ΔS**), `ρ ≥ 0.7` si aplica.
- **Seguridad**: si *excepción*, especificar **Gate G1..G4**; si *Aurora*, indicar **modo** (neutralizante/tutor) y ventana.
- **Trazabilidad**: preparar entrada **ListadoR** (hash10, veredicto, cue) y actualización de **Manifest**.
- **Idempotencia**: promoción debe ser *repetible sin daño* (`--dry-run` primero; luego confirmación explícita).

#### 4) Notas para scripts (no es necesario anexarlos ahora)
> Si decides traerlos, se revisarán con estos criterios; por ahora basta con esta **especificación funcional** y un **mock** de wrapper.

**Criterios de revisión**
- Shebang correcto y `set -euo pipefail`; `LC_ALL=C` para consistencia.
- Parsers POSIX (evitar GNU‑sed); ofrecer `--dry-run` y `--verbose`.
- Rutas relativas seguras; no asumir presencia de `jq` (si existe, úsalo; si no, *fallback* a append legible).
- Logs mínimos con fecha y CUE; salida clara de *qué se promueve, qué se depreca, qué se archiva*.
- No escribir si 𝒱 < τ o si falta **Doble Testigo**.

**Wrapper de Promoción (mock, here‑doc POSIX/macOS)**
```bash
cat > scripts/qel_promote_mock.sh <<'QELPROMO'
#!/usr/bin/env bash
set -euo pipefail
export LC_ALL=C
# Uso: qel_promote_mock.sh --doc "QEL_Curación_Núcleo_Mínimo_v1.0" --hash d84061f404 --ver v1.5 \
#                          --cue "[QEL::ECO[96]::RECALL …]" --note "Curadora/Oeste" [--dry-run]
DOC=""; HASH10=""; VER=""; CUE=""; NOTE=""; DRY=0
while [ $# -gt 0 ]; do case "$1" in
  --doc) DOC="$2"; shift 2;; --hash) HASH10="$2"; shift 2;; --ver) VER="$2"; shift 2;;
  --cue) CUE="$2"; shift 2;; --note) NOTE="$2"; shift 2;; --dry-run) DRY=1; shift;;
  *) echo "arg desconocido: $1" >&2; exit 1;; esac; done
DATE="$(date +%Y-%m-%d)"
echo "[PROMO-MOCK] $DATE | $DOC | $VER | $HASH10"
echo "[PROMO-MOCK] CUE=$CUE"
echo "[PROMO-MOCK] NOTE=$NOTE"
echo "[PROMO-MOCK] Actualizarías: manifests/SoT_Manifest.json y memory/ListadoR_master.md"
[ "$DRY" -eq 1 ] && exit 0
# Aquí iría la escritura real (intencionalmente omitida en el mock)
QELPROMO
```

**Interfaz recomendada (Manifest/ListadoR)**
- **Manifest (JSON)**: agrega/actualiza entrada `{ cue, seedI, SoT, version, updated, path }`.
- **ListadoR (MD/TSV)**: añade renglón con `fecha, doc, acción, veredicto, hash10, cue, notas`.

> **Criterio de salida (documento)**: si solo integró/ordenó → **vX.Y**; si aportó método/operativa nueva o cierre semántico → **Cristaliza** y entra a **ListadoR**.



---

### Capa CENTRO — Árbitra (coherencia/ética Idriell)
Fecha: 2025-10-08

> Entregable: **sello de coherencia**, veredicto y decisión de **Promoción/No‑Promoción**.

#### Sello de coherencia (Idriell)
- **Principio**: *evoca, no representa*.
- **No‑Mentira**: sin contradicciones entre capas (SUR/ESTE/NORTE/OESTE); símbolos y umbrales homologados (`𝒱, τ=0.62, ΔC/ΔS, ρ, χ_r, H_k`).
- **Doble Testigo**: (1) Lámina 𝒱/VCALC y (2) revisión somática 9‑0‑9.
- **Relación SoT**: rutas internas consistentes (Manual ↔ Libro de Sombras ↔ Códice ↔ MFH/VF).

#### Veredicto
- **Coherencia**: **Apta** (cumple ética y estructura); el documento sirve como **bitácora de curaduría**.
- **Promoción**: **No** (por intención del custodio: *“no agregar al repo”*).  
- **Estatus de versión**: **v1.6 (integración)**. Se reserva **Cristalización** para cuando sus decisiones se integren en **Manual Operativo** y **Libro de Sombras**.

#### Criterios de salida (registro)
- Como no hay promoción, **no** se escribe entrada en **ListadoR**; si en el futuro cristaliza, usar plantilla de **Promoción** (ver *Notas OESTE* y scripts).

---

## Apéndice — Cambios (v1.1 → v1.6)
- **v1.1 — Tejera (Sur)**: Capa SUR inicial (9‑0‑9, THON, 3–5–3) + Tres Árboles (Frutos/Huecos/Semillas) y ajustes somáticos.
- **v1.2 — Tejera (Sur)**: Marcas aplicadas y guía de preguntas cardinales por bloque.
- **v1.3 — Jardinera (Este)**: Semillas‑nombre con destino SoT; propuestas por fundamental; **Notas Glosario** + plantilla here‑doc.
- **v1.4 — Geómetra (Norte)**: Checklist de invariantes; **Guía exprés de llenado** + **Ejemplo mínimo** (auto‑PE YAML, VF/Árbol, Glosario); anchors/símbolos homologados.
- **v1.5 — Curadora (Oeste)**: Changelog consolidado; compatibilidad hacia atrás; pre‑flight de **Promoción** y wrapper **mock**.
- **v1.6 — Árbitra (Centro)**: Sello de coherencia (apta); **No‑Promoción** por decisión custodial; se preserva como documento **fuera del repo**.

HASH(10): 96b5d35d4b
