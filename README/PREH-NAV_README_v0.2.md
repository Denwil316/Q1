SoT=UNCLASSIFIED
[QEL::ECO[96]::RECALL A96-250817-PREH-NAV-README]
SOT=PREH-NAV/v0.2 TARGET=interfaz|servidor|navegacion
VERSION=v0.2 UPDATED=2025-08-17

# PREH-NAV · README (M1)

**Intención**: Dejar una interfaz navegable para leer documentos QEL **en el navegador**, usando el `SoT_Manifest` como fuente de verdad.

---

## 0) ¿Qué significa “respetando la ruta”?

El **manifest** (ej. `QEL_SoT_Manifest_v0.7.json`) lista documentos con una **ruta relativa** (p. ej. `docs/core/QEL_Glosario_v1.2.md`).

El navegador (Vite) **solo** puede servir archivos que estén dentro de la carpeta **`public/`** del proyecto React. Por eso, al preparar PREH-NAV debemos **replicar** esa ruta **dentro de `public/`**:

- Si el manifest dice: `docs/core/QEL_Glosario_v1.2.md`  
  **Entonces coloca el archivo en**: `PREH-NAV/public/docs/core/QEL_Glosario_v1.2.md`

En resumen: *respetar la ruta* = **mantener el mismo árbol** que dice el manifest pero **adentro de `public/`** del app React.

> No importa cómo esté tu repo raíz; lo importante es que **dentro del app** (PREH-NAV) exista `public/docs/...` con las mismas subcarpetas/archivos que el manifest espera.

---

## 1) Dónde poner todo en tu estructura actual

Veo que tienes algo como:

```
.
├── apps/
│   └── preh-nav/
│       ├── PLAN_ORG_Codex_M0.md
│       ├── app.jsx
│       └── index.html
├── docs/
│   ├── core/ ...           # muchos .md, .json
│   ├── ritual/ ...
│   ├── tools/  ...
│   └── history/ ...
└── ...
```

**Opción A (Recomendada)**: usar el starter **PREH-NAV (M1)** que te pasé y copiar allí el contenido del manifest.

- Proyecto React (starter): `PREH-NAV/`
  - Manifest para el navegador: `PREH-NAV/public/sot-manifest.json`
  - Documentos servidos: `PREH-NAV/public/docs/...`

**¿Qué copio?**  
1) Copia **tu** `QEL_SoT_Manifest_v0.7.json` a `PREH-NAV/public/sot-manifest.json`.  
2) Copia **todos los archivos** que mencione el manifest (y cualquier otro que quieras navegar) a `PREH-NAV/public/docs/`, **respetando la ruta** (mismo árbol).  
   - Ejemplo directo desde tu estructura:
     - `docs/core/QEL_Diario_del_Conjurador_v1.2.md` → `PREH-NAV/public/docs/core/QEL_Diario_del_Conjurador_v1.2.md`
     - `docs/core/QEL_Glosario_v1.2.md` → `PREH-NAV/public/docs/core/QEL_Glosario_v1.2.md`
     - `docs/core/QEL_Lamina_V_Detallada_v1.0.md` → `PREH-NAV/public/docs/core/QEL_Lamina_V_Detallada_v1.0.md`
     - `docs/core/QEL_Manual_Interpretacion_Sombras_v1.1.md` → `PREH-NAV/public/docs/core/QEL_Manual_Interpretacion_Sombras_v1.1.md`
     - (y así con **ritual**, **tools**, **history**, etc.)

**Opción B (Avanzada)**: en vez de copiar, crear **symlinks** dentro de `PREH-NAV/public/docs/` que apunten a tus carpetas reales. Útil si no quieres duplicar archivos. (Requiere permisos/Developer Mode en Windows.)

- macOS/Linux (ejemplo):
  ```bash
  mkdir -p PREH-NAV/public/docs
  ln -s ../../../../docs/core     PREH-NAV/public/docs/core
  ln -s ../../../../docs/ritual   PREH-NAV/public/docs/ritual
  ln -s ../../../../docs/tools    PREH-NAV/public/docs/tools
  ln -s ../../../../docs/history  PREH-NAV/public/docs/history
  ```

