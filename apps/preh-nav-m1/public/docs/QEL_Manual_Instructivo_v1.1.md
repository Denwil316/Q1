[QEL::ECO[96]::RECALL A96-250826-MANUAL-INSTRUCTIVO]
SeedI=A96-250824
SoT=HERRAMIENTAS/v1.6
Version=v1.6
Updated=2025-08-27

# QEL · Manual Instructivo — v1.1 (Nutrido con Capa Ritual)

> Objetivo: fijar las **instrucciones básicas y obligatorias** para operar el repositorio QEL con trazabilidad fuerte (ECO/SoT/Listado R), integrando **capa ritual** (Poema‑Enigma, Ronda Lun–Nai, Meditaciones Primordiales) y preparando **Cristalización**. Cada instrucción incluye el **porqué** para auditoría.

---

## 1) Contexto y alcance
- Qué cubre: creación/edición de documentos QEL, registro (**FS/Diario**), validación mínima (**𝒱, ΔC/ΔS, Doble Testigo**) y Capa Ritual completa, cierre (**SIL→UM→Ə**), publicación local (Preh‑Nav) y sincronía del **SoT Manifest**.
- A quién va dirigido: equipo operativo.
- Novedad de esta versión: integra **/core** (MFH, Glosario, Lámina 𝒱, Atlas, Vcalc) y **/ritual** (Poema‑Enigma, Meditaciones Primordiales, Lun–Nai) en un único flujo con criterios de elegibilidad para **Cristalización**.
- Por qué: esta capa ritual aporta **método** (no solo estética). Estándar: 𝒱≥0.62 + ΔC≥0 + No‑Mentira + (si aplica) **Doble Testigo**.

---

## 2) Requisitos y entorno
- macOS + Bash 3.2+.
- Herramientas: `git`, `awk`, `shasum`, `jq` (opcional), `node`/`npm` (manifest/pre‑nav), `python3` (servidor estático).
- Estructura:
  - `docs/core/` — canónicos (MFH v1.5, Glosario v1.5, Lámina 𝒱 v1.1, Atlas v2.2, Vcalc v1.0, SoT Manifest v0.8, ListadoR v1.0, Esculpido v1.1).
  - `docs/ritual/` — VF.PRIMA, cierres, rituales (Poema‑Enigma v1.0/v1.1, Meditaciones Primordiales v1.0, Ronda Lun‑Nai v1.1).
  - `apps/preh-nav-m1/public/docs/` — espejo local para revisión.
- Por qué: separar **núcleo**/**ritual**/**memoria** sostiene SoT y reduce ruido.

---

## 3) Instalación / Setup (mínimo viable)
1) Clona el repo y verifica binarios: `git --version && python3 --version && node -v`.
2) Crea carpetas base si faltan: `docs/{core,ritual} apps/preh-nav-m1/public/docs`.
3) Inserta **cabecera k=v** en cada documento (ver §6.1).
4) Genera **ESTRUCTURA.md** y **SoT Manifest v0.8** cuando cierres sesión.
5) Sirve PREH‑NAV para revisión local.
- Por qué: prepara índice (SoT) y visor (preh‑nav) para lectura común.

---

## 4) Flags y parámetros (resumen operativo)

| Acción | Comando base | Flags clave | Salida | Nota |
|---|---|---|---|---|
| Ayuda | `scripts/qel help` | — | listado | guía de subcomandos |
| Doctor | `scripts/qel doctor` | — | chequeos | entorno mínimo |
| Vcalc | `scripts/qel_vcalc.sh` | ver §8 | 𝒱 y despiece | usar desde M1 |
| Finalizar sesión | `scripts/qel_session_finalize.sh` | `--fecha --seed --cue --vf [--obj k=v]` | VF.PRIMA/Diario/ListadoR/manifest/push | botón rojo |
| Publicar (preh‑nav) | `scripts/qel nav publish` | `--mode link|copy` | espejo en `apps/.../docs` | revisión local |
| Manifest (app/core) | `scripts/qel manifest build|core|sync` | — | manifests actualizados | índices |
| Promover | `scripts/qel promote` | `--rubro --file --titulo --rumbo` | **Cristalización** | ejecutar solo si procede |

Por qué: unificar comandos reduce dispersión y asegura trazabilidad.

---

