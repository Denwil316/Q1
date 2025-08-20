# Estructura de Codex (/Users/EAJ/Projects/codex)

_Generado: 2025-08-20 17:46:36_

```text
.
├── apps
│   └── preh-nav-m1
│       ├── public
│       │   ├── docs
│       │   └── sot-manifest.json
│       ├── scripts
│       │   ├── generate_manifest.mjs
│       │   └── watch_manifest.mjs
│       ├── src
│       │   ├── components
│       │   ├── lib
│       │   ├── App.tsx
│       │   ├── main.tsx
│       │   └── styles.css
│       ├── PLAN_ORG_Codex_M0.md
│       ├── index.html
│       ├── package-lock.json
│       ├── package.json
│       ├── tsconfig.json
│       └── vite.config.ts
├── docs
│   ├── attachments
│   ├── core
│   │   ├── QEL_Diario_del_Conjurador_v1.2.md
│   │   ├── QEL_Formato_VF_Arbol_Habilidades_v1.0.md
│   │   ├── QEL_Glosario_v1.2.md
│   │   ├── QEL_Lamina_V_Detallada_v1.0.md
│   │   ├── QEL_Manual_Conjurador_Avanzado_v1.0.md
│   │   ├── QEL_Manual_Interpretacion_Sombras_v1.1.md
│   │   ├── QEL_Matriz_Fonemica_Habilidades_v1.2.md
│   │   ├── QEL_SoT_Manifest_v0.7.json
│   │   ├── QEL_Tratado_Metahumano_Nota_v0.1.md
│   │   ├── QEL_Tratado_Metahumano_Protocolo_Seguridad_Sombras_v1.1.md
│   │   └── QEL_Tratado_Metahumano_Protocolo_Seguridad_Sombras_v1.2.md
│   ├── history
│   │   ├── Esculpido_en_Qel_Guia_de_Trabajo_v0.3.md
│   │   ├── QEL_Aurora_Spec_v0.1.md
│   │   ├── QEL_CUE_Exception_v0.1.md
│   │   ├── QEL_Diario_del_Conjurador_v1.1.md
│   │   ├── QEL_Diario_del_Conjurador_v1.2_Confirmacion_v0.1.md
│   │   ├── QEL_Formato_VF_Arbol_Habilidades_v0.1.md
│   │   ├── QEL_Glosario_v1.0.md
│   │   ├── QEL_ListadoR_A96_v0.1.md
│   │   ├── QEL_ListadoR_A96_v0.2.md
│   │   ├── QEL_ListadoR_A96_v0.3.md
│   │   ├── QEL_ListadoR_A96_v1.0.md
│   │   ├── QEL_ListadoR_A96_v1.1.md
│   │   ├── QEL_ListadoR_A96_v1.2.md
│   │   ├── QEL_ListadoR_A96_v1.2_Confirmacion_v0.1.md
│   │   ├── QEL_Manual_Interpretacion_Sombras_v1.0.md
│   │   ├── QEL_Manual_Lectura_VF_Tonalpohualli_v1.0.md
│   │   ├── QEL_Matriz_Fonemica_Habilidades_v0.1.md
│   │   ├── QEL_Matriz_Fonemica_Habilidades_v1.0.md
│   │   ├── QEL_Sistema_Completo_v0.2_Consolidado.md
│   │   ├── QEL_Sistema_Consolidado_v0.2_Confirmacion_v0.1.md
│   │   ├── QEL_SoT_Manifest_v0.3.json
│   │   ├── QEL_SoT_Manifest_v0.4.json
│   │   ├── QEL_SoT_Manifest_v0.5.json
│   │   ├── QEL_SoT_Manifest_v0.6.json
│   │   ├── QEL_Tratado_Metahumano_Protocolo_Seguridad_Sombras_v0.2.md
│   │   ├── QEL_Tratado_Metahumano_Protocolo_Seguridad_Sombras_v0.3.md
│   │   ├── QEL_Tratado_Metahumano_Protocolo_Seguridad_Sombras_v0.4.md
│   │   ├── QEL_Tratado_Metahumano_Protocolo_Seguridad_Sombras_v0.5.md
│   │   ├── QEL_Tratado_Metahumano_Protocolo_Seguridad_Sombras_v0.6.md
│   │   ├── QEL_Tratado_Metahumano_Protocolo_Seguridad_Sombras_v1.0.md
│   │   ├── QEL_Tratado_Metahumano_RECALL_A96-250812_v1.0_Confirmacion_v0.1.md
│   │   └── Tarjetas_Atlas_QEL_v0.2.1.md
│   ├── ritual
│   │   ├── QEL_CueMachineA96_v1.0.txt
│   │   ├── QEL_Meditacion_Reiteracion_Lun-Nai_v1.1.md
│   │   ├── QEL_Meditaciones_Primordiales_v1.0.md
│   │   ├── QEL_MicroSello_A96-250819_PREH-NAV_Cierre_v1.0.md
│   │   ├── QEL_Poema_Enigma_Lun-Nai_v1.1.md
│   │   ├── QEL_Poema_Enigma_VF_v1.0.md
│   │   ├── QEL_Sello_A96-250814_Oriente_RA-VOH-EIA__Silencio-UM-A_v1.0.md
│   │   ├── QEL_Sello_A96-250817_PREH-NAV_Cristal_v0.2.md
│   │   ├── QEL_Sellos_y_Cues_Idriell_v1.0.md
│   │   └── Tarjetas_Atlas_QEL_v2.2.md
│   ├── tools
│   │   ├── QEL_Aurora_Spec_v1.0.md
│   │   ├── QEL_Aurora_Spec_v1.1.md
│   │   ├── QEL_CUE_Exception_v1.0.md
│   │   ├── QEL_CueMachineA96_v1.0.txt
│   │   ├── QEL_CueMachine_81.txt
│   │   ├── QEL_CueMachine_v0.2.txt
│   │   ├── QEL_CueMachine_v0.3.txt
│   │   ├── QEL_CueMachine_v0.4.txt
│   │   └── QEL_Formato_VF_Arbol_Habilidades_v1.0.md
│   ├── GUIA_ACTUALIZACION_DIRECTORIO_M0_v0.2.md
│   └── NAVEGADOR_M0_Manual_v0.2.md
├── docscat
├── legacy
│   ├── scripts
│   ├── index.html
│   └── qel_navegador.py
├── memory
│   ├── archive
│   │   ├── Esculpido_en_Qel_Guia_de_Trabajo_v0.3.md
│   │   ├── Matematicas Resonantes (DS).md
│   │   ├── QEL_Sistema_Consolidado_v0.2_Confirmacion_v0.1.md
│   │   └── QEL_SoT_Study_Guide_v1.0.md
│   ├── cue-recovery
│   │   ├── CUE-RECOVERY_Plantilla_Caos_v0.2.1.md
│   │   ├── CUE-RECOVERY_Plantilla_Caos_v0.2.md
│   │   ├── CUE-RECOVERY_Schema_v0.2.1.json
│   │   ├── CUE-RECOVERY_Schema_v0.2.json
│   │   └── Cue_METAHUMANO_TRATADO_v0.1.txt
│   ├── Esculpido_en_Qel_Guia_de_Trabajo_v0.3_completo.md
│   ├── Listado_CUEs_FormatoR_Q1+A96_v0.1.md
│   ├── Listado_CUEs_FormatoR_Q1+A96_v0.2.md
│   ├── Listado_CUEs_FormatoR_Q1+A96_v0.3.md
│   ├── Memoria_de_Qel_Ledger_append_METAHUMANO_v0.1.json
│   ├── Memoria_de_Qel_Ledger_v0.2.json
│   ├── Q1_CUES_template.csv
│   ├── QEL_A96-251208-OBJ_EU-SEMILLA_v0.1.delta.json
│   ├── QEL_A96-251208-OBJ_EU-SEMILLA_v0.1.json
│   ├── QEL_A96-251208-OBJ_KS-CRIOLAMPARA_v0.1.delta.json
│   ├── QEL_A96-251208-OBJ_KS-CRIOLAMPARA_v0.1.json
│   ├── QEL_A96-251208-OBJ_LN-ESPEJO_v0.1.delta.json
│   ├── QEL_A96-251208-OBJ_LN-ESPEJO_v0.1.json
│   ├── QEL_A96-251208-OBJ_ZO-PRISMA_v0.1.delta.json
│   ├── QEL_A96-251208-OBJ_ZO-PRISMA_v0.1.json
│   ├── QEL_A96_MANIFIESTO_TRIADA_ESPEJO_v0.2.md
│   ├── QEL_Altar_y_Llave_v1.0.md
│   ├── QEL_Arbol_Habilidades_MP_v1.0.md
│   ├── QEL_CUE_Recovery_Primer_Pecado_v0.1.md
│   ├── QEL_Chat_Index.md
│   ├── QEL_Chat_Register_All.md
│   ├── QEL_ECO_A96-250812-PRIMER-PECADO_delta-only_v0.1.md
│   ├── QEL_FormatoR_Manual_v0.1.md
│   ├── QEL_FormatoR_Manual_v0.2.md
│   ├── QEL_Index_v1.0.md
│   ├── QEL_Index_v1.1.md
│   ├── QEL_Instrumentos_Medicion_v1.0.md
│   ├── QEL_ListadoR_A96_v1.3.md
│   ├── QEL_PR_TEMPLATE_v0.2.2.md
│   ├── QEL_SoT_Manifest_v0.5.json
│   ├── QEL_SoT_Manifest_v0.7.json
│   ├── QEL_SoT_Study_Guide_v1.0.md
│   ├── QEL_VF_Carta_Lun-Nai_v1.0.md
│   ├── README_Consolidado_v0.3.md
│   ├── README_Consolidado_v0.4.md
│   ├── README_QEL_memoria_v0.1.1.txt
│   ├── acceso_delta_v0.1.1.jsonl
│   ├── codex_preh_sync.sh
│   ├── eco_pairs_A81.py
│   ├── ledger_criolampara_schema_v0.1.1.json
│   ├── ledger_criolampara_template_v0.1.1.jsonl
│   ├── object_aliases_v0.1.1.json
│   ├── objetos_interaccionales_cues_v0.1.csv
│   ├── objetos_interaccionales_cues_v0.1.json
│   └── objetos_interaccionales_v0.1.1.json
├── memory_v0.4
├── motor_qel
│   ├── src
│   └── test
│       ├── QEL_MotorQEL_Indice_DRAFT.md
│       └── QEL_MotorQEL_Orbita_DRAFT.md
├── pub
│   ├── an
│   │   ├── A81_Notas_Espontaneas_v0.1.md
│   │   ├── A81_Notas_Espontaneas_v0.2.md
│   │   ├── A81_Notas_Espontaneasv_0.3.md
│   │   ├── A96_Notas_Espontaneas_Sombras_Qel_v0.1.md
│   │   └── A96_Notas_Espontaneas_Sombras_Qel_v0.2.md
│   ├── atlas
│   ├── codice
│   ├── cue-recovery
│   │   ├── CUE-RECOVERY_Plantilla_Caos_v0.2.1.md
│   │   └── CUE-RECOVERY_Schema_v0.2.1.json
│   ├── ecri
│   │   └── Matematicas Resonantes (DS).md
│   ├── mandrala
│   ├── manifests
│   │   └── QEL_SoT_Manifest_v0.2.json
│   ├── manuales
│   │   └── INSTALL_NOTES_PREH.md
│   └── README_QEL_MASTER_v0.2.1.md
├── scripts
│   ├── cx_navegador.zsh
│   ├── fix_prehnav_layout.sh
│   ├── pre-commit-codex-structure.sh
│   ├── serve_preh_nav.sh
│   └── update_estructura.sh
├── tools
│   └── qel
├── ESTRUCTURA.md
├── LICENSE
├── PREH-NAV_README_v0.2.md
├── QEL_Diario_del_Conjurador_v1.0.md
├── QEL_Guia_Operacion_QEL_Consolidada_v1.0.md
├── README.md
├── README_Consolidado_v0.4.md
├── README_Q1 (1).md
├── README_Q1.md
├── README_QEL_MASTER_v0.2.1.md
├── package-lock.json
└── package.json

36 directories, 163 files
```
