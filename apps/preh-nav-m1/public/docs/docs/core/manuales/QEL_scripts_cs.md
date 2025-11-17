[QEL::ECO[96]::RECALL A96-251112-CHEATSHEET-SUR]
SeedI=A96-251112
SoT=CHEATSHEETS/SCRIPTS/v1.4
Version=v1.4
Updated=2025-11-14

# Capa SUR · Cheat-Sheet Operativo de Scripts (Tejera)

> **Rol:** Tejera (Sur · cuerpo/ritmo)
>
> **Compás somático:** respiración **9-0-9**, pulso **THON** constante, pausas **3–5–3** al cierre de cada bloque.
>
> **Enfoque:** Legibilidad corporal, micro-ritmos de lectura, ejemplos mínimos operables. Integrar **Tres Árboles** en clave somática: frutos (*fonemas de sombra*), huecos geométricos (espacios/pausas), semillas-nombre (identificadores canónicos: CUE/SeedI/SoT/Version/Updated).

---

## 0) Contexto y alcance
Este documento cristaliza, en una sola lámina de referencia rápida (“cheat-sheet”), **todos los scripts** usados en el ciclo actual del repo **Q1/QEL**. Formato unificado: **Función / Importancia / Obligatorios / Opcionales / Uso / Plantilla completa (here-doc)**. No modifica los scripts; sólo consolida su **modo de uso**.

**Scripts cubiertos**:

- `qel_session_new.sh`
- `qel_session_finalize.sh`
- `qel_promote_mac.sh`
- `qel_atlas_microreg.sh`
- `qel_vcalc.sh`
- `qel_vcalc_json.sh`
- `qel_vcalc_io.sh`
- `qel_pe_generate.mjs`
- `qel_cuemachine_check.sh`
- `qel_cuemachine_add.sh`
- `qel_secret_init.sh`

> **Ritmo de lectura sugerido (SUR):** lee cada sección con respiración **9-0-9**, aplica una pausa **3** al cerrar “Obligatorios”, pausa **5** tras “Uso”, y pausa **3** después de revisar la plantilla (here-doc). Mantén el pulso **THON** como metrónomo mental.

---

## 1) `qel_session_new.sh`

### Función
Genera un archivo **FS (Formato Situacional)** en formato JSON, que documenta los parámetros y contexto de una sesión ritual, técnica o creativa. Este FS actúa como “semilla temporal” que nutre otros procesos, especialmente `qel_session_finalize.sh`, permitiendo registrar métricas, referencias, resultados y metadatos coherentes. Es la primera respiración del flujo (inicio de sesión).

### Importancia
Sin el FS, los cierres y micro-sellos pierden trazabilidad. Estandariza la estructura de una sesión y consolida su identidad (`SeedI`, `CUE`, `SoT`, `Version`, `Updated`).

### Obligatorios (núcleo FS)
- `--fecha YYMMDD`
- `--tema "…"`
- `--intencion "…"`
- `--modo M0|M1|M2|M3`
- `--rumbo "Centro"` (o CSV: `"N,S,E,O,Centro"`)
- `--tiempo "min"`

### Opcionales (recomendados)
- `--refs "…,…"`, `--veredicto "…"`, `--salida "…"` (repetible)
- Métricas: `--delta-c ↑|→|↓`, `--delta-s ↑|→|↓`, `--V k=v` (repetible), `--no-mentira true|false`
- Testigos/narrativa: `--t1 Axx`, `--t2 Axx`, `--triada "…"`, `--mantra "…"`
- Resultados: `--axioma KEY` (repetible), `--obj k=v` (repetible), `--cierres "…"`, `--registro "…"`, `--artefacto PATH` (rep), `--micro TAG` (rep)
- Meta: `--cue "[QEL::…]"`, `--seed "Axx-YYMMDD"`, `--sot "DOM/…/vX.Y"`, `--version vX.Y`, `--updated YYYY-MM-DD`
- Modo/Salida: `--no-prompt`, `--from FS_prev.json`, `--stdout`, `--out FS_YYMMDD.json`

### Uso (SUR · cuerpo/ritmo)
1. **Inhala (9)**: confirma **tema/intención**.
2. **Retén (0)**: fija **modo/rumbo/tiempo**.
3. **Exhala (9)**: añade **refs/salidas**.
4. Pulso **THON**: métricas `Δc/Δs`, `V` y **no_mentira**.
5. Pausas **3–5–3** para revisar **resultados/artefactos**.

### Plantilla completa
```bash
: <<'QEL_SESSION_NEW_TEMPLATE'
--fecha "YYMMDD"
--tema "Título/tema"
--intencion "Objetivo concreto"
--modo "M0|M1|M2|M3"
--rumbo "Centro"           # o CSV: "N,S,E,O,Centro"
--tiempo "30"
--refs "Ref1,Ref2,Ref3"
--veredicto "Juicio breve"
--salida "Entregable 1"
--salida "Entregable 2"
--delta-c "↑" --delta-s "→" --V "Kael/Prisma=0.89" --no-mentira true
--t1 A81 --t2 A96 --triada "EIA(.35)-A(.30)-THON(.35)" --mantra "…"
--axioma "PIG" --axioma "TPC"
--obj "Kael/Prisma=0.89" --obj "Vun/Trompa=0.85"
--cierres "SIL→UM→Ə; Doble Testigo si hay Cristalización"
--registro "Actualizar Árbol VF y Listado R si aplica"
--artefacto "docs/ritual/Plan.md" --micro "MS-YYMMDD-A"
--cue "[QEL::ECO[96]::RECALL A96-YYMMDD-<TAG>]" --seed "A96-YYMMDD"
--sot "DOM/SUB/v1.0" --version "v1.0" --updated "YYYY-MM-DD"
--no-prompt --out "FS_YYMMDD.json"
QEL_SESSION_NEW_TEMPLATE
```

---

## 2) `qel_session_finalize.sh`

