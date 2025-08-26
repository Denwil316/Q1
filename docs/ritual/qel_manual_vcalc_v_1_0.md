# [QEL::ECO[96]::A96-250824-VCALC-MANUAL]
SeedI=A96-250820
SoT=MANUAL/v1.0
Version=v1.0
Updated=2025-08-24

---

# Manual de **Vcalc** (lectura humana y operación práctica)

> Propósito: explicar de forma exhaustiva cómo usar `scripts/qel_vcalc.sh` para calcular **𝒱** (viabilidad) y leer su salida en sesiones M0–M3. Este manual está pensado para humanos (no para máquinas), con ejemplos, tablas SoT vigentes y referencias cruzadas a MFH, Lámina 𝒱, Atlas y Diario.

---

## 0) Qué es Vcalc y cuándo usarlo
**Vcalc** es un calculador de **𝒱**: una métrica de compatibilidad entre **p** (triada fonémica), **O** (objeto interaccional), **r** (rumbo) y **k** (clase). En su forma operativa (v0.2), Vcalc toma parámetros simples y devuelve:

- **Salida “pretty”**: despiece legible + 𝒱 clippeado a \[0..1].
- **Salida “quiet”**: solo el valor 𝒱 en dos decimales.
- **Salida “json”**: objeto JSON con factores y 𝒱.

Úsalo a partir de **M1**. En **M0** basta con **ΔC/ΔS + No‑Mentira** y registro en el Diario.

---

## 1) Línea de comandos — modos de ejecución

### 1.1 Modo core (pretty por defecto)
```bash
scripts/qel_vcalc.sh \
  --obj "Fonema/Objeto" \
  --afinidad 0.60..0.95 \
  --rumbo N|O|W|S|C \
  --clase comun|raro|singular|unico \
  --gates "mediacion[,doble][,aurora]" \
  --ruido 0..0.15 \
  --delta-c up|flat|down \
  --delta-s up|flat|down \
  [--emit pretty|quiet|json]
```

### 1.2 Modo interactivo (`io`)
```bash
scripts/qel_vcalc.sh io
```
Guía al usuario con hints, normaliza comas decimales y puede devolver JSON vía una pregunta final.

### 1.3 Modo objeto (`json`)
```bash
# stdin
echo '{
  "obj":"Nai/Llave",
  "afinidad":0.72,
  "rumbo":"W",
  "clase":"unico",
  "gates":["mediacion","aurora"],
  "ruido":0.12,
  "delta":{"c":"up","s":"up"}
}' | scripts/qel_vcalc.sh json

# o desde archivo
scripts/qel_vcalc.sh json --in caso.json
```

---

## 2) Anatomía de la salida (ejemplo real)
Ejemplo de consola (tu último cálculo):
```
Objeto: Nai/Llave
A (afinidad): 0.72
χ_r (rumbo W): 0.90
H_k (clase unico): 1.00
Π_gates: 0.855000   (from: mediacion,aurora)
ΔC/ΔS factor: 1.0400   | Ruido factor: 0.8800
-----------------------------------------------
𝒱 (clip 0..1): 0.51
Sugerencia --obj: "Nai/Llave=0.51"
```
### Cómo leerlo
- **Objeto**: etiqueta compacta *Fonema/Objeto*. Aquí: `Nai/Llave`.
- **A (afinidad)**: intensidad p↔O. Usa rúbrica MFH (indirecto ≈0.60, directo ≈0.80, canónico ≈0.95; ajustar ±0.05 por contexto). Aquí: **0.72**.
- **χ_r**: factor por **rumbo**. SoT operativo: N/C=1.00 · O=0.95 · W=0.90 · S=0.88. Aquí: **W→0.90**.
- **H_k**: factor por **clase** del objeto: común 0.85 · raro 0.92 · singular 1.00 · único 1.00. Aquí: **único→1.00**.
- **Π_gates**: producto de gates. Por defecto penalizaciones: mediación 0.80, doble 0.90, aurora 1.00. Si declaras el gate, sube a su valor operativo: mediación 1.00; doble 1.00; **aurora (contacto)** 0.95 (cautela). Aquí: **mediación** presente →1.00; **doble ausente** →0.90; **aurora** presente →0.95; producto **0.855**.
- **ΔC/ΔS factor**: tendencias cognitivas y somáticas (up +0.02 · down −0.02, acumulables). Aquí: up+up → **1.04**.
- **Ruido factor**: clip del ruido ρ ≤0.15; se usa **(1−ρ)**. Aquí: ρ=0.12 → **0.88**.
- **𝒱**: `clip(A·χ_r·H_k·Π_gates·FΔ·(1−ρ))`. El resultado numérico fue **0.507… → 0.51** (dos decimales).
- **Sugerencia --obj**: atajo para registrar el pairing con 𝒱.

