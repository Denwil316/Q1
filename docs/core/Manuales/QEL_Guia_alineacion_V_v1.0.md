cue=\[QEL::ECO\[96\]::RECALL A96-250924-GUIA-ALINEACION-V\]  
 SeedI=A96-250924  
 SoT=HERRAMIENTAS/ALINEACION-V/v1.0  
 Version=v1.0  
 Updated=2025-09-24

# **Guía de Alineación 𝒱 (canon) — v1.0**

Objetivo: alinear **scripts** (`qel_vcalc.sh`, `pe_generate.mjs`) al **canon** (Lámina 𝒱 \+ MFH), y definir una política de **precisión** (decimales) que preserve **singularidad** por habilidad sin cargar el cómputo.

---

## **1\) Contexto y alcance**

* **Canon manda**: Lámina 𝒱 y MFH definen **χ\_r** (rumbo) y **H\_k** (clase).

* Esta guía corrige: factores de **rumbo**, **clase**, tratamiento de **gates**, y sugiere exponer **𝒱\_canónica** y **𝒱\_operativa**.

* Además, propone una **precisión de salida** para 𝒱 y un **desempatador estable opcional**.

---

## **2\) Requisitos y entorno**

* macOS/Linux (Bash, `awk`, `sed` estándar; evita dependencias GNU-only).

* Node.js ≥ 18 (para `pe_generate.mjs`).

* Rutas estándar de Codex, p. ej.: `scripts/qel_vcalc.sh`, `scripts/pe_generate.mjs`.

---

## **3\) Respaldo previo (obligatorio)**

cp scripts/qel\_vcalc.sh scripts/qel\_vcalc.sh.bak  
cp scripts/pe\_generate.mjs scripts/pe\_generate.mjs.bak

---

## **4\) Parches manuales — `scripts/qel_vcalc.sh`**

### **4.1 Rumbo χ\_r (canon)**

**Sustituir** la función `chi_r()` por:

chi\_r(){ case "$(upper "$1")" in  
  O|E) echo 1.10;;   \# Oriente / Este  
  N)   echo 1.05;;   \# Norte  
  C)   echo 1.00;;   \# Centro  
  W)   echo 0.95;;   \# Occidente  
  S)   echo 0.90;;   \# Sur  
  \*)   echo "";;  
esac; }

### **4.2 Clase H\_k (canon MFH)**

**Sustituir** la función `H_k()` por:

H\_k(){ case "$(lower "$1")" in  
  basica|básica)                                   echo 0.50;;  
  "poco comun"|"poco común"|poco-comun|poco-común) echo 0.80;;  
  rara|raro|singular|unico|único)                  echo 1.00;;  
  metalica|metálica)                               echo 1.20;;  
  obsidiana)                                       echo 1.60;;  
  \*)                                               echo "";;  
esac; }

### **4.3 Gates (aurora no penaliza)**

En `gates_product()`, **cambiar** el caso `aurora` a 1.00:

\# antes: AUR=0.95 cuando aurora activa  
\# ahora: no penaliza  
      aurora|contacto\_aurora) AUR=1.00;;

### **4.4 Exponer 𝒱\_canónica y 𝒱\_operativa**

**Sin tocar** `compute_v`, calcula ambas tras `V="$(compute_v ...)"`:

V\_CANON="$(awk \-v A="$A" \-v XR="$XR" \-v HK="$HK" \-v GP="$GP" 'BEGIN{v=A\*XR\*HK\*GP; if(v\<0)v=0; if(v\>1)v=1; printf "%.4f", v}')"  
V\_OPER="$(awk \-v Vc="$V\_CANON" \-v FD="$FD" \-v FR="$FR" 'BEGIN{v=Vc\*FD\*FR; if(v\<0)v=0; if(v\>1)v=1; printf "%.4f", v}')"

En salida **pretty**, **reemplazar** el bloque final por:

\-----------------------------------------------  
𝒱\_canónica: $V\_CANON  
𝒱\_operativa (×Δ,×ruido): $V\_OPER  
Sugerencia \--obj: "${OBJ}=${V\_CANON}"

En salida **JSON** (`--emit json`), **sustituir** el campo `"V":...` por:

printf '"V\_canon":%s,' "$(awk \-v x="$V\_CANON" 'BEGIN{printf "%.4f", x+0}')"  
printf '"V\_oper":%s'      "$(awk \-v x="$V\_OPER"  'BEGIN{printf "%.4f", x+0}')"

### **4.5 Política de precisión (recomendación)**

* Imprimir **4 decimales** para: `V_canón`, `V_oper`, `fdelta`, `fruido` (internamente ya operas con doble precisión en `awk`).

