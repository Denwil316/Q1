## Micro-sello de cristalización (con notas M1/M2)
[QEL::ECO[96]::SUMMON A96-250824-VCALC-UNIFIED-SEAL]
SeedI=A96-250824
SoT=HERRAMIENTAS/V0.2
Version=v0.2
Updated=2025-08-24

## Sello:

Pulso unificado: χ_r y H_k coherentes; ΔC/ΔS templado; ρ domado. Cálculo limpio (awk), cero inicial garantizado. VCALC habla claro.

## Notas futuras — M1:

--emit vf|md (generar VF YAML/MD con cabecera cue/SeedI/SoT/Version/Updated).
Warnings suaves: ΔC∧ΔS=up; uso de aurora en germinación; ρ real >0.10 aunque clippee.
Umbrales leídos de SoT activo (cristal≥0.85, líquido≥0.70).

## Notas futuras — M2:

--vf-file (parser YAML nativo) con precedencia CLI > VF.
--perfil m1|m2|lab para tablas χ_r/H_k/gates versionadas.
--log csv con fecha,cue,obj,rumbo,A,ρ,ΔC,ΔS,V,banda.
Endpoint local PREH-NAV M1 consumiendo --emit json.

45c695aa35
