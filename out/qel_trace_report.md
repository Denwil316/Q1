# QEL · Informe de Trazabilidad

- **Archivos auditados:** 75
- **TC (Traza-Completitud):** -2.0267
- **TI (Integridad cruzada):** 0.5200
- **TT (Temporalidad):** 1.0000
- **UH (Unicidad HASH):** 1.0000
- **IT (Índice global de Traza):** -0.3547

## Leyenda de errores

| Código | Descripción breve |
|--------|--------------------|
| E1 | Front-matter incompleto (SeedI/SoT/Version/Updated) |
| E2 | HASH(10) ausente o mal formateado en EOF |
| E3 | HASH(10) duplicado en más de un archivo |
| E4 | SeedI del artefacto ≠ SeedI en ListadoR |
| E5 | SoT/Version/Updated ≠ ListadoR |
| E6 | Ruta en ListadoR ≠ ruta real del archivo |
| E7 | Temporalidad no monótona (Updated < max histórico en ListadoR) |
| E8 | Artefacto ausente en ListadoR |
| E9 | Artefacto ausente en Atlas (cuando aplica) |
| E10 | No expuesto en carpeta pública (cuando CHECK_PUBLIC=1) |
| E11 | SoT no canónico (regex simple; posible problema de formato) |
| E12 | CUE ausente `[QEL::ECO[..]::RECALL ...]` |

## Conteo global de errores

| Código | Conteo |
|--------|--------|
| E1 | 32 |
| E2 | 75 |
| E3 | 0 |
| E4 | 0 |
| E5 | 0 |
| E6 | 10 |
| E7 | 0 |
| E8 | 45 |
| E9 | 75 |
| E10 | 0 |
| E11 | 43 |
| E12 | 26 |

## Top archivos con más errores

| # errores | archivo | errores |
|----------:|---------|---------|
| 5 | `docs/ritual/qel_manual_vcalc_v_1_0.md` | E12;E2;E11;E8;E9 |
| 5 | `docs/ritual/microsellos/QEL_MicroSello_A96-250824_VCALC_UNIFIED_SEAL_v.10.md` | E12;E2;E11;E8;E9 |
| 5 | `docs/ritual/microsellos/QEL_MicroSello_A96-250824_PREH-NAV_Cierre_v1.0.md` | E12;E2;E11;E6;E9 |
| 5 | `docs/ritual/microsellos/QEL_MicroSello_A96-250820_PREH-NAV_Cierre_v1.0.md` | E12;E2;E11;E8;E9 |
| 5 | `docs/ritual/QEL_Sello_A96-250824_Centro_Sur_Norte_EIA-A-THON_Cierre_SIL-UM-Əv1.0.md` | E12;E2;E11;E8;E9 |
| 5 | `docs/nutria/SQ.md` | E1;E12;E2;E8;E9 |
| 5 | `docs/nutria/QEL.md` | E1;E12;E2;E6;E9 |
| 5 | `docs/nutria/PCdI.md` | E1;E12;E2;E8;E9 |
| 5 | `docs/nutria/Matematicas Resonantes (DS).md` | E1;E12;E2;E8;E9 |
| 5 | `docs/nutria/Lýmina.md` | E1;E12;E2;E8;E9 |
| 5 | `docs/nutria/Kósmos 8.md` | E1;E12;E2;E8;E9 |
| 5 | `docs/nutria/Astra.md` | E1;E12;E2;E8;E9 |
| 5 | `docs/nutria/ACL-QEL.md` | E1;E12;E2;E8;E9 |
| 5 | `docs/habilidades/Ə-UM-A/Llave/C/singular/e2c82e10e1.md` | E1;E12;E2;E6;E9 |
| 5 | `docs/core/atlas/codice_madre_atlas_qel_tarjetas_maestras_v_2.md` | E1;E12;E2;E8;E9 |
| 5 | `docs/core/QEL_ListadoR_master_v1.0.md` | E1;E12;E2;E8;E9 |
| 4 | `docs/ritual/vf/QEL_VF_PRIMA_A96-251018_SEAL_v1.0.md` | E2;E11;E8;E9 |
| 4 | `docs/ritual/vf/QEL_VF_PRIMA_A96-251011_SEAL_v1.0.md` | E2;E11;E8;E9 |
| 4 | `docs/ritual/vf/QEL_VF_PRIMA_A96-251002_SEAL_v1.0.md` | E2;E11;E8;E9 |
| 4 | `docs/ritual/vf/QEL_VF_PRIMA_A96-250924_SEAL_v1.0.md` | E2;E11;E8;E9 |
