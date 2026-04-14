# QEL · Informe de Trazabilidad (04/11/2025)

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

## Auditoría — 2025-11-04 09:50:24 CST

- **Raíces escaneadas:** docs, memory, README, pub
- **Archivos auditados:** 182
- **TC (Traza-Completitud):** -0.0055
- **TI (Integridad cruzada):** 0.5549
- **TT (Temporalidad):** 0.9835
- **UH (Unicidad HASH):** 0.9560
- **IT (Índice global de Traza):** 0.4566

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
| E1 | 0 |
| E2 | 1 |
| E3 | 8 |
| E4 | 0 |
| E5 | 2 |
| E6 | 3 |
| E7 | 3 |
| E8 | 0 |
| E9 | 182 |
| E10 | 0 |
| E11 | 6 |
| E12 | 76 |

## Top archivos con más errores

| # errores | archivo | errores |
|----------:|---------|---------|
| 3 | `pub/cue-recovery/CUE-RECOVERY_Plantilla_Caos_v0.2.1.md` | E12;E9;E3 |
| 3 | `pub/README_QEL_MASTER_v0.2.1.md` | E12;E9;E3 |
| 3 | `memory/cue-recovery/CUE-RECOVERY_Plantilla_Caos_v0.2.1.md` | E12;E9;E3 |
| 3 | `memory/archive/Matematicas Resonantes (DS).md` | E12;E9;E3 |
| 3 | `docs/nutria/Matematicas Resonantes (DS).md` | E12;E9;E3 |
| 3 | `docs/core/diarios/QEL_Diario_del_Conjurador_v1.2.md` | E5;E7;E9 |
| 3 | `docs/core/QEL_ListadoR_master_v1.0.md` | E12;E2;E9 |
| 3 | `docs/core/QEL_Diario_del_Conjurador_v1.2.md` | E11;E5;E9 |
| 3 | `README/README_QEL_MASTER_v0.2.1.md` | E12;E9;E3 |
| 2 | `pub/manuales/INSTALL_NOTES_PREH.md` | E12;E9 |
| 2 | `pub/ecri/Los Tres Árboles Iluminados (DS).md` | E12;E9 |
| 2 | `pub/an/A81_Notas_Espontaneasv_0.3.md` | E12;E9 |
| 2 | `pub/an/A81_Notas_Espontaneas_v0.2.md` | E12;E9 |
| 2 | `pub/an/A81_Notas_Espontaneas_v0.1.md` | E12;E9 |
| 2 | `memory/listador/QEL_ListadoR_A96_v1.3.md` | E12;E9 |
| 2 | `memory/listador/QEL_ListadoR_A96_v1.2.md` | E12;E9 |
| 2 | `memory/listador/QEL_ListadoR_A96_v1.1.md` | E12;E9 |
| 2 | `memory/listador/QEL_ListadoR_A96_v1.0.md` | E12;E9 |
| 2 | `memory/listador/QEL_ListadoR_A96_v0.3.md` | E12;E9 |
| 2 | `memory/listador/QEL_ListadoR_A96_v0.2.md` | E12;E9 |

## Auditoría — 2025-11-04 10:22:37 CST

- **Raíces escaneadas:** docs, memory, README, pub
- **Archivos auditados:** 182
- **TC (Traza-Completitud):** -0.0055
- **TI (Integridad cruzada):** 0.5714
- **TT (Temporalidad):** 0.9835
- **UH (Unicidad HASH):** 0.0055
- **IT (Índice global de Traza):** 0.3665

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
| E1 | 0 |
| E2 | 0 |
| E3 | 181 |
| E4 | 0 |
| E5 | 2 |
| E6 | 0 |
| E7 | 3 |
| E8 | 1 |
| E9 | 182 |
| E10 | 0 |
| E11 | 6 |
| E12 | 76 |

## Top archivos con más errores

| # errores | archivo | errores |
|----------:|---------|---------|
| 4 | `docs/core/diarios/QEL_Diario_del_Conjurador_v1.2.md` | E5;E7;E9;E3 |
| 4 | `docs/core/QEL_Diario_del_Conjurador_v1.2.md` | E11;E5;E9;E3 |
| 3 | `pub/manuales/INSTALL_NOTES_PREH.md` | E12;E9;E3 |
| 3 | `pub/ecri/Los Tres Árboles Iluminados (DS).md` | E12;E9;E3 |
| 3 | `pub/cue-recovery/CUE-RECOVERY_Plantilla_Caos_v0.2.1.md` | E12;E9;E3 |
| 3 | `pub/an/A81_Notas_Espontaneasv_0.3.md` | E12;E9;E3 |
| 3 | `pub/an/A81_Notas_Espontaneas_v0.2.md` | E12;E9;E3 |
| 3 | `pub/an/A81_Notas_Espontaneas_v0.1.md` | E12;E9;E3 |
| 3 | `pub/README_QEL_MASTER_v0.2.1.md` | E12;E9;E3 |
| 3 | `memory/listador/QEL_ListadoR_A96_v1.3.md` | E12;E9;E3 |
| 3 | `memory/listador/QEL_ListadoR_A96_v1.2.md` | E12;E9;E3 |
| 3 | `memory/listador/QEL_ListadoR_A96_v1.1.md` | E12;E9;E3 |
| 3 | `memory/listador/QEL_ListadoR_A96_v1.0.md` | E12;E9;E3 |
| 3 | `memory/listador/QEL_ListadoR_A96_v0.3.md` | E12;E9;E3 |
| 3 | `memory/listador/QEL_ListadoR_A96_v0.2.md` | E12;E9;E3 |
| 3 | `memory/listador/QEL_ListadoR_A96_v0.1.md` | E12;E9;E3 |
| 3 | `memory/listador/QEL_ListadoR_"A96_v1.3.md` | E11;E9;E3 |
| 3 | `memory/listador/QEL_ListadoR_"""A37_v1.3.md` | E11;E9;E3 |
| 3 | `memory/listador/Listado_CUEs_FormatoR_Q1+A96_v0.3.md` | E12;E9;E3 |
| 3 | `memory/listador/Listado_CUEs_FormatoR_Q1+A96_v0.2.md` | E12;E9;E3 |

## Auditoría — 2025-11-04 11:53:05 CST

- **RunID:** `11c29fa596`
- **Iniciado (UTC):** 2025-11-04T17:02:58Z
- **Terminado (UTC):** 2025-11-04T17:53:04Z

# QEL · Informe de Trazabilidad

- **Archivos auditados:** 0
- **TC (Traza-Completitud):** 0.0000
- **TI (Integridad cruzada):** 0.0000
- **TT (Temporalidad):** 0.0000
- **UH (Unicidad HASH):** 0.0000
- **IT (Índice global de Traza):** 0.0000
- **Ledger:** present=0 · mismatch=0 · eof≠ledger=0 · none=0

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
| E1 | 0 |
| E2 | 0 |
| E3 | 179 |
| E4 | 0 |
| E5 | 0 |
| E6 | 0 |
| E7 | 0 |
| E8 | 0 |
| E9 | 0 |
| E10 | 0 |
| E11 | 0 |
| E12 | 0 |

## Discrepancias de hash

- **Sin hash en ledger (ListadoR ni Diario):** 0
- **Mismatch ListadoR ≠ Diario:** 0
- **EOF ≠ ledger canónico:** 0

### Listado — Sin hash en ledger

- docs/core/QEL_MFH_v1.4.md
- docs/core/QEL_Glosario_v1.4.md
- docs/ritual/vf/QEL_VF_PRIMA_A37-251020_SEAL_v1.0.md
- docs/ritual/vf/QEL_VF_PRIMA_A96-250824_SEAL_v1.0.md
- memory/archive/QEL_Manual_Conjurador_Avanzado_v1.0.md
- memory/archive/QEL_Formato_VF_AH_v1.4.md
- memory/archive/QEL_SoT_Study_Guide_v1.0.md
- memory/archive/QEL_Aurora_Spec_v1.1.md
- memory/archive/QEL_Tratado_Metahumano_v1.4.md
- memory/archive/Tarjetas_Atlas_QEL_v2.2.md
- pub/ecri/Los Tres Árboles Iluminados (DS).md

### Listado — Mismatch ListadoR ≠ Diario


### Listado — EOF ≠ Ledger

