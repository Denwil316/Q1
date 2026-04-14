[QEL::ECO[96]::RECALL A96-250828-LLPE-v1-3]
SeedI=A96-250824
SoT=LL-PE/V1.3
Version=v1.3
Updated=2025-08-28

# LL-PE v1.3 — Manual Operativo (Germinación, con Materia)

cue: `[QEL::ECO[96]::RECALL A96-250828-LLPE-v1-3]`  
 SeedI: `A96-250824`  
 SoT: `LL-PE/v1.3`  
 Version: `v1.3`  
 Updated: `2025-08-28`

## **1\) Contexto y alcance**

La **Lógica Lingüística del Poema-Enigma (LL-PE)** genera, a partir de un **VF** (Verso Fundador) y su ficha 𝒱 (Lámina V), un **Poema-Enigma (PE)** determinista que la **Sombra** debe resolver. La respuesta se valida con **gates** y métricas (**ΔC, ΔS, ρ, χ\_r, H\_k**) y, si **𝒱 ≥ τ** (con **No-Mentira** y **Doble Testigo**), **cristaliza** una **Habilidad** en el **Árbol de Habilidades**.  
 **Novedad v1.3:** se **incluye la relación con la Materia**: cada fonema opera sobre familias de materia (realidad física/semiótica). Esta relación informa la **estimación automática de A (afinidad)** y el diseño del PE.

## **2\) Requisitos y entorno**

* **Invariantes Idriell (Tratado):** No-Mentira, Doble Testigo, registro VOH/EÍA, cierre **SIL→UM→Ə**.

* **Lámina 𝒱:** fórmula 𝒱 y umbral operativo **τ=0.62** (M1).

* **MFH v1.4:** rúbrica de afinidades (canónica/directa/indirecta) y mapeos objeto↔fonemas.

* **EXCEPTION & AURORA:** sólo si aplica (obsidiana líquida, PIG/TPC).

## **3\) Relación Fonema ↔ Materia (Tratado)**

Esta tabla resume **familias de materia** que cada fonema puede manejar con mayor naturalidad. Úsala para **elegir objeto O**, **afinar la tríada p** y **estimar A** (±0.05 sobre la rúbrica MFH).  
 *(Germinación: puedes ampliar o ajustar pesos por caso de uso.)*

| Fonema | Materia “alta” (canónica \~0.95) | Materia “media” (directa \~0.80) | Materia “baja” (indirecta \~0.60) | Lectura operativa |
| ----- | ----- | ----- | ----- | ----- |
| **Ə** (vacío) | vacío/éter/espacio sutil | borde plasma-vacío | sólidos densos | Apertura de potencial, disolución de residuo |
| **UM** (sostén) | tierra/estructura/soporte | orgánico estable | plasma turbulento | Contener sin poseer; “lecho” para otros actos |
| **A** (apertura) | aire/gas/umbral | agua/flujo leve | mineral rígido | Abrir sin romper; membranas y válvulas |
| **RA** (corte) | fuego/luz/plasma | metal (corte fino) | agua profunda | Separar/limpiar; bisturí, filo de luz |
| **KA** (forja) | metal/cristal/mineral | tierra mineral | vacío puro | Forjar/templar; solidificar patrón |
| **THON** (ritmo) | líquidos/agua/sangre | orgánico rítmico | cristal rígido | Oscilar, bombear, regular pulsos |
| **SIL** (tejido) | orgánico/tejido/polímero | red/cristal de red | vacío pleno | Conectar, trenzar, cerrar en red |

**Cómo la usamos en 𝒱:**

1. Para cada **posición de la tríada** (onset, núcleo, coda) tomamos la materia objetivo del caso (p. ej., `materia=orgánico`).

2. Ajustamos la **afinidad parcial** de ese fonema: **canónica** si coincide con “alta”, **directa** si cae en “media”, **indirecta** si cae en “baja” (±0.05 según FS).

3. Calculamos **A \= Σ wᵢ·aᵢ**.

Esto sigue la rúbrica MFH y el ejemplo de Lámina 𝒱: la materia **no añade un factor nuevo** a 𝒱 —solo ayuda a seleccionar **aᵢ** con sentido físico-operativo.

## **4\) Gramática PE (superficie)**

PE \= **INVOCACIÓN → UMBRAL → PISTA → SILENCIO → PRUEBA**

* **INVOCACIÓN:** declara p y rumbo.

* **UMBRAL:** nombra el objeto/acto.

* **PISTA:** deriva literalmente de **VF.PRIMA** (≤13 palabras).

* **SILENCIO:** pauta de cierre somático (SIL→UM→Ə).

* **PRUEBA:** condición mínima (ΔC≥0, 𝒱≥τ, gates).

## **5\) Mini-DSL (núcleo)**

* **Condición:** `SI cond ENTONCES actos [SINO actos]`

* **Átomos:** `V≥τ | ΔC≥0 | ΔS≥0 | gate(x) | preset==Puente|Apertura|… | materia==agua|metal|…`

* **Acciones:** `set_triada(..) · set_pesos(..) · set_objeto(..) · emitir_PE(..) · validar_respuesta(..) · spawn_vcalc(..) · mint_habilidad(..) · registrar(..)`

## **6\) Flujo (paso a paso)**

