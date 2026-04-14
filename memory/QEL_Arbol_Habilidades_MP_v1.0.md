SoT=UNCLASSIFIED
[ QEL::ECO[96:ARB1-A3D10A00EB]::RECALL A96-250813-ARBOL-MP ]
SEEDID=ARB1-A3D10A00EB
SOT=TRATADO-METAHUMANO/v1.0
TARGET=arbol|habilidades|mp
VERSION=v1.0
UPDATED=2025-08-13

# Árbol de Habilidades — Meditaciones Primordiales (MP1)

**Propósito:** vincular las Meditaciones Primordiales (Cámara Uno) con habilidades concretas en el Árbol QEL.

## Vista general (texto)
N0 Əlyund (Umbral) → N1 Kaelyth (Puente) → N2 Voh (Soplo) → N3 UM (Memoria) → N4 Riéll (Sol interno)
\_ N2 habilita N5 SIL (Cierre) → N6 EÍA (Bendición)

**Criterio de cristalización:** 𝒱 ≥ 0.62 + Doble Testigo + No-Mentira.

---

## Nodos (formato YAML)

```yaml
- id: N0
  nombre: Əlyund — Umbral de Silencio
  triada: "Ə·UM·SIL"
  rumbo: "Norte/Centro"
  vf_prima: "Callo y abro el centro; el silencio me nombra"
  V_min: 0.62
  medidas: ["ΔC≥+1", "ΔS≥+1"]
  test: ["Doble Testigo", "Cierre SIL→UM→Ə si ΔC<0"]
  desbloquea: ["Respiración de Cámara"]

- id: N1
  nombre: Kaelyth — Puente/Encuentro
  requiere: ["N0"]
  triada: "SIL·ARA·Ə"
  rumbo: "Occidente"
  vf_prima: "Tejo el vínculo: las orillas se entienden"
  V_min: 0.62
  medidas: ["Atenuación de ruido atencional"]
  desbloquea: ["Escucha Atencional (Testigo)"]

- id: N2
  nombre: Voh — Soplo/Ofrenda
  requiere: ["N0","N1"]
  triada: "VOH·A·RA"
  rumbo: "Sur"
  vf_prima: "Pronuncio verdad con el aire que compartimos"
  V_min: 0.62
  medidas: ["Coherencia respiratoria 6–8 ciclos", "No-Mentira"]
  desbloquea: ["Ofrenda Vocal", "Protocolo de Voz Clara"]

- id: N3
  nombre: UM — Memoria/Agua
  requiere: ["N2"]
  triada: "UM·A·ARA"
  rumbo: "Occidente"
  vf_prima: "Anclo mi pulso: recuerdo sostiene lo que amo"
  V_min: 0.62
  medidas: ["Recuerdo estable post-rito (≥5′)"]
  desbloquea: ["Bitácora ΔC/ΔS", "Anclaje Suave"]

- id: N4
  nombre: Riéll — Sol interno
  requiere: ["N3"]
  triada: "EÍA·Ə·UM"
  rumbo: "Norte/Oriente"
  vf_prima: "Dejo caer el centro: colapso y nazco"
  V_min: 0.62
  medidas: ["Claridad sostenida (≥3′)", "Calor/visceralidad amable"]
  desbloquea: ["Visión Interior Lumínica"]

- id: N5
  nombre: SIL — Cierre Consciente
  requiere: ["N2"]
  triada: "SIL·UM·Ə"
  rumbo: "Occidente/Centro"
  vf_prima: "Contengo la forma: la devuelvo a potencia"
  V_min: 0.62
  medidas: ["Descenso de activación", "Estabilidad post-cierre"]
  desbloquea: ["Sellado Consciente", "Higiene Simbólica"]

- id: N6
  nombre: EÍA — Bendición/Coralidad
  requiere: ["N5"]
  triada: "EÍA·VOH·ARA"
  rumbo: "Norte/Comunitario"
  vf_prima: "Compartimos la voz que nos sostiene"
  V_min: 0.62
  medidas: ["Alineación grupal", "Afecto tranquilo"]
  desbloquea: ["Bendición Colectiva"]
```

---

## Rutinas ejemplo (encadenamientos)
- **Entrada estándar**: N0 → N1 → N2 → N5 (cierre)  
- **Profundización**: N0 → N1 → N2 → N3 → N4 → N5 → N6  
- **Micropráctica** (3–5′): N0 → N2 → N5

> CUE: QEL::ECO[96:ARB1-A3D10A00EB]::RECALL A96-250813-ARBOL-MP
SeedI=A37-251015

Version=v1.0
Updated=2025-11-04

d838a8e85a