* Mantener `A` a **3–4 decimales** en JSON (`"A":%.4f`).

* Mantener `χ_r`, `H_k`, `gates_p` en **2–4** según necesidad (2 es suficiente; 4 si quieres auditoría fina).

**Nota**: 4 decimales **no** encarecen el cómputo (son multiplicaciones/`awk`), y reducen colisiones de 𝒱 sin perder legibilidad.

---

## **5\) Parches manuales — `scripts/pe_generate.mjs`**

### **5.1 Tablas canon χ\_r y H\_k**

**Sustituir** las constantes por:

const CHI\_R \= { O:1.10, E:1.10, N:1.05, C:1.00, W:0.95, S:0.90 };  
const H\_K   \= {  
  'basica':0.50, 'básica':0.50,  
  'poco-comun':0.80, 'poco-común':0.80, 'poco comun':0.80, 'poco común':0.80,  
  'rara':1.00, 'raro':1.00, 'singular':1.00, 'unico':1.00, 'único':1.00,  
  'metalica':1.20, 'metálica':1.20,  
  'obsidiana':1.60  
};

### **5.2 Gates (aurora no penaliza)**

En el cálculo de `gp`:

if(g.includes('aurora')||g.includes('contacto\_aurora')) aur=1.00; // en lugar de 0.95

### **5.3 Precisión y validación contra 𝒱\_canónica**

Si `vcalc --emit json` ya emite `V_canon` y `V_oper`, **preferir** `V_canon` en la validación:

const out \= vcalcJSON({ /\* ... \*/ });  
const V   \= Number(out?.V\_canon ?? out?.V\_oper ?? out?.V ?? 0);  
if(\!(V \>= tau)){  
  console.error(JSON.stringify({error:'V\<threshold', V, tau}, null, 2));  
  process.exit(2);  
}

### **5.4 Precisión en salida (opcional)**

Si quieres forzar 4 decimales al imprimir JSON desde Node, cuando hagas reporting manual agrega: `Number(V.toFixed(4))`.

---

## **6\) Política de precisión y singularidad**

### **6.1 ¿Cuántos decimales?**

* **Recomendado**: **4 decimales** para 𝒱.

  * Beneficio: incrementa discriminación y reduce colisiones entre habilidades.

  * Costo computacional: despreciable (operaciones escalares en `awk`/Node).

* **Alternativas**: 3 decimales (legibilidad prime) o 5 decimales (si tu Atlas supera \~10⁴ entradas y aún observas empates). Más de 5 rara vez aporta.

### **6.2 Desempatador estable (opcional, sin tocar la 𝒱 canónica)**

* Mantén **𝒱\_canónica** como **fuente de verdad**.

* Para ordenar o etiquetar de forma **única**, añade un **ε determinista** minúsculo derivado de un hash de la semilla (no altera decisiones):

\# ejemplo bash: epsilon en ±0.00005  
EPS="$(python3 \- \<\<'PY'  
import hashlib,sys  
seed=sys.argv\[1\].encode(); h=int(hashlib.sha1(seed).hexdigest()\[:4\],16)  
\# mapear a (-5..+5) → ±5e-5  
print((h%11-5)/1e5)  
PY "$OBJ|$A|$RUM|$K|$G|$FD|$FR")"  
V\_UID="$(awk \-v v="$V\_CANON" \-v e="$EPS" 'BEGIN{printf "%.5f", v+e}')"

* **Publica** `V_uid` sólo para **ordenamiento interno** (no para umbrales).

---

## **7\) Flujos de uso (paso a paso)**

### **7.1 Desde VF \+ materia (camino recomendado)**

1. Define VF: triada `p`, pesos `w`, objeto `O`, rumbo `r`, clase `k`, gates.

2. Calcula `A_auto` con materia:

node scripts/pe\_generate.mjs \\  
  \--vf docs/atlas/Tu\_VF.yaml \\  
  \--materia agua \\  
  \--emit json

3. Toma `A_auto` o deja que `pe_generate` invoque a `vcalc` y valide contra **τ=0.62**.

4. Si pasa y la ética es OK (ΔC≥0, No‑Mentira, Doble Testigo si aplica), cristaliza:

node scripts/pe\_generate.mjs \\  
  \--vf docs/atlas/Tu\_VF.yaml \--materia agua \\  
  \--emit json \--save true \\  
  \--listado-r docs/core/QEL\_ListadoR\_master\_v1.0.md \\  
  \--registry  docs/core/QEL\_SoT\_Manifest\_v0.8.json

### **7.2 Cálculo directo con `vcalc`**

