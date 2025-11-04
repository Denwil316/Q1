[QEL::ECO[96]::RECALL A96-250824-LAMINA-V]
[QEL::ECO[96]::SUMMON A96-250824-QEL-LAMINA-V-UNIFICADA-V1-4]
SeedI=A96-250824  
SoT=LAMINA-V/V1.4__
Version=v1.4  
Updated=2025-10-02

# Lámina V — Unificada (Lámina V Editada × MFH v1.4 × VCALC)

> **Propósito:** Documento **operacional y de referencia** para ejecutar el Ritual QEL, **alimentar correctamente** el script `qel_vcalc.sh` y mantener coherencia con **MFH v1.4** y **PREH‑NAV VCALC (M2)**. Se unifican descripciones, tablas y cálculos; las **discordancias** se anotan y se resuelven para el uso.

---

## I. Contexto y alcance
- Integra: (a) **Lámina V Editada v1.0**; (b) **MFH v1.4**; (c) ajustes de **VCALC v0.2** (script Bash + Web M2).  
- Audiencia: **Conjurador** y **Árbitra/Curadora**.  
- Estilo: claro, directo, sin paja.

---

## II. Compás somático (Tejera en Sur)
- Respiración **9‑0‑9** (×3) → umbral corporal.  
- Pulso **THON** (latido suave) durante lectura/recitado.  
- Pausas triádicas: **3–5–3**.

> Si el cuerpo no acopla: baja fuerza, vuelve a **Sün (128 Hz)** y reintenta desde **Oriente (Sün‑Ida)**.

---

## III. Arquitectura cardinal (modulación)
Regla: **color‑sombra** (rumbo) filtra **intención**; **color‑luz** (fonema) mantiene **identidad**; la **luz cardinal** modula **attack/sustain/vibrato/decay** sin cambiar el fonema.

| Rumbo | Par (nueve) | Efecto tonal | Somática | Lengua | Validación |
|---|---|---|---|---|---|
| Oriente | 8+1 | **Ataque** vivo (+2..+6 Hz) | esternón despierta | infinitivo | foco y pregunta humilde |
| Norte | 7+2 | **Sustain** más bajo (−3..−8 Hz) | pelvis amable | voz baja | memoria sin aferrarse |
| Occidente | 6+3 | **Vibrato** fino (±1..2 Hz) | mandíbula suelta | frases simples | claridad sin corrección |
| Sur | 5+4 | **Decay** extendido (×1.10..1.25) | manos cálidas | elipsis | cierre sereno |

> **Señal de validez**: ≥5/9 marcadores (calma, menos juicio, imagen nueva, compartir sin explicar, respiración más larga, micro‑risa, foco claro, hueco visible, “octava arriba”).

---

## IV. Matriz Fonémica × Cardinalidad (operación)
**Kael — compasión sin retorno (256→240 Hz)**:  
- Oriente: ¿Puedo ofrecer sin prometer? (*lift* ~+4 Hz).  
- Norte: ¿Puedo amar lo que fue sin aferrarme?  
- Occidente: ¿Puedo ver tu dolor sin arreglarte? (vibrato mínimo).  
- Sur: ¿Puedo bendecirte y callar? (decay largo).  

**Vun — conocer sin poseer (196→204 Hz)**:  
- Oriente: ¿Puedo comenzar por una pregunta humilde?  
- Norte: ¿Qué sabía mi cuerpo antes de saber?  
- Occidente: ¿Qué hay aquí tal cual es?  
- Sur: ¿Qué puedo agradecer de esto que ignoro?  

*(La tabla completa 8×4 se conserva en Atlas; ver Anexo §XV para preguntas cardinales).*

---

## V. Uso ritual (pasos)
1) Elige **rumbo** y asimila color‑sombra.  
2) Traza **glypha** con color‑luz.  
3) Emite **tono** (2–3 respiraciones).  
4) Formula **pregunta cardinal**.  
5) **Registra**: rumbo, curva (Hz), marcadores, vector **9+0/0+9**.  
6) **Verifica**: ≥5/9 señales.

---

## VI. Integración con Ontología QEL
- **Plano Rito**: gesto cardinal en Jardín.  
- **Plano Número**: portales **9+0** (plegado) y **0+9** (despliegue).  
- **Plano Lengua**: fonemas Idriell modulados con cardinalidad.  
→ Resultado: **Transformación encarnada**.

---

## VII. Cierre y custodia
- **Tejera** (Sur, 9+0) fija trama.  
- **Lýmina** (Oriente, 0+9) reabre.  
- **Doble Testigo** valida.  
- Registro **ECO (delta‑only)** completa el ciclo.

