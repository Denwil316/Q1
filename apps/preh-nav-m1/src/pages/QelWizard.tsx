// apps/preh-nav-m1/src/pages/QelWizard.tsx
import React, { useEffect, useRef, useState } from 'react'
import { getLibrary, sessionNew, startRitualCanonM0M1, connectLogs } from '../lib/api'

type FS = {
  fecha: string; tema: string; intencion: string; modo: string; rumbo: string;
  tiempo: number | string; referencias: string[]; veredicto?: string;
  resultados: { artefactos: string[]; micro_sellos: string[] }
}

const todayYYMMDD = () => {
  const d = new Date(); return `${String(d.getFullYear()).slice(2)}${String(d.getMonth()+1).padStart(2,'0')}${String(d.getDate()).padStart(2,'0')}`
}

export default function QelWizard() {
  const [step, setStep] = useState(1)
  const [micros, setMicros] = useState<string[]>([])
  const [file, setFile] = useState('')
  const [logs, setLogs] = useState<string[]>([])
  const stopRef = useRef<null | (()=>void)>(null)

  const [fecha, setFecha] = useState(todayYYMMDD())
  const [seed, setSeed] = useState('A37-251020')
  const [cue, setCue] = useState('[QEL::ECO[37]::RECALL A37-251020-CURADURIA-MICROSELLO-PROMO]')
  const [vf, setVf] = useState('Cristaliza: cierre SIL→UM→Ə.')

  const [fs, setFs] = useState<FS>({
    fecha, tema: 'Curaduría', intencion: 'Práctica Qel M0/M1', modo: 'M1', rumbo: 'Centro',
    tiempo: 30, referencias: [], veredicto: 'Listo', resultados: { artefactos: [], micro_sellos: [] }
  })

  useEffect(()=> setFs(s=>({...s, fecha})), [fecha])

  useEffect(()=>{
    getLibrary().then(lib=>{
      const list = (lib.ritual||[]).map(x=>x.url||'').filter(u=>/\/ritual\/microsellos\/.+\.md$/i.test(u))
      setMicros(list)
      if (!file && list.length) setFile(list[list.length-1].replace(/^\/ritual\//,'docs/ritual/'))
    })
  },[])

  useEffect(()=> setFs(s=>({...s, resultados:{...s.resultados, artefactos: file? [file] : []}})), [file])

  const push = (s:string)=> setLogs(L=>[...L, s.replace(/\n+$/,'')])
  const attach = (jobId:string)=>{
    stopRef.current?.()
    stopRef.current = connectLogs(jobId, (l)=>push(l), (ok)=>push(`[done code=${ok?0:1}]`))
  }

  const next = ()=> setStep(s=>Math.min(4, s+1))
  const prev = ()=> setStep(s=>Math.max(1, s-1))

  const doCreateFS = async ()=>{
    if (!fs.fecha) return alert('Falta fecha YYMMDD')
    const r = await sessionNew(fs); push(`[fs] escrito ${r.file}`); next()
  }

  const doRunCanon = async ()=>{
    if (!file) return alert('Elige un Micro-Sello')
    const { jobId } = await startRitualCanonM0M1({
      file, rubro:'CURADURIA', titulo:'Promoción', rumbo:'Centro',
      kind:'PROMO', title:'Promoción',
      fecha, seed, cue, vf, fs
    })
    attach(jobId)
  }

  const refSel = useRef<HTMLSelectElement>(null)

  return (
    <div className="p-6 space-y-6">
      <h1 className="text-2xl font-semibold">Qel Wizard (M0/M1)</h1>

      <ol className="flex gap-3 text-sm">
        <li className={step>=1?'font-semibold':''}>1. FS</li>
        <li>→</li>
        <li className={step>=2?'font-semibold':''}>2. Elegir Micro-Sello</li>
        <li>→</li>
        <li className={step>=3?'font-semibold':''}>3. Revisar datos</li>
        <li>→</li>
        <li className={step>=4?'font-semibold':''}>4. Ritual canónico</li>
      </ol>

      {step===1 && (
        <section className="space-y-2">
          <h2 className="font-medium">Formato Situacional</h2>
          <div className="grid md:grid-cols-3 gap-3">
            <label className="flex flex-col text-sm"><span>Fecha YYMMDD</span>
              <input className="border rounded px-2 py-1" value={fecha} onChange={e=>setFecha(e.target.value)} />
            </label>
            <label className="flex flex-col text-sm"><span>Tema</span>
              <input className="border rounded px-2 py-1" value={fs.tema} onChange={e=>setFs(s=>({...s, tema:e.target.value}))} />
            </label>
            <label className="flex flex-col text-sm"><span>Intención</span>
              <input className="border rounded px-2 py-1" value={fs.intencion} onChange={e=>setFs(s=>({...s, intencion:e.target.value}))} />
            </label>
          </div>
          <div className="flex gap-2">
            <button className="px-3 py-2 rounded bg-black text-white" onClick={doCreateFS}>Guardar FS</button>
            <button className="px-3 py-2 rounded border" onClick={next}>Siguiente</button>
          </div>
        </section>
      )}

      {step===2 && (
        <section className="space-y-2">
          <h2 className="font-medium">Elegir Micro-Sello</h2>
          <div className="flex gap-2 items-center">
            <select ref={refSel} className="border rounded px-2 py-1 min-w-[420px]"
              value={file} onChange={e=>setFile(e.target.value)}>
              {micros.map(u=>{
                const p = u.replace(/^\/ritual\//, 'docs/ritual/')
                return <option key={u} value={p}>{p}</option>
              })}
            </select>
            <button className="border rounded px-3 py-1" onClick={()=>setFile(refSel.current?.value||'')}>Usar</button>
          </div>
          <div className="flex gap-2">
            <button className="px-3 py-2 rounded border" onClick={prev}>Atrás</button>
            <button className="px-3 py-2 rounded bg-indigo-600 text-white" onClick={next}>Siguiente</button>
          </div>
        </section>
      )}

      {step===3 && (
        <section className="space-y-2">
          <h2 className="font-medium">Revisión</h2>
          <div className="text-sm">
            <div><b>Seed</b>: {seed}</div>
            <div><b>Cue</b>: {cue}</div>
            <div><b>VF</b>: {vf}</div>
            <div><b>Archivo</b>: {file || '(elige)'}</div>
          </div>
          <div className="flex gap-2">
            <button className="px-3 py-2 rounded border" onClick={prev}>Atrás</button>
            <button className="px-3 py-2 rounded bg-green-600 text-white" onClick={()=>setStep(4)}>Listo</button>
          </div>
        </section>
      )}

      {step===4 && (
        <section className="space-y-2">
          <h2 className="font-medium">Ritual (Promote → Microreg → Finalize)</h2>
          <div className="grid md:grid-cols-3 gap-3">
            <label className="flex flex-col text-sm"><span>Seed</span>
              <input className="border rounded px-2 py-1" value={seed} onChange={e=>setSeed(e.target.value)} />
            </label>
            <label className="flex flex-col text-sm"><span>Cue</span>
              <input className="border rounded px-2 py-1" value={cue} onChange={e=>setCue(e.target.value)} />
            </label>
            <label className="flex flex-col text-sm"><span>VF / Veredicto</span>
              <input className="border rounded px-2 py-1" value={vf} onChange={e=>setVf(e.target.value)} />
            </label>
          </div>
          <div className="flex gap-2">
            <button className="px-3 py-2 rounded border" onClick={prev}>Atrás</button>
            <button className="px-3 py-2 rounded bg-indigo-600 text-white" onClick={doRunCanon}>Ejecutar</button>
          </div>

          <div className="mt-3">
            <h3 className="text-sm font-medium">Logs</h3>
            <pre className="bg-gray-100 p-3 rounded whitespace-pre-wrap text-sm h-72 overflow-auto">
{logs.join('\n')}
            </pre>
          </div>
        </section>
      )}
    </div>
  )
}
