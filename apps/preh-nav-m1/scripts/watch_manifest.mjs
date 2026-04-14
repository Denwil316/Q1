/* [QEL::ECO[96]::RECALL A96-250819-MANIFEST-WATCH]
   SeedI=PREH-NAV::M1
   SOT=PREH-NAV/v0.3 TARGET=manifest|watcher
   VERSION=v0.3 UPDATED=2025-08-19 */
import { spawn } from 'node:child_process'
import chokidar from 'chokidar'
import path from 'path'
import { fileURLToPath } from 'url'
const __dirname = path.dirname(fileURLToPath(import.meta.url))
const APP = process.env.APP_DIR || path.resolve(__dirname, '..')
const DOCS = path.join(APP, 'public', 'docs')
let busy=false
function regen(){
  if(busy) return; busy=true
  const proc = spawn(process.execPath, [path.join(__dirname,'generate_manifest.mjs')], {stdio:'inherit', cwd:APP})
  proc.on('exit',()=>{busy=false})
}
console.log('[WATCH] observando:', DOCS)
chokidar.watch(DOCS,{ignoreInitial:true,depth:20,awaitWriteFinish:{stabilityThreshold:200,pollInterval:50}})
  .on('all', regen)
regen()