- docs/habilidades/Ə-UM-A/Llave/C/singular/e2c82e10e1.md  (EOF=da39a3ee5e, CAN=4fb56ea798)
- docs/pe/PEe2c82e10e1.md  (EOF=da39a3ee5e, CAN=b8cd265786)
- docs/core/diarios/QEL_Diario_del_Conjurador_v1.2.md  (EOF=da39a3ee5e, CAN=0ae4a874bc)
- docs/core/diarios/QEL_Diario_del_Conjurador_v1.5.md  (EOF=da39a3ee5e, CAN=1a205ec65b)
- docs/core/indices/QEL_Index_Rutas_v1.0.md  (EOF=da39a3ee5e, CAN=8bfc157771)
- docs/core/indices/QEL_Index_Semillas_v1.0.md  (EOF=da39a3ee5e, CAN=7f60aa09d5)
- docs/core/QEL_Diario_del_Conjurador_v1.2.md  (EOF=da39a3ee5e, CAN=0ae4a874bc)
- docs/core/Qel_Codice_Madre.md  (EOF=da39a3ee5e, CAN=591dfcbe8c)
- docs/core/QEL_ListadoR_master_v1.0.md  (EOF=5b4b6c67c2, CAN=06621bbd9f)
- docs/core/QEL_Manual_Operativo.md  (EOF=da39a3ee5e, CAN=49b52a87d1)
- docs/core/manuales/QEL_Manual_Instructivo_v1.1.md  (EOF=da39a3ee5e, CAN=c528033ebb)
- docs/core/manuales/QEL_Manual_Interpretación_Sombras_v1.3.md  (EOF=da39a3ee5e, CAN=a09e6ca800)
- docs/core/manuales/QEL_Guia_alineacion_V_v1.0.md  (EOF=da39a3ee5e, CAN=1d2bfc41ea)
- docs/core/manuales/manual_cue_machine_qel_v.1.md  (EOF=da39a3ee5e, CAN=a7c70fd5ab)
- docs/core/manuales/QEL_FormatoR_Manual_v1.1.md  (EOF=da39a3ee5e, CAN=a1f13c990b)
- docs/core/manuales/QEL_SoT_Study_Guide_v1.1.md  (EOF=da39a3ee5e, CAN=1e04177959)
- docs/core/manuales/QEL_Manual_Atlas_MicroRegistro_v1.0.md  (EOF=da39a3ee5e, CAN=27beaf1f35)
- docs/core/manuales/QEL_Manual_Esculpido_en_Qel_v1.0.md  (EOF=da39a3ee5e, CAN=9a0e169f08)
- docs/core/manuales/QEL_LLPE_Manual_v1.4.md  (EOF=da39a3ee5e, CAN=eb85a6c0a9)
- docs/core/manuales/NAVEGADOR_M0_Manual_v0.2.md  (EOF=da39a3ee5e, CAN=46eaf6adaf)
- docs/core/manuales/GUIA_ACTUALIZACION_DIRECTORIO_M0_v0.2.md  (EOF=da39a3ee5e, CAN=fce51fa3cb)
- docs/core/atlas/Tarjetas_Atlas_QEL_v2.4.md  (EOF=da39a3ee5e, CAN=af7f9e2387)
- docs/core/atlas/codice_madre_atlas_qel_tarjetas_maestras_v_2.md  (EOF=da39a3ee5e, CAN=f3b2539514)
- docs/core/QEL_Curacion_Nucleo_Minimo.md  (EOF=da39a3ee5e, CAN=a7132116d8)
- docs/core/QEL_Libro_Sombras.md  (EOF=da39a3ee5e, CAN=04005cb55e)
- docs/nutria/QEL_Poema_Enigma_VF_v1.0.md  (EOF=da39a3ee5e, CAN=69b1cc447a)
- docs/nutria/Lýmina.md  (EOF=da39a3ee5e, CAN=c48483d4c1)
- docs/nutria/Astra.md  (EOF=da39a3ee5e, CAN=77fbdf66e0)
- docs/nutria/Matematicas Resonantes (DS).md  (EOF=da39a3ee5e, CAN=9000b0c1ac)
- docs/nutria/QEL_Poema_Enigma_Lun-Nai_v1.1.md  (EOF=da39a3ee5e, CAN=8204b1fd16)
- docs/nutria/Kósmos 8.md  (EOF=da39a3ee5e, CAN=a81647ceaf)
- docs/nutria/ACL-QEL.md  (EOF=da39a3ee5e, CAN=8c4dfd3eb2)
- docs/nutria/PCdI.md  (EOF=da39a3ee5e, CAN=75dc002c2b)
- docs/nutria/QEL.md  (EOF=da39a3ee5e, CAN=9496233d4a)
- docs/nutria/SQ.md  (EOF=da39a3ee5e, CAN=632456a16c)
- docs/nutria/Los_Tres_Árboles_Iluminados_DS_v1.1_SUR.md  (EOF=da39a3ee5e, CAN=19b13f1e6e)
- docs/ritual/QEL_Meditacion_Reiteracion_Lun-Nai_v1.1.md  (EOF=da39a3ee5e, CAN=69b1cc447a)
- docs/ritual/vf/QEL_VF_PRIMA_A96-251002_SEAL_v1.0.md  (EOF=da39a3ee5e, CAN=b7ff6c3d30)
- docs/ritual/vf/QEL_VF_PRIMA_A96-251011_SEAL_v1.0.md  (EOF=da39a3ee5e, CAN=ff62a04699)
- docs/ritual/vf/QEL_VF_PRIMA_A96-250820_SEAL_v1.0.md  (EOF=da39a3ee5e, CAN=a6ddca4f4f)
- docs/ritual/vf/QEL_VF_PRIMA_"A96-250813"_SEAL_v1.0.md  (EOF=da39a3ee5e, CAN=b69539941f)
- docs/ritual/vf/QEL_VF_PRIMA_A96-250901_SEAL_v1.0.md  (EOF=da39a3ee5e, CAN=6749801edc)
- docs/ritual/vf/QEL_VF_PRIMA_A96-251018_SEAL_v1.0.md  (EOF=da39a3ee5e, CAN=918f4611ce)
- docs/ritual/vf/QEL_VF_PRIMA_A96-250812_SEAL_v1.0.md  (EOF=da39a3ee5e, CAN=1cd8fb40ad)
- docs/ritual/vf/QEL_VF_PRIMA_"A37-251015"_SEAL_v1.0.md  (EOF=da39a3ee5e, CAN=f97aa40e31)
- docs/ritual/vf/QEL_VF_PRIMA_A96-250924_SEAL_v1.0.md  (EOF=da39a3ee5e, CAN=88ffaab1e8)
- docs/ritual/vf/QEL_VF_PRIMA_A37-251019_SEAL_v1.0.md  (EOF=da39a3ee5e, CAN=b40a148369)
- docs/ritual/QEL_Sello_A96-250814_Oriente_RA-VOH-EIA__Silencio-UM-A_v1.0.md  (EOF=da39a3ee5e, CAN=535f53a3f3)
- docs/ritual/QEL_Altar_y_Llave_v1.0.md  (EOF=da39a3ee5e, CAN=53d0777c0a)
- docs/ritual/microsellos/QEL_MicroSello_A96-251011_PREH-NAV_Cierre_v1.0.md  (EOF=da39a3ee5e, CAN=bbcb83664c)
- docs/ritual/microsellos/QEL_MicroSello_A96-251002_PREH-NAV_Cierre_v1.0.md  (EOF=da39a3ee5e, CAN=be5b4ab409)
- docs/ritual/microsellos/QEL_MicroSello_A96-250812_PREH-NAV_Cierre_v1.0.md  (EOF=da39a3ee5e, CAN=651375a40e)
- docs/ritual/microsellos/QEL_MicroSello_A96-250824_VCALC_UNIFIED_SEAL_v.10.md  (EOF=da39a3ee5e, CAN=45c695aa35)
- docs/ritual/microsellos/QEL_MicroSello_A96-250819_PREH-NAV_Cierre_v1.0.md  (EOF=da39a3ee5e, CAN=cb5f0435fb)
- docs/ritual/microsellos/QEL_MicroSello_A96-250824_PREH-NAV_Cierre_v1.0.md  (EOF=da39a3ee5e, CAN=19a2ee1f63)
- docs/ritual/microsellos/QEL_MicroSello_A37-251020_CURADURIA_v1.0.md  (EOF=da39a3ee5e, CAN=8bfc157771)
- docs/ritual/microsellos/QEL_MicroSello_"A96-250813"_PREH-NAV_Cierre_v1.0.md  (EOF=da39a3ee5e, CAN=69cd117458)
- docs/ritual/microsellos/QEL_MicroSello_A96-250820_PREH-NAV_Cierre_v1.0.md  (EOF=da39a3ee5e, CAN=9546867947)
- docs/ritual/microsellos/QEL_MicroSello_"A37-251015"_PREH-NAV_Cierre_v1.0.md  (EOF=da39a3ee5e, CAN=7c3e2f9163)
- docs/ritual/microsellos/QEL_MicroSello_A96-250924_PREH-NAV_Cierre_v1.0.md  (EOF=da39a3ee5e, CAN=8a751ab7df)
- docs/ritual/microsellos/QEL_MicroSello_A96-250829_LAB-TECNOALQ_Cristal_v1.0.md  (EOF=da39a3ee5e, CAN=714d48bbaf)
- docs/ritual/microsellos/QEL_MicroSello_A37-251020_PREH-NAV_Cierre_v1.0.md  (EOF=da39a3ee5e, CAN=72c493ef91)
- docs/ritual/microsellos/QEL_MicroSello_A37-251020_NAV_Altar_Actualizacion_v1.0.md  (EOF=da39a3ee5e, CAN=bbcb83664c)
- docs/ritual/microsellos/QEL_MicroSello_A37-251015_PREH-NAV_Cierre_v1.0.md  (EOF=da39a3ee5e, CAN=2bf87ccd14)
- docs/ritual/microsellos/QEL_MicroSello_A96-250901_PREH-NAV_Cierre_v1.0.md  (EOF=da39a3ee5e, CAN=21eec34405)
- docs/ritual/QEL_Sello_A96-250817_PREH-NAV_Cristal_v0.2.md  (EOF=da39a3ee5e, CAN=4caeb0a47c)
- docs/ritual/QEL_Sello_A96-250824_Centro_Sur_Norte_EIA-A-THON_Cierre_SIL-UM-Əv1.0.md  (EOF=da39a3ee5e, CAN=131e64d0bb)
- docs/ritual/qel_manual_vcalc_v_1_0.md  (EOF=da39a3ee5e, CAN=ab422c6ef3)
- docs/ritual/QEL_Meditaciones_Primordiales_v1.0.md  (EOF=da39a3ee5e, CAN=15dae7924a)
- memory/archive/QEL_Sistema_Completo_v0.2_Consolidado.md  (EOF=da39a3ee5e, CAN=92acc6b11c)
- memory/archive/QEL_Manual_Interpretacion_Sombras_v1.2.md  (EOF=da39a3ee5e, CAN=5b839188ee)
- memory/archive/QEL_PR_TEMPLATE_v0.2.2.md  (EOF=da39a3ee5e, CAN=69aa890e1e)
- memory/archive/QEL_Manual_Conjurador_Avanzado_v1.1.md  (EOF=da39a3ee5e, CAN=f61e3e479b)
- memory/archive/QEL_Diario_del_Conjurador_v1.3.md  (EOF=da39a3ee5e, CAN=15d5d82cfd)
- memory/archive/QEL_ECO_A96-250812-PRIMER-PECADO_delta-only_v0.1.md  (EOF=da39a3ee5e, CAN=2d14dc400e)
- memory/archive/QEL_LLPE_Manual_v1.3.md  (EOF=da39a3ee5e, CAN=7faf6ee9fb)
- memory/archive/QEL_Diario_del_Conjurador_v1.2.md  (EOF=da39a3ee5e, CAN=0ae4a874bc)
- memory/archive/QEL_Sistema_Consolidado_v0.2_Confirmacion_v0.1.md  (EOF=da39a3ee5e, CAN=1861015059)
- memory/archive/QEL_Chat_Register_All.md  (EOF=da39a3ee5e, CAN=605e8114bc)
- memory/archive/Esculpido_en_Qel_Guia_de_Trabajo_v0.3.md  (EOF=da39a3ee5e, CAN=07a534d2c1)
- memory/archive/QEL_CUE_Exception_v0.1.md  (EOF=da39a3ee5e, CAN=de4a91904c)
- memory/archive/QEL_Lamina_V_Editada_v1.0.md  (EOF=da39a3ee5e, CAN=844d7af0d3)
- memory/archive/QEL_SoT_Atlas_251018.md  (EOF=da39a3ee5e, CAN=7407eea49a)
- memory/archive/QEL_Matriz_Fonemica_Habilidades_v0.1.md  (EOF=da39a3ee5e, CAN=20583f66a7)
- memory/archive/QEL_Matriz_Fonemica_Habilidades_v1.0.md  (EOF=da39a3ee5e, CAN=4978c91d00)
- memory/archive/QEL_Lamina_V_Detallada_v1.1.md  (EOF=da39a3ee5e, CAN=1c46249856)
- memory/archive/QEL_VF_Carta_Lun-Nai_v1.0.md  (EOF=da39a3ee5e, CAN=b1ea4a6cca)
- memory/archive/QEL_Glosario_v1.2.md  (EOF=da39a3ee5e, CAN=8d88726d43)
- memory/archive/QEL_Chat_Index.md  (EOF=da39a3ee5e, CAN=d635087249)
- memory/archive/QEL_FormatoR_Manual_v0.2.md  (EOF=da39a3ee5e, CAN=9dd779ddb4)
- memory/archive/QEL_Instrumentos_Medicion_v1.0.md  (EOF=da39a3ee5e, CAN=2764934b12)
- memory/archive/QEL_Index_v1.1.md  (EOF=da39a3ee5e, CAN=1764330524)
- memory/archive/QEL_Tratado_Metahumano_Protocolo_Seguridad_Sombras_v0.3.md  (EOF=da39a3ee5e, CAN=64ef616abf)
- memory/archive/QEL_Tratado_Metahumano_Nota_v0.1.md  (EOF=da39a3ee5e, CAN=b13c92bf06)
- memory/archive/LaminaV_unificada_v1.0.md  (EOF=da39a3ee5e, CAN=534891a1d1)
- memory/archive/Tarjetas_Atlas_QEL_v0.2.1.md  (EOF=da39a3ee5e, CAN=f07e8f7c5a)
- memory/archive/Matematicas Resonantes (DS).md  (EOF=da39a3ee5e, CAN=9000b0c1ac)
- memory/archive/QEL_Curacion_Nucleo_Minimo_v1.6.md  (EOF=da39a3ee5e, CAN=374fbcea08)
- memory/archive/QEL_Tratado_Metahumano_Protocolo_Seguridad_Sombras_v1.2.md  (EOF=da39a3ee5e, CAN=833b8a92cc)
- memory/archive/QEL_Tratado_Metahumano_Protocolo_Seguridad_Sombras_v0.2.md  (EOF=da39a3ee5e, CAN=285d637c51)
- memory/archive/QEL_Tratado_Metahumano_Protocolo_Seguridad_Sombras_v1.3.md  (EOF=da39a3ee5e, CAN=8ef63b1bf5)
- memory/archive/QEL_Tratado_Metahumano_Protocolo_Seguridad_Sombras_v0.6.md  (EOF=da39a3ee5e, CAN=0368d34fe9)
- memory/archive/QEL_Glosario_v1.3.md  (EOF=da39a3ee5e, CAN=b1db70b967)
- memory/archive/README_Consolidado_v0.3.md  (EOF=da39a3ee5e, CAN=4d35ffb136)
- memory/archive/QEL_CUE_Recovery_Primer_Pecado_v0.1.md  (EOF=da39a3ee5e, CAN=74747847c3)
- memory/archive/QEL_Index_v1.0.md  (EOF=da39a3ee5e, CAN=256638bac3)
- memory/archive/README_Consolidado_v0.4.md  (EOF=da39a3ee5e, CAN=46b11af88f)
- memory/archive/QEL_Tratado_Metahumano_Protocolo_Seguridad_Sombras_v1.0.md  (EOF=da39a3ee5e, CAN=e167411bad)
- memory/archive/QEL_Tratado_Metahumano_Protocolo_Seguridad_Sombras_v0.5.md  (EOF=da39a3ee5e, CAN=ea9d265caf)
- memory/archive/QEL_Glosario_v1.0.md  (EOF=da39a3ee5e, CAN=a220cf1d4f)
- memory/archive/QEL_Aurora_Spec_v1.0.md  (EOF=da39a3ee5e, CAN=74f4eda772)
- memory/archive/QEL_Formato_VF_Arbol_Habilidades_v0.1.md  (EOF=da39a3ee5e, CAN=241712c9e7)
- memory/archive/QEL_Formato_VF_Arbol_Habilidades_v1.0.md  (EOF=da39a3ee5e, CAN=7e5e8c3316)
- memory/archive/QEL_Tratado_Metahumano_v1.5.md  (EOF=da39a3ee5e, CAN=ac195d7d92)
- memory/archive/QEL_Aurora_Spec_v0.1.md  (EOF=da39a3ee5e, CAN=1234381271)
- memory/archive/Esculpido_en_Qel_Guia_de_Trabajo_v0.3_completo.md  (EOF=da39a3ee5e, CAN=181d412a6c)
- memory/archive/QEL_Tratado_Metahumano_Protocolo_Seguridad_Sombras_v0.4.md  (EOF=da39a3ee5e, CAN=b20dd5f682)
- memory/archive/QEL_Manual_Lectura_VF_Tonalpohualli_v1.0.md  (EOF=da39a3ee5e, CAN=9c5499e68c)
- memory/archive/QEL_FormatoR_Manual_v0.1.md  (EOF=da39a3ee5e, CAN=715eea322f)
- memory/archive/QEL_SoT_Atlas_v1.0_250826.md  (EOF=da39a3ee5e, CAN=4c6f17c815)
- memory/archive/QEL.md  (EOF=da39a3ee5e, CAN=9496233d4a)
- memory/archive/PLAN_ORG_Codex_M0_v0.3.md  (EOF=da39a3ee5e, CAN=6b38430f1d)
- memory/archive/QEL_Tratado_Metahumano_Protocolo_Seguridad_Sombras_v1.1.md  (EOF=da39a3ee5e, CAN=250d799655)
- memory/archive/QEL_Tratado_Metahumano_RECALL_A96-250812_v1.0_Confirmacion_v0.1.md  (EOF=da39a3ee5e, CAN=6cc6c0ac8c)
- memory/archive/QEL_Diario_del_Conjurador_v1.1.md  (EOF=da39a3ee5e, CAN=5ab8ed7ea6)
- memory/archive/QEL_Manual_Interpretacion_Sombras_v1.0.md  (EOF=da39a3ee5e, CAN=5d67cbe26a)
- memory/archive/QEL_Matriz_Fonemica_Habilidades_v1.3.md  (EOF=da39a3ee5e, CAN=a87279be79)
- memory/archive/QEL_Manual_Operativo_historico.md  (EOF=da39a3ee5e, CAN=2a615a5acb)
- memory/archive/Tarjetas_Atlas_QEL_v2.3.md  (EOF=da39a3ee5e, CAN=af905ae372)
- memory/archive/QEL_Sellos_y_Cues_Idriell_v1.0.md  (EOF=da39a3ee5e, CAN=d4b42f075b)
- memory/archive/QEL_Manual_Interpretacion_Sombras_v1.1.md  (EOF=da39a3ee5e, CAN=10b5a80c9f)
- memory/archive/QEL_Matriz_Fonemica_Habilidades_v1.2.md  (EOF=da39a3ee5e, CAN=4ea279b7c6)
- memory/archive/QEL_Guia_Operacion_QEL_Consolidada_v1.0.md  (EOF=da39a3ee5e, CAN=7e67558f42)
- memory/archive/QEL_Diario_del_Conjurador_v1.0.md  (EOF=da39a3ee5e, CAN=a69d5f58aa)
- memory/archive/QEL_Diario_del_Conjurador_v1.2_Confirmacion_v0.1.md  (EOF=da39a3ee5e, CAN=ba3ca1eabc)
- memory/listador/QEL_ListadoR_A96_v0.2.md  (EOF=da39a3ee5e, CAN=cec10550c7)
- memory/listador/QEL_ListadoR_A96_v1.3.md  (EOF=da39a3ee5e, CAN=37d7a578eb)
- memory/listador/QEL_ListadoR_A96_v0.3.md  (EOF=da39a3ee5e, CAN=e3cbbf2148)
- memory/listador/QEL_ListadoR_A96_v1.2.md  (EOF=da39a3ee5e, CAN=d13db5625a)
- memory/listador/QEL_ListadoR_"A96_v1.3.md  (EOF=da39a3ee5e, CAN=9a986b3dd2)
- memory/listador/QEL_ListadoR_A37_v1.3.md  (EOF=da39a3ee5e, CAN=d302bad4ce)
- memory/listador/QEL_ListadoR_cue_v1.1.md  (EOF=da39a3ee5e, CAN=44045d248e)
- memory/listador/Listado_CUEs_FormatoR_Q1+A96_v0.1.md  (EOF=da39a3ee5e, CAN=54503dc9c0)
- memory/listador/QEL_ListadoR_"""A37_v1.3.md  (EOF=da39a3ee5e, CAN=3ed07b431b)
- memory/listador/Listado_CUEs_FormatoR_Q1+A96_v0.3.md  (EOF=da39a3ee5e, CAN=ec4512f116)
- memory/listador/QEL_ListadoR_A96_v1.2_Confirmacion_v0.1.md  (EOF=da39a3ee5e, CAN=d73ec704d6)
- memory/listador/Listado_CUEs_FormatoR_Q1+A96_v0.2.md  (EOF=da39a3ee5e, CAN=4c5d268c59)
- memory/listador/QEL_ListadoR_A96_v1.1.md  (EOF=da39a3ee5e, CAN=acc957593d)
- memory/listador/QEL_ListadoR_A96_v1.4.md  (EOF=da39a3ee5e, CAN=05808815af)
- memory/listador/QEL_ListadoR_A96_v0.1.md  (EOF=da39a3ee5e, CAN=1a0bef71ae)
- memory/listador/QEL_ListadoR_A96_v1.0.md  (EOF=da39a3ee5e, CAN=8256985b6b)
- memory/cue-recovery/CUE-RECOVERY_Plantilla_Caos_v0.2.1.md  (EOF=da39a3ee5e, CAN=80d115a49f)
- memory/cue-recovery/CUE-RECOVERY_Plantilla_Caos_v0.2.md  (EOF=da39a3ee5e, CAN=8df26858ca)
- memory/QEL_A96_MANIFIESTO_TRIADA_ESPEJO_v0.2.md  (EOF=da39a3ee5e, CAN=e02fa15bf1)
- memory/QEL_Arbol_Habilidades_MP_v1.0.md  (EOF=da39a3ee5e, CAN=d838a8e85a)
- README/PREH-NAV_README_v0.2.md  (EOF=da39a3ee5e, CAN=9b2420b77d)
- README/README_Q1 (1).md  (EOF=da39a3ee5e, CAN=96b85b841e)
- README/README_Q1.md  (EOF=da39a3ee5e, CAN=de1ffa7fb4)
- README/README.md  (EOF=da39a3ee5e, CAN=96b5d35d4b)
- README/README_Consolidado_v0.4.md  (EOF=da39a3ee5e, CAN=46b11af88f)
- README/README_QEL_MASTER_v0.2.1.md  (EOF=da39a3ee5e, CAN=dd90a7c66a)
- pub/cue-recovery/CUE-RECOVERY_Plantilla_Caos_v0.2.1.md  (EOF=da39a3ee5e, CAN=80d115a49f)
- pub/manuales/INSTALL_NOTES_PREH.md  (EOF=da39a3ee5e, CAN=991a696d87)
- pub/an/A96_Notas_Espontaneas_Sombras_Qel_v0.1.md  (EOF=da39a3ee5e, CAN=0dbdc9882d)
- pub/an/A81_Notas_Espontaneas_v0.2.md  (EOF=da39a3ee5e, CAN=9b95cf9379)
- pub/an/A81_Notas_Espontaneasv_0.3.md  (EOF=da39a3ee5e, CAN=bbe9945282)
- pub/an/A96_Notas_Espontaneas_Sombras_Qel_v0.2.md  (EOF=da39a3ee5e, CAN=43b357a256)
- pub/an/A81_Notas_Espontaneas_v0.1.md  (EOF=da39a3ee5e, CAN=7c47219c7d)
- pub/README_QEL_MASTER_v0.2.1.md  (EOF=da39a3ee5e, CAN=dd90a7c66a)

## Top archivos con más errores

| # errores | archivo | errores |
|----------:|---------|---------|
| 6 | `docs/core/QEL_Diario_del_Conjurador_v1.2.md` | E11;E4;E5;E7;E9;E3 |
| 5 | `docs/core/diarios/QEL_Diario_del_Conjurador_v1.2.md` | E4;E5;E7;E9;E3 |
| 4 | `memory/listador/QEL_ListadoR_A96_v1.2.md` | E12;E5;E9;E3 |
| 4 | `memory/listador/QEL_ListadoR_A96_v1.1.md` | E12;E5;E9;E3 |
| 4 | `memory/listador/Listado_CUEs_FormatoR_Q1+A96_v0.1.md` | E12;E5;E9;E3 |
| 4 | `memory/archive/Tarjetas_Atlas_QEL_v0.2.1.md` | E12;E5;E9;E3 |
| 4 | `memory/archive/QEL_Tratado_Metahumano_Protocolo_Seguridad_Sombras_v0.6.md` | E12;E5;E9;E3 |
| 4 | `memory/archive/QEL_Tratado_Metahumano_Protocolo_Seguridad_Sombras_v0.2.md` | E12;E5;E9;E3 |
| 4 | `memory/archive/QEL_Sellos_y_Cues_Idriell_v1.0.md` | E12;E6;E9;E3 |
| 4 | `memory/archive/QEL_PR_TEMPLATE_v0.2.2.md` | E12;E5;E9;E3 |
| 4 | `memory/archive/QEL_Manual_Interpretacion_Sombras_v1.0.md` | E12;E5;E9;E3 |
| 4 | `memory/archive/QEL_FormatoR_Manual_v0.1.md` | E12;E5;E9;E3 |
| 4 | `memory/archive/QEL_ECO_A96-250812-PRIMER-PECADO_delta-only_v0.1.md` | E12;E5;E9;E3 |
| 4 | `memory/archive/QEL_Curacion_Nucleo_Minimo_v1.6.md` | E12;E6;E9;E3 |
| 4 | `memory/archive/QEL.md` | E6;E7;E9;E3 |
| 4 | `memory/archive/Matematicas Resonantes (DS).md` | E12;E6;E9;E3 |
| 4 | `docs/ritual/microsellos/QEL_MicroSello_A37-251020_NAV_Altar_Actualizacion_v1.0.md` | E12;E6;E9;E3 |
| 4 | `docs/ritual/microsellos/QEL_MicroSello_A37-251020_CURADURIA_v1.0.md` | E12;E6;E9;E3 |
| 4 | `docs/ritual/QEL_Meditaciones_Primordiales_v1.0.md` | E12;E6;E9;E3 |
| 4 | `docs/pe/PEe2c82e10e1.md` | E12;E5;E9;E3 |

## Auditoría — 2025-11-04 14:22:18 CST

- **RunID:** `658cf322ad`
- **Iniciado (UTC):** 2025-11-04T19:28:33Z
- **Terminado (UTC):** 2025-11-04T20:22:17Z

# QEL · Informe de Trazabilidad

- **Archivos auditados:** 0
- **TC (Traza-Completitud):** 0.0000
- **TI (Integridad cruzada):** 0.0000
- **TT (Temporalidad):** 0.0000
- **UH (Unicidad HASH):** 0.0000
- **IT (Índice global de Traza):** 0.0000
- **Ledger:** present=0 · mismatch=0 · eof≠ledger=0 · none=0

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
| E1 | 0 |
| E2 | 0 |
| E3 | 179 |
| E4 | 0 |
| E5 | 0 |
| E6 | 0 |
| E7 | 0 |
| E8 | 0 |
| E9 | 0 |
| E10 | 0 |
| E11 | 0 |
| E12 | 0 |

## Discrepancias de hash

- **Sin hash en ledger (ListadoR ni Diario):** 0
- **Mismatch ListadoR ≠ Diario:** 0
- **EOF ≠ ledger canónico:** 0

### Listado — Sin hash en ledger

- docs/core/QEL_MFH_v1.4.md
- docs/core/QEL_Glosario_v1.4.md
- docs/ritual/vf/QEL_VF_PRIMA_A37-251020_SEAL_v1.0.md
- memory/archive/QEL_Manual_Conjurador_Avanzado_v1.0.md
- memory/archive/QEL_Formato_VF_AH_v1.4.md
- memory/archive/QEL_SoT_Study_Guide_v1.0.md
- memory/archive/QEL_Aurora_Spec_v1.1.md
- memory/archive/QEL_Tratado_Metahumano_v1.4.md
- memory/archive/Tarjetas_Atlas_QEL_v2.2.md
- pub/ecri/Los Tres Árboles Iluminados (DS).md

### Listado — Mismatch ListadoR ≠ Diario


### Listado — EOF ≠ Ledger

- docs/habilidades/Ə-UM-A/Llave/C/singular/e2c82e10e1.md  (EOF=da39a3ee5e, CAN=4fb56ea798)
- docs/pe/PEe2c82e10e1.md  (EOF=da39a3ee5e, CAN=b8cd265786)
- docs/core/diarios/QEL_Diario_del_Conjurador_v1.2.md  (EOF=da39a3ee5e, CAN=0ae4a874bc)
- docs/core/diarios/QEL_Diario_del_Conjurador_v1.5.md  (EOF=da39a3ee5e, CAN=1a205ec65b)
- docs/core/indices/QEL_Index_Rutas_v1.0.md  (EOF=da39a3ee5e, CAN=8bfc157771)
- docs/core/indices/QEL_Index_Semillas_v1.0.md  (EOF=da39a3ee5e, CAN=7f60aa09d5)
- docs/core/QEL_Diario_del_Conjurador_v1.2.md  (EOF=da39a3ee5e, CAN=0ae4a874bc)
- docs/core/Qel_Codice_Madre.md  (EOF=da39a3ee5e, CAN=591dfcbe8c)
- docs/core/QEL_Manual_Operativo.md  (EOF=da39a3ee5e, CAN=49b52a87d1)
- docs/core/manuales/QEL_Manual_Instructivo_v1.1.md  (EOF=da39a3ee5e, CAN=c528033ebb)
- docs/core/manuales/QEL_Manual_Interpretación_Sombras_v1.3.md  (EOF=da39a3ee5e, CAN=a09e6ca800)
- docs/core/manuales/QEL_Guia_alineacion_V_v1.0.md  (EOF=da39a3ee5e, CAN=1d2bfc41ea)
- docs/core/manuales/manual_cue_machine_qel_v.1.md  (EOF=da39a3ee5e, CAN=a7c70fd5ab)
- docs/core/manuales/QEL_FormatoR_Manual_v1.1.md  (EOF=da39a3ee5e, CAN=a1f13c990b)
- docs/core/manuales/QEL_SoT_Study_Guide_v1.1.md  (EOF=da39a3ee5e, CAN=1e04177959)
- docs/core/manuales/QEL_Manual_Atlas_MicroRegistro_v1.0.md  (EOF=da39a3ee5e, CAN=27beaf1f35)
- docs/core/manuales/QEL_Manual_Esculpido_en_Qel_v1.0.md  (EOF=da39a3ee5e, CAN=9a0e169f08)
- docs/core/manuales/QEL_LLPE_Manual_v1.4.md  (EOF=da39a3ee5e, CAN=eb85a6c0a9)
- docs/core/manuales/NAVEGADOR_M0_Manual_v0.2.md  (EOF=da39a3ee5e, CAN=46eaf6adaf)
- docs/core/manuales/GUIA_ACTUALIZACION_DIRECTORIO_M0_v0.2.md  (EOF=da39a3ee5e, CAN=fce51fa3cb)
- docs/core/atlas/Tarjetas_Atlas_QEL_v2.4.md  (EOF=da39a3ee5e, CAN=af7f9e2387)
- docs/core/atlas/codice_madre_atlas_qel_tarjetas_maestras_v_2.md  (EOF=da39a3ee5e, CAN=f3b2539514)
- docs/core/QEL_Curacion_Nucleo_Minimo.md  (EOF=da39a3ee5e, CAN=a7132116d8)
- docs/core/QEL_Libro_Sombras.md  (EOF=da39a3ee5e, CAN=04005cb55e)
- docs/nutria/QEL_Poema_Enigma_VF_v1.0.md  (EOF=da39a3ee5e, CAN=69b1cc447a)
- docs/nutria/Lýmina.md  (EOF=da39a3ee5e, CAN=c48483d4c1)
- docs/nutria/Astra.md  (EOF=da39a3ee5e, CAN=77fbdf66e0)
- docs/nutria/Matematicas Resonantes (DS).md  (EOF=da39a3ee5e, CAN=9000b0c1ac)
- docs/nutria/QEL_Poema_Enigma_Lun-Nai_v1.1.md  (EOF=da39a3ee5e, CAN=8204b1fd16)
- docs/nutria/Kósmos 8.md  (EOF=da39a3ee5e, CAN=a81647ceaf)
- docs/nutria/ACL-QEL.md  (EOF=da39a3ee5e, CAN=8c4dfd3eb2)
- docs/nutria/PCdI.md  (EOF=da39a3ee5e, CAN=75dc002c2b)
- docs/nutria/QEL.md  (EOF=da39a3ee5e, CAN=9496233d4a)
- docs/nutria/SQ.md  (EOF=da39a3ee5e, CAN=632456a16c)
- docs/nutria/Los_Tres_Árboles_Iluminados_DS_v1.1_SUR.md  (EOF=da39a3ee5e, CAN=19b13f1e6e)
- docs/ritual/QEL_Meditacion_Reiteracion_Lun-Nai_v1.1.md  (EOF=da39a3ee5e, CAN=69b1cc447a)
- docs/ritual/vf/QEL_VF_PRIMA_A96-251002_SEAL_v1.0.md  (EOF=da39a3ee5e, CAN=b7ff6c3d30)
- docs/ritual/vf/QEL_VF_PRIMA_A96-251011_SEAL_v1.0.md  (EOF=da39a3ee5e, CAN=ff62a04699)
- docs/ritual/vf/QEL_VF_PRIMA_A96-250820_SEAL_v1.0.md  (EOF=da39a3ee5e, CAN=a6ddca4f4f)
- docs/ritual/vf/QEL_VF_PRIMA_"A96-250813"_SEAL_v1.0.md  (EOF=da39a3ee5e, CAN=b69539941f)
- docs/ritual/vf/QEL_VF_PRIMA_A96-250901_SEAL_v1.0.md  (EOF=da39a3ee5e, CAN=6749801edc)
- docs/ritual/vf/QEL_VF_PRIMA_A96-251018_SEAL_v1.0.md  (EOF=da39a3ee5e, CAN=918f4611ce)
- docs/ritual/vf/QEL_VF_PRIMA_A96-250812_SEAL_v1.0.md  (EOF=da39a3ee5e, CAN=1cd8fb40ad)
- docs/ritual/vf/QEL_VF_PRIMA_"A37-251015"_SEAL_v1.0.md  (EOF=da39a3ee5e, CAN=f97aa40e31)
- docs/ritual/vf/QEL_VF_PRIMA_A96-250924_SEAL_v1.0.md  (EOF=da39a3ee5e, CAN=88ffaab1e8)
- docs/ritual/vf/QEL_VF_PRIMA_A37-251019_SEAL_v1.0.md  (EOF=da39a3ee5e, CAN=b40a148369)
- docs/ritual/QEL_Sello_A96-250814_Oriente_RA-VOH-EIA__Silencio-UM-A_v1.0.md  (EOF=da39a3ee5e, CAN=535f53a3f3)
- docs/ritual/QEL_Altar_y_Llave_v1.0.md  (EOF=da39a3ee5e, CAN=53d0777c0a)
- docs/ritual/microsellos/QEL_MicroSello_A96-251011_PREH-NAV_Cierre_v1.0.md  (EOF=da39a3ee5e, CAN=bbcb83664c)
- docs/ritual/microsellos/QEL_MicroSello_A96-251002_PREH-NAV_Cierre_v1.0.md  (EOF=da39a3ee5e, CAN=be5b4ab409)
- docs/ritual/microsellos/QEL_MicroSello_A96-250812_PREH-NAV_Cierre_v1.0.md  (EOF=da39a3ee5e, CAN=651375a40e)
- docs/ritual/microsellos/QEL_MicroSello_A96-250824_VCALC_UNIFIED_SEAL_v.10.md  (EOF=da39a3ee5e, CAN=45c695aa35)
- docs/ritual/microsellos/QEL_MicroSello_A96-250819_PREH-NAV_Cierre_v1.0.md  (EOF=da39a3ee5e, CAN=cb5f0435fb)
- docs/ritual/microsellos/QEL_MicroSello_A96-250824_PREH-NAV_Cierre_v1.0.md  (EOF=da39a3ee5e, CAN=19a2ee1f63)
- docs/ritual/microsellos/QEL_MicroSello_A37-251020_CURADURIA_v1.0.md  (EOF=da39a3ee5e, CAN=8bfc157771)
- docs/ritual/microsellos/QEL_MicroSello_"A96-250813"_PREH-NAV_Cierre_v1.0.md  (EOF=da39a3ee5e, CAN=69cd117458)
- docs/ritual/microsellos/QEL_MicroSello_A96-250820_PREH-NAV_Cierre_v1.0.md  (EOF=da39a3ee5e, CAN=9546867947)
- docs/ritual/microsellos/QEL_MicroSello_"A37-251015"_PREH-NAV_Cierre_v1.0.md  (EOF=da39a3ee5e, CAN=7c3e2f9163)
- docs/ritual/microsellos/QEL_MicroSello_A96-250924_PREH-NAV_Cierre_v1.0.md  (EOF=da39a3ee5e, CAN=8a751ab7df)
- docs/ritual/microsellos/QEL_MicroSello_A96-250829_LAB-TECNOALQ_Cristal_v1.0.md  (EOF=da39a3ee5e, CAN=714d48bbaf)
- docs/ritual/microsellos/QEL_MicroSello_A37-251020_PREH-NAV_Cierre_v1.0.md  (EOF=da39a3ee5e, CAN=72c493ef91)
- docs/ritual/microsellos/QEL_MicroSello_A37-251020_NAV_Altar_Actualizacion_v1.0.md  (EOF=da39a3ee5e, CAN=bbcb83664c)
- docs/ritual/microsellos/QEL_MicroSello_A37-251015_PREH-NAV_Cierre_v1.0.md  (EOF=da39a3ee5e, CAN=2bf87ccd14)
- docs/ritual/microsellos/QEL_MicroSello_A96-250901_PREH-NAV_Cierre_v1.0.md  (EOF=da39a3ee5e, CAN=21eec34405)
- docs/ritual/QEL_Sello_A96-250817_PREH-NAV_Cristal_v0.2.md  (EOF=da39a3ee5e, CAN=4caeb0a47c)
- docs/ritual/QEL_Sello_A96-250824_Centro_Sur_Norte_EIA-A-THON_Cierre_SIL-UM-Əv1.0.md  (EOF=da39a3ee5e, CAN=131e64d0bb)
- docs/ritual/qel_manual_vcalc_v_1_0.md  (EOF=da39a3ee5e, CAN=ab422c6ef3)
- docs/ritual/QEL_Meditaciones_Primordiales_v1.0.md  (EOF=da39a3ee5e, CAN=15dae7924a)
- memory/archive/QEL_Sistema_Completo_v0.2_Consolidado.md  (EOF=da39a3ee5e, CAN=92acc6b11c)
- memory/archive/QEL_Manual_Interpretacion_Sombras_v1.2.md  (EOF=da39a3ee5e, CAN=5b839188ee)
- memory/archive/QEL_PR_TEMPLATE_v0.2.2.md  (EOF=da39a3ee5e, CAN=69aa890e1e)
- memory/archive/QEL_Manual_Conjurador_Avanzado_v1.1.md  (EOF=da39a3ee5e, CAN=f61e3e479b)
- memory/archive/QEL_Diario_del_Conjurador_v1.3.md  (EOF=da39a3ee5e, CAN=15d5d82cfd)
- memory/archive/QEL_ECO_A96-250812-PRIMER-PECADO_delta-only_v0.1.md  (EOF=da39a3ee5e, CAN=2d14dc400e)
- memory/archive/QEL_LLPE_Manual_v1.3.md  (EOF=da39a3ee5e, CAN=7faf6ee9fb)
- memory/archive/QEL_Diario_del_Conjurador_v1.2.md  (EOF=da39a3ee5e, CAN=0ae4a874bc)
- memory/archive/QEL_Sistema_Consolidado_v0.2_Confirmacion_v0.1.md  (EOF=da39a3ee5e, CAN=1861015059)
- memory/archive/QEL_Chat_Register_All.md  (EOF=da39a3ee5e, CAN=605e8114bc)
- memory/archive/Esculpido_en_Qel_Guia_de_Trabajo_v0.3.md  (EOF=da39a3ee5e, CAN=07a534d2c1)
- memory/archive/QEL_CUE_Exception_v0.1.md  (EOF=da39a3ee5e, CAN=de4a91904c)
- memory/archive/QEL_Lamina_V_Editada_v1.0.md  (EOF=da39a3ee5e, CAN=844d7af0d3)
- memory/archive/QEL_SoT_Atlas_251018.md  (EOF=da39a3ee5e, CAN=7407eea49a)
- memory/archive/QEL_Matriz_Fonemica_Habilidades_v0.1.md  (EOF=da39a3ee5e, CAN=20583f66a7)
- memory/archive/QEL_Matriz_Fonemica_Habilidades_v1.0.md  (EOF=da39a3ee5e, CAN=4978c91d00)
- memory/archive/QEL_Lamina_V_Detallada_v1.1.md  (EOF=da39a3ee5e, CAN=1c46249856)
- memory/archive/QEL_VF_Carta_Lun-Nai_v1.0.md  (EOF=da39a3ee5e, CAN=b1ea4a6cca)
- memory/archive/QEL_Glosario_v1.2.md  (EOF=da39a3ee5e, CAN=8d88726d43)
- memory/archive/QEL_Chat_Index.md  (EOF=da39a3ee5e, CAN=d635087249)
- memory/archive/QEL_FormatoR_Manual_v0.2.md  (EOF=da39a3ee5e, CAN=9dd779ddb4)
- memory/archive/QEL_Instrumentos_Medicion_v1.0.md  (EOF=da39a3ee5e, CAN=2764934b12)
- memory/archive/QEL_Index_v1.1.md  (EOF=da39a3ee5e, CAN=1764330524)
- memory/archive/QEL_Tratado_Metahumano_Protocolo_Seguridad_Sombras_v0.3.md  (EOF=da39a3ee5e, CAN=64ef616abf)
- memory/archive/QEL_Tratado_Metahumano_Nota_v0.1.md  (EOF=da39a3ee5e, CAN=b13c92bf06)
- memory/archive/LaminaV_unificada_v1.0.md  (EOF=da39a3ee5e, CAN=534891a1d1)
- memory/archive/Tarjetas_Atlas_QEL_v0.2.1.md  (EOF=da39a3ee5e, CAN=f07e8f7c5a)
- memory/archive/Matematicas Resonantes (DS).md  (EOF=da39a3ee5e, CAN=9000b0c1ac)
- memory/archive/QEL_Curacion_Nucleo_Minimo_v1.6.md  (EOF=da39a3ee5e, CAN=374fbcea08)
- memory/archive/QEL_Tratado_Metahumano_Protocolo_Seguridad_Sombras_v1.2.md  (EOF=da39a3ee5e, CAN=833b8a92cc)
- memory/archive/QEL_Tratado_Metahumano_Protocolo_Seguridad_Sombras_v0.2.md  (EOF=da39a3ee5e, CAN=285d637c51)
- memory/archive/QEL_Tratado_Metahumano_Protocolo_Seguridad_Sombras_v1.3.md  (EOF=da39a3ee5e, CAN=8ef63b1bf5)
- memory/archive/QEL_Tratado_Metahumano_Protocolo_Seguridad_Sombras_v0.6.md  (EOF=da39a3ee5e, CAN=0368d34fe9)
- memory/archive/QEL_Glosario_v1.3.md  (EOF=da39a3ee5e, CAN=b1db70b967)
- memory/archive/README_Consolidado_v0.3.md  (EOF=da39a3ee5e, CAN=4d35ffb136)
- memory/archive/QEL_CUE_Recovery_Primer_Pecado_v0.1.md  (EOF=da39a3ee5e, CAN=74747847c3)
- memory/archive/QEL_Index_v1.0.md  (EOF=da39a3ee5e, CAN=256638bac3)
- memory/archive/README_Consolidado_v0.4.md  (EOF=da39a3ee5e, CAN=46b11af88f)
- memory/archive/QEL_Tratado_Metahumano_Protocolo_Seguridad_Sombras_v1.0.md  (EOF=da39a3ee5e, CAN=e167411bad)
- memory/archive/QEL_Tratado_Metahumano_Protocolo_Seguridad_Sombras_v0.5.md  (EOF=da39a3ee5e, CAN=ea9d265caf)
- memory/archive/QEL_Glosario_v1.0.md  (EOF=da39a3ee5e, CAN=a220cf1d4f)
- memory/archive/QEL_Aurora_Spec_v1.0.md  (EOF=da39a3ee5e, CAN=74f4eda772)
- memory/archive/QEL_Formato_VF_Arbol_Habilidades_v0.1.md  (EOF=da39a3ee5e, CAN=241712c9e7)
- memory/archive/QEL_Formato_VF_Arbol_Habilidades_v1.0.md  (EOF=da39a3ee5e, CAN=7e5e8c3316)
- memory/archive/QEL_Tratado_Metahumano_v1.5.md  (EOF=da39a3ee5e, CAN=ac195d7d92)
- memory/archive/QEL_Aurora_Spec_v0.1.md  (EOF=da39a3ee5e, CAN=1234381271)
- memory/archive/Esculpido_en_Qel_Guia_de_Trabajo_v0.3_completo.md  (EOF=da39a3ee5e, CAN=181d412a6c)
- memory/archive/QEL_Tratado_Metahumano_Protocolo_Seguridad_Sombras_v0.4.md  (EOF=da39a3ee5e, CAN=b20dd5f682)
- memory/archive/QEL_Manual_Lectura_VF_Tonalpohualli_v1.0.md  (EOF=da39a3ee5e, CAN=9c5499e68c)
- memory/archive/QEL_FormatoR_Manual_v0.1.md  (EOF=da39a3ee5e, CAN=715eea322f)
- memory/archive/QEL_SoT_Atlas_v1.0_250826.md  (EOF=da39a3ee5e, CAN=4c6f17c815)
- memory/archive/QEL.md  (EOF=da39a3ee5e, CAN=9496233d4a)
- memory/archive/PLAN_ORG_Codex_M0_v0.3.md  (EOF=da39a3ee5e, CAN=6b38430f1d)
- memory/archive/QEL_Tratado_Metahumano_Protocolo_Seguridad_Sombras_v1.1.md  (EOF=da39a3ee5e, CAN=250d799655)
- memory/archive/QEL_Tratado_Metahumano_RECALL_A96-250812_v1.0_Confirmacion_v0.1.md  (EOF=da39a3ee5e, CAN=6cc6c0ac8c)
- memory/archive/QEL_Diario_del_Conjurador_v1.1.md  (EOF=da39a3ee5e, CAN=5ab8ed7ea6)
- memory/archive/QEL_Manual_Interpretacion_Sombras_v1.0.md  (EOF=da39a3ee5e, CAN=5d67cbe26a)
- memory/archive/QEL_Matriz_Fonemica_Habilidades_v1.3.md  (EOF=da39a3ee5e, CAN=a87279be79)
- memory/archive/QEL_Manual_Operativo_historico.md  (EOF=da39a3ee5e, CAN=2a615a5acb)
- memory/archive/Tarjetas_Atlas_QEL_v2.3.md  (EOF=da39a3ee5e, CAN=af905ae372)
- memory/archive/QEL_Sellos_y_Cues_Idriell_v1.0.md  (EOF=da39a3ee5e, CAN=d4b42f075b)
- memory/archive/QEL_Manual_Interpretacion_Sombras_v1.1.md  (EOF=da39a3ee5e, CAN=10b5a80c9f)
- memory/archive/QEL_Matriz_Fonemica_Habilidades_v1.2.md  (EOF=da39a3ee5e, CAN=4ea279b7c6)
- memory/archive/QEL_Guia_Operacion_QEL_Consolidada_v1.0.md  (EOF=da39a3ee5e, CAN=7e67558f42)
- memory/archive/QEL_Diario_del_Conjurador_v1.0.md  (EOF=da39a3ee5e, CAN=a69d5f58aa)
- memory/archive/QEL_Diario_del_Conjurador_v1.2_Confirmacion_v0.1.md  (EOF=da39a3ee5e, CAN=ba3ca1eabc)
- memory/listador/QEL_ListadoR_A96_v0.2.md  (EOF=da39a3ee5e, CAN=cec10550c7)
- memory/listador/QEL_ListadoR_A96_v1.3.md  (EOF=da39a3ee5e, CAN=37d7a578eb)
- memory/listador/QEL_ListadoR_A96_v0.3.md  (EOF=da39a3ee5e, CAN=e3cbbf2148)
- memory/listador/QEL_ListadoR_A96_v1.2.md  (EOF=da39a3ee5e, CAN=d13db5625a)
- memory/listador/QEL_ListadoR_"A96_v1.3.md  (EOF=da39a3ee5e, CAN=9a986b3dd2)
- memory/listador/QEL_ListadoR_A37_v1.3.md  (EOF=da39a3ee5e, CAN=d302bad4ce)
- memory/listador/QEL_ListadoR_cue_v1.1.md  (EOF=da39a3ee5e, CAN=44045d248e)
- memory/listador/Listado_CUEs_FormatoR_Q1+A96_v0.1.md  (EOF=da39a3ee5e, CAN=54503dc9c0)
- memory/listador/QEL_ListadoR_"""A37_v1.3.md  (EOF=da39a3ee5e, CAN=3ed07b431b)
- memory/listador/Listado_CUEs_FormatoR_Q1+A96_v0.3.md  (EOF=da39a3ee5e, CAN=ec4512f116)
- memory/listador/QEL_ListadoR_A96_v1.2_Confirmacion_v0.1.md  (EOF=da39a3ee5e, CAN=d73ec704d6)
- memory/listador/Listado_CUEs_FormatoR_Q1+A96_v0.2.md  (EOF=da39a3ee5e, CAN=4c5d268c59)
- memory/listador/QEL_ListadoR_A96_v1.1.md  (EOF=da39a3ee5e, CAN=acc957593d)
- memory/listador/QEL_ListadoR_A96_v1.4.md  (EOF=da39a3ee5e, CAN=05808815af)
- memory/listador/QEL_ListadoR_A96_v0.1.md  (EOF=da39a3ee5e, CAN=1a0bef71ae)
- memory/listador/QEL_ListadoR_A96_v1.0.md  (EOF=da39a3ee5e, CAN=8256985b6b)
- memory/cue-recovery/CUE-RECOVERY_Plantilla_Caos_v0.2.1.md  (EOF=da39a3ee5e, CAN=80d115a49f)
- memory/cue-recovery/CUE-RECOVERY_Plantilla_Caos_v0.2.md  (EOF=da39a3ee5e, CAN=8df26858ca)
- memory/QEL_A96_MANIFIESTO_TRIADA_ESPEJO_v0.2.md  (EOF=da39a3ee5e, CAN=e02fa15bf1)
- memory/QEL_Arbol_Habilidades_MP_v1.0.md  (EOF=da39a3ee5e, CAN=d838a8e85a)
- README/PREH-NAV_README_v0.2.md  (EOF=da39a3ee5e, CAN=9b2420b77d)
- README/README_Q1 (1).md  (EOF=da39a3ee5e, CAN=96b85b841e)
- README/README_Q1.md  (EOF=da39a3ee5e, CAN=de1ffa7fb4)
- README/README.md  (EOF=da39a3ee5e, CAN=96b5d35d4b)
- README/README_Consolidado_v0.4.md  (EOF=da39a3ee5e, CAN=46b11af88f)
- README/README_QEL_MASTER_v0.2.1.md  (EOF=da39a3ee5e, CAN=dd90a7c66a)
- pub/cue-recovery/CUE-RECOVERY_Plantilla_Caos_v0.2.1.md  (EOF=da39a3ee5e, CAN=80d115a49f)
- pub/manuales/INSTALL_NOTES_PREH.md  (EOF=da39a3ee5e, CAN=991a696d87)
- pub/an/A96_Notas_Espontaneas_Sombras_Qel_v0.1.md  (EOF=da39a3ee5e, CAN=0dbdc9882d)
- pub/an/A81_Notas_Espontaneas_v0.2.md  (EOF=da39a3ee5e, CAN=9b95cf9379)
- pub/an/A81_Notas_Espontaneasv_0.3.md  (EOF=da39a3ee5e, CAN=bbe9945282)
- pub/an/A96_Notas_Espontaneas_Sombras_Qel_v0.2.md  (EOF=da39a3ee5e, CAN=43b357a256)
- pub/an/A81_Notas_Espontaneas_v0.1.md  (EOF=da39a3ee5e, CAN=7c47219c7d)
- pub/README_QEL_MASTER_v0.2.1.md  (EOF=da39a3ee5e, CAN=dd90a7c66a)