---

## 3) Fórmula y tablas (SoT operativo)
### 3.1 Fórmula canónica (operativa v0.2)
```
𝒱 = clip₀¹( A · χ_r · H_k · Π_gates · FΔ · (1−ρ) )
```
Donde:
- **A** = afinidad p↔O (MFH / rúbrica de 0.60–0.95).
- **χ_r** = factor por rumbo (ver tabla).*  
- **H_k** = factor por clase (ver tabla).*  
- **Π_gates** = producto de gates declarados (penaliza si faltan; ver tabla).*  
- **FΔ** = factor por **ΔC/ΔS** (up/down → ±0.02).  
- **ρ** = ruido (clip: ≤0.15) → se usa **(1−ρ)**.

> *Nota sobre SoT:* los factores aquí son la **línea operativa** para A96; difieren de las tarjetas *baseline* (Atlas) que muestran, a modo de consulta, una línea más amplia para estudio. Usa **esta** tabla cuando operes con `qel_vcalc.sh`.

### 3.2 Tablas operativas (v0.2)
**χ_r (rumbo)**: N=1.00 · O/E=0.95 · W=0.90 · S=0.88 · C=1.00.

**H_k (clase)**: común 0.85 · raro 0.92 · singular 1.00 · único 1.00 (clip ≤1).

**Gates (producto)**  
- Valores por defecto (si **no** declaras el gate): mediación **0.80**, doble **0.90**, aurora **1.00**.  
- Al **declarar** el gate: mediación **1.00**, doble **1.00**, **aurora 0.95** (contacto cauteloso).  
- Π_gates = mediación × doble × aurora.

**ΔC/ΔS → FΔ**  
- `up` = +0.02; `down` = −0.02; `flat` = 0.  
- `FΔ = 1 + dC + dS`.

**Ruido ρ**  
- Se recorta a **≤0.15**.  
- `Factor ruido = (1 − ρ)`.

**Umbral de avance (criterio)**  
- Mínimo recomendado para **Cristaliza**: **𝒱≥0.62** + **ΔC≥0** + **No‑Mentira**.

---

## 4) Afinidades: cómo estimar **A** (MFH)
1) **Mapa MFH** (objetos afines por fonema).  
2) **Rúbrica**: *indirecto* ≈0.60, *directo* ≈0.80, *canónico* ≈0.95.  
3) **Ajuste fino** ±0.05 por FS (contexto, triángulo de coherencia, test de sombra).  
4) **Documenta** tu A estimada en el Diario; si escalas a M2/M3, conviértelo en hipótesis replicable.

*Ejemplo rápido*: para **Nai** y **Llave** (objeto de puente/liberación), un **A=0.72** es razonable en M1 cuando hay historia previa de Nai→Llave/Velo en tu campo.

---

## 5) JSON de entrada/salida
### 5.1 Esquema mínimo de entrada
```json
{
  "obj": "Nai/Llave",
  "afinidad": 0.72,
  "rumbo": "W",
  "clase": "unico",
  "gates": ["mediacion","aurora"],
  "ruido": 0.12,
  "delta": {"c": "up", "s": "up"}
}
```

### 5.2 Salida JSON típica
```json
{
  "obj":"Nai/Llave",
  "A":0.720,
  "chi_r":0.90,
  "H_k":1.00,
  "gates_p":0.86,
  "fdelta":1.04,
  "fruido":0.88,
  "V":0.51
}
```