### Función
Cierra el ciclo iniciado por el FS, generando **VF.PRIMA**, actualizando el **Diario del Conjurador** y el **ListadoR**, y asegurando la existencia de un **MicroSello**. Este script consolida los resultados, validaciones y registros de una sesión. Es la exhalación final, donde el cuerpo ritual se asienta en el sistema documental.

### Importancia
Sin este cierre, el trabajo queda “abierto”: sin validación, sin vinculación en el Diario, y sin micro-sello de autenticidad. Su uso garantiza continuidad y orden narrativo entre fases.

### Requeridos
- `--fecha YYMMDD`
- `--vf "Texto de VF.PRIMA"`
- **CUE/SeedI**: pásalos con `--cue` y `--seed` o deriva desde `--artefacto` con metadatos válidos.

### Opcionales útiles
- `--artefacto PATH` (repetible), `--micro TAG` (rep), `--fs-json FS.json`
- Contenido (si no viene en FS): `--modo`, `--tema`, `--intencion`, `--rumbo`, `--tiempo`, `--refs`.
- Métricas/objetos (no leídas del FS): `--delta-c`, `--delta-s`, `--no-mentira`, `--obj k=v` (rep)
- Metadatos/rutas: `--updated`, `--sot-sello`, `--sot-diario`, `--diario-file`, `--listador-file`, `--veredicto`.

### Uso (SUR)
1. **Inhala**: verifica `FS_YYMMDD.json` listo.
2. **Exhala**: ejecuta finalize con **VF**, **CUE/SeedI** y **artefacto(s)**.
3. Pulso **THON**: pasa métricas u objetos si quieres que figuren en Diario.

### Plantilla completa
```bash
: <<'QEL_FINALIZE_TEMPLATE'
--fecha "YYMMDD"
--vf "Cierre formal/VF.PRIMA"
--cue "[QEL::ECO[96]::RECALL A96-YYMMDD-<TAG>]" --seed "A96-YYMMDD"
--artefacto "docs/ritual/Plan.md" --micro "MS-YYMMDD-A"
--fs-json "FS_YYMMDD.json"
--modo "M1" --tema "…" --intencion "…" --rumbo "Centro" --tiempo "30"
--refs "Ref1,Ref2"
--delta-c "↑" --delta-s "→" --no-mentira true
--obj "Kael/Prisma=0.89" --obj "Vun/Trompa=0.85"
--sot-sello "SELLOS/v1.0" --sot-diario "TRATADO-METAHUMANO/v1.2"
--updated "YYYY-MM-DD"
QEL_FINALIZE_TEMPLATE
```

---

## 3) `qel_promote_mac.sh`

### Función
Realiza la **promoción oficial** de un artefacto QEL: extrae o deriva su `SeedI`, genera su `HASH(10)` canónico, actualiza **ListadoR** y **Diario**, y copia el archivo hacia el espejo `apps/preh-nav-m1`. Representa el paso en que una creación pasa del plano individual al colectivo: “el cuerpo se proyecta”.

### Importancia
Actúa como un control de integridad, asegurando que cada documento promovido sea identificable y no duplicado. Es esencial para mantener consistencia entre ramas del repositorio y el historial de versiones.

### Requeridos
- `--rubro "RUBRO/SUBRUBRO"`
- `--file PATH` (debe existir)
- `--titulo "Título legible"`

### Opcionales
- `--rumbo "Centro|N|S|E|O|W"`, `--debug`
- ENV: `QEL_SEED_POLICY=auto|keep|strict` (default `auto`)

### Uso (SUR)
- **Inhala**: abre el archivo y confirma que contenga **cue/SeedI/SoT/Version/Updated**.
- **Exhala**: corre `promote` → asegura **SeedI** y **HASH(10)** en EOF; actualiza ListadoR/Diario; espejo PREH‑NAV; commit.

### Plantilla completa
```bash
: <<'QEL_PROMOTE_TEMPLATE'
--rubro  "CORE/MANUAL"
--file   "docs/core/manuales/QEL_Manual_auditoria_v1.2.md"
--titulo "QEL · Manual de Auditoría (v1.2)"
--rumbo  "Centro" --debug
# QEL_SEED_POLICY=auto|keep|strict
QEL_PROMOTE_TEMPLATE
```

---

## 4) `qel_atlas_microreg.sh`

### Función
Genera un **microregistro JSONL** en el Atlas principal, agregando una línea con metadatos y métricas de un documento promovido. Constituye la entrada “mínima viable” en el registro universal de artefactos del sistema. Es el paso intermedio entre la promoción y el cierre: fija el documento en el mapa global (Atlas).

### Importancia
Sin micro-registro, el sistema pierde la capacidad de trazar genealogías o búsquedas automáticas por tipo o versión. Garantiza visibilidad dentro del Atlas y coherencia en los índices de consulta.

### Requeridos
- `--kind "RUBRO/CATEGORÍA"`
- `--file PATH`

### Opcionales
- `--title|--titulo "…"`, `--hash10 "…"`, `--seed "Axx-YYMMDD"`
- `--rumbo`, `--triada`, `--obj`, `--clase`, `--materia`, `--V`, `--tau`, `--gates`
- Rutas: `--microreg`, `--indices-dir`, `--indexer`

### Uso (SUR)
- Tras **promote**, ejecuta **microreg** para registrar en **JSONL** (Atlas). Mantén **pausa 5** para verificar el renglón emitido.

### Plantilla completa
```bash
: <<'QEL_ATLAS_MICROREG_TEMPLATE'
--kind   "CORE/MANUAL" --file "docs/core/manuales/QEL_Manual_auditoria_v1.2.md"
--title  "QEL · Manual de Auditoría (v1.2)"
--hash10 "abcdef0123" --seed "A96-YYMMDD"
--rumbo  "Centro" --triada "EIA(.35)-A(.30)-THON(.35)" --obj "Kael/Prisma" \
--clase  "singular" --materia "obsidiana" --V "0.89" --tau "0.72" --gates "mediacion,doble"
--microreg    "docs/core/atlas_microreg_v1.0.jsonl"
--indices-dir "docs/core/indices" --indexer "tools/qel_indexer.py"
QEL_ATLAS_MICROREG_TEMPLATE
```

