SoT=UNCLASSIFIED
# CUE-RECOVERY · Plantilla del Caos · v0.2.1

Usa esto cuando NO recuerdas el SeedID. Completa lo que sepas.

```
[QEL::CUE-RECOVERY]
SOT=<sistema/version>
CHAT=<nombre visible del chat>
WHEN≈<YYYY-MM-DD ±Nd>
ECO≈<##|??>
KEYS=["clave1","clave2","..."]
RUMBO≈<Oriente|Norte|Occidente|Sur|desconocido>
PLANO≈<Rito|Numero|Lengua|mixto|desconocido>
FONEMAS≈["Kael","Vun"]
ASSET≈"<archivo.ext>"
CONTEXT≈"1–2 frases que ubiquen la pieza"
AUTHOR≈<usuario|modelo|mixto>
CONFIDENCE≈<1..5>
```

## ECO manual (si no propones uno)
1) Base por rumbo (dos dígitos): Oriente=81 · Norte=72 · Occidente=63 · Sur=54 · desconocido=42  
2) Peso por fonema (suma de dígitos del Tono → 1 dígito):
   - Kael=3 Vun=6 Ora=9 Zeh=4 Lun=8 Nai=2 Sün=1 Ida=5
   - Suma **únicos** implicados y toma %10.
3) Shift por KEYS: `shift = (consonantes + 2·vocales) % 10`  
4) ECO = `(base + peso + shift) % 100` → escribe con dos dígitos.

## Facetas (dodecaedro)
Rumbos × Planos (Rito/Número/Lengua) → F1..F12.  
Si indicas `RUMBO≈` y `PLANO≈`, la faceta se infiere.
SeedI=A37-251015

Version=v0.2
Updated=2025-11-04

80d115a49f
