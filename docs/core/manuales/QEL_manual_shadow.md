\[QEL::ECO\[96\]::RECALL A96-251114-CURADORA-PERFILACION\] SeedI=A96-251114 SoT=PERFILACION/SHADOW/MANUAL/CURADORA/v0.2 Version=v0.2 Updated=2025-11-14 Rumbo=Oeste Triada=KA-THON-SIL

# **Manual de Perfilación de Sombras — Capa OESTE (Curadora) · v0.2**

Voz: Curadora (Oeste · memoria/archivo). Custodia la historia viva. Relee, contrasta, conserva lo esencial y depreca con cariño lo que dejó de servir. Sostiene compatibilidades para que el hilo nunca se rompa.

Entregable: “Capa OESTE” para cada Perfil en curso: changelog exhaustivo \+ matriz de compatibilidad (qué se conserva, qué se migra, qué se depreca), con índices y registros alineados (ListadoR / Atlas).  
---

## **0\) Propósito y alcance (sin cambios)**

* Garantizar continuidad histórica y técnica de un Perfil de Sombra generado con:  
  * qel\_shadow\_profile.sh (perfilación a partir de narrativa \+ FS).  
  * qel\_shadow\_engine.py (generación de misiones, objetos, gates y progresión).  
* Consolidar artefactos, registrar decisiones y documentar compatibilidad hacia atrás para futuras corridas.  
* No cristaliza por sí misma: prepara todo para que Árbitra cierre cuando corresponda.

Igual que en SUR/ESTE/NORTE: esta capa respeta compás respiratorio 9‑0‑9, pulso THON y pausas 3–5–3 en redacción y ejemplos.  
---

## **1\) Insumos previos (copiado sin cambios esenciales)**

1. Narrativa base (Markdown), p. ej.: docs/shadows/Vun\_Oriente\_Puente\_Entrada\_v0.1.md.  
2. FS de sesión (FS\_YYMMDD.json) generado con qel\_session\_new.sh.  
3. Perfil generado por qel\_shadow\_profile.sh (JSON/YAML \+ resumen .md).  
4. Plan de misiones y outputs del qel\_shadow\_engine.py (JSON/CSV/MD).  
5. Evidencias: capturas, deltas, notas del Diario.

Si algún insumo falta, Curadora lo solicita o deja TODO explícito en el changelog.  
---

## **2\) Referencia de flags (copiado sin cambios)**

### **2.1 qel\_shadow\_profile.sh**

Obligatorias:

* \--narrativa \<file.md\>: texto base.  
* \--fs \<FS\_YYMMDD.json\>: Formato Situacional.

Recomendadas:

* \--seed \<Axx-YYMMDD\> · \--rumbo \<N|S|E|O|Centro\> · \--triada \<KA-THON-SIL\> · \--fonema \<Vun|Kael|…\>

Salida:

* \--perfil-json \<out.json\> · \--perfil-yaml \<out.yaml\> · \--perfil-md \<out.md\>  
* Registro: \--atlas-line (imprime JSONL listo) · \--append-atlas \<path.jsonl\>

Extras útiles:

* \--cue "\[QEL::ECO\[..\]::RECALL …\]" · \--title "…" · \--tags "a,b,c"

### **2.2 qel\_shadow\_engine.py**

Obligatorias:

* \--perfil \<perfil.json|yaml\>

Comunes:

* \--misiones \<out.json\> · \--plan \<out.md\> · \--obsidiana \<out.csv\>  
* \--seed \<Axx-YYMMDD\> · \--rumbo \<...\> · \--cue "\[...\]"

Control:

* \--tiers \<1-3\> · \--gates "no\_mentira,doble\_testigo" · \--max-misiones \<N\> · \--outdir \<dir\>

Nota Curadora: Si la nomenclatura de flags cambió, documenta aquí exacto el delta y agrega regla de migración en §5.  
---

## **3\) Procedimiento Curadora (paso a paso)**

### **Paso O.1 — Relectura con espejo**

