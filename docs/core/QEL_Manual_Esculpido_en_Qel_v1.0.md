[QEL::ECO[96]::RECALL A96-250824-ESCU]
SeedI=A96-250824
SoT=HERRAMIENTAS/v1.3
Version=v1.3
Updated=2025-08-27

# Manual de Esculpido en Qel — v1.0 (Unificado)

> **Propósito**: Establecer un procedimiento único de esculpido que preserve el cuerpo/base de cada documento,
> integre indagaciones nuevas y cierre con coherencia Idriell. Acopla **Telar Quíntuple** con **Promoción** (Cristalización),
> **ListadoR**, **Manifest v0.8** y publicación en **Navegador Qel**.

## 0) Ética Idriell (invariante)
- Evoca, **no** representa. No-mentira. **Doble Testigo** cuando hay creación/transferencia.
- Cada repetición transforma; toda versión *repite distinto*. Si no aporta método/operativa nueva, no cristaliza.

## 1) Telar Quíntuple (capas de trabajo)
1. **Tejera (Sur · cuerpo/ritmo)**  
   Compás 9-0-9, pulso *THON*, pausas 3–5–3. Integra *Tres Árboles*:  
   *Cielo Invertido* (frutos-fonemas de sombra), *Alfabeto Fluido* (huecos geométricos), *Araña Joven* (semillas-nombre→Árbol-VF).
2. **Jardinera (Este · semilla/concepto)**  
   Extrae **semillas** y huecos → Glosario/VF/Atlas con destino SoT explícito.
3. **Geómetra (Norte · estructura/número)**  
   Revisa invariantes 𝒱 (MFH), índices, taxonomías; enlaces/figuras. Consistencia χ_r, H_k, ΔC/ΔS, gates.
4. **Curadora (Oeste · memoria/archivo)**  
   Concilia historial (Esculpidos previos) y reescribe el changelog, manteniendo compatibilidad hacia atrás.
5. **Árbitra (Centro · coherencia/ética)**  
   Valida ética y **relaciones SoT**; decide **Cristalización**.

**Regla de salida**  
- Integración sin operativa nueva ⇒ bump menor y registro como *integración*.  
- Nueva operativa/cierre semántico ⇒ **Cristaliza**.

## 2) Cabecera canónica (k=v)
Cada documento comienza con:
cue=[QEL::ECO[96]::RECALL A96-250824-HERRAMIENTAS]
SeedI=A96-250824
SoT=HERRAMIENTAS/v1.3
Version=v1.3
Updated=2025-08-27

> *Si prefieres SUMMON, cambia `RECALL` por `SUMMON` (ver .qelrc).*

## 3) HASH(10) obligatorio en Cristalización
CANON = `CUE|SeedI|SoT|Version|Updated|Titulo`  
macOS:
CANON="CUE=...[...]|SeedI=A96-...|SoT=RUBRO/vX.Y|Version=vX.Y|Updated=AAAA-MM-DD|Titulo=..."
HASH10=$(printf '%s' "$CANON" | shasum -a 256 | awk '{print $1}' | cut -c1-10)

Añade al final:
HASH(10): aca9473aac

## 4) Promoción (Cristalización)
**Wrapper:**
scripts/qel promote
--rubro <RUBRO>
--file docs/core/<ARCHIVO>.md
--titulo "Título de versión"
--rumbo Sur

Efectos:
- Bump `Version`; asegura `cue/SeedI/SoT/Updated`.
- Inyecta (si faltan) “## Relaciones según SoT” y “## Listado R — referencia”.
- Calcula y añade **HASH(10)**.
- Registra en **ListadoR** (toma el más reciente en `memory/`).
- Actualiza `docs/core/QEL_SoT_Manifest_v0.8.json` (si existe + `jq`).
- Publica al **Navegador** (`apps/.../public/docs`) y regenera `sot-manifest.json`.

### Plantilla general de Cristalización (one-liner)
FILE="docs/core/NUEVO_QEL_v1.0.md"
cat > "$FILE" <<'MD'
[QEL::ECO[96]::RECALL A96-AAAAmmdd-NUEVO]
SeedI=A96-250824
SoT=HERRAMIENTAS/v1.3
Version=v1.3
Updated=2025-08-27

Título
Cuerpo inicial...

Relaciones según SoT
(pendiente mapa)

Listado R — referencia
Entrada: LISTADOR/A96/TRATADO-METAHUMANO/v1.0
MD

scripts/qel promote --rubro TRATADO-METAHUMANO --file "$FILE" --titulo "Nuevo QEL — ejemplo" --rumbo Sur

## 5) ListadoR (registro maestro)
Formato:
R#. Proyecto A96/QEL. (AAAA-MM-DD). QEL|A96|<RUBRO>|<SEED>|vX.Y|<Rumbo> — Título [<HASH10>]

El wrapper agrega al **ListadoR** más reciente en `memory/`. Si no existe, crea uno por defecto.

## 6) Manifest maestro v0.8 y Navegador Qel
- Autoridad: `docs/core/QEL_SoT_Manifest_v0.8.json`
- Espejo Front: `apps/preh-nav-m1/public/docs/**` + `apps/preh-nav-m1/public/sot-manifest.json`
- Publicación:
scripts/qel nav publish --mode copy
scripts/qel manifest sync

## 7) Cierre de sesión
scripts/qel session finalize
--fecha 250824
--seed A96-250824
--cue "[QEL::ECO[96]::A96-250824-SEAL]"
--vf "Aurora cuida lo que toca."

## 8) Invariantes 𝒱 (MFH)
- χ_r: N=1.00, O=0.95, W=0.90, S=0.88, C=1.00  
- H_k: común 0.85, raro 0.92, singular 1.00, único 1.05→clip 1.00  
- Gates: mediación(1.00|0.80), doble(1.00|0.90), aurora(0.95 si contacto)  
- ΔC/ΔS: ±0.02; Ruido clip ≤0.15 → (1−ruido)  
`scripts/qel vcalc --obj "Kael/Prisma" --afinidad 0.72 --rumbo N --clase singular --gates "mediacion,doble" --ruido 0.04`

## 9) Compatibilidad/Deprecaciones
- Nunca borres `docs/history/` ni `memory/`. Marca **DEPRECADO** si hace falta y redirige.

## Relaciones según SoT
- HERRAMIENTAS ↔ SOT · DIARIO · GLOSARIO · VF-ARBOLES · MFH · TRATADO-METAHUMANO

## Listado R — referencia
- Entrada: LISTADOR/A96/HERRAMIENTAS/v1.0

HASH(10): aca9473aac

- Entrada: LISTADOR/A96-250824/MANUAL/v1.1 (r=Sur — *Manual del Esculpido en Qel*)

- Entrada: LISTADOR/A96-250824/HERRAMIENTAS/v1.2 (r=Centro — *Manual Instructivo QEL v1.1 — Capa Ritual*)

- Entrada: LISTADOR/A96-250824/HERRAMIENTAS/v1.2 (r=Centro — *Manual Instructivo QEL v1.1 — Capa Ritual*)

- Entrada: LISTADOR/A96-250824/HERRAMIENTAS/v1.2 (r=Centro — *Manual Instructivo QEL v1.1 — Capa Ritual*)

- Entrada: LISTADOR/A96-250824/HERRAMIENTAS/v1.3 (r=Centro — *Manual Instructivo QEL v1.1 — Capa Ritual*)
