[QEL::ECO[96]::RECALL A96-250812-FORMATO-VF] 
SOT=TRATADO-METAHUMANO/v0.1 TARGET=verso-fundador|árbol-habilidades|formato
VERSION=v0.1 UPDATED=2025-08-12

# Formato VF — “Verso Fundador” y Árbol de Habilidades
**Definición**: El *Verso Fundador* es una **frase operativa** cuyo despliegue fonémico (onset–núcleo–coda) activa o encausa la cristalización de una habilidad.

## 1. Especificación
- **VF.PRIMA**: frase exacta (≤ 13 palabras).  
- **VF.CUE** (R): línea R compacta para citas:  
  `R#. Proyecto A96/QEL. (<AAAA-MM-DD>). QEL|A96|VF|<FONEMA>|v<X.Y>|<Rumbo> — *<Título>*`
- **VF.HASH**: SHA‑1 de VF.PRIMA (10).  
- **VF.TRIADA**: descomposición fonémica (p/ onset–núcleo–coda).  
- **VF.MFH**: enlace a entrada en Matriz Fonémica.  
- **VF.RUMBO**: Norte/Oriente/Occidente/Sur (+ Luz/Puente/Centro/Sombra).  
- **VF.OBJ**: objeto/artefacto dominante.  
- **VF.CLASE**: {"básica","poco-común","rara","metálica","obsidiana"}.  
- **VF.RIESGO**: leve/medio/alto + contrafonema.  
- **VF.GATES**: condiciones (doble testigo, ética, entorno).

## 2. Ejemplo
```
VF.PRIMA: “Corta la penumbra, prisma RA, sin nombrar lo que no vibra”
VF.CUE:   R7. Proyecto A96/QEL. (2025-08-12). QEL|A96|VF|RA|v0.1|Oriente — *Prisma de Corte*
VF.HASH:  1f7a0c9b21
VF.TRIADA: RA → (onset:R, núcleo:A, coda:∅)
VF.MFH:   p=RA, Objeto=Prisma, Rumbo=Oriente, Clase=rara
VF.RIESGO: medio (tendencia a exceso de corte) → contrafonema: UM
VF.GATES: doble testigo; ética Norte≥0.7; entorno con polvo de Qel visible
```

## 3. Árbol de habilidades (indexación)
Ruta: `/VF/<p>/<obj>/<rumbo>/<clase>/<hash10>`  
Ej.: `/VF/RA/Prisma/Oriente/rara/1f7a0c9b21`