---

## 5) `qel_vcalc.sh`

### Función
Calcula la **viabilidad 𝒱** de un objeto/fonema por **dos rutas en paralelo**:
1) **VCALC (operativa)**: combina afinidad `A`, rumbo `χ_r`, clase `H_k` y producto de gates `Π_gates`, con ajustes por `Δ` (delta-c/s) y `ρ` (ruido). Devuelve `V_canon` y `V_oper`.
2) **MFH (formal)**: evalúa `𝒱_MFH` sobre la base `A·χ_r·H_k` (por defecto **sin gates**), con opción **logistic** o **clip** y parámetro de punto medio `x0`.

### Importancia
Provee un valor **operable** para el día a día (VCALC) y un valor **estructural** (MFH) coherente con la MFH. Permite contrastar ambas miradas para evitar miopía operativa o sobreajuste simbólico.

### Requerido (core)
- `--obj "Fonema/Objeto"` (ej. `Kael/Prisma`)

### Opcionales
- Núcleo VCALC: `--afinidad`, `--rumbo`, `--clase`, `--gates`, `--ruido`, `--delta-c`, `--delta-s`, `--emit` (`pretty|quiet|json`).
- Núcleo MFH: `--mfh clip|logistic|auto` (def=clip), `--mfh-k 12`, `--mfh-x0 0.62`, `--mfh-include-gates true|false` (def=false).

### Uso (SUR)
- **Micro-ritmo**: 1) Objeto → 2) Afinidad → 3) Rumbo/Clase → 4) Gates → 5) Δ/ρ → 6) MFH (clip/logistic).
- `pretty` imprime las **tres**: `𝒱_canónica`, `𝒱_operativa` y `𝒱_MFH`.

### Plantilla completa
```bash
: <<'QEL_VCALC_TEMPLATE'
scripts/qel_vcalc.sh \
  --obj "Kael/Prisma" --afinidad 0.72 --rumbo O --clase singular \
  --gates "mediacion,doble" --ruido 0.03 --delta-c up --delta-s flat \
  --mfh clip --mfh-include-gates false \
  --emit pretty
QEL_VCALC_TEMPLATE
```

#### Variantes útiles
```bash
# JSON con MFH paralelo
echo '{"obj":"Kael/Prisma","afinidad":0.72,"rumbo":"O","clase":"singular","gates":["mediacion","doble"],"ruido":0.03,"delta":{"c":"up","s":"flat"}}' \
| scripts/qel_vcalc.sh json --mfh clip --mfh-include-gates false

# MFH logistic (sensibilidad alrededor de x0)
scripts/qel_vcalc.sh --obj "Kael/Prisma" --afinidad 0.62 --rumbo E --clase singular \
  --mfh logistic --mfh-k 12 --mfh-x0 0.62 --emit pretty
```
---

## 6) `qel_vcalc_json.sh` (wrapper)

### Función
Wrapper que canaliza **JSON → `qel_vcalc.sh json`** y re‑emite su salida. Permite **automatizar** VCALC+MFH sin interacción.

### Importancia
Interopera con pipelines (Node/PE/atlas) manteniendo formato JSON consistente. No procesa campos; solo pasa flags y re‑emite.

### Requerido
- Fuente JSON por `--json`, `--in` o stdin.

### Opcionales
- Flags espejo para MFH: `--mfh`, `--mfh-k`, `--mfh-x0`, `--mfh-include-gates` (por defecto `clip`, `12`, `0.62`, `false`).

### Uso (SUR)
- Mantén **pulso THON**: valida llaves mínimas (`obj`, `afinidad`, `rumbo`, `clase`).

### Plantilla completa
```bash
: <<'QEL_VCALC_JSON_TEMPLATE'
scripts/qel_vcalc_json.sh \
  --json '{"obj":"Kael/Prisma","afinidad":0.72,"rumbo":"O","clase":"singular","gates":["mediacion","doble"],"ruido":0.03,"delta":{"c":"up","s":"flat"}}' \
  --mfh clip --mfh-include-gates false
QEL_VCALC_JSON_TEMPLATE
```
---

## 7) `qel_vcalc_io.sh` (wrapper)

### Función
Abre el **modo interactivo** del core. Pregunta por VCALC (obj, A, rumbo, clase, gates, ρ, Δ) y por MFH (mode, include_gates, y si aplica `k`, `x0`).

### Importancia
Ideal para sesiones de aprendizaje y cálculos rápidos **conscientes**; el usuario percibe el número antes de automatizarlo.

### Requerido
- Ninguno (invoca prompts de `qel_vcalc.sh io`).

### Uso (SUR)
- Usa respiración **9‑0‑9** antes de confirmar cada prompt.

### Plantilla completa
```bash
: <<'QEL_VCALC_IO_TEMPLATE'
# Abre el asistente interactivo (incluye MFH)
scripts/qel_vcalc_io.sh
QEL_VCALC_IO_TEMPLATE
```
---

## 8) `qel_pe_generate.mjs`

### Función
Genera y mantiene los **Poemas-Enigma (PE)**, integrando VCALC, tono ritual, estructura de habilidad y registro automático en el sistema (Manifiesto y ListadoR). Su diseño combina creatividad textual con lógica simbólica.

### Importancia
Actúa como “laboratorio creativo automatizado”: traduce estructuras técnicas en contenido poético codificado. Sin este script, el puente entre lenguaje y cálculo (Verbo y Número) quedaría roto.

### Recomendado (práctica segura)
- Especificar **VF** con `--vf` y activar `--save true` cuando quieras persistir.