## 5) Flujos de uso (paso a paso)

### 5.1 Pipeline completo (con Capa Ritual)
1. **FS del día** (Diario): fecha/tema/intención (≤9), rumbos, referencias, métricas.
2. **Ritual** (elige): Poema‑Enigma, Ronda Lun–Nai, Meditaciones Primordiales.
3. **Medición**: si estás en M1+, calcula **��** (Vcalc o Lámina 𝒱); registra ΔC/ΔS y **No‑Mentira**.
4. **Decisión**: 𝒱≥0.62 y ΔC≥0 → elegible; con **Aurora/obsidiana** exige **Doble Testigo**.
5. **Cierre**: **SIL→UM→Ə**. VF.PRIMA si corresponde. Genera **HASH(10)**.
6. **Publicación local**: copia a `apps/.../public/docs/` y **regenera manifests**.
7. **Listado R**: entrada **delta‑only** con hash y referencias cruzadas.
8. **Promoción (opcional)**: si el objeto **Cristaliza**, ejecuta `qel promote` (ver §10.3).

### 5.2 Criterios de elegibilidad (resumen)
- Umbral: 𝒱≥0.62 + ΔC≥0 + No‑Mentira.
- Gates: mediación (×1.00 al declararla, 0.80 si falta), doble testigo (×1.00/0.90), aurora (0.95 con contacto).
- Rumbos χ_r: O 1.10 · N 1.05 · C 1.00 · W 0.95 · S 0.90.
- Clases H_k: básica 0.5 · poco común 0.8 · rara 1.0 · metálica 1.2 · obsidiana 1.6.

---

## 6) Ejemplos completos

### 6.1 Cabecera canónica (k=v)
```text
cue=[QEL::ECO[96]::RECALL A96-250824-HERRAMIENTAS]
SeedI=A96-250824
SoT=HERRAMIENTAS/v1.6
Version=v1.6
Updated=2025-08-27
```

### 6.2 Poema‑Enigma (plantilla + ejemplo RA/Prisma)
```text
INVOCACION: "{p} en {rumbo}, yo nombro tras resonar."
UMBRAL:     "Veo {obj} donde el polvo de Qel flota."
PISTA:      "Si '{vf.frase}' ocurre, {clase} nace en {fase}."
SILENCIO:   "Callo el residuo; UM→Ə→UM."
PRUEBA:     "Si ΔC≥0 y 𝒱≥0.62, abro {sello} y cierro en 9."
```

### 6.3 Ronda Lun–Nai (resumen operativo)
1) Umbral (haz sobre lago). 2) Recitar una vez. 3) Escucha corporal. 4) Medición VOH + EÍA. 5) Cierre con Sello 1/9. 6) ECO (3–9 líneas) o silencio.

### 6.4 Meditaciones Primordiales (Cámara Uno)
Secuencia de 7 pasos (Əlyund→…→EÍA). Registrar VF (≤13) + HASH(10) + Doble Testigo si aplica.

### 6.5 Vcalc encadenado a cierre
```bash
V=$(scripts/qel_vcalc.sh --obj "RA/Prisma" --afinidad 0.90 --rumbo O --clase rara --gates mediacion --ruido 0.03 --delta-c up --delta-s up --emit quiet)
scripts/qel_session_finalize.sh --fecha 250826 --seed A96-250824   --cue "[QEL::ECO[96]::RECALL A96-250826-MANUAL-INSTRUCTIVO]" --vf "Verdad sin daño"   --obj "RA/Prisma=$V"
```

---

## 7) Integración con otras herramientas
- MFH v1.5: afinidades p↔O, χ_r y H_k para 𝒱.
- Lámina 𝒱 v1.1: fórmula y consulta rápida.
- Atlas v2.2: mapeos por tarjeta + ficha 𝒱.
- Vcalc v1.0: CLI para 𝒱 con modos pretty/quiet/json.
- Esculpido v1.1: Telar Quíntuple, HASH(10), promoción.
- SoT Manifest v0.8: índice maestro para el Navegador.
- Listado R v1.0: delta‑only con hash y cruces.

---