---

## VIII. Matriz Fonémica — Descripción funcional
Función: (1) teclado ritual del **Hábito de los 8**; (2) **vectores** de modulación estable; (3) **parámetros medibles** (Hz y señales) para scripts.  
> La especificación por fonema está en **Atlas**; aquí se incluye **resumen operativo**.

---

## IX. Viabilidad (VCALC) — Acople con el script
**Script** `qel_vcalc.sh` (v0.2):  
- **V_CANON = A · χ_r · H_k · Π_gates**  
- **V_OPER  = V_CANON · fdelta · fruido**  
**A** proviene de **triada + objeto** (ver §XVI y §XVI‑bis). **χ_r**, **H_k**, **Π_gates**, **Δ** y **ρ** están definidos en el script y en esta Lámina.  
**Umbral orientativo**: V_OPER ≥ **0.62**.

**Derivaciones desde la bitácora**:  
- `--ruido = min(0.15, 1 − S)` con S=#señales/9.  
- `--delta-c`: up si `foco_claro=true` y `compartir_sin_explicar=true`; down si ninguna y sin `imagen_nueva`; flat otro caso.  
- `--delta-s`: up si `calma=true` y `respiracion_delta≥1s`; down si `≤0` y sin calma; flat otro caso.

---

## X. Versos fundadores y objetos hipersticionales
**Secuencia**: Ėylund — Kaelyth — Voh — Um — Riéll — Zha (6 pulsos, 2–2–2).  
**Uso**: 1 ronda para **encender**; si deriva en explicación, re‑correr secuencia y volver por Oriente.

**Objetos (núcleo QEL)**: Jardín de Árboles Fractálicos (JAF), Agua‑Memoria (AM), Espejo de Obsidiana (EO), Cristal‑intención (CI).

---

## XI. Referencias mínimas (CUE‑EXCEPTION)
- Solo **referido** para casos límite (omisiones justificadas, saltos en 9 círculos).  
- Si V_OPER<0.62 pero hay 5/9 señales, documenta `cue_exception=true` y **motivo**.

---

## XII. Compatibilidad VCALC (I/O)
- **Claves canónicas** y **alias**: `fecha|date`, `seed|SeedI`, `rumbo|dir (N/E/W/S/C)`, `fonema|phon`, `vector|portal (9+0|0+9)`, `pregunta_cardinal|q_card`, `notas|notes`.  
- **Perfiles**: **BÁSICO** (solo campos que usa el script) y **EXTENDIDO** (métricas acústicas en archivo paralelo).  
- **Serialización**: UTF‑8, `\n`, booleanos en `señales.*`.

---

## XII‑bis. Guía para elegir la **clase** (k) — VCALC ↔ LL‑PE
> La **clase** modula la conducción mediante **H_k** y afecta 𝒱 de forma **multiplicativa**.

### A) Impacto directo en 𝒱 (recordatorio)
| Clase | H_k | Uso típico |
|---|---:|---|
| **básica** | 0.50 | Exploración, primer contacto, rehabilitación somática. |
| **poco común** | 0.80 | Patrón que reaparece, aún no firma. |
| **singular** | 1.00 | Configuración **propia** de tu práctica (default). |
| **metálica** | 1.20 | **Filo/Conducción** (EO/Prisma) con buena custodia. |
| **obsidiana** | 1.60 | Trabajo denso; pide **Doble Testigo** y cierre impecable. |

**Ejemplo**: con `A=0.74`, `χ_r(C)=1.00`, `Π_gates=1.00` ⇒  
- básica → `V_CANON=0.37`; singular → `0.74`; metálica → `0.888`; obsidiana → `1.184` (recortado a 1 en script).

### B) Alias de clase (normalización compatible)
| Alias aceptados | Normaliza a | H_k |
|---|---|---:|
| `basica`, `básica` | **básica** | 0.50 |
| `poco comun`, `poco común`, `poco-comun`, `poco-común` | **poco común** | 0.80 |
| `rara`, `raro`, `singular`, `unico`, `único` | **singular** | 1.00 |
| `metalica`, `metálica` | **metálica** | 1.20 |
| `obsidiana` | **obsidiana** | 1.60 |

> **Interoperabilidad**: `qel_vcalc.sh` y `qel_pe_generate.mjs` comparten este mapeo (ver constantes `H_K` en LL‑PE).