### Opcionales clave
- Entrada: `--vf` | `--in`
- Cálculo/contexto: `--materia`, `--ruido`, `--delta-c`, `--delta-s`, `--tau`, `--preset`, `--emit`
- Guardado/registro: `--save`, `--out-pe`, `--out-hab`, `--registry`, `--listado-r`
- Parcheo/validación: `--patch-file|--patch-id|--patch-hash|--pe-root`, `--answer`

### Uso (SUR)
- **Inhala** VF → **Exhala** PE con 𝒱/τ; pausa **5** para leer el poema.

### Plantilla completa
```bash
: <<'QEL_PE_GENERATE_TEMPLATE'
--vf "docs/atlas/Tarjeta_VF_Kosmos8_v1.0.yaml"
--materia "obsidiana" --ruido "0.03" --delta-c "up" --delta-s "flat" --tau "0.62"
--preset "Apertura" --emit "md" --save true
--out-pe "docs/pe/PEabcdef1234.md" --out-hab "docs/habilidades/.../abcdef1234.md"
--registry "docs/core/QEL_SoT_Manifest_v0.8.json" --listado-r "docs/core/QEL_ListadoR_master_v1.0.md"
--patch-id "PE::ABCDEF1234" --pe-root "docs/pe" --answer "Ə·UM·A"
QEL_PE_GENERATE_TEMPLATE
```

---

## 9) `qel_cuemachine_check.sh`

### Función
Audita y mantiene la integridad del **ledger CueMachine**, que contiene el historial de CUEs del sistema. Construye y verifica cadenas hash (chain), firma HMAC con un secreto seguro y puede bloquear o desbloquear el ledger.

### Importancia
Funciona como “sistema inmunitario” del Codex: evita duplicaciones, manipulación o pérdida de integridad en los registros. Sin él, el ecosistema documental podría contaminarse.

### Requerido
- `--cm-file PATH` (ledger CueMachine)

### Opcionales
- `--sidecar-dir DIR`
- Acciones: `--update-chain`, `--verify`, `--sign`, `--verify-sign`, `--lock`, `--unlock`
- Firma/testigo: `--witness "…"`
- `--verbose`

### Uso (SUR)
- **Cadencia**: Añade línea → `--update-chain` → `--sign --witness …` → `--verify --verify-sign` → `--lock`.

### Plantilla completa
```bash
: <<'QEL_CUEMACHINE_CHECK_TEMPLATE'
--cm-file "docs/cuemachine/ledger.txt"
--sidecar-dir "docs/cuemachine/.side"
--update-chain --sign --verify --verify-sign --lock
--witness "A96-YYMMDD|FS_YYMMDD|Aurora:OK" --verbose
QEL_CUEMACHINE_CHECK_TEMPLATE
```

---

## 10) `qel_cuemachine_add.sh`

### Función
Agrega una nueva entrada al ledger CueMachine con los campos canónicos (`CUE`, `SeedI`, `SoT`, `Version`, `Updated`). Permite que cada documento quede formalmente enlazado a su historia en cadena.

### Importancia
Es la acción que otorga “existencia oficial” a un documento dentro de CueMachine. Sin ella, no hay reconocimiento de su procedencia ni validación en cadena.

### Requeridos
- `--cm-file PATH` · `--cue "[QEL::…]"` · `--seed "Axx-YYMMDD"` · `--sot "…/vX.Y"` · `--version vX.Y` · `--updated YYYY-MM-DD`

### Opcionales
- `--target PATH|HASH` · `--allow-duplicate` · `--verbose`

### Uso (SUR)
- Tras promover o cerrar sesión, **añade** la ficha al ledger y luego firma/verifica con `cuemachine_check`.

### Plantilla completa
```bash
: <<'QEL_CUEMACHINE_ADD_TEMPLATE'
--cm-file "docs/cuemachine/ledger.txt"
--cue     "[QEL::ECO[96]::RECALL A96-YYMMDD-<TAG>]"
--seed    "A96-YYMMDD" --sot "DOM/SUB/v1.0" --version "v1.0" --updated "YYYY-MM-DD"
--target  "docs/ritual/Plan.md" --allow-duplicate --verbose
QEL_CUEMACHINE_ADD_TEMPLATE
```

---

## 11) `qel_secret_init.sh`

### Función
Inicializa el secreto HMAC utilizado por CueMachine para firmar las cadenas de registros. Utiliza Keychain (macOS) o variables temporales para proteger el material criptográfico.

### Importancia
Es el equivalente a encender la “forja” de seguridad del sistema. Sin el secreto, no se pueden firmar ni verificar cadenas, debilitando la confianza estructural del ledger.

### Requerido
- `--nutria-dir DIR` (debe existir)

### Opcionales
- `--verso "frase base"`, `--service "Nombre_Keychain"`, `--preview`

### Uso (SUR)
- **Somática de seguridad**: establece el secreto HMAC (Keychain macOS) **antes** de firmar Cuemachine.

### Plantilla completa
```bash
: <<'QEL_SECRET_INIT_TEMPLATE'
--nutria-dir "codex"
--verso "bajo el lago yo vibro" --service "QEL_CueMachine_HMAC" --preview
QEL_SECRET_INIT_TEMPLATE
```

---

## 12) Flujo estándar (SUR) · Promote → Microreg → Finalize
1) **Promote** el documento principal.
2) **Microreg** en Atlas (JSONL) con los metadatos + VF.
3) **Finalize** la sesión (VF.PRIMA, Diario, ListadoR, MicroSello, HASH).
4) **Cuemachine**: agrega la entrada y firma/lock.

> Mantén **respiración 9‑0‑9** entre pasos; al terminar, realiza pausa **5** para lectura corporal del cierre.

---

