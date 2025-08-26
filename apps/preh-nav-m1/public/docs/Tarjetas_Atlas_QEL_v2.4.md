[QEL::ECO[96]::RECALL A96-250826-ATLAS-TARJETAS-V2-4]
cue=[QEL::ECO[96]::RECALL A96-250826-ATLAS-TARJETAS-V2-4]
SeedI=A96-250824
SoT=ATLAS-TARJETAS/v2.4
Version=v2.4
Updated=2025-08-26

# Tarjetas Atlas QEL — v2.4 (Interfaz de práctica)

> Propósito: usar cada tarjeta como interfaz de práctica que condensa preguntas vivientes, modulaciones por rumbo y la Ficha 𝒱 de cierre. Se apoya en MFH/Glosario/Diario/Lámina. Estado: **Cristalizado**.

---

## 1) Manual operativo (resumen)

**A. Preparación (2–3′)**  
1) Abrir **Diario (FS)** y fijar intención/rumbo.  
2) Revisar la *tarjeta* elegida (glypha, tono, preguntas, marcadores).

**B. Ejecución (10–15′)**  
1) Seguir **preguntas cardinales** según rumbo del FS.  
2) Observar *marcadores somáticos*; ajustar intensidad/rumbo si hay riesgo (consultar casuística).

**C. Medición y cierre (5–10′)**  
- En **M0**, registra **ΔC/ΔS** y **No-Mentira** (sin 𝒱).  
- En **M1+**, completa la **Ficha 𝒱** (triada, objeto, afinidades, χ_r, H_k, gates), calcula **𝒱** y consigna **V_final**.  
- Buenas prácticas: sesiones 15–30′; cierre **SIL→UM→Ə**; *promocionar* sólo si **Cristaliza**.

---

## 2) Ficha 𝒱 — Plantilla genérica (copiar/pegar)

```yaml
# Ficha 𝒱 por Tarjeta (Atlas v2.4)
tarjeta: "<Kael|Vun|Ora|Zeh|Lun|Nai|Sün|Ida>"
rumbo: "<N|S|E|W|Centro>"
glypha: "<descripción breve>"
tono: "<fonema/curva>"
preguntas: ["<1>", "<2>", "<3>"]
marcadores: ["<somático 1>", "<somático 2>", "<somático 3>"]
riesgos: ["<señal 1>", "<señal 2>"]
objeto: "<Prisma|Llave|Velo|Lente|Crisol|Sello|...>"
triada: "<p·p·p>"                  # p.ej., "RA·SIL·A"
pesos: [0.40,0.30,0.30]            # suma=1.0
afinidades: [0.95, 0.80, 0.60]     # MFH (±0.05)
chi_r: 1.00                        # rumbo
H_k: 1.00                          # clase
gates: ["mediación-luminosa:1.00"] # seguridad
A: 0.000                           # agregación triada×afinidades
V_final: null                      # si M1+
delta_c: ""
delta_s: ""
no_mentira: true
cierre: "SIL→UM→Ə"
```

---

## 3) Perfiles operativos por fonema (usar con la plantilla)

- **KAEL (Sur · Fuego contenido)** — *Glypha*: fuego vertical contenido · *Tono*: “RA”.  
  **Preguntas**: ¿Qué debo quemar sin destruir raíz? ¿Dónde falta coraje cuidadoso?  
  **Marcadores**: calor esternal; visión enfocada; pulso firme.  
  **Riesgos**: hiper-ímpetu/juicio (mediar con SÜN).  
  **Objeto**: Prisma/Crisol. · **Ajustes**: χ_r=1.05; H_k=1.00.

- **VUN (Norte · Agua-memoria)** — *Glypha*: onda concéntrica · *Tono*: “VOH”.  
  **Preguntas**: ¿Qué hidratar o drenar? ¿Qué recuerdo pide vuelco?  
  **Marcadores**: frescor en palmas; respiración amplia; ojos húmedos.  
  **Riesgos**: disolución/escape (compensar con NAI o ZEH).  
  **Objeto**: Semilla/Ánfora. · **Ajustes**: χ_r=1.05; H_k=1.00.

- **ORA (Oriente · Prisma-luz)** — *Glypha*: triángulo radiante · *Tono*: “A”.  
  **Preguntas**: ¿Qué faceta pide luz? ¿Qué sesgo oscurece mi lectura?  
  **Marcadores**: claridad frontal; respiración alta; impulso a ordenar.  
  **Riesgos**: deslumbramiento/rigidez (equilibrar con VUN o SÜN).  
  **Objeto**: Prisma/Lente. · **Ajustes**: χ_r=1.10; H_k=1.00.

