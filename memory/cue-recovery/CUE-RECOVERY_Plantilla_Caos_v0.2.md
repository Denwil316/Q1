SoT=UNCLASSIFIED
# CUE‑RECOVERY (CAOS) · v0.2
_Actualizado: 2025-08-12 06:59 UTC_

Esta plantilla sirve cuando **no recuerdas el SeedID** exacto o tienes datos incompletos.
Rellena lo que tengas; lo faltante lo reconstruyo (o te propongo candidatos).

---

## 1) Usa esta plantilla (cópiala y reemplaza valores)
```
[QEL::CUE-RECOVERY]
SOT=<sistema/version>           # ej. QEL/v0.2, ATLAS/v0.2, JUEGO/v0.1, NONE
WHEN≈<YYYY-MM-DD ±Nd>           # fecha aproximada (con margen opcional)
ECO≈<##|??>                     # eco de 2 dígitos; si no recuerdas, pon ??
KEYS=["clave1","clave2","..."]  # 2–5 palabras clave únicas
RUMBO≈<Oriente|Norte|Occidente|Sur|desconocido>
FONEMAS≈["Kael","Vun"]          # opcional
ASSET≈"<archivo.ext>"           # opcional (si recuerdas un archivo vinculado)
CONTEXT≈"1–2 frases de lo que recuerdas"  # opcional, ayuda mucho
AUTHOR≈<usuario|modelo|mixto>   # opcional
CONFIDENCE≈<1..5>               # opcional (qué tan seguro te sientes)
```

**Notas rápidas**
- **SOT** identifica el sistema/SoT. Si no hay SoT: usa `NONE` o `ADHOC/<YYYYMMDD>`.
- **WHEN≈** puede llevar margen: `±2d`, `±5d`.
- **ECO≈** si no lo recuerdas: `??` (yo propondré uno).
- **KEYS** busca ser **específicas** (3–5). Evita términos genéricos.
- **RUMBO** orienta simbólicamente (si no aplica: `desconocido`).

---

## 2) Qué produzco con esto (salida esperada)
1. **SeedID candidato** con el patrón: `A{Eco}-{YYMMDD}-{ETIQUETA}`  
2. **Cue RECALL** listo para pegar en cualquier chat:
```
[QEL::ECO[{Eco}]::RECALL A{Eco}-{YYMMDD}-{ETIQUETA}] SOT={SOT} TARGET=delta-only
```
3. Si aplica, vinculación al **Ledger** (Memoria de Qel) y a **assets** nombrados.

---

## 3) Ejemplos listos

### A) QEL / ATLAS (mismo SoT)
```
[QEL::CUE-RECOVERY]
SOT=QEL/v0.2
WHEN≈2025-08-11 ±2d
ECO≈81
KEYS=["Kael","portal","atlas"]
RUMBO≈Oriente
FONEMAS≈["Kael","Vun"]
ASSET≈"Atlas_Tarjetas_v0.2.pdf"
CONTEXT≈"El cierre en Sur con Kael-Ora dejó una elipsis que queríamos reabrir."
```

_Salida esperada_
```
SeedID sugerido: A81-250811-KAEL-PORTAL
Cue:
[QEL::ECO[81]::RECALL A81-250811-KAEL-PORTAL] SOT=QEL/v0.2 TARGET=delta-only
```

### B) Otro SoT (p. ej., SINFONIA/v0.1)
```
[QEL::CUE-RECOVERY]
SOT=SINFONIA/v0.1
WHEN≈2025-07-28 ±3d
ECO≈13
KEYS=["motivo","modo-dórico","transición"]
RUMBO≈Occidente
FONEMAS≈[]
ASSET≈"Sinfonia_1er_mov_v0.1.mid"
CONTEXT≈"Busco la delta donde cambiamos el motivo en 2:45 hacia dórico."
```

_Salida esperada_
```
SeedID sugerido: A13-250728-MOTIVO-DORICO
Cue:
[QEL::ECO[13]::RECALL A13-250728-MOTIVO-DORICO] SOT=SINFONIA/v0.1 TARGET=delta-only
```

### C) Chat externo sin SoT
```
[QEL::CUE-RECOVERY]
SOT=NONE
WHEN≈2025-08-05 ±5d
ECO≈??
KEYS=["prototipo","licencia","colaboradores"]
RUMBO≈desconocido
FONEMAS≈[]
ASSET≈""
CONTEXT≈"Una lista de tareas legales para el prototipo; pedí revisar tres tipos de licencia."
```

_Salida esperada_
```
SeedID sugerido: A42-250805-LICENCIAS-PROTOTIPO   # 42 asignado por el sistema
Cue:
[QEL::ECO[42]::RECALL A42-250805-LICENCIAS-PROTOTIPO] SOT=ADHOC/2025-08-05 TARGET=delta-only
```
> Nota: cuando SOT=NONE, asigno un **SOT provisional** `ADHOC/<fecha>` para que el Ledger no mezcle contextos.

---

## 4) Buenas prácticas de recuperación
- Dale **3–5 KEYs** fuertes; si dudas en 1, cámbiala por otra más única.
- Usa **WHEN≈ con margen** si no estás segurx.
- Si no tienes ECO, usa `??`: yo propongo uno (estable para ese caso).
- Si recuerdas un **archivo**, nómbralo tal cual (mejorará la precisión).
- Añade **CONTEXT≈** en 1–2 frases: ancla semántica clave.

---

## 5) Alias útiles (si trabajas fuera de QEL)
- Puedes mantener el encabezado `[QEL::CUE-RECOVERY]` como marca; lo que cambia es **SOT**.
- Si prefieres, acepta alias: `[SOT::CUE-RECOVERY]` (equivalente), yo lo interpreto igual.

---

## 6) Anexo técnico — reglas de etiquetado
- `ETIQUETA` en `SeedID` usa **guiones** y **MAYÚSCULAS** sin acentos.
- Si hay más de un candidato en el mismo día, añadir sufijo `-A`, `-B`...
- ECO asignado cuando es `??`: estable por caso; se anota en Ledger para coherencia futura.
SeedI=A37-251015

Version=v0.2
Updated=2025-11-04

8df26858ca