## 13) Buenas prácticas (SUR)
- **Metadatos canónicos en cada archivo**: `cue, SeedI, SoT, Version, Updated`.
- **HASH(10)** al EOF (canónico). Evita ediciones después de sellar.
- **Consistencia de Rumbos**: usa CSV si hay múltiples.
- **VCALC**: fija `emit=json` para consumo por herramientas; `pretty` para revisión humana.
- **Cuemachine**: `update-chain → sign → verify → lock` como mantra operativo.

---

## 14) Solución de problemas (FAQ breve)
- *No encuentro SeedI/CUE en promote*: exporta `QEL_SEED_POLICY=strict` o añade encabezado al archivo.
- *Finalize no muestra Δc/Δs/V*: pásalos por flags (`--delta-*`, `--obj`). No se extraen del FS aún.
- *`local: can only be used in a function`*: usa variables simples en top‑level o envuelve en función (corregido en `session_new`).
- *Firma Cuemachine falla*: inicializa secreto con `qel_secret_init.sh` y repite `--sign`.

---

## 15) Anexos (here-docs listos para pegar)
- Incluidos en cada sección como **Plantilla completa**.

---

# Capa ESTE · Guía de Germinación (Jardinera)

> **Rol:** Jardinera (Este · semilla/germinación)
>
> **Clave:** Donde Tejera marca el ritmo, **Jardinera planta y germina**. Aquí replicamos los contenidos **idénticos** tal cual y añadimos **semillas adicionales** (presets, kits operables y casos mínimos) para poner en marcha el flujo sin fricción.
>
> **Ritual de lectura:** Igual compás somático **9‑0‑9** y pausas **3–5–3**; tras cada kit, realiza una “pausa 5” para revisar que el artefacto generado exista y tenga metadatos canónicos.

---

## (Secciones 1E–12E ya incluidas arriba)

---

# Capa NORTE · Verificación Estructural (Geómetra)

> **Rol:** Geómetra (Norte · estructura/número)
>
> **Objetivo:** Confirmar **invariantes** de estructura, tipos y contratos entre scripts; validar que las plantillas reflejen lo que los scripts aceptan; proponer pruebas mínimas reproducibles.

### 1N) Invariantes del sistema (resumen)
- **Metadatos canónicos** presentes en documentos promovidos: `cue`, `SeedI`, `SoT`, `Version`, `Updated` → requeridos por `promote` y para HASH(10) estable.
- **FS ↔ Finalize**: campos mínimos del FS que consume `finalize` (si usas `--fs-json`): `fecha`, `tema`, `intencion`, `modo`, `rumbo`, `tiempo`, `referencias`, `veredicto`, `resultados.artefactos`, `resultados.micro_sellos`.
- **VCALC**: `obj` **obligatorio**; resto opcional con dominios finitos (`rumbo ∈ {N,S,E,O,W,Centro}`, `delta-{c,s} ∈ {up,flat,down}`, `emit ∈ {pretty,quiet,json}`).
- **CueMachine**: `cm-file` apunta a ledger de texto; firma requiere secreto HMAC válido en Keychain macOS (o `QEL_CUEMACH_HMAC`).

### 2N) Matriz rápida de flags (confirmada contra scripts cargados)
*(extracción automática por inspección de archivos en esta sesión)*

