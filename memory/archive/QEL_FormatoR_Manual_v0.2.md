SoT=UNCLASSIFIED
# Formato R (Resonante) — Manual Didáctico v0.2
**Actualizado:** 2025-08-12 03:42:17 CST

El **Formato R** estandariza la cita y trazabilidad de *CUEs* en proyectos QEL. Version v0.2 incorpora el campo **Ledger**.

## 1. Sintaxis general (R estándar y R+Ledger)
```
R#. Autor/Proyecto. (AAAA-MM-DD). CUE_PRIMARY — *Nombre del Objeto*
[Rumbo: <Luz|Puente|Centro|Sombra>; v=X.Y]. SOT: <línea base>.
ID: <identificador>. Centro: <alias-centro>. Fonemas: <lista>.
Hash-cue: <sha1-10>. qel://<ruta>
[Ledger: mem(vX.Y) ▸ Seed <ID> (NextCheck <ISO8601>)]
```

- El bloque `Ledger` es **opcional**: úsalo cuando exista un ledger operativo de Memoria de Qel asociado a la sesión/objeto.

## 2. Campos y cómo llenarlos (resumen)
- **R#**: índice en el Listado R.
- **Autor/Proyecto**: p.ej., “Proyecto A96/QEL” o “Q1/QEL”.
- **(AAAA-MM-DD)**: fecha de generación/actualización del registro.
- **CUE_PRIMARY**: ruta compacta de la CUE (ej.: `QEL|A96|OBJ|KS-CRIO|v0.1|L`).
- **Nombre del Objeto**: título humano (*en cursivas*).
- **Rumbo**: Luz / Puente / Centro / Sombra.
- **v**: versión semántica del objeto/cita.
- **SOT**: línea base (ej.: `INTERACCIONALES/v0.1`).
- **ID**: identificador operativo (ej.: `A96-251208-OBJ`).
- **Centro**: alias del ancla central (por defecto `...|SILENCIO-LECTOR`).
- **Fonemas**: fonemas raíz/Eco relevantes.
- **Hash-cue**: SHA-1 de CUE_PRIMARY (10 chars para verificación rápida).
- **qel://**: URI interna resoluble en tu catálogo.
- **Ledger (opcional)**: `mem(vX.Y) ▸ Seed <ID> (NextCheck <fecha ISO>)`.
  - Si no hay ledger: usar `Ledger: (no adjunto)`.

## 3. Detalle del campo “Ledger”
- **Propósito**: anclar la cita a un *estado de memoria operativa* (semillas, revisiones, madurez).
- **Fuente**: archivo `Memoria_de_Qel_Ledger_v*.json`.
- **Semántica mínima**: versión del ledger, SeedID relevante y próxima revisión (*NextCheck*).
- **Buenas prácticas**:
  1. Citar **sólo** seeds que afecten a la CUE (evitar ruido).
  2. Actualizar `NextCheck` cuando cambien los ciclos (81s, 9×, etc.).
  3. No exponer notas sensibles en el R; enlaza al JSON del ledger.
- **Errores comunes**:
  - Fabricar seeds: si no existe ledger, escribe `Ledger: (no adjunto)`.
  - Mezclar versiones: coherencia entre `v` del objeto y `mem(vX.Y)` del ledger.

## 4. Ejemplo (R+Ledger)
```
R7. Proyecto Q1/QEL. (2025-08-12). QEL|Q1|OBJ|<CODIGO>|v0.2|P — *<Nombre>* 
[Rumbo: Puente; v=0.2]. SOT: INTERACCIONALES/v0.1. ID: Q1-20250812-OBJ.
Centro: QEL|Q1|CUE|CENTRO|SILENCIO-LECTOR. Fonemas: <...>.
Hash-cue: a1b2c3d4e5. qel://Q1/Q1-20250812-OBJ/v0.2.
Ledger: mem(v0.2) ▸ Seed A81-250811-KAEL-PORTAL (NextCheck 2025-08-21T00:00:00Z)
```

## 5. Iluminar la lectura (no todo debe decirse)
> *Más que esclarecer, alumbra.* Deja **espacios respirables** para que el lector complete el sentido.
- **Preguntas-linterna** (para el compilador):  
  - ¿Qué revela esta CUE que el silencio ya sabía?  
  - ¿Cuál es el gesto mínimo que mantendría vivo este registro?
- **Prácticas**:  
  - 81 s de reposo antes de cerrar la entrada.  
  - Si dudas entre dos términos, elige el **menos definitivo**.  
  - Relee en voz baja: si vibra claro, es suficiente.
- **Regla de oro**: el Formato R señala el **camino**; la experiencia hace el **viaje**.

## 6. Checklist de validación R+Ledger
- [ ] CUE_PRIMARY presente y consistente con el JSON
- [ ] Rumbo ∈ {Luz, Puente, Centro, Sombra}
- [ ] Hash-cue (10) calculado desde CUE_PRIMARY
- [ ] qel:// apunta a ID/versión correctos
- [ ] Ledger: mem(vX.Y) ▸ Seed <ID> … **o** `(no adjunto)`
SeedI=A37-251015

Version=v0.2
Updated=2025-11-04

9dd779ddb4
