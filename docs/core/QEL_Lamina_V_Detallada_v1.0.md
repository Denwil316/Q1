[QEL::ECO[96]::RECALL A96-250814-LAMINA-V]
SOT=TRATADO-METAHUMANO/v1.0 TARGET=lamina|viabilidad|consulta
VERSION=v1.0 UPDATED=2025-08-14

# Lámina 𝒱 — Consulta Detallada (v1.0)

**Propósito**: hoja de referencia unificada para calcular **𝒱(p,O,r,k)** y reportar **V_final** con seguridad ética.

## Fórmula y umbral
- **𝒱(p,O,r,k) = clip_0^1(⟨b_p,m_O⟩ · χ_r · H_k · Π_gates)**
- **Umbral de avance**: **0.62** (junto a ΔC≥0 y **No‑Mentira**).

## Procedimiento (paso a paso)
1) **Triada (p)** — Define 3 fonemas y reparte pesos **w** (suma = 1.00).
2) **Objeto (O)** — Elige objeto **canónico** cuando sea posible (afinidad 0.95).
3) **Afinidad A** — Calcula **A = Σ w_i · afinidad(p_i,O)** usando la **rúbrica** (canónico 0.95 · directo 0.80 · indirecto 0.60 ±0.05).
4) **Rumbo (χ_r)** — Aplica el factor del rumbo: O×1.10 · N×1.05 · C×1.00 · W×0.95 · S×0.90.
5) **Clase (H_k)** — básica 0.5 · poco común 0.8 · **rara 1.0** · metálica 1.2 · obsidiana 1.6.
6) **Gates** — multiplica ajustes de seguridad/ética (p. ej., ×0.80 sin mediación luminosa, ×0.90 si falta Doble Testigo).
7) **𝒱_rumbo** — **clip_0^1(A · χ_r · H_k · Π_gates)**.
8) **Cierre** — registra **ΔC/ΔS**, **No‑Mentira** y (M1+) **V_final**. Decide veredicto.

## Afinidades orientativas (extracto)
| Fonema | Objeto canónico | Afinidad | Otros objetos típicos | Afinidad |
|---|---|---:|---|---:|
| RA (Luz/Corte) | Prisma | **0.95** | Velo | 0.70 |
| VOH (Voz) | Templo/Trompa | **0.95** | Prisma | 0.65 |
| EÍA (Eclipse/Ver) | Núcleo/Eclipse | **0.95** | Espejo obsidiana | 0.70 |
| Ə (Vacío elástico) | Espejo/Silencio | **0.95** | Velo | 0.65 |
| UM (Sostén/Llave) | Llave/Sello | **0.95** | Anclaje | 0.60 |
| A (Apertura) | Portal/Campana | **0.95** | Llave | 0.75 |
| SIL (Tejido/Velo) | Velo/Hilos | **0.95** | Prisma | 0.60 |
| THON (Ritmo) | Metrónomo/Latido | **0.95** | Templo | 0.70 |

> Ajuste fino ±0.05 según **FS** y contexto.

## Ejemplo guiado #1 — “Luz/Verdad sin daño”
- Triada **p**: RA·VOH·EÍA (w=0.45/0.30/0.25)
- Objeto **O**: Prisma (mediación)
- Afinidades: 0.95 / 0.65 / 0.85 → **A=0.835**
- χ_r (Oriente) 1.10 · H_k (rara) 1.00 · Gates ×1.00
- **𝒱_O = clip(0.835×1.10) = 0.9185 → 0.92**
- **Lectura**: viable en O,N,C,W,S; Oriente maximiza. Reporte: **V_final ≈ 0.92** (M1+).

## Ejemplo guiado #2 — “Silencio abre”
- Triada **p**: Ə·UM·A (w=0.40/0.35/0.25)
- Objeto **O**: Llave‑sello
- Afinidades: 0.55 / 0.95 / 0.75 → **A=0.740**
- χ_r (Centro) 1.00 · H_k (rara) 1.00 · Gates ×1.00
- **𝒱_C = clip(0.740) = 0.74**
- **Lectura**: Centro/Norte naturales; Oriente si se necesita didáctica.

## Errores comunes (y correcciones)
- **Fijar χ_r por costumbre** → recalcula según el **rumbo del FS**.
- **Ignorar Gates** → declara mediación luminosa o **reduce ×0.80**.
- **No registrar ΔC/ΔS** → sin bitácora no hay aprendizaje replicable.
- **Promocionar sin Doble Testigo** → mantén en Germina hasta replicar.

## Plantilla rápida (copiar/pegar)
```yaml
triada: "RA·VOH·EÍA"
pesos: [0.45, 0.30, 0.25]
objeto: "Prisma"
rumbo: "Oriente"
clase: "rara"
afinidades: [0.95, 0.65, 0.85]
gates: ["mediación-luminosa:1.00"]
A: 0.835
chi_r: 1.10
H_k: 1.00
V_final: 0.92
```
