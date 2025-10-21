// apps/preh-nav-m1/src/pages/QelWorkspace.tsx
import React, { useEffect, useRef, useState } from 'react'
import {
  getLibrary, sessionNew, startLLPE, connectLogs,
  fsHash, diarioSistemaAppend, listadorSesionesAppend,
} from '../lib/api'

export default function QelWorkspace() {
  // Norte: explorar core
  const [core, setCore] = useState<{name:string; url:string}[]>([])
  useEffect(()=>{ getLibrary().then(lib=>{
    setCore((lib.core||[]).map((x:any)=>({ name:x.name, url:x.url })))
  }) },[])

  // Centro: estado de sesión
  const [fecha, setFecha] = useState<string>('')
  const [seed, setSeed] = useState<string>('')
  const [cue, setCue] = useState<string>('')
  const [tema, setTema] = useState<string>('Práctica Qel')
  const [intencion, setIntencion] = useState<string>('')

  // Oriente: LL_PE
  const [vfPath, setVfPath] = useState<string>('docs/atlas/Tarjetas_Atlas_QEL_v2.4.md')
  const [llpeLogs, setLlpeLogs] = useState<string[]>([])
  const stopLLPE = useRef<null | (()=>void)>(null)

  // Vcalc (simple)
  const [vObj, setVObj] = useState('Prisma')
  const [vA, setVA] = useState(0.85)
  const [vRumbo, setVRumbo] = useState('C')
  const [vClase, setVClase] = useState('basica')
  const [vGates, setVGates] = useState('no_mentira,doble_testigo')
  const [vRuido, setVRuido] = useState(0.12)
  const [vDeltaC, setVDeltaC] = useState<'up'|'down'|'flat'>('up')
  const [vDeltaS, setVDeltaS] = useState<'up'|'down'|'flat'>('flat')
  const [vOut, setVOut] = useState<any>(null)

  // Sur: Diario Sistema
  const [hashFS, setHashFS] = useState<string>('')
  const [fsFile, setFsFile] = useState<string>('') // si guardaste FS via sessionNew
  const [notas, setNotas] = useState<string>('')

  // Altar (captura somática)
  const [altar, setAltar] = useState<any>({
    estado_corporal:'', respiracion:0, tension:0, calor:0, latido:0,
    emocion_principal:'', intensidad_emocion:0,
    marcas_atencionales:[], observaciones:''
  })

  const runLLPE = async ()=>{
    const { jobId } = await startLLPE({ vf: vfPath, seed, cue })
    stopLLPE.current?.()
    stopLLPE.current = connectLogs(jobId, (l)=> setLlpeLogs(L=>[...L, l]), ()=>{})
  }

  const doHashFS = async ()=>{
    if (!fsFile) return alert('Primero guarda un FS (M0/M1) o selecciona uno')
    const r = await fsHash({ file: fsFile, save: true })
    setHashFS(r.hash10)
  }

  const doAppendSistema = async ()=>{
    // Diario del Sistema
    const ds = await diarioSistemaAppend({
      fecha, modo:'M2', tema, intencion, cue, seed, vf:'Cierre', fsFile, hash_fs10: hashFS,
      notas, altar
    })
    // ListadoR sesiones
    await listadorSesionesAppend({ fecha, seed, tema, result:'OK', hash_fs10: hashFS })
    alert('Registrado en Diario del Sistema y ListadoR de sesiones.')
  }

  return (
    <div className="p-5 grid gap-4 md:grid-cols-2 xl:grid-cols-3">
      {/* Norte */}
      <section className="border rounded p-3">
        <h2 className="font-semibold">Norte · Códice Madre (docs/core)</h2>
        <div className="text-xs mt-2 h-64 overflow-auto">
          {core.map((d)=>(
            <div key={d.url} className="truncate"><a href={d.url} target="_blank" rel="noreferrer">{d.name}</a></div>
          ))}
        </div>
      </section>

      {/* Este */}
      <section className="border rounded p-3">
        <h2 className="font-semibold">Este · Manual Operativo</h2>
        <p className="text-xs text-gray-600">Validador canónico y ayudas (placeholder).</p>
        <div className="grid grid-cols-2 gap-2 mt-2 text-sm">
          <label className="flex flex-col"><span>Fecha</span>
            <input className="border rounded px-2 py-1" value={fecha} onChange={e=>setFecha(e.target.value)} />
          </label>
          <label className="flex flex-col"><span>Tema</span>
            <input className="border rounded px-2 py-1" value={tema} onChange={e=>setTema(e.target.value)} />
          </label>
          <label className="flex flex-col"><span>Seed</span>
            <input className="border rounded px-2 py-1" value={seed} onChange={e=>setSeed(e.target.value)} />
          </label>
          <label className="flex flex-col"><span>Cue</span>
            <input className="border rounded px-2 py-1" value={cue} onChange={e=>setCue(e.target.value)} />
          </label>
          <label className="flex flex-col col-span-2"><span>Intención</span>
            <input className="border rounded px-2 py-1" value={intencion} onChange={e=>setIntencion(e.target.value)} />
          </label>
        </div>
      </section>

      {/* Oriente */}
      <section className="border rounded p-3">
        <h2 className="font-semibold">Oriente · Libro de las Sombras (LL_PE)</h2>
        <div className="text-sm grid gap-2">
          <label className="flex flex-col"><span>VF (ruta)</span>
            <input className="border rounded px-2 py-1" value={vfPath} onChange={e=>setVfPath(e.target.value)} />
          </label>
          <button className="px-3 py-2 rounded border" onClick={runLLPE}>Generar LL_PE</button>
          <pre className="bg-gray-100 p-2 rounded h-40 overflow-auto text-xs">{llpeLogs.join('\n')}</pre>
        </div>
      </section>

      {/* Centro */}
      <section className="border rounded p-3">
        <h2 className="font-semibold">Centro · Conjurador (Vcalc)</h2>
        <div className="grid grid-cols-2 gap-2 text-sm">
          <label className="flex flex-col"><span>Objeto</span>
            <input className="border rounded px-2 py-1" value={vObj} onChange={e=>setVObj(e.target.value)} />
          </label>
          <label className="flex flex-col"><span>Afinidad (0–1)</span>
            <input className="border rounded px-2 py-1" type="number" step="0.01" value={vA} onChange={e=>setVA(parseFloat(e.target.value)||0)} />
          </label>
          <label className="flex flex-col"><span>Rumbo</span>
            <input className="border rounded px-2 py-1" value={vRumbo} onChange={e=>setVRumbo(e.target.value)} />
          </label>
          <label className="flex flex-col"><span>Clase</span>
            <input className="border rounded px-2 py-1" value={vClase} onChange={e=>setVClase(e.target.value)} />
          </label>
          <label className="flex flex-col"><span>Gates</span>
            <input className="border rounded px-2 py-1" value={vGates} onChange={e=>setVGates(e.target.value)} />
          </label>
          <label className="flex flex-col"><span>Ruido</span>
            <input className="border rounded px-2 py-1" type="number" step="0.01" value={vRuido} onChange={e=>setVRuido(parseFloat(e.target.value)||0)} />
          </label>
          <label className="flex flex-col"><span>ΔC</span>
            <select className="border rounded px-2 py-1" value={vDeltaC} onChange={e=>setVDeltaC(e.target.value as any)}>
              <option>up</option><option>flat</option><option>down</option>
            </select>
          </label>
          <label className="flex flex-col"><span>ΔS</span>
            <select className="border rounded px-2 py-1" value={vDeltaS} onChange={e=>setVDeltaS(e.target.value as any)}>
              <option>up</option><option>flat</option><option>down</option>
            </select>
          </label>
        </div>
        <button className="mt-2 px-3 py-2 rounded border" onClick={async ()=>{
          const r = await fetch('/api/v1/vcalc',{ method:'POST', headers:{'Content-Type':'application/json'},
            body: JSON.stringify({ obj:vObj, A:vA, rumbo:vRumbo, clase:vClase, gates:vGates, ruido:vRuido, delta:{c:vDeltaC,s:vDeltaS} })
          }).then(r=>r.json())
          setVOut(r)
        }}>Calcular V</button>
        <pre className="bg-gray-100 p-2 rounded h-32 overflow-auto text-xs mt-2">{JSON.stringify(vOut,null,2)}</pre>
      </section>

      {/* Sur */}
      <section className="border rounded p-3">
        <h2 className="font-semibold">Sur · Diario del Sistema</h2>
        <div className="grid gap-2 text-sm">
          <label className="flex flex-col"><span>FS (ruta) para HASH</span>
            <input className="border rounded px-2 py-1" value={fsFile} onChange={e=>setFsFile(e.target.value)} />
          </label>
          <div className="flex gap-2">
            <button className="px-3 py-2 rounded border" onClick={doHashFS}>Calcular HASH_FS(10)</button>
            {hashFS && <span className="self-center text-xs">HASH_FS(10): {hashFS}</span>}
          </div>
          <label className="flex flex-col"><span>Notas espontáneas</span>
            <textarea className="border rounded px-2 py-1 h-24" value={notas} onChange={e=>setNotas(e.target.value)} />
          </label>
          <button className="px-3 py-2 rounded bg-indigo-600 text-white" onClick={doAppendSistema}>Append Diario + ListadoR</button>
        </div>
      </section>

      {/* Altar */}
      <section className="border rounded p-3">
        <h2 className="font-semibold">Altar · Sensación/Experiencia</h2>
        <div className="grid grid-cols-2 gap-2 text-sm">
          <label className="flex flex-col"><span>Estado corporal</span>
            <input className="border rounded px-2 py-1" value={altar.estado_corporal} onChange={e=>setAltar({...altar, estado_corporal:e.target.value})} />
          </label>
          <label className="flex flex-col"><span>Emoción principal</span>
            <input className="border rounded px-2 py-1" value={altar.emocion_principal} onChange={e=>setAltar({...altar, emocion_principal:e.target.value})} />
          </label>
          {['respiracion','tension','calor','latido','intensidad_emocion'].map((k)=>(
            <label className="flex flex-col" key={k}><span>{k}</span>
              <input className="border rounded px-2 py-1" type="number" min={0} max={5}
                value={altar[k]} onChange={e=>setAltar({...altar, [k]: Number(e.target.value)||0})} />
            </label>
          ))}
          <label className="flex flex-col col-span-2"><span>Observaciones</span>
            <textarea className="border rounded px-2 py-1 h-24" value={altar.observaciones} onChange={e=>setAltar({...altar, observaciones:e.target.value})} />
          </label>
        </div>
      </section>
    </div>
  )
}
