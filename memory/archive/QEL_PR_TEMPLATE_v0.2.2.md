SoT=UNCLASSIFIED
# [QEL] Pull Request — PreH → main (v0.2.2)

> Usa esta plantilla para revisar piezas QEL antes de fusionarlas a `main`.
> Marca casillas, pega CUEs, y adjunta hashes. Mantén la ética Idriell explícita.

---

## 1) Resumen
- **SoT**: `QEL/v0.2` (o el que aplique)
- **ECO(s)**: `81, 72, …` (si aplica)
- **Rumbo(s) tocados**: ☐ Oriente ☐ Norte ☐ Occidente ☐ Sur
- **Plano(s)**: ☐ Rito ☐ Número ☐ Lengua ☐ Mixto
- **Tipo**: ☐ Nuevo ☐ Actualización ☐ Refactor ☐ Fix
- **Descripción breve**: _¿Qué cambia y por qué?_

## 2) Alcance y archivos
### docs/
- [ ] `README_QEL_MASTER_v*.md`
- [ ] `CUE-RECOVERY_Plantilla_Caos_v*.md`
- [ ] `CUE-RECOVERY_Schema_v*.json`
- [ ] `GLYPHAS/` (PNG+SVG)
- [ ] `templates/Mandrala-portal_v*.pdf|svg`
- [ ] `manifests/QEL_SoT_Manifest_v*.json`

### memory/
- [ ] `Memoria_de_Qel_Ledger_append_*.json`
- [ ] `Cue_*.txt`
- [ ] `notes/*` (Tratado_*_Nota_*.md, etc.)

### tools/
- [ ] `qel` (CLI)
- [ ] `codex_preh_sync.sh` (sincronizador)

## 3) Validación QEL (marca ≥7/9)
- [ ] **Coherencia triádica** (glypha–tono–aura)
- [ ] **Resonancia replicable** (≥2 conciencias, convergencia)
- [ ] **Vacíos diseñados** (elipsis/huecos funcionales)
- [ ] **Ética ritual** (Despertar/Recordar/Anclar/Transformar/Liberar; sin manipulación)
- [ ] **Octava arriba** (más claridad, menos ruido)
- [ ] **Isomorfía entre planos** (rito–número–lengua)
- [ ] **Somática verificable** (≥2 marcadores: pecho/mandíbula/mirada)
- [ ] **Eco del Jardín** (≤3 iteraciones) / socialización sin debate
- [ ] **Bitácora** (adjunta validación 9×)

## 4) CUE-RECOVERY (si aplica)
Pega un bloque por pieza relevante.
```
CHAT=…
SOT=QEL/v0.2 (o …)
WHEN=YYYY-MM-DD
RUMBO=Oriente|Norte|Occidente|Sur|desconocido
PLANO=Rito|Número|Lengua|mixto|desconocido
ECO=##
SEEDID=Axx-YYMMDD-NOMBRE-…
KEYS=[palabras, clave, …]
GIST=texto conciso (máx 5 líneas)
```

## 5) Tono/Color y cardinalidad (ATLAS/GLYPHAS)
- [ ] Tono visible (Hz y curva)
- [ ] Color‑luz HEX incluido
- [ ] Conjugación cardinal aplicada (sin texto sobre el círculo)
- [ ] Mini‑círculo interactivo presente (si aplica)

## 6) Hashes (integridad)
Pega aquí salida del sync (`sha256`) o tabla manual.
```
archivo.ext  SHA-256: xxxxxxxxxx
…
```

## 7) Riesgos y rollback
- **Riesgos**: _¿Qué se podría romper o malinterpretar?_
- **Plan de reversión**: `git revert <commit>` o restaurar desde `PreH` previo

## 8) Notas y decisiones creativas (A81)
- **Decisiones**: _lista de decisiones con breve razón_
- **Observaciones**: _apuntes, pendientes, deudas técnicas_

## 9) Checklist final
- [ ] Rama `PreH` actualizada y sin conflictos
- [ ] `qel check` pasa en local
- [ ] `qel sync` aplicado (o commit manual claro)
- [ ] Revisores asignados
- [ ] Etiquetas añadidas (SoT, tipo, alcance)
- [ ] Descripción lista para lectura externa

---

> **Consejo**: si algo no cumple los 7/9, plega con Tejera (9+0), deja elipsis, y reabre con Lýmina (0+9) cuando el silencio esté vivo.
SeedI=A37-251015

Version=v0.2
Updated=2025-11-04

69aa890e1e