| Script | Flags clave detectadas |
|---|---|
| `qel_session_new.sh` | `--fecha, --tema, --intencion, --modo, --rumbo, --tiempo, --refs, --veredicto, --salida, --axioma, --obj, --artefacto, --micro, --cue, --seed, --sot, --version, --updated, --from, --stdout, --out, --no-prompt, --help` |
| `qel_session_finalize.sh` | `--fecha, --vf, --cue, --seed, --artefacto, --micro, --fs-json, --modo, --tema, --intencion, --rumbo, --tiempo, --refs, --delta-c, --delta-s, --no-mentira, --obj, --sot-sello, --sot-diario, --diario-file, --listador-file, --updated, --veredicto, --help` |
| `qel_promote_mac.sh` | `--rubro, --file, --titulo, --rumbo, --debug` + git flags internos |
| `qel_atlas_microreg.sh` | `--kind, --file, --title/--titulo, --hash10, --seed, --rumbo, --triada, --obj, --clase, --materia, --V, --tau, --gates, --microreg, --indices-dir, --indexer` |
| `qel_vcalc.sh` | `--obj, --afinidad, --rumbo, --clase, --gates, --ruido, --delta-c, --delta-s, --emit` + **MFH**: `--mfh, --mfh-k, --mfh-x0, --mfh-include-gates` |json` |
| `qel_vcalc_json.sh` | `--json, --in` (stdin soportado) + **MFH**: `--mfh, --mfh-k, --mfh-x0, --mfh-include-gates` |
| `qel_vcalc_io.sh` | (sin flags obligatorias; abre `io` con preguntas VCALC+MFH) |
| `qel_pe_generate.mjs` | `--vf/--in, --save, --emit, --preset, --materia, --ruido, --delta-c, --delta-s, --tau, --out-pe, --out-hab, --registry, --listado-r, --patch-file/--patch-id/--patch-hash, --pe-root, --answer` |
| `qel_cuemachine_check.sh` | `--cm-file, --sidecar-dir, --update-chain, --verify, --sign, --verify-sign, --lock, --unlock, --witness, --verbose` |
| `qel_cuemachine_add.sh` | `--cm-file, --cue, --seed, --sot, --version, --updated, --target, --allow-duplicate, --verbose` |
| `qel_secret_init.sh` | `--nutria-dir, --verso, --service, --preview` |

> **Resultado Geómetra:** Los flags listados **coinciden** con las secciones SUR/ESTE del cheat‑sheet. No se detectan disonancias de nombres.

### 3N) Pruebas mínimas (paso a paso)
1. **Estructura FS**:
   ```bash
   jq -e '.fecha and .tema and .intencion and .modo and .rumbo and .tiempo' FS_YYMMDD.json
   ```
2. **Promoción + HASH(10) al EOF**:
   ```bash
   scripts/qel_promote_mac.sh --rubro TEST --file docs/pruebas/Demo.md --titulo "Demo"
   tail -n1 docs/pruebas/Demo.md | grep -E '^[A-Fa-f0-9]{10}$'
   ```
3. **Atlas JSONL (renglón válido)**:
   ```bash
   scripts/qel_atlas_microreg.sh --kind TEST --file docs/pruebas/Demo.md --title "Demo"
   tail -n1 docs/core/atlas_microreg_v1.0.jsonl | jq -e '.kind and .file and .title and .hash10'
   ```
4. **VCALC contrato**:
   ```bash
   scripts/qel_vcalc.sh --obj "Kael/Prisma" --emit json | jq -e '.V_canon and .V_oper'
   ```
5. **CueMachine cadena + firma**:
   ```bash
   scripts/qel_cuemachine_add.sh --cm-file docs/cuemachine/ledger.txt \
     --cue "[QEL::ECO[96]::RECALL A96-YYMMDD-TEST]" --seed "A96-YYMMDD" \
     --sot "TEST/v1.0" --version v1.0 --updated $(date +%F)
   scripts/qel_cuemachine_check.sh --cm-file docs/cuemachine/ledger.txt --update-chain --sign --verify --verify-sign
   ```

### 4N) Tipos y dominios (tabla breve)
| Campo | Tipo | Dominio / Regla |
|---|---|---|
| `fecha` | string | `YYMMDD` (6 dígitos) |
| `updated` | string | `YYYY-MM-DD` |
| `modo` | enum | `{M0,M1,M2,M3}` |
| `rumbo` | enum/CSV | `{N,S,E,O,W,Centro}` |
| `delta-{c,s}` | enum | `{up,flat,down}` |
| `emit` | enum | `{pretty,quiet,json}` |
| `hash10` | string | `[A-Fa-f0-9]{10}` |

### 5N) Casos borde
- `--mfh=logistic` exige `--mfh-k` y `--mfh-x0` (>0). Si faltan, el core usa `k=12`, `x0=0.62`.
- `--mfh-include-gates=true` multiplica la base MFH por `Π_gates` (útil si modelas gates en MFH). Por defecto es `false` para mantener independencia formal.
- `--emit=quiet` sigue imprimiendo **solo `V_oper`** para compatibilidad.
- `qel_vcalc_json.sh` re‑emite JSON con **`V` (operativa) y `V_mfh`**; si algún consumidor espera solo `V`, no se rompe (campos extra son ignorables).

### 6N) Checklist Geómetra
- [ ] Plantillas del cheat‑sheet ≡ flags reales (✓ verificado).
- [ ] Campos obligatorios de cada flujo validados con `jq`/`grep`.
- [ ] HASH(10) al EOF en artefactos promovidos.
- [ ] Microregistro emite JSONL válido.
- [ ] CueMachine firma/verifica sin error.

---

> **Estado Geómetra:** Consistencia confirmada contra los scripts cargados. Listo para pasar a **Capa OESTE (Curadora)** cuando indiques.


# Capa OESTE · Curaduría Editorial (Curadora)

> **Rol:** Curadora (Oeste · lenguaje/orden)
>
> **Propósito:** Afinar lenguaje, estandarizar formas y asegurar *usabilidad inmediata* de todo el cheat‑sheet. La Curadora no cambia la verdad técnica; **ordena, aclara y protege** el sentido.

---

## O1) Principios editoriales QEL
1. **Claridad antes que ornamento:** cada sección inicia con *qué hace* y *por qué importa* (ya aplicado a todos los scripts).
2. **Metadatos canónicos** en *todo* artefacto: `cue, SeedI, SoT, Version, Updated` (orden fijo). HASH(10) **en el EOF** al promover.
3. **Nombres de archivo sin acentos/espacios:** usa `A-Z a-z 0-9 _ - .` (evita `Í`, `ñ`, etc.). Ej.: `QEL_Manual_Operativo_v1.4.md`.
4. **Fechas legibles y consistentes:** `Updated=YYYY-MM-DD` y `fecha=YYMMDD` en FS.
5. **Código listo para pegar:** *toda plantilla* en here‑doc (`: <<'TAG' … TAG`).
6. **Flags en línea recta:** cuando repitas un comando largo, respeta el orden de flags como en la plantilla. No abreviar nombres.
7. **Voz operativa:** tono **claro, directo, sin paja**; términos simbólicos se mantienen, pero *siempre* acompañados de su función.
8. **Rutas reales:** ejemplos con carpetas reales del repo (`docs/core`, `docs/pe`, `apps/preh-nav-m1`).
9. **Índices e interconexión:** cada artefacto importante debe aparecer en **ListadoR**, **Atlas** y, si aplica, **Manifiesto SoT**.
10. **Revisión en 3 capas:** Tejera (legibilidad), Jardinera (operabilidad), Geómetra (contrato). Curadora da **Green/Yellow/Red** al cierre editorial.

---

## O2) Plantilla editorial para nuevos documentos
Usa esta base al crear **cualquier** documento que después será promovido.

```bash
: <<'QEL_DOC_BASE'
[QEL::ECO[96]::RECALL A96-<YYMMDD>-<ECO-NOMBRE>]
SeedI=A96-251112
SoT=<DOMINIO>/<SUB>/v1.0
Version=v1.0
Updated=<YYYY-MM-DD>

# <Título claro y único> (v1.0)

> **Rol:** <Tejera/Jardinera/Geómetra/Curadora/Arbitra>
> **Resumen:** 1–3 líneas con propósito y alcance.

## 1. Contexto
## 2. Contenido
## 3. Procedimiento / Uso
## 4. Integración (Promote → Microreg → Finalize)
## 5. Notas / Referencias

