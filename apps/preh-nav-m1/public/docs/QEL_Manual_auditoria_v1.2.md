[QEL::ECO[96]::RECALL A96-251104-MANUAL-AUDITORIA]
SeedI=A96-251104
SoT=CORE/MANUAL
Version=v1.0
Updated=<2025-11-04>

# Manual de Auditoría QEL · Flujo completo (v1.2)

> **Propósito**: Establecer un flujo claro, repetible y humano‑legible para **auditar, corregir y consolidar** la trazabilidad de artefactos QEL (Markdown y afines), integrando ListadoR, Atlas, PREH‑NAV y el sellado con HASH(10).
>
> **Alcance**: Repositorio `codex` y subárboles relacionados.
>
> **Roles**: Tejera (tejido), Jardinera (orden), Geómetra (estructura), Curadora (consistencia), Árbitra (cierre).

---

## 0) Conceptos base

- **Artefacto**: Documento versionado (p. ej., `.md`) con front‑matter mínimo y metadatos QEL (`SeedI`, `SoT`, `Version`, `Updated`, `CUE`, `HASH(10)`).
- **ListadoR**: Registro maestro humano‑legible que **refiere** a artefactos, con líneas de contexto y metadatos adyacentes.
- **Atlas (JSONL)**: Micro‑registro estructurado por artefacto (`atlas_microreg_v1.0.jsonl`).
- **Exposición pública**: Copia de artefactos en `apps/preh-nav-m1/public/docs` (para PREH‑NAV).
- **HASH(10) canónico (de documento)**: Sello de 10 hex en la **última línea** del archivo. Lo garantiza `qel_promote_mac.sh` (y `autofix` sólo cuando procede para desbloquear auditorías). **No debe cambiar por ediciones menores**; idealmente solo cambia con **nueva versión** del documento.
- **Hash de auditoría (de reporte)**: Identificador opcional **sólo en reportes** (no se escribe en EOF de los `.md`). Útil para rastrear corridas de auditoría.
- **Ledger de hash canónico**: Registro auxiliar (`qel_hash_canonicalize_ledger.sh`) para asegurar que el hash de documento permanezca estable entre corridas y para reconciliar discrepancias con ListadoR/Diario.

---

## 1) Flujo de trabajo (visión general)

```
[Preparación] → [Auditoría] → [Análisis de reporte] → [Autofix seguro]
                → [Resolución de SoT] → [Promoción + Atlas] → [Finalización] → [Re‑auditoría]
```

**Orden recomendado (alto nivel):**
1. **Preparar entorno** (opcional): `qel_verify_env.sh`.
2. **Auditar**: `qel_trace_audit.sh` (dry‑run). Genera `out/qel_trace_report.csv` + **apéndice** con sello de tiempo en `out/qel_trace_report.md`.
3. **Leer reporte**: Priorizar `E1`/`E12`/`E11`/`E2` → luego `E8`/`E9`/`E6`/`E7`.
4. **Autofix** (mínimos seguros): `qel_trace_autofix.sh` (dry‑run → aplicar con `APPLY=1`).
5. **Resolver SoT**: `qel_sot_resolve.sh` (fuentes autorizadas + heurísticas; ver §4).
6. **Promoción + sellado**: `qel_promote_mac.sh` (HASH(10) canónico, ListadoR, copia a `public/docs`).
7. **Atlas**: `qel_atlas_microreg.sh` (línea JSONL por artefacto).
8. **Ledger de HASH** *(opcional, recomendado)*: `qel_hash_canonicalize_ledger.sh` para consolidar/normalizar el hash canónico entre Diario/ListadoR/artefacto.
9. **Finalizar sesión**: `qel_session_finalize.sh` (VF.PRIMA, MicroSello, Diario, ListadoR, manifests).
10. **Re‑auditar**: `qel_trace_audit.sh` para confirmar **cero** `E1/E2/E11/E12` y mínimos `E8/E9/E6`.

> **Tip**: Trabaja en **ramas** (`PreH` o feature) y confirma cada fase con commits pequeños.