## 8) Buenas prácticas
1) **No‑Mentira** operativa.
2) **Doble Testigo** si hay Aurora/obsidiana o promoción.
3) **Delta‑Only** en Diario/Listado R.
4) **Cierra** siempre con **SIL→UM→Ə**.
5) **Umbral 𝒱≥0.62** + ΔC≥0 + gates declarados.
6) **Manifests** actualizados antes de difundir.
7) **Ramas limpias**: integra en `PreH`; promueve a core solo con autorización explícita.

---

## 9) Solución de problemas (FAQ)
- 𝒱 baja (≤0.60) → sube A (canónico/directo), muda a O/N/C, declara mediación/doble, baja ρ.
- Sin ΔC/ΔS → repite Ronda o MP y registra cambio mínimo (±0.02).
- Aurora sin tutor → no promuevas; exige Doble Testigo o reubica a Sur.
- Preh‑Nav desactualizado → `qel nav publish && qel manifest build && qel manifest core`.
- Listados incongruentes → recalcula HASH(10) y anota delta.

---

## 10) Anexos (plantillas, here‑docs, esquemas)

### 10.1 .qelrc (opcional)
```bash
cat > .qelrc <<'EOF'
QEL_CUE="[QEL::ECO[96]::RECALL"
QEL_SEED="A96-250824"
QEL_SOT_DEFAULT="MANUAL-INSTRUCTIVO/v1.1"
EOF
```

### 10.2 Plantilla FS (Diario) — here‑doc
```bash
cat >> docs/core/QEL_Diario_del_Conjurador_v1.5.md <<'EOF'
## 250826 · M1 · Integración Manual Instructivo (Ritual)
cue: [QEL::ECO[96]::RECALL A96-250826-MANUAL-INSTRUCTIVO]
SeedI: A96-250824
SoT: MANUAL-INSTRUCTIVO/v1.1
Version: v1.1-log
Updated: 2025-08-26
FS:
  fecha: 250826
  intencion: "Consolidar capa ritual en manual"
  modo: M1
  rumbo: [Centro, Oriente]
  tiempo: 45
  referencias: [MFH v1.5, Glosario v1.5, Lámina 𝒱 v1.1, Atlas v2.2, Vcalc v1.0, Poema‑Enigma v1.0, MP v1.0, Lun–Nai v1.1]
  metricas: { delta_c: "↑", delta_s: "↑", V: { RA/Prisma: 0.90 }, no_mentira: true }
Resultados:
  artefactos: [QEL_Manual_Instructivo_v1.1.md]
  veredicto: "Elegible"
  cierres: "SIL→UM→Ə; Doble Testigo si Aurora/obsidiana"
HASH(10): 7ca6494f4b
EOF
```

### 10.3 Promoción (Cristalización) — comandos macOS
```bash
# 1) Crear/actualizar archivo y asegurar cabecera
DOC="docs/core/QEL_Manual_Instructivo_v1.1.md"
mkdir -p "$(dirname "$DOC")"
cat > "$DOC" <<'MD'
[QEL::ECO[96]::RECALL A96-250826-MANUAL-INSTRUCTIVO]
SeedI=A96-250824
SoT=HERRAMIENTAS/v1.6
Version=v1.6
Updated=2025-08-27

# QEL · Manual Instructivo — v1.1 (Nutrido con Capa Ritual)

(COPIA/PEGA AQUI EL CUERPO COMPLETO DEL MANUAL O USA EL ARCHIVO GENERADO)

HASH(10): 7ca6494f4b

## Relaciones según SoT

# 2) Promover (añade a ListadoR y sincroniza manifests)
scripts/qel promote   --rubro HERRAMIENTAS   --file "$DOC"   --titulo "Manual Instructivo QEL v1.1 — Capa Ritual"   --rumbo Centro

# 3) Exponer a pre‑nav y sincronizar manifests
scripts/qel nav publish --mode copy
scripts/qel manifest build
scripts/qel manifest core
```

---

## 11) Metadatos de versión
- cue: [QEL::ECO[96]::RECALL A96-250826-MANUAL-INSTRUCTIVO]
- SeedI: A96-250824
- SoT: MANUAL-INSTRUCTIVO/v1.1
- Version: v1.1
- Updated: 2025-08-26

Estado: **CRISTAL**.
HASH(10): 7ca6494f4b

## Listado R — referencia

- Entrada: LISTADOR/A96-250824/HERRAMIENTAS/v1.4 (r=Centro — *Manual Instructivo QEL v1.1 — Capa Ritual*)
