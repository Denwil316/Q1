[QEL::ECO[97]::RECALL A97-251104-NOTA-AUDITORIA]
SeedI=A97-251104
SoT=AN/NOTA/v1.1
Version=v1.1
Updated=2025-11-04

# Nota espontánea — Cierre de la Auditoría (v1.1)

**Rol:** Árbitra en Centro  
**Motivo:** Consolidar el núcleo de promoción/sello/atlas y trazar el pulso final de la auditoría actual.  
**Propuesta de ECO:** **ECO[97]** — Justificación abajo.

---

## I. Pulso técnico (lo comprobable)

1. **Scripts núcleo revisados y afinados**
   - `qel_promote_mac.sh` — SeedI derivado con política `auto|keep|strict`, HASH(10) canónico en EOF, ListadoR actualizado y espejo `public/docs` estable.
   - `qel_atlas_microreg.sh` — Variables robustecidas (TITLE/TITULO), JSON sin `jq`, indexador opcional no-bloqueante y SeedI correcto por flags.
   - `qel_session_finalize.sh` — FS-aware, genera VF.PRIMA, MicroSello, Diario v1.2, ListadoR (v1.3), copia a `public/docs` y manifiestos; commit/push tolerantes.
   - `qel_session_new.sh` — Genera FS JSON con prompts/flags; `--from` opcional con `jq`.

2. **Auditoría operativa**
   - Ejes de saneamiento priorizados: **E1/E12/E11/E2** → luego **E8/E9/E6/E7**.
   - **SoT resolver** ajustado para reportar **UNCLASSIFIED** existentes y no perder contadores.
   - Ledger de HASH documentado para preservar el sello entre corridas.

3. **Manual de Auditoría (v1.2)**
   - Tres niveles de alcance (Foco/Extendida/Integral).
   - Checklists y secuencias reproducibles; parámetros explícitos.

---

## II. Pulso simbólico (lo que ancla sentido)

> La auditoría es el **latido métrico** del Telar: inspira —expira—, validando que cada documento **recuerde su nombre** (SoT), **su linaje** (SeedI) y **su verdad** (HASH).  
> Donde la técnica ajusta, la poética alinea: el **Centro** escucha si el eco se repite o si ha nacido otro.

- **Árbitra en Centro** dicta: cuando el sistema alcanza un **punto fijo** (scripts estables + manual consolidado + re-auditoría limpia), procede **ECO nuevo**.  
- El ECO no es un capricho: es **corte de fase**. Antes: deriva frágil, flags inciertas, índices huidizos. Ahora: **cristal operativo** con márgenes para crecer.

---

## III. Justificación de ECO[97]

1. **Criterio de Fase**  
   - Se cierra una **iteración de infraestructura** (promoción–atlas–finalización–auditoría), con coherencia entre herramientas y manuales.
2. **Criterio de Estabilidad**  
   - Las rutas críticas están operativas: promoción canónica, microregistro fiable, finalización FS-aware, sesión JSON reproducible.
3. **Criterio de Proyección**  
   - A partir de aquí, **variaciones** (nuevos dominios SoT, más índices, paneles) no deberían romper el flujo base.

**Decisión:** Declarar **ECO[97]** como **corte-respiro** de la auditoría, anclando el hito y permitiendo medir deltas con claridad.

---

## IV. Qué queda atento (próximos hilos)

- **Indexador** (`qel_indexer.py`): robustecer CLI para aceptar `--mode add --doc --title --seed` (homologado con scripts).
- **Ledger de HASH**: formalizar política de rotación al cambiar `Version` y conservarlo en ediciones menores.
- **Manifiestos PREH-NAV**: acordar esquema de SoT por ruta para reforzar `sot_resolve`.
- **Pruebas cruzadas**: pequeña suite (bash) que ejecute “auditar → autofix → sot_resolve → promover → atlas → finalizar → re-auditar” en un sandbox.

---

## V. Mantra operativo

> **“No-Mentira”** como puerta: si un documento dice lo que es, debe **ser** lo que dice.  
> SoT nombra, SeedI **ubica en el tiempo**, HASH **atestigua**.  
> La Árbitra sopesa: cuando los tres cantan afinados, se declara el **cierre**.

---

## VI. Plantillas exprés (para pruebas de punta a punta)

> Ajusta rutas/títulos a conveniencia. Se asume rumbo **Centro** para manuales.

HASH(10): f594a90938