- **ZEH (Occidente · Corte/criterio)** — *Glypha*: filo curvo · *Tono*: “ZÈ”.  
  **Preguntas**: ¿Qué cortar sin violencia? ¿Dónde falta un “no” nítido?  
  **Marcadores**: tono mandibular; postura erguida; alivio en plexo.  
  **Riesgos**: severidad (suavizar con VUN; reencuadre con ORA).  
  **Objeto**: Cuchilla/Sello de corte. · **Ajustes**: χ_r=1.05; H_k=1.05.

- **LUN (Poniente-Interior · Espejo/agua-luna)** — *Glypha*: círculo hueco · *Tono*: “LU”.  
  **Preguntas**: ¿Qué refleja el entorno de mí? ¿Qué necesita serenarse?  
  **Marcadores**: relajación ocular; temperatura baja; escucha amplia.  
  **Riesgos**: estancamiento (activar con KAEL u ORA).  
  **Objeto**: Espejo/Velo. · **Ajustes**: χ_r=1.00; H_k=1.00.

- **NAI (Sur-Interior · Llave/intención)** — *Glypha*: rombo transitable · *Tono*: “NA”.  
  **Preguntas**: ¿Cuál es la puerta de hoy? ¿Qué intención es suficiente?  
  **Marcadores**: presión en paladar; cosquilleo en manos; foco umbilical.  
  **Riesgos**: precipitación (acompasar con SÜN).  
  **Objeto**: Llave/Sello. · **Ajustes**: χ_r=1.00; H_k=1.00.

- **SÜN (Centro · Silencio/mediación)** — *Glypha*: díada concéntrica · *Tono*: “SIL”.  
  **Preguntas**: ¿Dónde callo por miedo y dónde por escucha?  
  **Marcadores**: alivio mandibular; peso diafragmático; pulso lento.  
  **Riesgos**: colapso si se abusa (reactivar con KAEL suave).  
  **Objeto**: Cáliz/Velo fino. · **Ajustes**: χ_r=1.00; H_k=1.00.

- **IDA (Noreste · Raíz/ritmo)** — *Glypha*: columna ondulada · *Tono*: “Ì”.  
  **Preguntas**: ¿Qué raíz sostiene mi paso? ¿Qué pulso estabilizar?  
  **Marcadores**: peso en plantas; pulso constante; espalda larga.  
  **Riesgos**: rigidez (flexibilizar con VUN o LUN).  
  **Objeto**: Semilla/Marcapulso. · **Ajustes**: χ_r=1.05; H_k=1.00.

---

## 4) Tablas rápidas (χ_r, H_k, Gates)

```yaml
# χ_r — ajuste por rumbo
Norte: 1.05
Sur: 1.05
Oriente: 1.10
Occidente: 1.05
Centro: 1.00
Noreste: 1.05
Noroeste: 1.00
Sureste: 1.00
Suroeste: 1.00
```

```yaml
# H_k — ajuste por clase
basica: 1.00
poco-comun: 1.00
rara: 1.00
metalica: 1.05
obsidiana: 1.10
```

```yaml
# Gates — seguridad
G1: 1.00   # mediación presente (9-0-9)
G2: 0.95   # mediación parcial
G3: 0.90   # falta anclaje corporal
G4: 0.80   # riesgo evidente → bajar intensidad/cambiar rumbo
```

---

## 5) Ejemplos de cierre

- **ORA (Oriente)** — Triada A·RA·SIL (0.40/0.40/0.20) · Objeto Prisma · Afinidades 0.90/0.85/0.70 → A=0.85 → χ_r=1.10 · H_k=1.00 → 𝒱≈0.935 → ΔC↑ ΔS↓ No-Mentira✓ → *Viable (M1+)*.  
- **IDA (Noreste)** — Triada Ì·VOH·SIL (0.45/0.35/0.20) · Objeto Marcapulso · Afinidades 0.80/0.75/0.85 → A=0.79 → χ_r=1.05 · gates×0.95 → 𝒱≈0.787 → *Reposa* + SÜN 5′.

---

## 6) Buenas prácticas (v2.4)

- Sesiones 15–30′; una tarjeta por sesión.  
- Cierre **SIL→UM→Ə**, Doble Testigo si se decide promoción.  
- Documentar en Diario; *promocionar* solo con evidencia reproducible.