> Nota: `gates_p` se muestra con 2 decimales en JSON por brevedad; internamente se calcula a 6.

---

## 6) Buenas prácticas (con Diario y Protocolo)
- Calcula **𝒱** sólo en **M1+**; en M0 **no** es requerido.
- Mantén **ΔC/ΔS** visibles; si uno baja y otro sube, **anota** hipótesis.
- Declara **Doble Testigo** si hay Aurora o si pretendes promover a Árbol/VF.
- **Cierra siempre** con **SIL→UM→Ə** y registra **V_final** si corresponde.
- Si **ρ>0.15** sostenido o ΔC/ΔS bajan, desplázate a **Sur**, reduce carga, revisa Custodio.

---

## 7) Resolución de errores (típicos)
- **No imprime nada / cuelga** → verifica permisos `chmod +x`, ruta `scripts/`, y que no haya pipes esperando entrada.
- **`printf: invalid number`** → solucionado en v0.2 (cálculo por `awk`, forzando `LC_NUMERIC=C`).
- **`Flag desconocida`** → revisa `--emit`, `--delta-*` y orden de flags.
- **JSON vacío** en modo `json` → confirma que pasas `--json` o `--in`, o que alimentas `stdin`.

---

## 8) Lecturas cruzadas (para intuición y rigor)
- **Lámina 𝒱** (consulta rápida y ejemplos).  
- **MFH** (afinidades y objetos por fonema).  
- **Atlas — Tarjetas** (sugerencias Nai→Llave/Velo, guía por rumbos).  
- **Diario del Conjurador** (FS, Doble Testigo, criterios de promoción).  
- **Tratado Metahumano** (Proyección→Vibración→Eco; cierres seguros; incidentes A/B/C).

---

## 9) Apéndice A — Interpretación del ejemplo `Nai/Llave`
1) **A=0.72** (historia previa Nai→Llave y/o Nai→Velo): razonable.
2) **χ_r(W)=0.90** (Occidente: memoria/eco). Si buscas didáctica, considera **Oriente**.
3) **H_k=1.00** (único clippeado a 1.00 en esta línea operativa).
4) **Gates**: mediación presente (1.00), doble ausente (0.90), aurora contacto (0.95) → **0.855**.
5) **Δ**: up+up → **FΔ=1.04**.
6) **Ruido**: 0.12 → **(1−ρ)=0.88**.
7) **𝒱**: producto = **0.507… → 0.51**. Interpretación: **Germina/M1** salvo apoyo adicional (p. ej., activar “doble” o subir A). Para **Cristaliza**, apunta a **≥0.62**.

---

## 10) Apéndice B — Tabla de referencia rápida (operativa)
- **χ_r**: N|C 1.00 · O 0.95 · W 0.90 · S 0.88
- **H_k**: común 0.85 · raro 0.92 · singular 1.00 · único 1.00
- **Gates**: mediación 0.80→1.00 · doble 0.90→1.00 · aurora 1.00→0.95 (contacto)
- **ΔC/ΔS**: up +0.02 · down −0.02
- **ρ**: clip ≤0.15 → factor (1−ρ)
- **Criterio**: 𝒱≥0.62 + ΔC≥0 + No‑Mentira

---

## 11) Notas de diseño (v0.2)
- Se eliminó dependencia de `bc` para evitar problemas de locale; todo cálculo numérico via `awk`.
- Normalización de decimales coma→punto en entradas (`--io` y `--json`).
- Mantenimiento de **tres modos** (`pretty|quiet|json`) para integrar con scripts de terceros.

---

## 12) Changelog
- **v1.0 (2025-08-24)** — Manual unificado; incorpora ejemplo Nai/Llave, tablas SoT operativas, guía JSON/IO, y apéndices.

---

> **Cierre**: SIL→UM→Ə  ·  **Doble Testigo** cuando corresponda  ·  𝒱 se interpreta **con** FS, no en vacío.