- Windows (PowerShell, con permisos para symlinks):
  ```powershell
  New-Item -ItemType Directory -Path PREH-NAV/public/docs -Force | Out-Null
  New-Item -ItemType SymbolicLink -Path PREH-NAV/public/docs/core    -Target "$PWD/docs/core"
  New-Item -ItemType SymbolicLink -Path PREH-NAV/public/docs/ritual  -Target "$PWD/docs/ritual"
  New-Item -ItemType SymbolicLink -Path PREH-NAV/public/docs/tools   -Target "$PWD/docs/tools"
  New-Item -ItemType SymbolicLink -Path PREH-NAV/public/docs/history -Target "$PWD/docs/history"
  ```

> Si symlinks te dan lata, usa copia simple (ver §3).

---

## 2) Instalar y arrancar el navegador

Dentro de `PREH-NAV/`:

```bash
npm i
npm run dev    # abre http://localhost:5173
# producción local
npm run build && npm run preview
```

PowerShell (Windows):
```powershell
npm i
npm run dev
```

Scripts incluidos (alternativos):
- `scripts/serve_preh_nav.sh 5173 127.0.0.1`
- `scripts/serve_preh_nav.ps1 -Port 5173 -Host 127.0.0.1`

---

## 3) Copiar todo tu `docs/` (atajo rápido)

Si prefieres **copiar todo** (no solo lo del manifest), para pruebas iniciales:

**macOS/Linux** (desde el *root* de tu repo):
```bash
mkdir -p PREH-NAV/public/docs
rsync -av --delete docs/ PREH-NAV/public/docs/
```

**Windows (PowerShell)**:
```powershell
New-Item -ItemType Directory -Path PREH-NAV/public/docs -Force | Out-Null
robocopy .\docs .\PREH-NAV\public\docs /MIR
```

Después, verifica en el navegador que al abrir `/doc/<slug>` se muestren correctamente.

---

## 4) ¿Dónde debe vivir el manifest para la app?

- La app espera por defecto **`/sot-manifest.json`**, es decir:  
  `PREH-NAV/public/sot-manifest.json`

- Ese archivo suele ser una **copia** de tu `docs/core/QEL_SoT_Manifest_v0.7.json`.  
  Si cambias el manifest maestro, vuelve a copiarlo a `public/sot-manifest.json` (o ajusta el código para leer otra ruta).

---

## 5) Validador rápido de manifest (opcional)

Crea `scripts/validate_manifest.js` con esto y ejecútalo con `node` para comprobar que **cada ruta** del manifest existe en `public/`:

```js
// scripts/validate_manifest.js
import fs from 'fs'
const manifest = JSON.parse(fs.readFileSync('public/sot-manifest.json','utf8'))
const missing = []
;(manifest.files || []).forEach(f => {
  const p = 'public/' + f.path.replace(/^\/?/, '')
  if (!fs.existsSync(p)) missing.push(p)
})
if (missing.length) {
  console.log('Faltan archivos:\n' + missing.join('\n'))
  process.exit(1)
}
console.log('Manifest OK: todos los archivos existen en public/.')
```

Ejecuta:
```bash
node scripts/validate_manifest.js
```

---

## 6) Preguntas frecuentes

- **¿Puedo dejar mis carpetas (`docs/core`, `docs/ritual`, etc.) en su lugar?**  
  Sí, pero para que el navegador pueda **servir** los archivos, deben existir **también** dentro de `PREH-NAV/public/docs/...` (por copia o symlink).

- **Tengo `apps/preh-nav` ya creado, ¿me va a chocar con el starter?**  
  Puedes renombrar el starter a `apps/preh-nav-m1` o moverlo a `PREH-NAV/` en paralelo. Lo importante es que se mantenga su `public/` propio.

- **¿Puedo cambiar dónde lee el manifest la app?**  
  Sí. En `src/components/ManifestContext.tsx` cambia `fetch('/sot-manifest.json')` por la ruta que prefieras (mientras esté bajo `public/`).

---

## 7) Cierre QEL (Centro)

- **Checklist M1**: carga de manifest, apertura de 3 MD, 1 PDF, prueba de búsqueda y rutas directas, No-Mentira, ΔC/ΔS, **V_final** ≥ umbral.  
- **Veredicto**: si todo pasa → **CRISTALIZA** (ver sello). Si algo falta → **GERMINA** y reintenta.

> Mantra: *El orden de la Biblioteca subyace en lo Sagrado.*

SeedI=A37-251015

Version=v0.2
Updated=2025-11-04

9b2420b77d
