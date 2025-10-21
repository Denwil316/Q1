// apps/preh-nav-m1/src/pages/RitualStudio.tsx
import React, { useEffect, useRef, useState } from 'react'
import {
  getLibrary,
  sessionNew,
  startPromote,
  startMicroreg,
  startFinalize,
  startRitualCanonM0M1, // <- canon M0/M1
  connectLogs,
} from '../lib/api'

type FS = {
  fecha: string
  tema: string
  intencion: string
  modo: string
  rumbo: string
  tiempo: string | number
  referencias: string[]
  veredicto?: string
  resultados: { artefactos: string[]; micro_sellos: string[] }
  meta: { cue?: string; SeedI?: string; SoT?: string; Version?: string; Updated?: string }
}

const todayYYMMDD = () => {
  const d = new Date()
  const yy = String(d.getFullYear()).slice(2)
  const mm = String(d.getMonth() + 1).padStart(2, '0')
  const dd = String(d.getDate()).padStart(2, '0')
  return `${yy}${mm}${dd}`
}

export default function RitualStudio() {
  // -------- state base ----------
  const [micros, setMicros] = useState<string[]>([])
  const [file, setFile] = useState<string>('') // path del Micro-Sello
  const [fsFile, setFsFile] = useState<string>('') // ruta del JSON escrito (opcional)
  const [logs, setLogs] = useState<string[]>([])
  const stopLogsRef = useRef<null | (() => void)>(null)

  // defaults
  const [rubro, setRubro] = useState('CURADURIA')
  const [titulo, setTitulo] = useState('Micro-Sello · CURADURÍA (v1.0)')
  const [rumbo, setRumbo] = useState('Centro')
  const [kind, setKind] = useState('PROMO')
  const [title, setTitle] = useState('Micro-Sello · CURADURÍA (v1.0)')
  const [fecha, setFecha] = useState(todayYYMMDD())
  const [seed, setSeed] = useState('A37-251020')
  const [cue, setCue] = useState('[QEL::ECO[37]::RECALL A37-251020-CURADURIA-MICROSELLO-PROMO]')
  const [vf, setVf] = useState('Promoción Micro-Sello Curaduría; cierre SIL→UM→Ə.')

  // FS form
  const [fs, setFs] = useState<FS>({
    fecha,
    tema: 'Curaduría',
    intencion: 'Promoción + registro',
    modo: 'M1',
    rumbo: 'Centro',
    tiempo: 30,
    referencias: ['CURADURIA/v1.0', 'Glosario v1.5'],
    veredicto: 'Listo',
    resultados: { artefactos: [], micro_sellos: [] },
    meta: { cue: '', SeedI: '', SoT: '', Version: '', Updated: '' },
  })

  useEffect(() => {
    setFs((s) => ({ ...s, fecha }))
  }, [fecha])

  // -------- cargar biblioteca y filtrar microsellos ----------
  useEffect(() => {
    getLibrary()
      .then((lib) => {
        const list = [...(lib.ritual || [])]
          .map((x) => x.url || '')
          .filter((u) => /\/ritual\/microsellos\/.+\.md$/i.test(u))
        setMicros(list)
        if (!file && list.length)
          setFile(list[list.length - 1].replace(/^\/ritual\//, 'docs/ritual/')) // toma el último como default
      })
      .catch(() => {
        /* noop */
      })
  }, [])

  // artefactos en FS = incluye el file elegido
  useEffect(() => {
    setFs((s) => ({ ...s, resultados: { ...s.resultados, artefactos: file ? [file] : [] } }))
  }, [file])

  const pushLog = (s: string) => setLogs((L) => [...L, s.replace(/\n+$/, '')])
  const clearLogs = () => setLogs([])

  const connect = (jobId: string) => {
    stopLogsRef.current?.()
    stopLogsRef.current = connectLogs(jobId, (line) => pushLog(line), (ok) => pushLog(`[done code=${ok ? 0 : 1}]`))
  }

  // -------- acciones ----------
  const doSaveFS = async () => {
    if (!fs.fecha) return alert('Falta fecha YYMMDD')
    const res = await sessionNew(fs)
    setFsFile(res.file)
    pushLog(`[fs] escrito ${res.file}`)
  }

  const doPromote = async () => {
    if (!file) return alert('Elige un Micro-Sello')
    const { jobId } = await startPromote({ file, rubro, titulo, rumbo })
    connect(jobId)
  }

  const doMicroreg = async () => {
    if (!file) return alert('Elige un Micro-Sello')
    const { jobId } = await startMicroreg({
      kind,
      file,
      title,
      gates: 'no_mentira,doble_testigo',
      rumbo,
      triada: 'SIL·UM·Ə',
      clase: 'basica',
    })
    connect(jobId)
  }

  const doFinalize = async () => {
    if (!fecha || !seed || !cue || !vf) return alert('Faltan datos clave (fecha/seed/cue/vf)')
    const { jobId } = await startFinalize({
      fecha,
      seed,
      cue,
      vf,
      fsJson: fsFile || undefined, // si no guardaste FS, el finalizer usará sus defaults
    })
    connect(jobId)
  }

  const doRitual = async () => {
    if (!file) return alert('Elige un Micro-Sello')
    const payload = {
      file,
      rubro,
      titulo,
      rumbo,
      kind,
      title,
      fecha,
      seed,
      cue,
      vf,
      fs, // embebido: el server lo guardará en docs/fs/FS_YYMMDD.json
    }
    const { jobId } = await startRitualCanonM0M1(payload) // <-- M0/M1: canon sin LL_PE ni Vcalc
    connect(jobId)
  }

  // -------- UI ----------
  const refSel = useRef<HTMLSelectElement>(null)

  return (
    <div className="p-6 space-y-6">
      <h1 className="text-2xl font-semibold">Ritual Studio</h1>

      {/* Paso 1: Selección del Micro-Sello */}
      <section className="space-y-2">
        <h2 className="font-medium">1) Micro-Sello</h2>
        <div className="flex gap-2 items-center">
          <select
            ref={refSel}
            className="border rounded px-2 py-1 min-w-[420px]"
            value={file}
            onChange={(e) => setFile(e.target.value)}
          >
            {micros.map((u) => {
              const p = u.replace(/^\/ritual\//, 'docs/ritual/')
              return (
                <option key={u} value={p}>
                  {p}
                </option>
              )
            })}
          </select>
          <button className="border rounded px-3 py-1" onClick={() => setFile(refSel.current?.value || '')}>
            Usar
          </button>
        </div>

        <div className="grid md:grid-cols-3 gap-3">
          <label className="flex flex-col text-sm">
            <span>Rubro</span>
            <input className="border rounded px-2 py-1" value={rubro} onChange={(e) => setRubro(e.target.value)} />
          </label>
          <label className="flex flex-col text-sm">
            <span>Título promoción</span>
            <input className="border rounded px-2 py-1" value={titulo} onChange={(e) => setTitulo(e.target.value)} />
          </label>
          <label className="flex flex-col text-sm">
            <span>Rumbo</span>
            <input className="border rounded px-2 py-1" value={rumbo} onChange={(e) => setRumbo(e.target.value)} />
          </label>
          <label className="flex flex-col text-sm">
            <span>Kind (microreg)</span>
            <input className="border rounded px-2 py-1" value={kind} onChange={(e) => setKind(e.target.value)} />
          </label>
          <label className="flex flex-col text-sm">
            <span>Title (microreg)</span>
            <input className="border rounded px-2 py-1" value={title} onChange={(e) => setTitle(e.target.value)} />
          </label>
        </div>
      </section>

      {/* Paso 2: FS Form */}
      <section className="space-y-2">
        <h2 className="font-medium">2) Formato Situacional (FS)</h2>
        <div className="grid md:grid-cols-3 gap-3">
          <label className="flex flex-col text-sm">
            <span>Fecha YYMMDD</span>
            <input className="border rounded px-2 py-1" value={fecha} onChange={(e) => setFecha(e.target.value)} />
          </label>
          <label className="flex flex-col text-sm">
            <span>Seed</span>
            <input className="border rounded px-2 py-1" value={seed} onChange={(e) => setSeed(e.target.value)} />
          </label>
          <label className="flex flex-col text-sm">
            <span>Cue</span>
            <input className="border rounded px-2 py-1" value={cue} onChange={(e) => setCue(e.target.value)} />
          </label>
          <label className="flex flex-col text-sm">
            <span>Tema</span>
            <input
              className="border rounded px-2 py-1"
              value={fs.tema}
              onChange={(e) => setFs((s) => ({ ...s, tema: e.target.value }))}
            />
          </label>
          <label className="flex flex-col text-sm">
            <span>Intención</span>
            <input
              className="border rounded px-2 py-1"
              value={fs.intencion}
              onChange={(e) => setFs((s) => ({ ...s, intencion: e.target.value }))}
            />
          </label>
          <label className="flex flex-col text-sm">
            <span>Modo</span>
            <input
              className="border rounded px-2 py-1"
              value={fs.modo}
              onChange={(e) => setFs((s) => ({ ...s, modo: e.target.value }))}
            />
          </label>
          <label className="flex flex-col text-sm">
            <span>Rumbo</span>
            <input
              className="border rounded px-2 py-1"
              value={fs.rumbo}
              onChange={(e) => setFs((s) => ({ ...s, rumbo: e.target.value }))}
            />
          </label>
          <label className="flex flex-col text-sm">
            <span>Tiempo (min)</span>
            <input
              className="border rounded px-2 py-1"
              value={fs.tiempo}
              onChange={(e) => setFs((s) => ({ ...s, tiempo: e.target.value }))}
            />
          </label>
          <label className="flex flex-col text-sm">
            <span>Referencias (CSV)</span>
            <input
              className="border rounded px-2 py-1"
              value={fs.referencias.join(', ')}
              onChange={(e) =>
                setFs((s) => ({ ...s, referencias: e.target.value.split(',').map((x) => x.trim()).filter(Boolean) }))
              }
            />
          </label>
        </div>

        <div className="grid md:grid-cols-2 gap-3">
          <label className="flex flex-col text-sm">
            <span>VF / Veredicto</span>
            <input className="border rounded px-2 py-1" value={vf} onChange={(e) => setVf(e.target.value)} />
          </label>
          <label className="flex flex-col text-sm">
            <span>FS.veredicto</span>
            <input
              className="border rounded px-2 py-1"
              value={fs.veredicto || ''}
              onChange={(e) => setFs((s) => ({ ...s, veredicto: e.target.value }))}
            />
          </label>
        </div>

        <div className="flex gap-2">
          <button className="px-3 py-2 rounded bg-black text-white" onClick={doSaveFS}>
            Guardar FS
          </button>
          {fsFile && <span className="text-xs text-gray-600 self-center">→ {fsFile}</span>}
        </div>
      </section>

      {/* Paso 3: Ejecutar */}
      <section className="space-y-2">
        <h2 className="font-medium">3) Ejecutar</h2>
        <div className="flex flex-wrap gap-2">
          <button className="px-3 py-2 rounded border" onClick={doPromote}>
            Promote
          </button>
          <button className="px-3 py-2 rounded border" onClick={doMicroreg}>
            Microreg
          </button>
          <button className="px-3 py-2 rounded border" onClick={doFinalize}>
            Finalize
          </button>
          <button className="px-3 py-2 rounded bg-indigo-600 text-white" onClick={doRitual}>
            Ritual completo (1 clic)
          </button>
          <button className="px-3 py-2 rounded border" onClick={clearLogs}>
            Limpiar logs
          </button>
        </div>

        <div className="mt-2">
          <h3 className="text-sm font-medium">Logs</h3>
          <pre className="bg-gray-100 p-3 rounded whitespace-pre-wrap text-sm h-72 overflow-auto">
{logs.join('\n')}
          </pre>
        </div>
      </section>
    </div>
  )
}
