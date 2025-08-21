[QEL::ECO[96]::RECALL A96-250815-GUIA-OP-QEL]
SEEDID=A96-GUIA-OP-250815
SOT=GUIA-OPERACION/v1.0
VERSION=v1.0 UPDATED=2025-08-15

# Guía de Operación QEL — Consolidada (v1.0)

> Propósito: una referencia **única** y **operativa** para levantar, navegar, versionar y empaquetar el sistema QEL en tu carpeta `codex/`, con buenas prácticas de **código limpio**, seguridad y trazabilidad (Listado R).

---

## 1) Contexto y alcance
Esta guía integra y resume lo práctico de: **Diario v1.2**, **Glosario v1.2 + Lámina 𝒱**, **MFH v1.2**, **Tratado Metahumano v1.1**, **Manual Sombras v1.1**, **Formato VF/Árbol v1.0**, **Esculpido v0.3**, **Tarjetas Atlas v2.2**, **Meditaciones v1.0/1.1**, **Poema‑Enigma v1.0**, **Listado R v1.3**, y utilidades (AURORA, CUE‑EXCEPTION, CueMachine).

- **Ciclo 15–30′**: Esculpido → Proyección → Vibración → Eco; cierre **SIL→UM→Ə** con **ΔC/ΔS** y (M1+) **𝒱 ≥ 0.62**.
- **Promoción**: si **Cristaliza**, registrar en **Formato VF/Árbol** y **Listado R**.
- **Seguridad**: No‑Mentira, Doble Testigo, gates (ver Manual/Tratado).

---

## 2) Organización “Clean Code” para `codex/`

```text
codex/
├─ docs/                 # Material QEL (md/json/artefactos)
│  ├─ core/              # Núcleo operativo (Diario, Glosario, Lámina 𝒱, MFH, Tratado, Manual)
│  ├─ ritual/            # Meditaciones, Poema‑Enigma, Sellos & Cues, Tarjetas Atlas
│  ├─ tools/             # Formato VF/Árbol, CUE‑EXCEPTION, AURORA, CueMachine
│  ├─ history/           # Versiones históricas no vigentes (p.ej. MFH v1.0)
│  └─ attachments/       # Imágenes/diagramas/otros
│
├─ memory/               # Bitácoras y Listado R vigente
├─ memory_v0.4/          # Congelado histórico
│
├─ preh_nav/             # Navegador estático y empaquetadores
│  ├─ index.html         # Navegador (v0.2+)
│  ├─ manifest.json      # Autogenerado por build
│  ├─ build/             # Salidas (zip, html minificado)
│  └─ scripts/           # build.{js,py}, utilidades
│
├─ motor_qel/            # Código fuente: parsers, validadores 𝒱
│  ├─ src/
│  ├─ test/              # Tests (node/pytest)
│  └─ package.json o pyproject.toml
│
├─ LICENSE
├─ README.md             # Vista general
├─ README_docs.md        # Convenciones de docs
├─ CHANGELOG.md          # Cambios globales
└─ .gitignore
```

**Convenciones**:
- Nombres: `QEL_<Nombre>_vM.m.md` (ej.: `QEL_Lamina_V_Detallada_v1.0.md`).
- Cabecera en cada doc:
  ```
  [QEL::ECO[96]::RECALL A96-YYYYMMDD-<TAG>]
  SOT=<SOT>/<versión> TARGET=<palabras-clave>
  VERSION=vX.Y UPDATED=YYYY-MM-DD
  ```
- Un README por carpeta con: propósito, contenidos, cómo actualizar, responsables.
- CHANGELOG semántico (fecha + scope).
- Tests para scripts (mínimo: enlaces válidos, títulos únicos).

---

## 3) Procedimiento operativo mínimo (M0→M1)
1. **Diario v1.2** → redacta **FS** (tema, intención, modo, rumbo, tiempo).
2. **Ejecución**: triada p + objeto O; **Esculpido v0.3** (15–30′).
3. **Consulta**: **Lámina 𝒱** + **Glosario** (si M1+).
4. **Cierre**: **SIL→UM→Ə**; registra **ΔC/ΔS**, No‑Mentira, (M1+) **V_final**.
5. **Promoción**: si **Cristaliza** → **VF/Árbol** + **Listado R**.

---

## 4) Construcción del **Navegador HTML** (v0.2) — *cómo está hecho*

