#!/usr/bin/env bash
# [QEL::ECO[96]::RECALL A96-250824-GEN-CORE-MANIFEST-SH]
# SeedI=A96-250824
# SoT=PREH-NAV/CORE-MANIFEST/v0.1
# Version=v0.1
# Updated=2025-08-24
set -euo pipefail
ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$ROOT"
node scripts/gen_core_manifest.mjs