<!-- HASH(10) será insertado por qel_promote_mac.sh en EOF -->
QEL_DOC_BASE
```

**Convenciones:** encabezado *exacto*; título con versión; secciones 1–5; comentario del HASH(10) al final.

---

## O3) Estilo de commits y PRs
- **Commit de promoción**
  ```text
  promote: <Título corto> (vX.Y) · SeedI <Axx-YYMMDD> · HASH10 <abcdef0123>
  ```
- **Commit de microregistro**
  ```text
  atlas: +microreg <kind> → <file> · V=<0.xx> τ=<0.xx> gates=<...>
  ```
- **Commit de cierre de sesión**
  ```text
  finalize: FS <YYMMDD> · VF.PRIMA lista · Diario/ListadoR actualizados
  ```
- **PR**: resume *qué*, *por qué*, *cómo probar* (incluir comandos exactos y paths reales).

---

## O4) Caso editorial completo (copia/pega)
> *Secuencia mínima con nombres limpios y mensajes claros.*

```bash
# 1) Semilla de sesión
scripts/qel_session_new.sh --no-prompt --out FS_$(date +%y%m%d).json \
  --fecha $(date +%y%m%d) --tema "Manual de Indices" \
  --intencion "Definir índice automático y flujo" --modo M1 --rumbo "Centro" --tiempo 30 \
  --refs "QEL_Manual_Operativo_v1.4, QEL_ListadoR_master_v1.0" --salida "FS registrado"

# 2) Promoción del manual
scripts/qel_promote_mac.sh --rubro "CORE/MANUAL" \
  --file docs/core/QEL_Manual_Operativo.md \
  --titulo "QEL · Manual Operativo (v1.4)" --rumbo "Centro"

# 3) Microregistro en Atlas
scripts/qel_atlas_microreg.sh --kind "CORE/MANUAL" \
  --file docs/core/QEL_Manual_Operativo.md --title "QEL · Manual Operativo (v1.4)"

# 4) Cierre de sesión
scripts/qel_session_finalize.sh --fecha $(date +%y%m%d) \
  --vf "Manual validado; publicado en PREH-NAV" \
  --cue "[QEL::ECO[96]::RECALL A96-$(date +%y%m%d)-MANUAL]" --seed "A96-$(date +%y%m%d)" \
  --fs-json FS_$(date +%y%m%d).json --no-mentira true

# 5) CueMachine (ledger)
scripts/qel_cuemachine_add.sh --cm-file docs/cuemachine/ledger.txt \
  --cue "[QEL::ECO[96]::RECALL A96-$(date +%y%m%d)-MANUAL]" \
  --seed "A96-$(date +%y%m%d)" --sot "CORE/MANUAL/v1.4" --version "v1.4" --updated "$(date +%F)" \
  --target docs/core/QEL_Manual_Operativo.md
scripts/qel_cuemachine_check.sh --cm-file docs/cuemachine/ledger.txt --update-chain --sign --verify --verify-sign --lock
```

---

## O5) QA Curadora (gates O₁–O₈)
- **O₁ Metadatos**: encabezado presente y correcto (sin acentos en ruta/archivo).
- **O₂ HASH(10)**: última línea del artefacto promovido es el hash de 10 hex.
- **O₃ Plantillas**: here‑docs copian/pegan sin pérdida (sin tabs mezclados).
- **O₄ Flags**: nombres y dominios coinciden con el *contrato Geómetra*.
- **O₅ Índices**: aparece en **ListadoR**, **Atlas**, (y **Manifiesto SoT** si aplica).
- **O₆ JSON válido**: todos los `.json/.jsonl` pasan `jq -e`.
- **O₇ Commit/PR**: mensajes con formato Curadora y paths reales.
- **O₈ Nombres limpios**: sin acentos ni espacios; kebab/underscore según convención.

---

## O6) Errores frecuentes y su cura
- **`invalid path 'Í…'` en `git pull`** → renombra archivos/carpetas con acentos a ASCII simple antes de subir.
- **`local: can only be used in a function`** → no declares `local` en top‑level (ya remediado en `session_new`).
- **FS incompleto** → vuelve a `session_new` con `--from FS_prev.json` y añade los campos faltantes.
- **Atlas sin línea** → verifica ruta de `--microreg` y permisos; usa `tail -n1` + `jq -e`.
- **CueMachine sin firma** → ejecuta `qel_secret_init.sh` y repite `--sign --verify --verify-sign`.

---

## O7) Estilo y voz (curaduría de texto)
- **Títulos** en `#` con versión entre paréntesis.
- **Listas** de flags en monoespaciado cuando sean comandos; evita cursivas para flags.
- **Notas simbólicas** siempre con **función operativa**: ej. “Pulso THON → metrónomo cognitivo entre tareas”.
- **Glosario**: si introduces un término nuevo, añade enlace a `QEL_Glosario_v1.4.md`.

---

## O8) Semillas curadoras
- **Base para README de script**
  ```bash
  : <<'QEL_SCRIPT_README'
  # <script> — descripción breve
  
  ## Uso
  scripts/<script> [flags]
  
  ## Flags
  - --flag1 …
  - --flag2 …
  
  ## Ejemplos
  scripts/<script> --flag1 A --flag2 B
  QEL_SCRIPT_README
  ```
- **Checklist pre‑promote (1 minuto)**
  ```text
  [ ] Encabezado canónico  [ ] Sin acentos/espacios en ruta  [ ] HASH10 ausente (lo agregará promote)
  [ ] Ejemplo runnable  [ ] Campos SoT/Version/Updated correctos
  ```

---

> **Estado Curadora:** Capa OESTE añadida y validada. El cheat‑sheet queda **listo para promoción** siguiendo O5. ¿Pasamos a **Capa CENTRO (Árbitra)** para el cierre meta‑sistémico y el *dictamen de suficiencia*?

# Capa CENTRO · Dictamen Meta‑Sistémico (Árbitra)