### 4.1 Diseño didáctico
- **HTML único** (sin framework): accesible, portable y fácil de versionar.
- **Lista de ítems** = {`title`, `href`} construidos a partir de archivos en `docs/` y `memory/`.
- **Búsqueda local**: filtrado por `includes()` sobre `title.toLowerCase()`.
- **Enlaces sandbox**: `href="sandbox:/ruta/al/archivo"` para abrir directamente.
- **Codificación**: se evita TypeScript en runtime; JSON.stringify con `ensure_ascii=false` para mantener acentos y 𝒱; **no** se interpolan strings sin escapar.

### 4.2 Prevención de errores (por qué tuviste `Expecting Unicode escape sequence \\uXXXX`)
- Evitamos anotar tipos TS (`Row({ label, href }:{...})`) en JS puro.
- Mantuvimos caracteres Unicode **dentro de strings válidos** (no en claves no‑quoted).
- Cualquier contenido de datos se inserta como **JSON** en `<script>`:  
  ```js
  const items = [{ "title":"Lámina 𝒱 v1.0", "href":"sandbox:/mnt/data/QEL..." }];
  ```
  (El motor de JS entiende Unicode en strings sin necesidad de `\\uXXXX`.)

### 4.3 Estructura mínima del HTML
```html
<input id="q" type="search" placeholder="Filtra..." />
<section id="list"></section>
<script>
  const items = [/* ... autogenerado ... */];
  function render(f=''){
    // filtra y pinta filas con enlaces
  }
  render();
  document.getElementById('q').addEventListener('input', e=>render(e.target.value));
</script>
```

---

## 5) Empaquetado (ZIP) con **build scripts**

### 5.1 Bash (rápido)
```bash
cd codex
DATE=$(date +"%Y-%m-%d")
OUT="QEL_Documentos_Completos_vALL_${DATE}.zip"
zip -r "preh_nav/build/${OUT}" docs memory preh_nav/index.html -x "*/history/*"
# Para incluir history/ elimina el -x
```

### 5.2 Node (manifest + zip)
`codex/preh_nav/scripts/build.js`:
```js
import { promises as fs } from 'fs';
import path from 'path';
import archiver from 'archiver';
const ROOT = path.resolve(process.cwd(), '..');
const CODEX = path.join(ROOT, 'codex');
const DOCS = path.join(CODEX, 'docs');
const MEMORY = path.join(CODEX, 'memory');
const PREH = path.join(CODEX, 'preh_nav');
const BUILD = path.join(PREH, 'build');
const DATE = new Date().toISOString().slice(0,10);
const OUT = `QEL_Documentos_Completos_vALL_${DATE}.zip`;

function collect(dir, filter=(p)=>true) {
  const walk = async (d) => (await fs.readdir(d,{withFileTypes:true}))
   .flatMap(async ent => ent.isDirectory() ? await walk(path.join(d,ent.name))
                                           : (filter(path.join(d,ent.name)) ? [path.join(d,ent.name)] : []));
  return walk(dir);
}
const isQEL = p => /(docs|memory)\//.test(p);

const main = async () => {
  await fs.mkdir(BUILD,{recursive:true});
  const files = [
    ...(await collect(DOCS, isQEL)),
    ...(await collect(MEMORY, ()=>true)),
  ].sort();
  const manifest = {
    cue: "[QEL::ECO[96]::RECALL A96-"+DATE.replace(/-/g,'')+"-MANIFEST]",
    sot: "PREH-NAV/v0.2",
    version: "v0.2",
    updated: DATE,
    count: files.length,
    files: files.map(p=>({ title: path.basename(p), path: p.replace(CODEX,'').replace(/^\|^\//,'') }))
  };
  await fs.writeFile(path.join(PREH,'manifest.json'), JSON.stringify(manifest,null,2), 'utf8');

  const out = path.join(BUILD, OUT);
  const output = (await fs.open(out,'w')).createWriteStream();
  const zip = archiver('zip',{zlib:{level:9}});
  zip.pipe(output);
  for (const p of files) zip.file(p, { name: p.replace(CODEX+path.sep,'') });
  zip.file(path.join(PREH,'index.html'), { name:'preh_nav/index.html' });
  zip.file(path.join(PREH,'manifest.json'), { name:'preh_nav/manifest.json' });
  await zip.finalize();
};
main().catch(e=> (console.error(e), process.exit(1)));
```

**Ejecuta**:
```bash
cd codex
npm init -y && npm i archiver
node preh_nav/scripts/build.js
```