## Top archivos con más errores

| # errores | archivo | errores |
|----------:|---------|---------|
| 6 | `docs/core/QEL_Diario_del_Conjurador_v1.2.md` | E11;E4;E5;E7;E9;E3 |
| 5 | `docs/core/diarios/QEL_Diario_del_Conjurador_v1.2.md` | E4;E5;E7;E9;E3 |
| 4 | `memory/listador/QEL_ListadoR_A96_v1.2.md` | E12;E5;E9;E3 |
| 4 | `memory/listador/QEL_ListadoR_A96_v1.1.md` | E12;E5;E9;E3 |
| 4 | `memory/listador/Listado_CUEs_FormatoR_Q1+A96_v0.1.md` | E12;E5;E9;E3 |
| 4 | `memory/archive/Tarjetas_Atlas_QEL_v0.2.1.md` | E12;E5;E9;E3 |
| 4 | `memory/archive/QEL_Tratado_Metahumano_Protocolo_Seguridad_Sombras_v0.6.md` | E12;E5;E9;E3 |
| 4 | `memory/archive/QEL_Tratado_Metahumano_Protocolo_Seguridad_Sombras_v0.2.md` | E12;E5;E9;E3 |
| 4 | `memory/archive/QEL_Sellos_y_Cues_Idriell_v1.0.md` | E12;E6;E9;E3 |
| 4 | `memory/archive/QEL_PR_TEMPLATE_v0.2.2.md` | E12;E5;E9;E3 |
| 4 | `memory/archive/QEL_Manual_Interpretacion_Sombras_v1.0.md` | E12;E5;E9;E3 |
| 4 | `memory/archive/QEL_FormatoR_Manual_v0.1.md` | E12;E5;E9;E3 |
| 4 | `memory/archive/QEL_ECO_A96-250812-PRIMER-PECADO_delta-only_v0.1.md` | E12;E5;E9;E3 |
| 4 | `memory/archive/QEL_Curacion_Nucleo_Minimo_v1.6.md` | E12;E6;E9;E3 |
| 4 | `memory/archive/QEL.md` | E6;E7;E9;E3 |
| 4 | `memory/archive/Matematicas Resonantes (DS).md` | E12;E6;E9;E3 |
| 4 | `docs/ritual/microsellos/QEL_MicroSello_A37-251020_NAV_Altar_Actualizacion_v1.0.md` | E12;E6;E9;E3 |
| 4 | `docs/ritual/microsellos/QEL_MicroSello_A37-251020_CURADURIA_v1.0.md` | E12;E6;E9;E3 |
| 4 | `docs/ritual/QEL_Meditaciones_Primordiales_v1.0.md` | E12;E6;E9;E3 |
| 4 | `docs/pe/PEe2c82e10e1.md` | E12;E5;E9;E3 |

