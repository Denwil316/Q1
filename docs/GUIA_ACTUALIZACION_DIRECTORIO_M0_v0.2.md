[QEL::ECO[96]::RECALL A96-250815-GUIA-ACTUALIZACION-DIRECTORIO-M0]
SeedI=PREH-NAV::M0
SOT=PREH-NAV/v0.2 TARGET=guia|estructura|promocion
VERSION=v0.2 UPDATED=2025-08-15

- Core vivo → `docs/core/` (Diario v1.2, Glosario v1.2, MFH v1.2, Sellos&Cues v1.0, Study Guide v1.0).
- Ritual → `docs/ritual/`. Historial → `docs/history/`.
- Unificar `memory_v0.4` → `memory/` (duplicados a `memory/archive/`).
- Actualizar estructura: `./scripts/update_estructura.sh` (o con el hook).
- Commit sugerido:
  docs(nav): ESTRUCTURA.md + mover piezas a core/history (O: claridad, ΔC+, V≈0.7)