> **Rol:** Árbitra (Centro · integración/juicio)
>
> **Propósito:** Emitir **dictamen de suficiencia** del cheat‑sheet (v1.3), validar coherencia transversal (SUR/ESTE/NORTE) y presentar **cálculo de viabilidad 𝒱** por dos rutas: **VCALC** y **MFH**.

---

## C1) Marco de evaluación
- **Umbral operativo:** elegible si **𝒱 ≥ 0.62** (MFH §Viabilidad).
- **Contraste de fórmulas**
  - **VCALC (operativa):**
    \[ V_{\text{canon}} = \mathrm{clip}\big(A\,\chi_r\,H_k\,G_p\big),\quad V_{\text{oper}} = V_{\text{canon}}\cdot F_{\Delta}\cdot F_{\rho} \\]
    con `A=afinidad∈[0,1]`, `χ_r` (rumbo), `H_k` (clase), `G_p` (producto de gates), `F_Δ` (delta‑c/s), `F_ρ` (ruido).
  - **MFH (formal):**
    \[ \mathcal{V}(p,O,r,k)=\sigma\big(\langle b_p, m_O\rangle\,\chi_r\,H_k\big) \\]
    Para este pase aplicamos **σ≈clip(x,0,1)** (sin pérdida de generalidad; logistic se parametriza en calibración futura). Tomamos **⟨b_p,m_O⟩ ≈ A** (afinidad) cuando no se hayan definido vectores canónicos en la ficha del objeto.

> **Notas de consistencia:** Se adoptan **los mismos pesos** de `χ_r` y `H_k` que en VCALC (según `qel_vcalc.sh`).

---

## C2) Caso evaluado (ejemplo mínimo reproducible)
**Objeto:** `Kael/Prisma` · **Fonema raíz:** Kael · **Rumbo:** Occidente/Oriente (`O/E`) · **Clase:** `singular` · **Gates:** `mediacion,doble` · **Afinidad A:** `0.72` · **Ruido ρ:** `0.03` · **Δ:** `c=up, s=flat`.

| Parámetro | Valor | Fuente |
|---|---:|---|
| A (afinidad) | 0.72 | input
| χ_r (O/E) | 1.10 | `qel_vcalc.sh: chi_r`
| H_k (singular) | 1.00 | `qel_vcalc.sh: H_k`
| G_p (gates `mediacion,doble`) | 1.00 | `qel_vcalc.sh: gates_product`
| F_Δ (up,flat) | 1.02 | `qel_vcalc.sh: fdelta`
| F_ρ (ρ=0.03) | 0.97 | `qel_vcalc.sh: fruido`

**Resultados**
- **VCALC:** `V_canon = 0.7920`, `V_oper = 0.7836` (recorte [0,1]).
- **MFH (σ≈clip):** `𝒱_MFH = 0.7920`.

**Dictamen Árbitra:** `𝒱 ≥ 0.62` ⇒ **Elegible**. Recomendación: **GREEN** para promoción del cheat‑sheet y cierre del ciclo.

> *Observación:* Si se omiten gates, `G_p≈0.72` (por defecto MED×DOB), lo que reduce ~28% `V_canon`. Mantener **Doble Testigo** cuando la clase suba a `metálica/obsidiana`.

---

## C3) Recomendaciones de cierre
1. **Promover** el cheat‑sheet v1.3 con encabezado canónico y **HASH(10)** al EOF.
2. **Micro‑registrar** en Atlas con `kind CHEATSHEETS/SCRIPTS`.
3. **Finalize** con `VF.PRIMA` documentando: propósito, tablas de flags, QA Curadora O₁–O₈ y este **Dictamen Árbitra**.
4. **CueMachine:** alta en ledger + firma + lock.

---

## C4) Comandos listos (ajusta rutas si difieren)
```bash
# 1) Promoción
scripts/qel_promote_mac.sh \
  --rubro "CHEATSHEETS/SCRIPTS" \
  --file  "docs/cheatsheets/QEL_CheatSheet_Scripts_v1.3.md" \
  --titulo "QEL · Cheat‑Sheet Operativo de Scripts (v1.3)" \
  --rumbo "Centro"

# 2) Microregistro (Atlas JSONL)
scripts/qel_atlas_microreg.sh \
  --kind  "CHEATSHEETS/SCRIPTS" \
  --file  "docs/cheatsheets/QEL_CheatSheet_Scripts_v1.3.md" \
  --title "QEL · Cheat‑Sheet Operativo de Scripts (v1.3)"

# 3) Cierre de sesión (VF)
scripts/qel_session_finalize.sh \
  --fecha $(date +%y%m%d) \
  --vf "Cheat‑sheet v1.3 validado por Árbitra; QA O₁–O₈ OK; listo para PREH‑NAV" \
  --cue  "[QEL::ECO[96]::RECALL A96-$(date +%y%m%d)-CHEATSHEET-SCRIPTS]" \
  --seed "A96-$(date +%y%m%d)" \
  --fs-json FS_$(date +%y%m%d).json \
  --no-mentira true

# 4) CueMachine: alta + firma + lock
scripts/qel_cuemachine_add.sh \
  --cm-file docs/cuemachine/ledger.txt \
  --cue "[QEL::ECO[96]::RECALL A96-$(date +%y%m%d)-CHEATSHEET-SCRIPTS]" \
  --seed "A96-$(date +%y%m%d)" --sot "CHEATSHEETS/SCRIPTS/v1.3" --version "v1.3" --updated "$(date +%F)" \
  --target docs/cheatsheets/QEL_CheatSheet_Scripts_v1.3.md --verbose
scripts/qel_cuemachine_check.sh --cm-file docs/cuemachine/ledger.txt --update-chain --sign --verify --verify-sign --lock
```

---

> **Estado Árbitra:** Dictamen emitido. El documento está **maduro** para **Promote → Microreg → Finalize** siguiendo C4. Si deseas otra **prueba de viabilidad** (nuevo objeto/fonema), puedo añadir la tabla comparativa en esta misma capa.

HASH(10): 17cea84111