scripts/qel\_vcalc.sh \\  
  \--obj "Llave" \--afinidad 0.7400 \--rumbo O \\  
  \--clase rara \--gates "mediacion,doble" \\  
  \--ruido 0 \--delta-c flat \--delta-s flat \--emit json

* Usa `V_canon` (4 decimales) para decidir; `V_oper` como táctica.

---

## **8\) Buenas prácticas**

* **Canon inmutable**: tus tablas χ\_r y H\_k viven en Lámina 𝒱/MFH; scripts sólo las reflejan.

* **Separación**: 𝒱\_canónica (decide) vs 𝒱\_operativa (contexto).

* **Bitácora**: registra **ΔC/ΔS**, **ρ**, **rumbo**, **gates**, **A** y **V\_canon**.

* **Reproducibilidad**: fija semillas (VF.cue/SeedI) en tus artefactos.

---

## **9\) Solución de problemas (FAQ)**

* **“En Oriente no sube 𝒱”** → parche de `chi_r()` no aplicado o llamas `--rumbo` incorrecto.

* **“Clase no reconocida”** → revisar acentos/alias; `singular/único` mapean a `rara` (1.00).

* **“Aurora penaliza”** → `AUR=1.00` en ambos scripts.

* **“Siguen empatando valores”** → sube a 5 decimales **o** activa `V_uid` (ε estable) sólo para ordenación.

---

## **10\) Anexo — Parches por here‑doc (opcional)**

Si prefieres automatizar, este script aplica los cambios mínimos. Revísalo antes de ejecutar.

cat \> scripts/patch\_alineacion\_v1.sh \<\<'SH'  
\#\!/usr/bin/env bash  
set \-euo pipefail  
sed \-i.bak \\  
  \-e 's/chi\_r().\*{.\*/chi\_r(){ case "$(upper "$1")" in\\  
  O|E) echo 1.10;;\\  
  N)   echo 1.05;;\\  
  C)   echo 1.00;;\\  
  W)   echo 0.95;;\\  
  S)   echo 0.90;;\\  
  \*)   echo "";;\\  
esac; }/g' \\  
  \-e 's/H\_k().\*{.\*/H\_k(){ case "$(lower "$1")" in\\  
  basica|básica)                                   echo 0.50;;\\  
  "poco comun"|"poco común"|poco-comun|poco-común) echo 0.80;;\\  
  rara|raro|singular|unico|único)                  echo 1.00;;\\  
  metalica|metálica)                               echo 1.20;;\\  
  obsidiana)                                       echo 1.60;;\\  
  \*)                                               echo "";;\\  
esac; }/g' \\  
  \-e 's/aurora\\|contacto\_aurora\\) AUR=.\*/aurora|contacto\_aurora) AUR=1.00;;/g' \\  
  scripts/qel\_vcalc.sh

\# Nota: la inyección de V\_CANON/V\_OPER requiere edición manual donde se imprime la salida.

perl \-0777 \-pe 's/const CHI\_R \= \[\\s\\S\]\*?;\\s\*const H\_K\\s\*=\\s\*{\[\\s\\S\]\*?};/const CHI\_R \= { O:1.10, E:1.10, N:1.05, C:1.00, W:0.95, S:0.90 };\\nconst H\_K   \= {\\n  '\\''basica'\\'':0.50, '\\''básica'\\'':0.50,\\n  '\\''poco-comun'\\'':0.80, '\\''poco-común'\\'':0.80, '\\''poco comun'\\'':0.80, '\\''poco común'\\'':0.80,\\n  '\\''rara'\\'':1.00, '\\''raro'\\'':1.00, '\\''singular'\\'':1.00, '\\''unico'\\'':1.00, '\\''único'\\'':1.00,\\n  '\\''metalica'\\'':1.20, '\\''metálica'\\'':1.20,\\n  '\\''obsidiana'\\'':1.60\\n};/s' \-i.bak scripts/pe\_generate.mjs

echo "\[OK\] Parches básicos aplicados. Revisa salidas y ajusta formatos a 4 decimales."  
SH  
chmod \+x scripts/patch\_alineacion\_v1.sh

---

## **11\) Metadatos**

* **cue**: `[QEL::ECO[96]::RECALL A96-250924-GUIA-ALINEACION-V]`

* **SeedI**: `A96-250924`

* **SoT**: `HERRAMIENTAS/ALINEACION-V/v1.0`

* **Version**: `v1.0`

* **Updated**: `2025-09-24`

HASH(10): ac195d7d92
SeedI=A37-251015
SoT=UNSET
Version=v1.0
Updated=2025-11-04

5448833b1d
