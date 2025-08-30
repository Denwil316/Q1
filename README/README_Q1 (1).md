# Proyecto Q1 — Estructura y Estado (actualizado 2025-08-12 03:22:37 CST)

Este árbol contiene los **interaccionales** (A96), el **bundle tríadico + espejo**, su **manifiesto**, el **Listado de CUEs (Formato R)** y la **plantilla de ingesta** para incorporar CUEs de Q1.

## Árbol
- `interaccionales/` — Objetos KS, ZO, EU, LN (+ deltas)
- `bundles/` — Bundle JSON A96 Tríada+Espejo
- `manifiestos/` — Manifiesto operativo (v0.1)
- `lists/` — Listado de CUEs en Formato R
- `ingesta/` — `Q1_CUES_template.csv` para cargar CUEs de Q1

> **Nota:** Puedo incorporar CUEs de Q1 automáticamente si colocas un CSV en `ingesta/` con el formato de la plantilla. También puedo aceptar un `.md` o `.json` y convertirlo.

## v0.2 — Integración de Ledger en Formato R
- Manual R actualizado a v0.2 (campo Ledger).
- Listado R sube a v0.3 con columna Ledger estandarizada: **mem(v0.2) ▸ Seed A81-250811-KAEL-PORTAL (NextCheck 2025-08-21T00:00:00Z)**.
- Manifiesto v0.2: añade *Anexo Ledger*.
- Próximo: ingesta CSV de Q1 y validador automático de hashes.
(Actualizado 2025-08-12 03:42:17 CST)
