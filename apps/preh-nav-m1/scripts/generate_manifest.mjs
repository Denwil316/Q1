/* [QEL::ECO[96]::RECALL A96-250819-MANIFEST-GEN]
   SeedI=PREH-NAV::M1
   SOT=PREH-NAV/v0.3 TARGET=manifest|generador
   VERSION=v0.3 UPDATED=2025-08-19 */
import fs from 'fs'
import path from 'path'
const APP = process.env.APP_DIR || process.cwd()
const ROOT = path.join(APP, 'public', 'docs')
function walk(dir){const out=[];for(const e of fs.readdirSync(dir,{withFileTypes:true})){if(e.name.startsWith('.'))continue;const f=path.join(dir,e.name);e.isDirectory()?out.push(...walk(f)):out.push(f)}return out}
if(!fs.existsSync(ROOT)){console.error('No existe',ROOT);process.exit(1)}
const files = walk(ROOT).filter(p=>/\.(md|markdown|txt|pdf|zip)$/i.test(p))
const items = files.map(full=>{const rel=path.relative(path.join(APP,'public'),full).replace(/\\/g,'/');const name=path.basename(rel).replace(/\.(md|markdown|txt|pdf|zip)$/i,'');const role=rel.split('/')[1]||'misc';return {name,role,path:rel}})
  .sort((a,b)=>a.name.localeCompare(b.name))
const out = { files: items, recommended_core: [], optional: [] }
fs.writeFileSync(path.join(APP,'public','sot-manifest.json'), JSON.stringify(out,null,2), 'utf8')
console.log('Manifest generado con', items.length, 'entradas.')