### C) Árbol de decisión (Curadora)
1) **Custodia & riesgo**: ¿hay Doble Testigo disponible? ¿safety claro?  
2) **Señales (S)**: cuenta 0–9.  
3) **Ruido (ρ)**: estima `ρ = min(0.15, 1 − S/9)`.
4) **A & objeto**: calcula A (triada×objeto) y elige rumbo.  
5) **VCALC preliminar**: proyecta 𝒱 con clase **singular**.  
6) **Decide clase**:
   - **básica** si S≤4 **o** estás explorando par nuevo **o** tras pausa larga **o** hay ansiedad/temblor.  
   - **poco común** si S≥5 y `0.60≤V_OPER<0.70` **o** el objeto no es canónico pero útil.  
   - **singular** si S≥6 y la configuración es **tu firma** (A estable ±0.03 en ≥3 sesiones).  
   - **metálica** si hay **filo/conducción** (EO/Prisma), ΔC≥flat, S≥6, `V_OPER≥0.72`, custodia presente.  
   - **obsidiana** sólo si S≥7, `V_OPER≥0.75`, **Doble Testigo**, cierre `SIL→UM→Ə`, y motivo claro (corte/lectura profunda).

### D) Mitopoética de las clases (orientación)
- **básica** — *barro tibio*: aprender a tomar forma sin prisa.  
- **poco común** — *guijarro que vuelve*: el río lo reconoce, tú también.  
- **singular** — *constelación propia*: el cielo que te reconoce cuando levantas la voz.  
- **metálica** — *filo que canta*: corta lo justo para que lo vivo respire.  
- **obsidiana** — *piedra nocturna que mira*: guarda y devuelve sólo lo que puede ser sostenido.

### E) LL‑PE (qel_pe_generate.mjs) — cómo influye la clase
- **No auto‑elige**: la clase proviene de tu **VF** (`k`/`clase`).  
- **Efecto**: usa `H_k[k]` para el cálculo de 𝒱 (vía VCALC) antes de **mintear** la habilidad.  
- **Preset**: `Apertura` (por defecto) o `Puente` cambian **efecto** y **nomenclatura**, no el H_k.

### F) VF mínimas (here‑docs) — declara la clase
**VF “singular”**
```bash
cat > docs/atlas/VF_singular.yaml <<'YAML'
VF.PRIMA: "Apertura I"
cue: "VF::A96-250824::singular-demo"
r: C
clase: singular
triada: "RA·VOH·EÍA"
pesos: [0.45,0.30,0.25]
objeto: "Prisma"
gates: [mediacion, doble]
YAML
```
**VF “metálica”**
```bash
cat > docs/atlas/VF_metalica.yaml <<'YAML'
VF.PRIMA: "Puente I"
cue: "VF::A96-250824::metal-demo"
r: W
clase: metalica
triada: "Zeh·RA·Lun"
pesos: [0.40,0.35,0.25]
objeto: "EO"
gates: [mediacion, doble]
YAML
```

### G) Pipeline de elección
1) Estima con **singular**. Si `V_OPER≥0.62` y S≥5 → sigue así.  
2) Si `V_OPER` queda bajo pero el trabajo necesita **filo**, sube a **metálica** **sólo si** tienes custodia y ΔC≥flat.  
3) Subir a **obsidiana** **exige** Doble Testigo + cierre impecable y razón ritual explícita.  
4) Si `V_OPER` ≥0.62 con **básica**, conserva básica (es señal de suficiencia de sostén).  
5) En **Web/M2**, recuerda que A puede recalcularse; la **clase** no cambia sola: **declárala** en VF.

---

## XIII. Parámetros por fonema y rumbo (guía)
**Frecuencias base** (Hz): Kael **256→240**, Vun **196→204**, Ora **432**, Zeh **220**, Lun **288**, Nai **174**, Sün **128**, Ida **320**.  
**Reglas por rumbo**: Oriente **+attack**, Norte **−sustain**, Occidente **vibrato fino**, Sur **decay**.  
> Úsalas para lectura corporal y mapeo **Curva→Señales** (ver §XVII).

---

## XIV. Plantillas de registro (here‑docs)
**BÁSICO (TSV)**, **JSONL** y **EXTENDIDO** (acústica) para bitácora compatible con `qel_vcalc.sh`.