---

## 2) Niveles de auditoría (perfiles de alcance)

Para equilibrar **tiempo** vs **cobertura**, usa tres niveles:

- **Nivel 1 · Foco** — *Rápido*: sólo núcleo de trabajo.
  - `DOCS_DIRS="docs"`
  - Uso: verificación continua mientras editas.

- **Nivel 2 · Extendida** — *Amplia*: núcleo + memoria.
  - `DOCS_DIRS="docs memory"`
  - Uso: cierre parcial de iteraciones.

- **Nivel 3 · Integral** — *Completa*: todo el repo útil (incluye `README` y `pub`).
  - `DOCS_DIRS="docs memory README pub"`
  - Uso: **cierre de auditoría** antes de una promoción grande o release.

> Mantén `EXCLUDE_DIRS` para evitar `apps/*/src`, `node_modules`, `scripts`, `out`, etc. La auditoría ya evita duplicar `apps/*/public/docs`.

---

## 3) Scripts y responsabilidades

| Script | Objetivo | Entrada clave | Salida/efecto | Notas |
|---|---|---|---|---|
| `qel_verify_env.sh` | Verifica binarios / dependencias | — | Mensajes de verificación | Opcional pero útil en máquinas nuevas. |
| `qel_trace_audit.sh` | Audita trazabilidad (E1–E12) con progreso y múltiples raíces | `DOCS_DIRS`, `EXCLUDE_DIRS`, `INCLUDE_EXT`, `LISTADOR`, `ATLAS_JSONL`, `CHECK_PUBLIC` | `out/qel_trace_report.csv` + **apéndice** en `out/qel_trace_report.md` | Evita `apps/*/public/docs`; imprime ETA; apéndice por corrida con fecha. |
| `qel_trace_autofix.sh` | Corrige **mínimos seguros** (front‑matter, CUE inferible, HASH(10) faltante) | `APPLY=1` | Archivos modificados + diff en dry‑run | No pisa contenido rico; respeta SoT existente. |
| `qel_sot_resolve.sh` | Resuelve `SoT=UNSET` (o no canónicos si `FIX_CANONICAL=1`) | `USE_PREHNAV`, `LISTADOR_POLICY`, `APPLY`, `REPORT_EXISTING_UNCLASSIFIED` | Actualiza SoT, normaliza canónico; **reporte** `out/qel_sot_resolve_report.md` + CSV de `UNCLASSIFIED` | **Arreglo clave**: loop principal por *process substitution* (no subshell) y reporte de `UNCLASSIFIED` ya existentes. |
| `qel_promote_mac.sh` | Promueve y garantiza **HASH(10)** canónico | Artefacto(s) | HASH(10) en EOF; actualiza ListadoR; copia a `public/docs`; commit | Seed‑aware; `QEL_SEED_POLICY` respeta/deriva `SeedI`. |
| `qel_atlas_microreg.sh` | Registra Atlas (JSONL) | `--kind`, `--file`, `--title`, etc. | Línea JSONL en `docs/core/atlas_microreg_v1.0.jsonl` | Usa `HASH10` si está o lo calcula. |
| `qel_hash_canonicalize_ledger.sh` | Canoniza/concerta HASH con Diario/ListadoR | Rutas de fuentes | Salida de conciliación + notas | Asegura persistencia del hash canónico entre corridas. |
| `qel_session_finalize.sh` | Cierre ritual/operativo | `--fecha/--seed/--cue/--vf` | VF.PRIMA, MicroSello, Diario, ListadoR; commits | Con manifiestos para PREH‑NAV. |

---

## 4) Errores (E1–E12) y cómo atacarlos

**Prioridad de corrección:** `E1` → `E12` → `E11` → `E2` → `E8` → `E9` → `E6` → `E7` → (`E10` si se activa)

