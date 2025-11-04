
# QEL · Matriz Fonémica de Habilidades (MFH) · v1.2
> Compilación: 2025-08-13 16:44:51 CST

## Cambios v1.2
- Agregada **Matriz 𝒱 base** con valores operativos de afinidad fonema↔objeto.
- Tabla de **χ_r** (rumbos) y **H_k** (clases) unificadas.
- Sección de **Gates** ampliada con ejemplos de seguridad/ética.
- Dos **ejemplos completos** de cálculo (Luz/Verdad y Silencio/Apertura).

---

## 1) Firma elemental (resumen)
RA (luz/corte); VOH (voz/expresión); EÍA (eclipse/visión); Ə (vacío elástico);
UM (sostén/llave); A (apertura/portal); SIL (velo/tejido); THON (ritmo/latido).

---

## 2) Matriz 𝒱 base (afinidad fonema↔objeto)
Rúbrica: canónico 0.95 · directo 0.80 · indirecto 0.60 (±0.05 según caso)

| Fonema | Objeto canónico | Afinidad | Otros objetos típicos | Afinidad |
|---|---|---:|---|---:|
| RA | Prisma | 0.95 | Velo | 0.70 |
| VOH | Templo/Trompa | 0.95 | Prisma | 0.65 |
| EÍA | Núcleo/Eclipse | 0.95 | Espejo obsidiana | 0.70 |
| Ə | Espejo/Silencio | 0.95 | Velo | 0.65 |
| UM | Llave/Sello | 0.95 | Anclaje | 0.60 |
| A | Portal/Campana | 0.95 | Llave | 0.75 |
| SIL | Velo/Hilos | 0.95 | Prisma | 0.60 |
| THON | Metrónomo/Latido | 0.95 | Templo | 0.70 |

> Nota: La matriz es **orientativa**; usa la rúbrica y el contexto del FS para ajustar ±0.05.

---

## 3) Modulación por rumbo (χ_r · baseline v1.2)
- Oriente ×1.10 (Luz/Voz)
- Norte ×1.05 (Ética/No-Mentira)
- Centro ×1.00 (SIL→UM→Ə)
- Occidente ×0.95 (Memoria/Eco)
- Sur ×0.90 (Cuerpo/Ritmo)

---

## 4) Clases (H_k)
básica 0.5 · poco común 0.8 · **rara 1.0** · metálica 1.2 · obsidiana 1.6

---

## 5) Gates (seguridad/ética)
- Protección luminosa: ×1.00 con mediación (prisma/velo), ×0.80 sin.
- Doble Testigo ausente: ×0.90 (no “promocionar”).
- No-Mentira comprometida: **bloquea** el cálculo/avance.
- Fatiga somática alta: ×0.90 (recomendar Sur/Centro antes de insistir).

---

## 6) Procedimiento de cálculo (resumen operativo)
1) Triada p con pesos w (suma 1.00).  
2) Elige objeto O (usa canónico si es posible).  
3) Calcula A = Σ w_i·afinidad(p_i,O).  
4) Aplica χ_r y H_k; multiplica gates.  
5) 𝒱 = clip_0^1(A·χ_r·H_k·Π_gates).  
6) Reporta **V_final** al cierre (M1+).

---

## 7) Ejemplos completos

### 7.1 VF-1 — “La Luz de la Verdad deja Ciego a quien quiera verla de cara.”
Triada: RA·VOH·EÍA (w=0.45/0.30/0.25)  
Objeto: Prisma  
Afinidades: 0.95 / 0.65 / 0.85 → **A=0.835**  
χ_r: O 1.10; N 1.05; C 1.00; W 0.95; S 0.90  
H_k: rara 1.00; Gates: mediación ×1.00  
𝒱: O 0.92; N 0.88; C 0.84; W 0.79; S 0.75

### 7.2 VF-2 — “El silencio abre la puerta que la prisa siempre pasa de largo.”
Triada: Ə·UM·A (w=0.40/0.35/0.25)  
Objeto: Llave-sello  
Afinidades: 0.55 / 0.95 / 0.75 → **A=0.740**  
χ_r: O 1.10; N 1.05; **C 1.00**; W 0.95; S 0.90  
H_k: rara 1.00; Gates: ×1.00  
𝒱: C 0.74; N 0.78; O 0.81; W 0.70; S 0.67
SeedI=A37-251015
SoT=UNSET
Version=v1.2
Updated=2025-11-04

4ea279b7c6
