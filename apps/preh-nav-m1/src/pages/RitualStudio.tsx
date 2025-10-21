import React, { useEffect, useMemo, useRef, useState } from 'react';
import Stepper, { Step } from '../components/Stepper';
import TagInput from '../components/TagInput';

type Delta = 'up'|'flat'|'down';
type Modo = 'M0'|'M1'|'M2'|'M3';

interface FS {
  fecha: string;
  tema: string;
  intencion: string;
  modo: Modo;
  rumbo: string;
  tiempo: number;
  referencias?: string[];
  salidas_esperadas?: string[];
  resultados?: { artefactos?: string[]; micro_sellos?: string[]; };
  meta?: Record<string, any>;
}

const VCALC_UNLOCK_AT_STEP = 0; // 0=tras FS; 1=tras Promote; 2=tras Microreg; 3=tras Finalize

export default function RitualStudio() {
  // ---------- estado base ----------
  const todayYYMMDD = new Date().toISOString().slice(2,10).replace(/-/g,'').slice(2);
  const [step, setStep] = useState<number>(0); // 0 FS, 1 Promote, 2 Microreg, 3 Finalize
  const [jobId, setJobId] = useState<string>('');
  const [logs, setLogs] = useState<string[]>([]);
  const sseRef = useRef<EventSource|null>(null);

  // FS
  const [fs, setFs] = useState<FS>({
    fecha: todayYYMMDD,      // YYMMDD
    tema: 'Curaduría',
    intencion: 'Promoción + registro',
    modo: 'M1',
    rumbo: 'Centro',
    tiempo: 30,
    referencias: [],
    salidas_esperadas: [],
    resultados: { artefactos: [], micro_sellos: [] },
    meta: {}
  });

  // Campos canónicos adicionales (seed/cue/vf)
  const [seed, setSeed] = useState<string>('');
  const [cue, setCue]   = useState<string>('');
  const [vf, setVf]     = useState<string>('Listo');

  // Microsello seleccionado
  const [file, setFile] = useState<string>('docs/ritual/microsellos/QEL_MicroSello_A37-251020_CURADURIA_v1.0.md');
  const [titulo, setTitulo] = useState<string>('');
  const [rubro, setRubro]   = useState<string>('CURADURIA');
  const [rumboUI, setRumboUI] = useState<string>('Centro');

  // ---------- stepper ----------
  const steps: Step[] = useMemo(()=>[
    { key:'fs',        title:'Formato Situacional', state: step>0?'done':step===0?'current':'todo' },
    { key:'promote',   title:'Promote',             state: step>1?'done':step===1?'current':'todo' },
    { key:'microreg',  title:'Microregistro',       state: step>2?'done':step===2?'current':'todo' },
    { key:'finalize',  title:'Finalize',            state: step>3?'done':step===3?'current':'todo' },
  ],[step]);

  // ---------- helpers ----------
  const appendLog = (line: string) => setLogs(prev => [...prev, line.replace(/\n+$/,'')]);

  const openSSE = (id: string) => {
    sseRef.current?.close();
    const es = new EventSource(`/api/v1/logs/${id}`);
    sseRef.current = es;
    es.onmessage = (ev) => {
      try {
        const data = JSON.parse(ev.data);
        if (data.line) appendLog(data.line);
        if (data.done) {
          appendLog(`[done code=${data.code}]`);
          es.close();
        }
      } catch { /* ignore */ }
    };
    es.onerror = () => { es.close(); };
  };

  useEffect(()=> () => { sseRef.current?.close(); }, []);

  // ---------- acciones ----------
  const createFS = async () => {
    setLogs([]);
    const res = await fetch('/api/v1/session/new', {
      method:'POST', headers:{'Content-Type':'application/json'},
      body: JSON.stringify(fs)
    }).then(r=>r.json());
    if (res.ok) {
      appendLog(`[fs] guardado ${res.file}`);
      setStep(1);
    } else {
      appendLog(`[fs][error] ${res.error||'falló'}`);
    }
  };

  const doPromote = async () => {
    setLogs([]);
    const payload = { file, rubro, titulo, rumbo: rumboUI };
    const r = await fetch('/api/v1/promote', { method:'POST', headers:{'Content-Type':'application/json'}, body: JSON.stringify(payload) }).then(r=>r.json());
    if (r.ok && r.jobId) {
      setJobId(r.jobId); openSSE(r.jobId);
      setStep(2);
    } else appendLog(`[promote][error] ${r.error||'falló'}`);
  };

  const doMicroreg = async () => {
    setLogs([]);
    const payload = {
      kind: 'PROMO', file,
      title: titulo || undefined,
      rumbo: rumboUI, triada: 'SIL·UM·Ə', gates: 'no_mentira,doble_testigo',
      clase: 'basica'
    };
    const r = await fetch('/api/v1/microreg', { method:'POST', headers:{'Content-Type':'application/json'}, body: JSON.stringify(payload) }).then(r=>r.json());
    if (r.ok && r.jobId) {
      setJobId(r.jobId); openSSE(r.jobId);
      setStep(3);
    } else appendLog(`[microreg][error] ${r.error||'falló'}`);
  };

  const doFinalize = async () => {
    setLogs([]);
    const payload = {
      fecha: fs.fecha, seed, cue, vf,
      fsJson: `docs/fs/FS_${fs.fecha.slice(2)}.json`, // si deseas exactitud YYYY, adapta
      diarioFile: 'docs/core/QEL_Diario_del_Conjurador_v1.2.md',
      listadorFile: 'docs/core/QEL_ListadoR_master_v1.0.md'
    };
    const r = await fetch('/api/v1/finalize', { method:'POST', headers:{'Content-Type':'application/json'}, body: JSON.stringify(payload) }).then(r=>r.json());
    if (r.ok && r.jobId) {
      setJobId(r.jobId); openSSE(r.jobId);
    } else appendLog(`[finalize][error] ${r.error||'falló'}`);
  };

  const vcalcEnabled = step >= VCALC_UNLOCK_AT_STEP;

  // ---------- UI ----------
  return (
    <div className="ritual">
      <div className="ritual-header">
        <h1>Altar · Ritual Studio</h1>
        <div className="toolbar">
          <a className={`btn ${vcalcEnabled?'':'btn-disabled'}`} href={vcalcEnabled ? '/vcalc' : undefined} aria-disabled={!vcalcEnabled}>
            Abrir calculadora VCALC
          </a>
        </div>
      </div>

      <Stepper steps={steps} />

      <div className="grid">
        {/* Izquierda: formulario y acciones */}
        <div className="col">
          {/* Paso 0: FS */}
          <section className="card">
            <h2>Formato Situacional</h2>
            <div className="field-row">
              <div className="field">
                <label className="label">Fecha (YYMMDD)</label>
                <input className="input" value={fs.fecha} onChange={e=>setFs({...fs, fecha:e.target.value.trim()})} />
              </div>
              <div className="field">
                <label className="label">Modo</label>
                <select className="input" value={fs.modo} onChange={e=>setFs({...fs, modo: e.target.value as Modo})}>
                  <option value="M0">M0</option>
                  <option value="M1">M1</option>
                  <option value="M2">M2</option>
                  <option value="M3">M3</option>
                </select>
              </div>
              <div className="field">
                <label className="label">Rumbo</label>
                <select className="input" value={fs.rumbo} onChange={e=>setFs({...fs, rumbo:e.target.value})}>
                  <option>Centro</option><option>N</option><option>S</option><option>E</option><option>W</option><option>O</option><option>C</option>
                </select>
              </div>
              <div className="field">
                <label className="label">Tiempo (min)</label>
                <input className="input" type="number" min={0} value={fs.tiempo} onChange={e=>setFs({...fs, tiempo:Number(e.target.value)})} />
              </div>
            </div>

            <div className="field">
              <label className="label">Tema</label>
              <input className="input" value={fs.tema} onChange={e=>setFs({...fs, tema:e.target.value})} />
            </div>
            <div className="field">
              <label className="label">Intención</label>
              <input className="input" value={fs.intencion} onChange={e=>setFs({...fs, intencion:e.target.value})} />
            </div>

            <TagInput
              label="Referencias"
              value={fs.referencias || []}
              onChange={arr => setFs({...fs, referencias: arr})}
              help="Enter para añadir; puedes pegar varias líneas."
            />

            <TagInput
              label="Salidas esperadas"
              value={fs.salidas_esperadas || []}
              onChange={arr => setFs({...fs, salidas_esperadas: arr})}
              help="Opcional: se integran en el finalize si las defines aquí."
            />

            <div className="actions">
              <button className="btn" onClick={createFS} disabled={step>0}>Guardar FS</button>
            </div>
          </section>

          {/* Paso 1: Promote */}
          <section className="card">
            <h2>Promoción de Microsello</h2>
            <div className="field">
              <label className="label">Archivo Microsello (.md)</label>
              <input className="input" value={file} onChange={e=>setFile(e.target.value)} />
              <p className="help">Ej: docs/ritual/microsellos/QEL_MicroSello_....md</p>
            </div>
            <div className="field-row">
              <div className="field">
                <label className="label">Rubro</label>
                <input className="input" value={rubro} onChange={e=>setRubro(e.target.value)} />
              </div>
              <div className="field">
                <label className="label">Título (opcional)</label>
                <input className="input" value={titulo} onChange={e=>setTitulo(e.target.value)} />
              </div>
              <div className="field">
                <label className="label">Rumbo</label>
                <input className="input" value={rumboUI} onChange={e=>setRumboUI(e.target.value)} />
              </div>
            </div>
            <div className="actions">
              <button className="btn" onClick={doPromote} disabled={step<1}>Promote</button>
            </div>
          </section>

          {/* Paso 2: Microreg */}
          <section className="card">
            <h2>Microregistro</h2>
            <div className="actions">
              <button className="btn" onClick={doMicroreg} disabled={step<2}>Microreg</button>
            </div>
          </section>

          {/* Paso 3: Finalize */}
          <section className="card">
            <h2>Finalize</h2>
            <div className="field-row">
              <div className="field">
                <label className="label">SeedI</label>
                <input className="input" value={seed} onChange={e=>setSeed(e.target.value)} />
              </div>
              <div className="field">
                <label className="label">CUE</label>
                <input className="input" value={cue} onChange={e=>setCue(e.target.value)} />
              </div>
              <div className="field">
                <label className="label">Veredicto</label>
                <input className="input" value={vf} onChange={e=>setVf(e.target.value)} />
              </div>
            </div>
            <div className="actions">
              <button className="btn" onClick={doFinalize} disabled={step<3}>Finalize</button>
            </div>
          </section>
        </div>

        {/* Derecha: logs */}
        <div className="col">
          <section className="card">
            <h2>Log en vivo</h2>
            <div className="logbox" aria-live="polite">
              {logs.length === 0 ? <p className="help">Sin salida aún.</p> : (
                <pre className="log">{logs.join('\n')}</pre>
              )}
            </div>
          </section>
        </div>
      </div>
    </div>
  );
}