| Código | Qué detecta | Causas típicas | Corrección recomendada |
|---|---|---|---|
| **E1** | Front‑matter incompleto (SeedI/SoT/Version/Updated) | Artefactos históricos, plantillas antiguas | `autofix` + revisión humana; luego `promote`. |
| **E12** | CUE faltante `[QEL::ECO[..]::RECALL ...]` | Documento no tejido por Telar | Si hay ECO/SeedI, `autofix` puede proponer; de lo contrario, completar manualmente. |
| **E11** | SoT no canónico | Espacios/minúsculas/`UNSET` | Normalizar/`sot_resolve` (ver §5). |
| **E2** | Falta HASH(10) en EOF o mal formateado | Artefactos sin `promote` | Promover o `autofix` y luego **promover** para el sello canónico. |
| **E8** | No aparece en ListadoR | Artefacto nuevo u órfano | `promote` añade bloque; o registrar manualmente. |
| **E9** | No aparece en Atlas | Micro‑registro no emitido | Ejecutar `qel_atlas_microreg.sh`. |
| **E6** | Ruta en ListadoR ≠ ruta real | Movido sin actualizar | Corregir en ListadoR o reubicar el archivo. |
| **E7** | `Updated` < máximo histórico | Retroceso de versión/fecha | Ajustar `Updated` o consolidar entradas. |
| **E10** | No expuesto en `public/docs` (`CHECK_PUBLIC=1`) | Falta copia pública | `promote` o copiar explícitamente. |

> **Criterio**: Siempre preferir **`promote`** para sellar y alinear ListadoR + copia pública. `autofix` es para desbloquear auditorías y homogeneizar mínimos.

---

## 5) Resolución de SoT (cuando hay `UNSET` o no canónico)

**Orden de fuentes (de mayor a menor autoridad):**
1. **ListadoR**: Bloques cercanos al basename (`SoT=` si existe y no es `UNSET`).
2. **Manifiestos PREH‑NAV**: (si `USE_PREHNAV=1`) mapeo `sot` por path/basename.
3. **Heurística de ruta/nombre**: p. ej., `docs/ritual/vf/*` ⇒ `RITUAL/VF/PRIMA`.
4. **Canonizar valor actual**: si `FIX_CANONICAL=1` y el valor existente sólo requiere normalización.

**Normalización canónica:**
- Mayúsculas + separadores seguros (`/`, `_`, `-`, `.`); regex: `^[A-Z0-9_./-]+$`.
- Eliminación de sufijos de versión en SoT cuando no son parte de la taxonomía (`.../v1.2`).
- Mapeos útiles: `PE` → `PE/POEMA-ENIGMA`.

**Comportamientos clave del script:**
- **Process substitution** en el loop principal (`while ... done < <(find_null)`) para evitar pérdida de contadores.
- `REPORT_EXISTING_UNCLASSIFIED=1` (por defecto): **reporta** archivos con `SoT=UNCLASSIFIED` aunque no los toque.
- `LISTADOR_POLICY=keep|soft|force` al escribir SoT en ListadoR `UPDATE_LISTADOR=1`.
- Reporte Markdown apendizado: `out/qel_sot_resolve_report.md` + CSV `out/qel_sot_unclassified.csv`.

**Ejemplos:**
```bash
# Dry‑run con PREH‑NAV como fuente adicional
USE_PREHNAV=1 bash scripts/qel_sot_resolve.sh

# Aplicar y actualizar ListadoR sólo si está vacío/UNSET
APPLY=1 UPDATE_LISTADOR=1 LISTADOR_POLICY=soft bash scripts/qel_sot_resolve.sh

# Canonizar SoT preexistentes no conformes (sin tocar UNCLASSIFIED)
FIX_CANONICAL=1 bash scripts/qel_sot_resolve.sh
```

---

## 6) Parámetros y configuración