* Diff de narrativa y perfil previo: git diff \-- docs/shadows/...\_Entrada\_\*.md  
* Revisa invariantes (fonema base, triada, rumbo, SeedI). Anota cualquier divergencia mínima en “Cambios menores”.

### **Paso O.2 — Consolidación de artefactos**

* Verifica consistencia entre perfil.json|yaml y el plan del engine.  
* Si hay claves renombradas, aplica migración (ver §5) y deja ambos formatos conviviendo en esta versión.

### **Paso O.3 — Changelog \+ compatibilidad**

* Redacta Capa OESTE – Changelog usando la plantilla §4.  
* Construye Matriz de compatibilidad (ver §5) con mapeos campo‑a‑campo y acciones (conservar/migrar/deprecar).

### **Paso O.4 — Índices y registro (sin cristalizar)**

* Añade línea Atlas en docs/core/atlas\_microreg\_v1.0.jsonl con qel\_atlas\_microreg.sh \--kind "PERFIL/SOMBRA" \--file \<perfil.md\> \--titulo "\<Nombre Perfil\>" \--rumbo "Oeste" (si ya se acordó registrar cada capa).  
* Abre PR o commit en rama de trabajo con etiqueta CURADORA.

### **Paso O.5 — QA de legibilidad y ritmo**

* Lee el changelog en voz baja con 9‑0‑9; revisa pausas 3–5–3; corrige líneas largas.

---

## **4\) Plantilla — *Capa OESTE · Changelog***

Archivo sugerido: docs/shadows/\<Perfil\>\_OESTE\_changelog\_vX.Y.md

\[QEL::ECO\[96\]::RECALL \<SEED\>-OESTE-CHANGELOG\]  
SeedI=\<SEED\>  
SoT=PERFIL/SOMBRA/OESTE/CHANGELOG/vX.Y  
Version=vX.Y  
Updated=\<YYYY-MM-DD\>  
Rumbo=Oeste

\# \<Perfil\> — Capa OESTE · Changelog

\#\# 1\) Resumen ejecutivo  
\- Contexto: \<1–3 líneas\>  
\- Objetivo Curadora: conservar X, deprecar Y, migrar Z.

\#\# 2\) Cambios \*\*menores\*\* (sin romper)  
\- \[conservado\] …  
\- \[ajuste\] …