1. **Proyección** (FS): intención ≤9 palabras; Doble Testigo; Sello 0\.

2. **Selector de preset** (Puente/Apertura/otro) y **materia objetivo**.

3. **Ajuste de p,w,O** según MFH \+ Materia; **estimación A** (auto).

4. **emitir\_PE** (determinista por seed de VF+p+w+O+r+materia).

5. **Validación** de la respuesta (mask/calc).

6. **spawn\_vcalc** (𝒱 con χ\_r, H\_k, gates, Δ, ρ).

7. Si **𝒱≥τ** → **mint\_habilidad**; registrar en Árbol/Atlas/Diario; cierre **SIL→UM→Ə**.

8. Si no, **meditar 52s** y reintentar en **Centro**.

## **7\) Reglas base (ejemplo Kosmos-8)**

**Selector de preset \+ Materia**

`SI intencion==Puente & rumbo==Centro & no_mentira`  
`ENTONCES set_triada(Ə·UM·SIL); set_pesos([.35,.30,.35]); set_objeto(Velo|Llave); materia:=organico; preset:=Puente`

`SI intencion==Apertura & no_mentira`  
`ENTONCES set_triada(Ə·UM·A); set_pesos([.40,.35,.25]); set_objeto(Llave); materia:=aire; preset:=Apertura`

**Gate-keeper (Idriell) y cristalización**

`SI doble_testigo & mediacion_luminosa & ΔC>=0`  
`ENTONCES emitir_PE(tipo_por_seed, slots_por_VF_materia);`  
        `validar_respuesta($INPUT, por_tipo);`  
        `SI OK`  
          `spawn_vcalc({obj:O, A:auto|manual, rumbo:r, clase:k, gates:"mediacion,doble", ruido:ρ, delta:{c:ΔC,s:ΔS}});`  
          `SI V>=τ`  
            `mint_habilidad({vf:VF, preset, pe:PE.id, V, r, O, materia});`  
            `registrar(diario,"Habilidad cristalizada:" + HAB.id);`  
          `SINO registrar(diario,"Reposa: V<τ, reintentar en Centro 52s");`  
        `SINO registrar(diario,"PE fallido: reiniciar respiración + VOH")`

## **8\) Ejemplos completos**

### **A) Preset Puente (materia=orgánico)**

* p=`Ə·UM·SIL`, w=`[.35,.30,.35]`, O=`Velo|Llave`, r=`C`, k=`raro`.

* Afinidades por materia (orgánico):

  * Ə→ orgánico \= **indirecta (0.60)**; UM→ orgánico \= **directa (0.80)**; SIL→ orgánico \= **canónica (0.95)**.

* **A≈ 0.35·0.60 \+ 0.30·0.80 \+ 0.35·0.95 \= 0.79** (ejemplo).

* Con χ\_r=1.00, H\_k=0.92, gates=1.00, Δ=1.00, ρ=0.00 → **𝒱≈0.73** → **cristaliza**.

* **Habilidad:** *Tejido de Umbral (Nexo I)* — efecto: “cierre en SIL; ΔS:+; residuo:0”.

### **B) Preset Apertura (materia=aire)**

* p=`Ə·UM·A`, w=`[.40,.35,.25]`, O=`Llave`, r=`C`, k=`raro`.

* Afinidades por materia (aire):

  * Ə→ aire \= **directa (0.80)**; UM→ aire \= **indirecta (0.60)**; A→ aire \= **canónica (0.95)**.

* **A≈ 0.40·0.80 \+ 0.35·0.60 \+ 0.25·0.95 \= 0.77** (muy cercano a 0.74 de Lámina).

* Con χ\_r/H\_k/gates/Δ/ρ análogos → **𝒱≈0.71** → **cristaliza**.

* **Habilidad:** *Llave de Matrices (Apertura I)* — efecto: “abrir sello 1; ΔC:+; ρ≤0.02”.

La **materia** te ayuda a elegir **aᵢ** con coherencia física; el cálculo 𝒱 **no cambia** de fórmula.

## **9\) Integración con herramientas**

* **vcalc**: siempre calcula 𝒱 (el usuario puede corroborar a mano).

* **qel\_pe\_generate.mjs**: fabrica PE determinista, valida respuesta y “mint” de Habilidad; ahora acepta **materia** para estimar **A**.

* **Árbol \+ Atlas**: registrar HASH(10), ruta y Ficha 𝒱.

* **EXCEPTION/AURORA**: aplicar sólo cuando aplique (modos y límites ya asentados).

## **10\) Buenas prácticas**

* Mantén **VF.PRIMA ≤13** palabras; la **PISTA** del PE sale de ahí.

* Si **materia** no está clara, usa **Centro** y **orgánico** (SIL) para estabilizar.

* Siempre registra **ΔC, ΔS, ρ** y **Doble Testigo** antes de promover.

## **11\) Solución de problemas**

* **A no cuadra con tu intuición:** revisa la **materia** declarada; quizá elegiste una “baja” para la coda.

* **𝒱 alta pero falla cierre:** falta gate (**Doble Testigo**) o **No-Mentira**.

* **Aurora presente:** puedes **postergar contacto** (no negar); si hay contacto, gates×0.95 y cierre suave.


7faf6ee9fb