- `DOCS_DIRS`: Raíces a auditar (separadas por `:` **o** espacio). Recomendado Nivel 3: `docs memory README pub`.
- `EXCLUDE_DIRS`: Directorios a excluir (`:` o espacio). Ej.: `.git:node_modules:scripts:tools:out:apps/*/src:apps/*/scripts:apps/*/dist:apps/*/build`.
- `INCLUDE_EXT`: Extensiones a incluir. Por defecto `md,MD`.
- `LISTADOR`: Ruta al ListadoR maestro. Por defecto `docs/core/QEL_ListadoR_master_v1.0.md`.
- `ATLAS_JSONL`: Ruta a Atlas. Por defecto `docs/core/atlas_microreg_v1.0.jsonl`.
- `PUBLIC_DIR`: Carpeta pública PREH‑NAV. Por defecto `apps/preh-nav-m1/public/docs`.
- `CHECK_PUBLIC`: `0`/`1` para activar `E10`.
- `OUT_DIR`, `OUT_CSV`, `OUT_MD`: Carpeta y salidas del reporte de auditoría.
- `TOP_N`: Límite de la tabla “Top archivos con más errores”.
- `PROGRESS_EVERY`: Frecuencia de actualización de progreso (en archivos escaneados).

**Ejemplos:**
```bash
# Auditoría estándar (múltiples raíces, con progreso y apéndice MD)
bash scripts/qel_trace_audit.sh

# Activar revisión de exposición pública (E10)
CHECK_PUBLIC=1 bash scripts/qel_trace_audit.sh

# Auditoría centrada sólo en docs/ y memory/ con exclusiones custom
DOCS_DIRS="docs memory" EXCLUDE_DIRS=".git node_modules scripts tools out" bash scripts/qel_trace_audit.sh
```

---

## 7) Interpretación de reportes

### 7.1 CSV principal (`out/qel_trace_report.csv`)
Campos: `file,SeedI,SoT,Version,Updated,HASH10,errors`.
- `errors` es lista `;`‑separada (p. ej., `E1;E12;E2`).
- Útil para **filtrar** y alimentar scripts (`sot_resolve`, batch promote, etc.).

### 7.2 Markdown de auditoría (`out/qel_trace_report.md`)
- **Apéndices** por corrida con sello de tiempo (`## Auditoría — YYYY‑MM‑DD HH:MM:SS`).
- Métricas **TC/TI/TT/UH** y **IT** global.
- Tabla **Top archivos** para priorizar intervención.

### 7.3 Reporte SoT (`out/qel_sot_resolve_report.md`)
- Apendiza parámetros y **métricas**: resueltos por fuente y conteo de **UNCLASSIFIED**.
- CSV asociado: `out/qel_sot_unclassified.csv`.

---

## 8) Corrección asistida (Autofix seguro)

**Principios**:
- No pisar contenido rico.
- Completar mínimos (`E1`, `E12`, `E2`) cuando puedan inferirse.
- Dejar **marcas** en diffs para revisión humana.

**Secuencia**:
```bash
# Vista previa (dry‑run)
bash scripts/qel_trace_autofix.sh

# Aplicar cambios mínimos
APPLY=1 bash scripts/qel_trace_autofix.sh
```
Resultados típicos:
- Inserta front‑matter mínimo (`SeedI/SoT/Version/Updated`) si estaba vacío.
- Emite CUE cuando se puede derivar (o deja TODO si no).
- Coloca `HASH(10)` en EOF si faltaba. **El sello canónico definitivo** lo establece la **promoción**.

---

## 9) Promoción, Ledger, Atlas y Finalización

1) **Promoción** — `qel_promote_mac.sh`:
   - Deriva/valida **SeedI**, ajusta **HASH(10)** canónico en EOF.
   - Actualiza **ListadoR** con metadatos y ruta exacta.
   - Copia a **`public/docs`** (exposición PREH‑NAV). Commit + push.

2) **Ledger de hash** — `qel_hash_canonicalize_ledger.sh` *(opcional, recomendado)*:
   - Reconciliación **hash documento ↔ Diario/ListadoR**.
   - Política: **mantener hash** entre ediciones menores; **rotar** sólo con nueva versión o promoción explícita.

3) **Atlas** — `qel_atlas_microreg.sh`:
   - Añade línea a `atlas_microreg_v1.0.jsonl` con `KIND, FILE, TITLE, HASH10, ...`.

