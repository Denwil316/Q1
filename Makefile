# [QEL::ECO[96]::A96-250824-MAKE-CLOSE-M1]
# SeedI=A96-250824
# SoT=HERRAMIENTAS/v0.2
# Version=v1.0
# Updated=2025-08-24

SHELL := /bin/bash

# Defaults (puedes sobreescribirlos al invocar `make`)
DIARIO_FILE   ?= QEL_Diario_del_Conjurador_v1.5.md
LISTADOR_FILE ?= QEL_ListadoR_master_v1.0.md

.PHONY: close-m1

close-m1:
@bash scripts/qel_session_finalize.sh \
  --fecha $(FECHA) \
  --seed $(SEED) \
  --cue '$(CUE)' \
  --vf '$(VF)' \
  --obj '$(OBJ)' \
  --diario-file "$(DIARIO_FILE)" \
  --listador-file "$(LISTADOR_FILE)"