## Auditoría — 2025-11-04 17:01:07 CST

- **RunID:** `829cbb84a6`
- **Iniciado (UTC):** 2025-11-04T22:07:06Z
- **Terminado (UTC):** 2025-11-04T23:01:07Z

# QEL · Informe de Trazabilidad

- **Archivos auditados:** 0
- **TC (Traza-Completitud):** 0.0000
- **TI (Integridad cruzada):** 0.0000
- **TT (Temporalidad):** 0.0000
- **UH (Unicidad HASH):** 0.0000
- **IT (Índice global de Traza):** 0.0000
- **Ledger:** present=0 · mismatch=0 · eof≠ledger=0 · none=0

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
| E1 | 0 |
| E2 | 0 |
| E3 | 30 |
| E4 | 0 |
| E5 | 0 |
| E6 | 0 |
| E7 | 0 |
| E8 | 0 |
| E9 | 0 |
| E10 | 0 |
| E11 | 0 |
| E12 | 0 |

## Discrepancias de hash

- **Sin hash en ledger (ListadoR ni Diario):** 0
- **Mismatch ListadoR ≠ Diario:** 0
- **EOF ≠ ledger canónico:** 0

### Listado — Sin hash en ledger

- docs/core/QEL_MFH_v1.4.md
- docs/core/QEL_Glosario_v1.4.md
- docs/ritual/vf/QEL_VF_PRIMA_A37-251020_SEAL_v1.0.md
- memory/archive/QEL_Manual_Conjurador_Avanzado_v1.0.md
- memory/archive/QEL_Formato_VF_AH_v1.4.md
- memory/archive/QEL_SoT_Study_Guide_v1.0.md
- memory/archive/QEL_Aurora_Spec_v1.1.md
- memory/archive/QEL_Tratado_Metahumano_v1.4.md
- memory/archive/Tarjetas_Atlas_QEL_v2.2.md
- pub/ecri/Los Tres Árboles Iluminados (DS).md