4) **Finalización** — `qel_session_finalize.sh`:
   - Genera **VF.PRIMA**, **MicroSello**, **Diario**, actualiza **ListadoR** y manifiestos.

---

## 10) Estrategia de commits y seguridad

- Siempre en ramas de trabajo (`feature/auditoria-YYYYMMDD`).
- Commits pequeños por lote de correcciones (p. ej., “autofix E1/E2 lote‑1”).
- `git diff` antes de aplicar; `git tag` en hitos.
- Respaldo previo si se toca una gran cantidad de archivos.

**Plantilla de commit**:
```
Auditoría QEL: autofix mínimos + promoción parcial

- E1/E2/E12 corregidos en N artefactos
- SoT normalizado (X casos)
- ListadoR actualizado (Y entradas)
- Atlas microreg: Z líneas
```

---

## 11) FAQ y problemas comunes

**`find: docs:memory:README:pub: No such file or directory`**  
El `find` interpretó `DOCS_DIRS` como **una** sola ruta. Solución: usa el buscador integrado de los scripts (acepta `:` o espacios) **o** exporta como espacios: `export DOCS_DIRS="docs memory README pub"`.

**Reporte `.md` se sobreescribe**  
La versión actual **apendiza** por corrida con sello de tiempo. Si el archivo existía vacío, crea el encabezado.

**Mucho `SoT=UNSET`**  
Ejecuta `qel_sot_resolve.sh`. Con `USE_PREHNAV=1` agrega manifiestos PREH‑NAV como fuente. Con `LISTADOR_POLICY=soft` actualiza ListadoR sólo si vacío/`UNSET`.

**`Unknown regexp modifier` al editar SoT**  
Ocurre si se intenta reemplazar con `perl -pe` valores que contienen `/`. Solución adoptada: uso de `awk` (`write_kv`) para escribir `SoT=` de forma segura.

**`sot_resolve` no cuenta nada (0 cambios)**  
Usar `while ... done < <(find_null)` (process substitution) en lugar de piping a un `while`, que crea subshell y pierde contadores.

**PREH‑NAV manifest no encontrado**  
Con `USE_PREHNAV=1`, el script advertirá si falta `apps/preh-nav-m1/public/sot-manifest.json`. Ajusta `PREHNAV_MANIFEST` o desactiva la fuente.

---

## 12) Checklist operativo

* [ ] **Elegir nivel de auditoría** (§2) y exportar `DOCS_DIRS` acorde.
* [ ] `qel_trace_audit.sh` (dry‑run) → leer **Top errores**.
* [ ] `qel_trace_autofix.sh` (dry‑run → `APPLY=1`) para `E1/E2/E12` mínimos.
* [ ] `qel_sot_resolve.sh` (con `USE_PREHNAV=1` si aplica) → resolver `UNSET` y normalizar canónicos.
* [ ] `qel_promote_mac.sh` en artefactos corregidos (HASH canónico + ListadoR + public/docs).
* [ ] `qel_hash_canonicalize_ledger.sh` para conciliar hash canónico.
* [ ] `qel_atlas_microreg.sh` para registrar en Atlas.
* [ ] `qel_session_finalize.sh` (sellos, diarios, manifiestos).
* [ ] `qel_trace_audit.sh` (re‑auditoría) → confirmar saneamiento.

### Mini checklist por nivel

#### Nivel 1 - Foco

export DOCS_DIRS="docs"
bash scripts/qel_trace_audit.sh
bash scripts/qel_sot_resolve.sh

#### Nivel 2 - Extendida

export DOCS_DIRS="docs memory"
bash scripts/qel_trace_audit.sh
APPLY=1 bash scripts/qel_trace_autofix.sh
USE_PREHNAV=1 APPLY=1 UPDATE_LISTADOR=1 LISTADOR_POLICY=soft bash scripts/qel_sot_resolve.sh

#### Nivel 3 Integral

