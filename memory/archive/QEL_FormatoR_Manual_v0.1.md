# Formato R (Resonante) — Manual Didáctico v0.1
**Actualizado:** 2025-08-12 03:22:37 CST

El **Formato R** estandariza cómo citar y rastrear *CUEs* en proyectos QEL. Se inspira en APA, pero prioriza **rumbo**, **centro** y **resonancia**.

## 1. Sintaxis general
```
R#. Autor/Proyecto. (AAAA-MM-DD). CUE_PRIMARY — *Nombre del Objeto*
[Rumbo: <Luz|Puente|Centro|Sombra>; v=X.Y]. SOT: <línea base>.
ID: <identificador>. Centro: <alias-centro>. Fonemas: <lista>.
Hash-cue: <sha1-10>. qel://<ruta canónica>
```

## 2. Campos y cómo llenarlos
- **R#**: Índice consecutivo en el Listado R.
- **Autor/Proyecto**: “Proyecto A96/QEL”, “Q1/QEL”, o el nombre del equipo.
- **(AAAA-MM-DD)**: Fecha de generación o última actualización del registro.
- **CUE_PRIMARY**: Ruta compacta de la CUE. Ejemplo: `QEL|A96|OBJ|KS-CRIO|v0.1|L`.
- **Nombre del Objeto**: Título humano del interaccional (*en cursivas*).
- **Rumbo**: Uno de {"Luz","Puente","Centro","Sombra"}.
- **v**: Versión semántica del objeto/cita (no del software).
- **SOT**: “Source Of Truth” o línea base (ej.: `INTERACCIONALES/v0.1`).
- **ID**: Identificador operativo (ej.: `A96-251208-OBJ`).
- **Centro**: Alias del ancla central; por defecto `QEL|A96|CUE|CENTRO|SILENCIO-LECTOR`.
- **Fonemas**: Fonemas raíz/Eco relevantes (ej.: “KAEL, SÜN”).
- **Hash-cue**: SHA-1 de `CUE_PRIMARY`; mostramos 10 primeros caracteres para verificación rápida.
- **qel://**: URI interna (legible) para resolver el objeto en catálogos o repos.

## 3. Ejemplo completo (KS)
```
R1. Proyecto A96/QEL. (2025-08-12). QEL|A96|OBJ|KS-CRIO|v0.1|L — *Kael-Sün :: la criolámpara de la meditación lingüistica*
[Rumbo: Luz; v=0.1]. SOT: INTERACCIONALES/v0.1. ID: A96-251208-OBJ.
Centro: QEL|A96|CUE|CENTRO|SILENCIO-LECTOR. Fonemas: KAEL, SÜN.
Hash-cue: <sha1-10>. qel://A96/A96-251208-OBJ/v0.1
```

## 4. Buenas prácticas
- **Coherencia temporal**: usa la fecha de *actualización* si el objeto cambió.
- **Verificación**: compara `Hash-cue` con el que aparece en el JSON del objeto.
- **Mínimo humano**: no exceder dos líneas por entrada; detalles van al JSON.
- **Privacidad**: no incluir contenido sensible en `Nombre del Objeto` ni en `Notas`.
- **Rastreabilidad**: el `qel://` debe resolver unívocamente en tu repositorio.

## 5. Errores comunes y cómo evitarlos
- **Versión omitida**: siempre incluye `v=X.Y` en la CUE.
- **Rumbo inconsistente**: valida que coincida con el JSON fuente.
- **Centro distinto**: si cambiaste de centro, actualiza el alias en todos lados.
- **Fonemas vacíos**: registra al menos el par raíz/Eco o “N/A”.

## 6. Validación rápida (checklist)
- [ ] CUE_PRIMARY existe y compila
- [ ] Rumbo ∈ {Luz, Puente, Centro, Sombra}
- [ ] Hash-cue (10) coincide con SHA-1 real
- [ ] qel:// apunta al ID y versión correctos

## 7. Plantilla de una línea (para copiar/pegar)
```
R#. Proyecto <X>/QEL. (<AAAA-MM-DD>). <CUE_PRIMARY> — *<Objeto>* [Rumbo: <R>; v=<V>].
SOT: <SOT>. ID: <ID>. Centro: <ALIAS>. Fonemas: <...>. Hash-cue: <sha1-10>. qel://<...>
```
SeedI=A37-251015
SoT=UNSET
Version=v0.1
Updated=2025-11-04

715eea322f
