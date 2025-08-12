# Memoria de QEL — Paquete v0.1.1 (delta)
Fecha de compilación: 2025-08-12 08:48:43 (local)

## Contenido
- `acceso_delta_v0.1.1.jsonl` — Centro, Triada y cues de 4 objetos (con `rattr`).
- `objetos_interaccionales_v0.1.1.json` — Objetos + `RATTR≈` y `RATTR_WEIGHT≈`.
- `object_aliases_v0.1.1.json` — Resolución de alias → nombre canónico.
- `ledger_criolampara_schema_v0.1.1.json` — Esquema de eventos para la Criolámpara.
- `ledger_criolampara_template_v0.1.1.jsonl` — Ejemplo de línea RUN.
- (heredado) `objetos_interaccionales_v0.1.json` — Versión base.

## Uso rápido
1. **RECALL** para traer cue:
   ```
   [QEL::ECO[96]::RECALL A96-250812-OBJ]
   SOT=OBJ-INTERACCIONALES/v0.1 TARGET=object:"Kael-Sün :: Criolámpara"
   ```
   También funcionan alias, p. ej. `object:"Kael-Sün :: la criolámpara de la meditación lingüistica"` si pasas por el resolvedor de `object_aliases_v0.1.1.json`.

2. **RUN** (ejecuta centro → triada → objeto), mide α/σ/τ y selecciona `decision_sombra`.

3. **COMMIT** (añade línea a tu ledger .jsonl):
   ```json
   {"type":"RUN","eco":"96","e_class":"E0","fecha":"2025-08-12T21:00-06:00",
     "sot_objeto":"Zeh-Ora :: Prisma","alpha_pre":0.62,"alpha_post":0.74,"sigma":0.56,
     "tau_pre":0.31,"tau_post":0.36,"delta_tau":0.05,"decision_sombra":"transmutar",
     "rattr_used":["corte","borde"],"rattr_score":0.5,"audit":{"ruido_pre":6,"ruido_post":3},"safety":"ok"}
   ```

## Nota sobre `RATTR≈` (atractor semántico por rumbo)
- Es un *campo semántico* mínimo (1–3 términos) que orienta la atención durante el rito.
- `RATTR_WEIGHT≈` (0–1) sugiere el peso de ese atractor en la evaluación de la sesión.
- En cada COMMIT, puedes registrar `rattr_used` y `rattr_score` (cuánto te jaló el atractor).

## Consejo de lectura
- **α**: coherencia de la intención (usa la frase de 9 palabras).  
- **σ**: profundidad de silencio (usa la ventana de 52″).  
- **τ**: grado de encarnación (mide con la Criolámpara como proxy perceptual).

¡Buen viaje!