export DOCS_DIRS="docs memory README pub"
CHECK_PUBLIC=1 bash scripts/qel_trace_audit.sh
bash scripts/qel_hash_canonicalize_ledger.sh
bash scripts/qel_session_finalize.sh --fecha "<YYMMDD>" --seed "A96-<YYMMDD>" --cue "[QEL::ECO[96]::RECALL A96-<YYMMDD>-...]" --vf "<veredicto breve>"
bash scripts/qel_trace_audit.sh

## 13) Glosario mínimo## 13) Glosario mínimo

- **SeedI**: Identificador semilla del eco (p. ej., `A96-250824`).
- **SoT** (*System of Type*) : Clasificación canónica del artefacto (capas/procesos QEL).
- **CUE**: Línea `[QEL::ECO[xx]::RECALL ...]` que ancla el artefacto al eco‑evento.
- **ListadoR**: Índice maestro humano‑legible de artefactos y metadatos.
- **Atlas**: Registro estructurado por artefacto en JSONL.
- **HASH(10)**: Sello de integridad (10 hex) en la **última** línea del archivo.
- **PREH‑NAV**: Front‑end de consulta (carpeta `public/docs`).
- **TC/TI/TT/UH/IT**: Métricas de auditoría (Traza‑Completitud, Integridad cruzada, Temporalidad, Unicidad de HASH, Índice Global).

---

## 14) Anexos

### 14.1 Variables de entorno rápidas
```bash
# Raíces y exclusiones (Nivel 3)
export DOCS_DIRS="docs memory README pub"
export EXCLUDE_DIRS=".git node_modules scripts tools out apps/*/src apps/*/scripts apps/*/dist apps/*/build"
export INCLUDE_EXT="md,MD"

# Maestros
export LISTADOR="docs/core/QEL_ListadoR_master_v1.0.md"
export ATLAS_JSONL="docs/core/atlas_microreg_v1.0.jsonl"

# Auditoría visual
export PROGRESS_EVERY=200
```

### 14.2 Secuencia de comandos típica
```bash
# 1) Auditoría
bash scripts/qel_trace_audit.sh

# 2) Autofix mínimos
bash scripts/qel_trace_autofix.sh           # dry‑run
APPLY=1 bash scripts/qel_trace_autofix.sh   # aplicar

# 3) Resolver SoT pendientes
USE_PREHNAV=1 bash scripts/qel_sot_resolve.sh              # dry‑run
APPLY=1 UPDATE_LISTADOR=1 LISTADOR_POLICY=soft bash scripts/qel_sot_resolve.sh

# 4) Promoción y Atlas
bash scripts/qel_promote_mac.sh --file <artefacto>
bash scripts/qel_atlas_microreg.sh --kind DOC --file <artefacto> --title "..."

# 5) Ledger de HASH (opcional)
bash scripts/qel_hash_canonicalize_ledger.sh

# 6) Finalización
bash scripts/qel_session_finalize.sh --fecha "YYMMDD" --seed "A96-YYMMDD" --cue "[...]" --vf "..."

# 7) Re‑auditoría
bash scripts/qel_trace_audit.sh
```

### 14.3 Cambios vs v1.0 (resumen)
- Añadidos **tres niveles de auditoría** (Foco, Extendida, Integral).
- `qel_sot_resolve.sh`:
  - Loop con *process substitution* (evita perder contadores).
  - `REPORT_EXISTING_UNCLASSIFIED=1` para reportar `UNCLASSIFIED` ya existentes.
  - Parámetros `USE_PREHNAV`, `LISTADOR_POLICY` documentados.
  - Reportes apéndice + CSV de `UNCLASSIFIED`.
- Política de **HASH canónico** (documento) vs **hash de auditoría** (reporte) y **ledger** de conciliación.
- FAQ ampliado (errores `find`, `Unknown regexp modifier`, manifest PREH‑NAV, etc.).

---

> **Mantén este manual junto a los scripts** y actualízalo cuando cambien la política de SeedI, la forma del HASH(10) o la taxonomía de SoT.
>
> *QEL · Telar vivo. Auditoría como práctica de claridad.*

HASH(10): 3cefde1c94