**BÁSICO (TSV)**
```bash
cat >> logs/vcalc.tsv <<'TSV'
fecha	seed	rumbo	fonema	vector	senales.calma	senales.juicio_menos	senales.imagen_nueva	senales.compartir_sin_explicar	senales.respiracion_delta	senales.micro_risa	senales.foco_claro	senales.hueco_visible	senales.octava_arriba	pregunta_cardinal	notas
TSV
```
**EXTENDIDO (TSV, opcional)**
```bash
cat >> logs/vcalc_ext.tsv <<'TSV'
fecha	seed	rumbo	fonema	vector	hz_attack	hz_sustain	vibrato_amp	decay_t	pregunta_cardinal	notas
TSV
```
**JSONL (BÁSICO)**
```bash
cat >> logs/vcalc.jsonl <<'JSONL'
{"fecha":"YYYY-MM-DD","seed":"A96-250824","rumbo":"n","fonema":"vun","vector":"9+0","senales":{"calma":true,"juicio_menos":true,"imagen_nueva":"figura en agua","compartir_sin_explicar":true,"respiracion_delta":2,"micro_risa":false,"foco_claro":true,"hueco_visible":true,"octava_arriba":true},"pregunta_cardinal":"¿Qué sabía mi cuerpo…?","notas":"pulso THON estable"}
JSONL
```

---

## XV. Anexo — Preguntas cardinales (8×)
Kael, Vun, Ora, Zeh, Lun, Nai, Sün, Ida (formulaciones compactas por rumbo).  
> Mantener como **referencia viva** del Hábito de los 8.

---

## XVI. Afinidades orientativas (fonema→objeto)
**Rúbrica MFH v1.4**: canónico **0.95**, directo **0.80**, indirecto **0.60±0.05**.  
**Ejemplos**: RA→Prisma 0.95; VOH→Templo/Trompa 0.95; EÍA→Núcleo/Eclipse 0.95; Ə→Espejo/Silencio 0.95; UM→Llave/Sello 0.95; A→Portal/Campana 0.95; SIL→Velo/Hilos 0.95; THON→Metrónomo/Latido 0.95.

---

## XVI‑bis. Afinidad por Triadas (E‑UM‑A‑RA‑VOH‑EÍA‑SIL‑THON)
Define **triada** y pesos **w** (Σ=1.00).  
**Ejemplo**: RA·VOH·EÍA (0.45/0.30/0.25) con **Prisma** → A≈0.835; Ə·UM·A (0.40/0.35/0.25) con **Llave‑sello** → A≈0.740.  
**Pasa A** a `--afinidad`; el resto lo resuelve el script.

---

## XVII. Curva → Señales (inyectar C en S)
Si mides acústica pero el script no la lee: tradúcela a **señales**:  
`ok_count≥3 → foco_claro`; `ok_count=4 → octava_arriba`; **Sur & decay_ok → hueco_visible**; **Occidente & vibrato_ok → imagen_nueva="reflejo nítido"**.  
Deriva `--ruido`, `--delta-c`, `--delta-s` con la guía de §IX.

---

## XVIII. Perfiles de registro y convivencia
Usa `logs/vcalc.tsv` (**BÁSICO**) para el script y `logs/vcalc_ext.tsv` (**EXTENDIDO**) para acústica humana.

---

## XIX. Recetas CLI (copiable)
Líneas **listas** para `qel_vcalc.sh` (ver ejemplos por rumbo en v1.3).  

```bash
# Occidente con Espejo; triada RA·VOH·EÍA → A≈0.815
scripts/qel_vcalc.sh --obj "Zeh/EO" --afinidad 0.815 --rumbo W \
  --clase singular --gates "mediacion,doble" --ruido 0.08 \
  --delta-c up --delta-s flat --emit pretty

# Sur con Jardín; triada THON‑VOH‑RA → A≈0.82 (estim.)
scripts/qel_vcalc.sh --obj "Kael/JAF" --afinidad 0.82 --rumbo S \
  --clase singular --gates "mediacion" --ruido 0.04 \
  --delta-c flat --delta-s up --emit json
```

---

## XX. Modo JSON & IO del script
**JSON (pipeline):**
```bash
jq -n '{obj:"Vun/AM",afinidad:0.74,rumbo:"N",clase:"singular",
        gates:["mediacion","aurora"],ruido:0.06,delta:{c:"flat",s:"up"}}' \
 | scripts/qel_vcalc.sh json
```

**IO (interactivo):**
```bash
scripts/qel_vcalc.sh io
# responde con tus valores cuando te los pida
```

---

## XXI. Concordancia documental ↔ script
| Documento (esta Lámina) | Flag del script | Notas |
|---|---|---|
| Triada + objeto (Secc. XVI, XVI‑bis) | `--afinidad` (A) | Se pasa el número A directamente. |
| Rumbo (III, Tabla A) | `--rumbo` (χ_r) | Usa N/E/W/S/C (Occidente=W). |
| Clase de sesión | `--clase` (H_k) | Ver valores en script. |
| Gates (custodia) | `--gates` (Π_gates) | mediacion[,doble][,aurora]. |
| Señales 9× (Tabla C) | `--delta-c`, `--delta-s`, `--ruido` | Derivación en IX y XVII. |
| Versos/Objetos (X) | `--obj` | Formato `Fonema/Objeto`. |