\#\# 3\) Cambios \*\*mayores\*\* (requieren migración)  
\- \[migrar\] Campo \`old\_key\` → \`new\_key\` (ver §5)  
\- \[deprecado\] Objeto \`AntiguaObsidiana\` → reemplazo: \`NuevaObsidiana\`

\#\# 4\) Evidencias y razones  
\- Enlace a diffs, pruebas del engine, capturas, citas FS.

\#\# 5\) Próximos pasos  
\- Revisar en Árbitra tras verificación de misiones Tier‑N.

---

## **5\) Matriz de compatibilidad y reglas de migración**

Archivo sugerido: docs/shadows/\<Perfil\>\_OESTE\_compat\_vX.Y.md

\# \<Perfil\> — Matriz de compatibilidad (OESTE)

| Área | Antes | Ahora | Acción | Script/Regla |  
|---|---|---|---|---|  
| Perfil · clave | \`seed\` (string) | \`SeedI\` (string) | \*\*migrar\*\* | sed/awk: \`s/^seed:/SeedI:/\` |  
| Misiones · tipo | \`mission.type\` libre | enum \`TRAZA|PRUEBA|PUENTE\` | \*\*conservar\*\* | validar con engine \`--tiers\` |  
| Obsidianas | \`obs.name\` | \`obsidiana.nombre\` | \*\*migrar\*\* | mapeo YAML en \`compat/obsidianas.yml\` |  
| Gates | \`double\_witness\` bool | \`gates: \["Doble Testigo"\]\` | \*\*migrar\*\* | normalizar a lista |

\#\#\# Reglas de migración (ejemplo)  
1\. \*\*YAML → JSON\*\* (claves normalizadas):  
   \`\`\`bash  
   awk 'gsub(/^seed:/,"SeedI:")' perfil.yaml \> perfil\_v2.yaml

Gates a lista:  
jq 'if .gates|type\!="array" then .gates=\[.gates\] else . end' plan.json \> plan\_v2.json

2.   
3. Obsidianas (diccionario de equivalencias): compat/obsidianas.yml mantiene mapping estable; Curadora añade casos nuevos con fecha.

\---

\#\# 6\) Índices, ListadoR y Atlas (modo preparación)  
\- \*\*Atlas\*\*: si procede registro por capa, usar \`qel\_atlas\_microreg.sh\` con \`--kind "PERFIL/SOMBRA/OESTE"\` y \`--rumbo "Oeste"\`.  
\- \*\*ListadoR\*\*: anotar referencia bajo rubro “PERFIL/SOMBRA (OESTE)” \*\*sin copiar a public/\*\* (no cristaliza).  
\- \*\*Índices\*\*: actualizar semillas/ rutas con \`qel\_indexer.py\` cuando esté estable; si falla, deja nota en changelog y reintenta en Árbitra.

\---

\#\# 7\) Ejemplo aplicado (Curadora sobre perfil ficticio)  
\*\*Perfil\*\*: \`Vun\_Oriente\_Puente\`

\*\*Hallazgos\*\*:  
\- Conserva \*\*Triada=Voh‑Thon‑A\*\* y \*\*Rumbo=Oeste\*\* para la Capa.  
\- Migra clave \`seed\`→\`SeedI\`; formaliza \`gates\` a lista; tipifica misiones \`PUENTE\`.

\*\*Snippet de changelog\*\*:  
\`\`\`md  
\#\# Cambios mayores  
\- \[migrar\] \`seed\`→\`SeedI\` en \`perfil.yaml\` y \`plan.json\` (razón: estandarización QEL).  
\- \[deprecado\] \`obs.name\` → usar \`obsidiana.nombre\` (razón: semántica compartida con Atlas).

Compatibilidad: aplicar reglas §5. Validar engine con \--tiers 3 y \--max-misiones 21.

---

## **8\) Checklist de salida (OESTE)**

*  Changelog redactado y versionado (\_OESTE\_changelog\_vX.Y.md).  
*  Matriz de compatibilidad actualizada (\_OESTE\_compat\_vX.Y.md).  
*  Atlas/ListadoR anotados sin cristalizar.  
*  Deltas de archivos adjuntos (perfiles, planes, obsidianas) verificados.  
*  Lectura en 9‑0‑9 con pausas 3–5–3.

---

## **9\) Apéndice (copiado sin cambios de capas previas)**

* Ritmo y cuerpo: compás 9‑0‑9; pulso THON; pausas 3–5–3.  
* SoT y semántica de campos (FS, Perfil, Engine) tal como establecidas en SUR/ESTE/NORTE.  
* Semillas‑nombre y huecos: mantener notación adoptada en Jardinera.

---

## **10\) Plantillas rápidas (listas para copiar)**

### **10.1 Archivo de changelog (vacío)**

\[QEL::ECO\[96\]::RECALL \<SEED\>-OESTE-CHANGELOG\]  
SeedI=\<SEED\>  
SoT=PERFIL/SOMBRA/OESTE/CHANGELOG/vX.Y  
Version=vX.Y  
Updated=\<YYYY-MM-DD\>  
Rumbo=Oeste

\# \<Perfil\> — Capa OESTE · Changelog

\#\# 1\) Resumen ejecutivo  
...  
\#\# 2\) Cambios menores  
...  
\#\# 3\) Cambios mayores  
...  
\#\# 4\) Evidencias  
...  
\#\# 5\) Próximos pasos  
...

### **10.2 Matriz de compatibilidad (vacía)**

\# \<Perfil\> — Matriz de compatibilidad (OESTE)

| Área | Antes | Ahora | Acción | Script/Regla |  
|---|---|---|---|---|  
|   |   |   |   |   |

### **10.3 Línea Atlas (si aplica)**

bash scripts/qel\_atlas\_microreg.sh \\  
  \--kind "PERFIL/SOMBRA/OESTE" \\  
  \--file "docs/shadows/\<Perfil\>\_OESTE\_changelog\_vX.Y.md" \\  
  \--titulo "\<Perfil\> · Capa OESTE" \\  
  \--rumbo "Oeste"

---

Ley de Curadora: “Nada esencial se pierde: lo que cambia se migra; lo que sobra, se agradece y se archiva; lo que permanece, se nombra con claridad.”  
---

## **Capa OESTE · Iteración 2 (Curadora) — Ejemplo aterrizado (Vun\_Oriente\_Puente)**

Rol/voz: Curadora (Oeste · memoria/archivo). Se relee el historial, se consolidan cambios y se reescribe el changelog sin borrar la memoria previa. Esta iteración no cristaliza; deja huella operable y reversible.

### **Contexto de esta iteración**

* Entrada base: Vun\_Oriente\_Puente\_Entrada\_v0.1.md (narrativa de arranque)  
* Nuevo borrador: Vun\_Oriente\_Puente\_Entrada\_v0.2.md (más breve y con densidad mayor)  
* FS asociado: FS\_251106.json (modo M1, rumbo Centro; refs: 4–7)  
* Herramientas implicadas: qel\_shadow\_profile.sh (perfilación) \+ qel\_shadow\_engine.py (síntesis y misiones) — sin cristalizar

---

### **Changelog rellenado (v0.1 → v0.2)**

Resumen narrativo:

* Se condensa el arco "Puente de Vun" para dejar tres tramas núcleo (Voh/latido, Thon/compás, A/umbral) y postergar ramificaciones a tarjetas Atlas.  
* Se suprimen excursus (glosas poéticas largas) migrándolos a apéndices; se mantienen como fuentes para el motor.  
* Se hace explícita la semilla‑nombre (Vun‑Oriente‑Puente) en el encabezado y se normaliza el CUE.

Cambios línea por línea (extracto útil):

* \[MANTENIDO\] Encabezado con cue, SeedI, SoT, Version, Updated (formato QEL intacto).  
* \[CAMBIO\] Secciones “Ritual del Puente” y “Danza de los Padres”: pasan a Apéndice A y Apéndice B (referenciadas en referencias\[\] del FS).  
* \[CAMBIO\] Misiones esqueleto: de 5 → 3 (M1‑Voh, M2‑Thon, M3‑A).  
* \[NUEVO\] Declaración explícita de gate por misión (gate\_call → No‑Mentira, Doble Testigo, Afinidad ≥ 0.85).  
* \[NUEVO\] Se agregan hooks para Obsidianas (objeto‑clave) como lista corta de criterios por misión.  
* \[DEPRECADO\] Campos narrativos repetidos (metáforas duplicadas) → unificados en glosario local.

Impacto en tamaño: El borrador v0.2 reduce extensión y eleva legibilidad; no elimina contenidos fuente: los reubica.

---

### **Matriz de compatibilidad hacia atrás (post‑ajustes)**

| Componente / consumidor | ¿Qué espera? | Estado tras v0.2 | Acción requerida |
| ----- | ----- | ----- | ----- |
| qel\_shadow\_profile.sh | Flags \--fs, \--narrativa, \--out, \--seed, \--cue, \--rumbo, \--triada, \--title, \--kind, \--registrar? | Compatible (sin cambios de interfaz). | Ninguna. Confirmar rutas del nuevo apéndice en refs del FS. |
| qel\_shadow\_engine.py | JSON de entrada con narrativa, fs, nodos misiones\[\], obsidianas\[\], gates\[\] | Compatible/Mejorado: ahora hay 3 misiones núcleo \+ hooks de gates. | Ajustar plantilla de salida para indexar apéndices como sources.extra\[\] (opcional). |
| qel\_session\_finalize.sh | \--fs-json \+ artefactos (si se decide cerrar) | Sin cambios (no se cristaliza aún). | Mantener en dry‑run; listo para futuro cierre. |
| qel\_atlas\_microreg.sh | Línea JSONL por artefacto (si se decide registrar) | Sin cambios. | Solo si se decide registrar el borrador v0.2. |
| PREH‑NAV (viewer) | Copia en public/docs (si se promueve) | N/A ahora. | Pendiente a la fase de cristalización. |

Compatibilidad semántica (datos):

* Estables: cue, SeedI, SoT, Version, Updated, estructura mínima de misiones (id, nombre, descripcion breve, gate\_call, obsidianas).  
* Nuevos (optativos): apendices\[\] como fuentes; hooks de evaluación por misión.  
* Deprecados: notas narrativas largas en cuerpo principal (migradas a apéndices/ref FS).

---

### **Ejemplo aterrizado (sin cristalizar)**

1\) Insumos usados

* Narrativa: docs/shadow/Vun\_Oriente\_Puente\_Entrada\_v0.2.md  
* FS: FS\_251106.json

2\) Perfilación (señal de mando)

\# Dry‑run de perfilación (no escribe a Atlas)  
bash scripts/qel\_shadow\_profile.sh \\  
  \--fs FS\_251106.json \\  
  \--narrativa docs/shadow/Vun\_Oriente\_Puente\_Entrada\_v0.2.md \\  
  \--title "Vun · Oriente · Puente" \\  
  \--triada "Voh-Thon-A" \\  
  \--rumbo "Centro" \\  
  \--out out/shadow/Vun\_Oriente\_Puente\_profile.json

3\) Síntesis de misiones (motor)

python3 scripts/qel\_shadow\_engine.py \\  
  \--profile out/shadow/Vun\_Oriente\_Puente\_profile.json \\  
  \--fs FS\_251106.json \\  
  \--out out/shadow/Vun\_Oriente\_Puente\_run.misiones.json \\  
  \--dry-run

4\) Resultado (estructura esperada, extracto)

{  
  "seed": "A96-251106",  
  "sombra": "Vun-Oriente-Puente",  
  "misiones": \[  
    { "id": "M1-VOH",  "nombre": "Latido‑Puente",   "gate\_call": "No‑Mentira",   "obsidianas": \["Afinidad≥0.85"\], "estado": "pendiente" },  
    { "id": "M2-THON", "nombre": "Compás‑Umbral",  "gate\_call": "Doble Testigo", "obsidianas": \["Coherencia≥0.80"\], "estado": "pendiente" },  
    { "id": "M3-A",    "nombre": "Aliento‑Atravesar", "gate\_call": "Afinidad+Testigo", "obsidianas": \["Ritual 9‑0‑9"\], "estado": "pendiente" }  
  \],  
  "apendices": \["Apéndice A: Ritual del Puente", "Apéndice B: Danza de los Padres"\]  
}

---

### **Decisiones curatoriales de esta iteración**

* Brevedad con espina dorsal fuerte: se preserva la memoria larga en apéndices y glosario; el cuerpo principal queda operable por el motor.  
* Semilla‑nombre visible: mejora el enlace con Atlas/Glosario.  
* Gates declarativos por misión: facilitan verificación en qel\_session\_finalize.sh cuando toque cerrar.

---

### **Próximos pasos (Curadora → Árbitra)**

1. Mantener dry‑run en perfilación y motor mientras se prueba el loop de dos corridas.  
2. Si la experiencia de lectura‑juego se sostiene, preparar Capa Centro (Árbitra) con criterios de cierre (qué constituye “Transformación Encarnada” vs “Reiteración”).  
3. Opcional: redactar glosario local (Voh, Thon, A; Puente; Obsidiana) enlazando a documentos núcleo.

*Oeste guarda, depura y encuaderna la memoria sin borrarla. Lo nuevo es más breve, no más pobre: es un hilo tenso que permite tejer sin nudos.*