### 5.3 Python (sin dependencias)
`codex/preh_nav/scripts/build.py`:
```python
import os, json, zipfile, datetime, pathlib
ROOT = pathlib.Path(__file__).resolve().parents[2]
CODEX = ROOT / "codex"
DOCS = CODEX / "docs"
MEMORY = CODEX / "memory"
PREH = CODEX / "preh_nav"
BUILD = PREH / "build"
DATE = datetime.date.today().isoformat()
OUT = BUILD / f"QEL_Documentos_Completos_vALL_{DATE}.zip"

def want(fn):
    b = os.path.basename(fn)
    return b.startswith(("QEL_","Esculpido_","Matematicas Resonantes","Tarjetas_Atlas"))

files = []
for base in (DOCS, MEMORY):
    for r, d, fns in os.walk(base):
        for fn in fns:
            p = os.path.join(r, fn)
            if base==DOCS and not want(fn): 
                continue
            files.append(p)
files.sort()
BUILD.mkdir(parents=True, exist_ok=True)
manifest = {
  "cue": f"[QEL::ECO[96]::RECALL A96-{DATE.replace('-','')}-MANIFEST]",
  "sot": "PREH-NAV/v0.2",
  "version": "v0.2",
  "updated": DATE,
  "count": len(files),
  "files": [{"title": os.path.basename(p), "path": os.path.relpath(p, CODEX)} for p in files]
}
(PREH/"manifest.json").write_text(json.dumps(manifest, ensure_ascii=False, indent=2), encoding="utf-8")
with zipfile.ZipFile(OUT, "w", zipfile.ZIP_DEFLATED) as z:
    for p in files: z.write(p, arcname=os.path.relpath(p, CODEX))
    z.write(PREH/"index.html", arcname="preh_nav/index.html")
    z.write(PREH/"manifest.json", arcname="preh_nav/manifest.json")
print("ZIP:", str(OUT), "count:", len(files))
```

---

## 6) Tests mínimos (recomendados)

**Node** (`motor_qel/test/links.spec.mjs`):
```js
import fs from 'fs';
const m = JSON.parse(fs.readFileSync('codex/preh_nav/manifest.json','utf8'));
test('manifest tiene archivos', ()=> expect(m.count).toBeGreaterThan(0));
test('titulos únicos', ()=>{
  const t = m.files.map(x=>x.title);
  expect(new Set(t).size).toBe(t.length);
});
```

**Python** (`motor_qel/test/test_links.py`):
```python
import json
m = json.load(open('codex/preh_nav/manifest.json','r',encoding='utf-8'))
def test_has_files(): assert m['count']>0
def test_unique_titles():
    titles=[x['title'] for x in m['files']]
    assert len(titles)==len(set(titles))
```

---

## 7) Buenas prácticas generales
- **Una fuente de verdad** por carpeta (README local + manifest).
- **No duplicar** definiciones entre Glosario, Lámina y MFH; enlaza referencias.
- **Histórico**: mueve versiones viejas a `docs/history/` (no borrarlas).
- **Promoción explícita**: cualquier “Cristaliza” debe reflejarse en **Listado R**.
- **Rendimiento**: preferir HTML estático en `preh_nav/` + búsqueda client‑side.
- **Unicode/JS**: evita TS en runtime; serializa datos con JSON; no interpolar HTML crudo desde datos.

---

## 8) Checklist para incorporar nuevos documentos
- [ ] Nombrado y cabecera QEL correctos.
- [ ] Ubicación correcta (`core/`, `ritual/`, `tools/`, `history/`).
- [ ] Actualizar **Listado R** si procede.
- [ ] Ejecutar `build` y verificar **manifest.json** + **index.html**.
- [ ] Hacer commit + push.

---

## 9) Glosario de atajos operativos
- **FS**: Formato Situacional (tema, intención, modo, rumbo, tiempo).
- **𝒱**: Viabilidad (Lámina 𝒱; umbral 0.62).
- **VF**: Verso Fundador (≤13 palabras).
- **Gates**: condiciones de seguridad/ética (Manual/Tratado).
- **Cierre**: **SIL→UM→Ə**.

---

## 10) Notas finales
- Esta guía **no sustituye** a los textos canónicos; los organiza.
- Si el navegador falla, revisa: 1) Unicode en strings; 2) JSON válido; 3) paths.

— Fin de v1.0