### Listado — Mismatch ListadoR ≠ Diario


### Listado — EOF ≠ Ledger


## Top archivos con más errores

| # errores | archivo | errores |
|----------:|---------|---------|
| 5 | `docs/core/diarios/QEL_Diario_del_Conjurador_v1.2.md` | E4;E5;E7;E9;E3 |
| 5 | `docs/core/QEL_Diario_del_Conjurador_v1.2.md` | E4;E5;E7;E9;E3 |
| 4 | `memory/archive/QEL.md` | E6;E7;E9;E3 |
| 4 | `memory/archive/Matematicas Resonantes (DS).md` | E12;E6;E9;E3 |
| 4 | `docs/ritual/microsellos/QEL_MicroSello_A37-251020_NAV_Altar_Actualizacion_v1.0.md` | E12;E6;E9;E3 |
| 4 | `docs/ritual/microsellos/QEL_MicroSello_A37-251020_CURADURIA_v1.0.md` | E12;E6;E9;E3 |
| 4 | `docs/nutria/QEL.md` | E12;E6;E9;E3 |
| 4 | `docs/nutria/Matematicas Resonantes (DS).md` | E12;E6;E9;E3 |
| 4 | `docs/core/indices/QEL_Index_Rutas_v1.0.md` | E12;E6;E9;E3 |
| 3 | `pub/ecri/Los Tres Árboles Iluminados (DS).md` | E12;E9;E3 |
| 3 | `pub/cue-recovery/CUE-RECOVERY_Plantilla_Caos_v0.2.1.md` | E12;E9;E3 |
| 3 | `pub/README_QEL_MASTER_v0.2.1.md` | E12;E9;E3 |
| 3 | `memory/listador/QEL_ListadoR_A96_v1.2.md` | E12;E5;E9 |
| 3 | `memory/listador/QEL_ListadoR_A96_v1.1.md` | E12;E5;E9 |
| 3 | `memory/listador/Listado_CUEs_FormatoR_Q1+A96_v0.1.md` | E12;E5;E9 |
| 3 | `memory/cue-recovery/CUE-RECOVERY_Plantilla_Caos_v0.2.1.md` | E12;E9;E3 |
| 3 | `memory/archive/Tarjetas_Atlas_QEL_v0.2.1.md` | E12;E5;E9 |
| 3 | `memory/archive/QEL_Tratado_Metahumano_Protocolo_Seguridad_Sombras_v0.6.md` | E12;E5;E9 |
| 3 | `memory/archive/QEL_Tratado_Metahumano_Protocolo_Seguridad_Sombras_v0.2.md` | E12;E5;E9 |
| 3 | `memory/archive/QEL_SoT_Study_Guide_v1.0.md` | E12;E9;E3 |