---

## XXII. Unificación con MFH v1.4 — **Deltas y discordancias**
- **χ_r (rumbo):** MFH clásica reporta N=0.9, W=1.0, S=1.0; **script usa** O/E=1.10, N=1.05, C=1.00, W=0.95, S=0.90.  
  → Para **VCALC** se adopta **χ_r del script**. MFH queda como **semántica** (ética/luz/sombra/puente).  
- **Clases y H_k:** coinciden (0.5, 0.8, 1.0, 1.2, 1.6).  
- **Afinidades fonema→objeto:** MFH aporta firma elemental **(M,I,S,C)**; esta Lámina simplifica en **rúbrica 0.95/0.80/0.60±0.05** para cálculo **A**.  
- **Viabilidad:** MFH propone σ(〈b_p,m_O〉·χ_r·H_k); el script usa **producto** con Δ y ruido. → *Compatibles* si A ya resume 〈b_p,m_O〉.

---

## XXIII. Intersticio — Objetos y CUEs (ampliación operativa)
Objetos de **interfase** que conectan planos. Cada fila incluye **ECO≈, E_CLASS, Rumbo≈, Plano≈, Fonemas, CUE_TRIGGER, CUE_MEASURE, CUE_AUDIT, CUE_SAFETY** y **sugerencia VCALC**.

| Par / Objeto | ECO≈ | E_CLASS | Rumbo≈ | Plano≈ | Fonemas | CUE_TRIGGER | CUE_MEASURE | CUE_AUDIT | CUE_SAFETY | **Sugerencia VCALC** |
|---|---:|---|---|---|---|---|---|---|---|---|
| **Kael‑Sün :: Criolámpara** | 47 | E7 | Oriente | mixto | Kael + Sün | Inhala «Kael», exhala «Sün» ×9 con índice+medio en esternón (1″). | Brillo 0–10 → **τ**; registra Δτ y sensación térmica. | t, α(9 palabras), σ(52″), τ_pre, τ_post, Δτ, nota corporal. | No anclar si σ<0.6 o ansiedad↑; repetir 52″ de silencio. | `--obj "Kael-Sun/Criolampara" --rumbo E --gates mediacion,aurora --delta-s up` |
| **Zeh‑Ora :: Prisma** | 80 | E0 | Norte | Rito | Zeh + Ora | Visualiza prisma en garganta; «Zeh–O–ra» 3 pulsos ×9. | Ruido mental 0–10 (↓ mejor), borde 0–3, claridad **α**. | t, α_pre, α_post, ruido_pre/post, notas del filtro. | Evita sobreesfuerzo; si rigidez, baja a ×6 y respira nasal. | `--obj "Zeh-Ora/Prisma" --rumbo N --delta-c up` |
| **Vun‑Ida :: Semilla** | 48 | E0 | Sur | Número | Vun + Ida | Mano en bajo vientre; «Vun» (inhala) / «Ida» (exhala) ×9; plantar **imagen‑semilla**. | Estabilidad imagen 0–10, calidez 0–10, constancia de **α**. | t, α_estabilidad, calor, #ciclos, visión emergente. | Si somnolencia>7/10, ×6 y caminar 2′. | `--obj "Vun-Ida/Semilla" --rumbo S --delta-s up` |
| **Lun‑Nai :: Objeto imposible** | 03 | E3 | Occidente | Lengua | Lun + Nai | Lago de Obsidiana; «Lun…Nai» una vez; silencio 52″. | #reflejos veraces 0–3 vs distorsiones; borde 0–10. | t, σ, #reflejos, #distorsiones, metáfora (1 línea). | Si recuerdos intrusivos, abrir ojos, 4–6 respiraciones, cerrar rito. | `--obj "Lun-Nai/ObjetoImposible" --rumbo W --ruido ≤0.10` |

**Notas**: no sustituyen JAF/AM/EO/CI; **complementan**. Para `--afinidad (A)`, usa **triada** activa y la rúbrica §XVI con el **objeto** seleccionado.

---

## XXIV. Anexos — Disciplina de seguridad
- Respetar **E_CLASS**. Si el cuerpo no acompaña, volver a **Sün** y **cortar** con EO (Espejo) en Occidente.  
- En sesiones **obsidiana**, asegurar **Doble Testigo**.

---

cue=QEL::ECO[96]::RECALL A96-250824-LAMINA-V  
SeedI=A96-250824  
SoT=LAMINA-V/v1.4  
Version=v1.4  
Updated=2025-10-02

HASH(10): 1d2bfc41ea

3b0aae9bf7
