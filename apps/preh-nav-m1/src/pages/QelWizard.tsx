import React, { useEffect, useMemo, useRef, useState } from 'react';
import Stepper, { Step } from '../components/Stepper';
import TagInput from '../components/TagInput';

type Modo = 'M0'|'M1'|'M2'|'M3';

interface FS {
  fecha: string;          // YYMMDD
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

export default function QelWizard() {
  const todayYYMMDD = new Date().toISOString().slice(2,10).replace(/-/g,'').slice(2);

  // Paso actual: 0 FS, 1 Promote, 2 Microreg, 3 Finalize
  const [step, setStep] = useState<number>(0);

  // Log & SSE
  const [logs, setLogs] = useState<string[]>([]);
  const [jobId, setJobId] = useState<string>('');
  const sseRef = useRef<EventSource|null>(null);
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
      } catch {/* ignore */}
    };
    es.onerror = () => { es.close(); };
  };
  useEffect(()=> () => sseRef.current?.close(), []);

  // FS
  const [fs, setFs] = useState<FS>({
    fecha: todayYYMMDD,
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

  // Promote / Microreg / Finalize
  const [file, setFile] = useState<string>('docs/ritual/microsellos/QEL_MicroSello_A37-251020_CURADURIA_v1.0.md');
  const [rubro, setRubro] = useState<string>('CURADURIA');
  const [titulo, setTitulo] = useState<string>('');
  const [rumboUI, setRumboUI] = useState<string>('Centro');
  const [seed, setSeed] = useState<string>('');
  const [cue,  setCue]  = useState<string>('');
  const [vf,   setVf]   = useState<string>('Listo');

  // Stepper
  const steps: Step[] = useMemo(()=>[
    { key:'fs',        title:'Formato Situacional', state: step>0?'done':step===0?'current':'todo' },
    { key:'promote',   title:'Promote',             state: step>1?'done':step===1?'current':'todo' },
    { key:'microreg',  title:'Microregistro',       state: step>2?'done':step===2?'current':'todo' },
    { key:'finalize',  title:'Finalize',            state: step>3?'done':step===3?'current':'todo' },
  ],[step]);

  // Actions
  const saveFS = async () => {
    setLogs([]);
    const r = await fetch('/api/v1/session/new', {
      method:'POST', headers:{'Content-Type':'application/json'},
      body: JSON.stringify(fs)
    }).then(r=>r.json());
    if (r.ok) { appendLog(`[fs] guardado ${r.file}`); setStep(1); }
    else appendLog(`[fs][error] ${r.error||'falló'}`);
  };

  const runPromote = async () => {
    setLogs([]);
    const payload = { file, rubro, titulo, rumbo: rumboUI };
    const r = await fetch('/api/v1/promote', { method:'POST', headers:{'Content-Type':'application/json'}, body: JSON.stringify(payload) }).then(r=>r.json());
    if (r.ok && r.jobId) { setJobId(r.jobId); openSSE(r.jobId); setStep(2); }
    else appendLog(`[promote][error] ${r.error||'falló'}`);
  };

  const runMicroreg = async () => {
    setLogs([]);
    const payload = { kind:'PROMO', file, title: titulo || undefined, rumbo: rumboUI, triada:'SIL·UM·Ə', gates:'no_mentira,doble_testigo', clase:'basica' };
    const r = await fetch('/api/v1/microreg', { method:'POST', headers:{'Content-Type':'application/json'}, body: JSON.stringify(payload) }).then(r=>r.json());
    if (r.ok && r.jobId) { setJobId(r.jobId); openSSE(r.jobId); setStep(3); }
    else appendLog(`[microreg][error] ${r.error||'falló'}`);
  };

  const runFinalize = async () => {
    setLogs([]);
    const payload = {
      fecha: fs.fecha, seed, cue, vf,
      fsJson: `docs/fs/FS_${fs.fecha.slice(2)}.json`,
      diarioFile: 'docs/core/QEL_Diario_del_Conjurador_v1.2.md',
      listadorFile: 'docs/core/QEL_ListadoR_master_v1.0.md'
    };
    const r = await fetch('/api/v1/finalize', { method:'POST', headers:{'Content-Type':'application/json'}, body: JSON.stringify(payload) }).then(r=>r.json());
    if (r.ok && r.jobId) { setJobId(r.jobId); openSSE(r.jobId); }
    else appendLog(`[finalize][error] ${r.error||'falló'}`);
  };

  // Modo “todo en uno” canónico M0/M1
  const runCanon = async () => {
    setLogs([]);
    const payload = {
      file,
      fecha: fs.fecha, seed, cue, vf,
      fs,
      rubro, titulo, rumbo: rumboUI, kind:'PROMO', title: titulo || undefined
    };
    const r = await fetch('/api/v1/ritual/canon/m0m1', { method:'POST', headers:{'Content-Type':'application/json'}, body: JSON.stringify(payload)}).then(r=>r.json());
    if (r.ok && r.jobId) { setJobId(r.jobId); openSSE(r.jobId); }
    else appendLog(`[canon][error] ${r.error||'falló'}`);
  };

  // UI
  return (
    <div className="ritual">
      <div className="ritual-header">
        <h1>Vía · Wizard (M0/M1)</h1>
        <div className="toolbar">
          <button className="btn" onClick={runCanon}>Ejecutar todo (canónico)</button>
          <a className="btn" href="/vcalc">Abrir VCALC</a>
        </div>
      </div>

      <Stepper steps={steps} />

      <div className="grid">
        <div className="col">
          {/* FS */}
          <section className="card">
            <h2>1. Formato Situacional</h2>
            <div className="field-row">
              <div className="field">
                <label className="label">Fecha (YYMMDD)</label>
                <input className="input" value={fs.fecha} onChange={e=>setFs({...fs, fecha:e.target.value.trim()})}/>
              </div>
              <div className="field">
                <label className="label">Modo</label>
                <select className="input" value={fs.modo} onChange={e=>setFs({...fs, modo:e.target.value as Modo})}>
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
                <label className="label">Tiempo</label>
                <input type="number" min={0} className="input" value={fs.tiempo} onChange={e=>setFs({...fs, tiempo:Number(e.target.value)})}/>
              </div>
            </div>
            <div className="field">
              <label className="label">Tema</label>
              <input className="input" value={fs.tema} onChange={e=>setFs({...fs, tema:e.target.value})}/>
            </div>
            <div className="field">
              <label className="label">Intención</label>
              <input className="input" value={fs.intencion} onChange={e=>setFs({...fs, intencion:e.target.value})}/>
            </div>
            <TagInput label="Referencias" value={fs.referencias||[]} onChange={arr=>setFs({...fs, referencias:arr})}/>
            <TagInput label="Salidas esperadas" value={fs.salidas_esperadas||[]} onChange={arr=>setFs({...fs, salidas_esperadas:arr})}/>
            <div className="actions">
              <button className="btn" onClick={saveFS} disabled={step>0}>Guardar FS</button>
            </div>
          </section>

          {/* Promote */}
          <section className="card">
            <h2>2. Promote</h2>
            <div className="field">
              <label className="label">Microsello (.md)</label>
              <input className="input" value={file} onChange={e=>setFile(e.target.value)}/>
              <p className="help">Ej: docs/ritual/microsellos/QEL_MicroSello_....md</p>
            </div>
            <div className="field-row">
              <div className="field"><label className="label">Rubro</label><input className="input" value={rubro} onChange={e=>setRubro(e.target.value)}/></div>
              <div className="field"><label className="label">Título</label><input className="input" value={titulo} onChange={e=>setTitulo(e.target.value)}/></div>
              <div className="field"><label className="label">Rumbo</label><input className="input" value={rumboUI} onChange={e=>setRumboUI(e.target.value)}/></div>
            </div>
            <div className="actions">
              <button className="btn" onClick={runPromote} disabled={step<1}>Promote</button>
            </div>
          </section>

          {/* Microreg */}
          <section className="card">
            <h2>3. Microregistro</h2>
            <div className="actions">
              <button className="btn" onClick={runMicroreg} disabled={step<2}>Microreg</button>
            </div>
          </section>

          {/* Finalize */}
          <section className="card">
            <h2>4. Finalize</h2>
            <div className="field-row">
              <div className="field"><label className="label">SeedI</label><input className="input" value={seed} onChange={e=>setSeed(e.target.value)}/></div>
              <div className="field"><label className="label">CUE</label><input className="input" value={cue} onChange={e=>setCue(e.target.value)}/></div>
              <div className="field"><label className="label">Veredicto</label><input className="input" value={vf} onChange={e=>setVf(e.target.value)}/></div>
            </div>
            <div className="actions">
              <button className="btn" onClick={runFinalize} disabled={step<3}>Finalize</button>
            </div>
          </section>
        </div>

        {/* Logs */}
        <div className="col">
          <section className="card">
            <h2>Log en vivo</h2>
            <div className="logbox" aria-live="polite">
              {logs.length ? <pre className="log">{logs.join('\n')}</pre> : <p className="help">Sin salida aún.</p>}
            </div>
          </section>
        </div>
      </div>
    </div>
  );
}
