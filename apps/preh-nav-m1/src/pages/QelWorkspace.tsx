import React, { useEffect, useRef, useState, useMemo } from 'react';
import TagInput from '../components/TagInput';
import Stepper from '../components/Stepper';
import { DEFAULT_PATHS } from '../config/paths';

type Mode = 'M1'|'M2'|'M3';
type Delta = 'up'|'flat'|'down';
type Rumbo = 'N'|'S'|'E'|'W'|'O'|'C';

const RUMBOS: Rumbo[] = ['N','S','E','W','O','C'];
const CLASES = ['basica','básica','raro','rara','singular','unico','único','metalica','metálica','obsidiana'];
const STORAGE_KEY = 'qel:workspace:vcalc:last';

function num(v: any, d = 0) {
  const n = Number(v);
  return Number.isFinite(n) ? n : d;
}
function buildQuery(params: Record<string, any>) {
  const q = new URLSearchParams();
  for (const [k, v] of Object.entries(params)) {
    if (v === undefined || v === null) continue;
    const s = typeof v === 'string' ? v.trim() : v;
    if (s === '' || Number.isNaN(s)) continue;
    q.set(k, String(s));
  }
  return q.toString();
}

export default function QelWorkspace() {
  // ---------- VCALC (moderna + enlace a clásica) ----------
  const [mode, setMode]     = useState<Mode>('M1');
  const [obj, setObj]       = useState<string>('Kael/Prisma');
  const [triada, setTriada] = useState<string>('SIL·UM·Ə');
  const [A, setA]           = useState<number>(0.62);
  const [rumbo, setRumbo]   = useState<Rumbo>('C');
  const [clase, setClase]   = useState<string>('singular');
  const [gates, setGates]   = useState<string[]>(['no_mentira','doble_testigo']);
  const [ruido, setRuido]   = useState<number>(0.12);
  // M2/M3 params
  const [w1, setW1] = useState<number>(0.40);
  const [w2, setW2] = useState<number>(0.35);
  const [w3, setW3] = useState<number>(0.25);
  const [a1, setA1] = useState<number>(0.55);
  const [a2, setA2] = useState<number>(0.95);
  const [a3, setA3] = useState<number>(0.75);
  const [deltaC, setDeltaC] = useState<Delta>('flat');
  const [deltaS, setDeltaS] = useState<Delta>('flat');

  const [vcalcOut, setVcalcOut] = useState<any>(null);

  // cargar guardado
  useEffect(() => {
    try {
      const raw = localStorage.getItem(STORAGE_KEY);
      if (!raw) return;
      const s = JSON.parse(raw);
      setMode(s.mode ?? 'M1');
      setObj(s.obj ?? 'Kael/Prisma');
      setTriada(s.triada ?? 'SIL·UM·Ə');
      setA(num(s.A, 0.62));
      setRumbo((s.rumbo ?? 'C') as Rumbo);
      setClase(s.clase ?? 'singular');
      setGates(Array.isArray(s.gates) ? s.gates : String(s.gates||'').split(',').filter(Boolean));
      setRuido(num(s.ruido, 0.12));
      setW1(num(s.w1, 0.40));
      setW2(num(s.w2, 0.35));
      setW3(num(s.w3, 0.25));
      setA1(num(s.a1, 0.55));
      setA2(num(s.a2, 0.95));
      setA3(num(s.a3, 0.75));
      setDeltaC((s.deltaC ?? 'flat') as Delta);
      setDeltaS((s.deltaS ?? 'flat') as Delta);
    } catch {}
  }, []);
  // guardar
  useEffect(() => {
    const s = { mode, obj, triada, A, rumbo, clase, gates, ruido, w1, w2, w3, a1, a2, a3, deltaC, deltaS };
    try { localStorage.setItem(STORAGE_KEY, JSON.stringify(s)); } catch {}
  }, [mode, obj, triada, A, rumbo, clase, gates, ruido, w1, w2, w3, a1, a2, a3, deltaC, deltaS]);

  // URL compatible con la calculadora clásica (vcalc.html)
  const vcalcClassicQS = useMemo(() => {
    const base: Record<string, any> = {
      m: mode, obj, triada, rumbo, clase, gates: gates.join(','),
      ruido: Math.max(0, Math.min(ruido, 1)).toFixed(2),
    };
    if (mode === 'M1') {
      base.A = num(A, 0.6).toFixed(4);
    } else if (mode === 'M2') {
      base.w1 = num(w1, 0.5).toFixed(2);
      base.w2 = num(w2, 0.3).toFixed(2);
      base.w3 = num(w3, 0.2).toFixed(2);
      base.a1 = num(a1, 0.7).toFixed(2);
      base.a2 = num(a2, 0.9).toFixed(2);
      base.a3 = num(a3, 0.8).toFixed(2);
      base.m2 = 1;
    } else if (mode === 'M3') {
      base.dc = deltaC;
      base.ds = deltaS;
      base.w1 = num(w1, 0.5).toFixed(2);
      base.w2 = num(w2, 0.3).toFixed(2);
      base.w3 = num(w3, 0.2).toFixed(2);
      base.a1 = num(a1, 0.7).toFixed(2);
      base.a2 = num(a2, 0.9).toFixed(2);
      base.a3 = num(a3, 0.8).toFixed(2);
    }
    return buildQuery(base);
  }, [mode, obj, triada, rumbo, clase, gates, ruido, A, w1, w2, w3, a1, a2, a3, deltaC, deltaS]);
  const vcalcClassicURL = useMemo(() => `/vcalc.html?${vcalcClassicQS}`, [vcalcClassicQS]);

  // calcular vía API moderna (no usa triada ni w*/a* porque la API actual no los requiere)
  const runVcalc = async () => {
    setVcalcOut(null);
    const payload = {
      obj,
      A,
      rumbo,
      clase,
      gates: gates.join(','),
      ruido,
      delta: { c: deltaC, s: deltaS },
    };
    const r = await fetch('/api/v1/vcalc', {
      method:'POST',
      headers:{'Content-Type':'application/json'},
      body: JSON.stringify(payload)
    }).then(r=>r.json());
    setVcalcOut(r);
  };

  // ---------- LL_PE ----------
  const [vfPath, setVfPath] = useState<string>(DEFAULT_PATHS.vf);
  const [seed, setSeed] = useState<string>('');
  const [cue,  setCue]  = useState<string>('');
  const [materia, setMateria] = useState<string>('');
  const [nutriaDir, setNutriaDir] = useState<string>('');
  const [llpeLogs, setLlpeLogs] = useState<string[]>([]);
  const llpeSseRef = useRef<EventSource|null>(null);
  const llpeAppend = (s:string)=> setLlpeLogs(prev=>[...prev, s.replace(/\n+$/,'')]);

  const runLLPE = async () => {
    setLlpeLogs([]);
    const payload = { vf: vfPath, seed, cue, materia, nutriaDir };
    const r = await fetch('/api/v1/llpe', {
      method:'POST', headers:{'Content-Type':'application/json'}, body: JSON.stringify(payload)
    }).then(r=>r.json());
    if (r.ok && r.jobId) {
      const es = new EventSource(`/api/v1/logs/${r.jobId}`);
      llpeSseRef.current?.close(); llpeSseRef.current = es;
      es.onmessage = (ev) => {
        try {
          const data = JSON.parse(ev.data);
          if (data.line) llpeAppend(data.line);
          if (data.done) { llpeAppend(`[done code=${data.code}]`); es.close(); }
        } catch {}
      };
      es.onerror = () => es.close();
    } else {
      llpeAppend(`[llpe][error] ${r.error||'falló'}`);
    }
  };
  useEffect(()=> () => llpeSseRef.current?.close(), []);

  // ---------- Diario del Sistema ----------
  const [dsFecha, setDsFecha] = useState<string>(new Date().toISOString().slice(2,10).replace(/-/g,'').slice(2));
  const [dsModo,  setDsModo]  = useState<string>('M2');
  const [dsTema,  setDsTema]  = useState<string>('Laboratorio');
  const [dsInt,   setDsInt]   = useState<string>('Exploración guiada por VCALC/LL_PE');
  const [dsCue,   setDsCue]   = useState<string>('');
  const [dsSeed,  setDsSeed]  = useState<string>('');
  const [dsVF,    setDsVF]    = useState<string>('');
  const [dsFS,    setDsFS]    = useState<string>('');
  const [dsHash,  setDsHash]  = useState<string>('');
  const [dsNotas, setDsNotas] = useState<string>('');
  const [dsResp,  setDsResp]  = useState<any>(null);

  const appendDiarioSistema = async () => {
    const payload = {
      fecha: dsFecha, modo: dsModo, tema: dsTema, intencion: dsInt,
      cue: dsCue, seed: dsSeed, vf: dsVF, fsFile: dsFS, hash_fs10: dsHash,
      notas: dsNotas
    };
    const r = await fetch('/api/v1/diario/sistema/append', {
      method:'POST', headers:{'Content-Type':'application/json'}, body: JSON.stringify(payload)
    }).then(r=>r.json());
    setDsResp(r);
  };

  // ---------- Hash de FS ----------
  const [fsFile, setFsFile]   = useState<string>(DEFAULT_PATHS.fsDefault);
  const [fsJson, setFsJson]   = useState<string>('');
  const [hashOut, setHashOut] = useState<any>(null);
  const [saveSidecar, setSaveSidecar] = useState<boolean>(false);
  const hashFS = async () => {
    let payload: any = {};
    if (fsJson.trim()) {
      try { payload.fs = JSON.parse(fsJson); }
      catch { return setHashOut({ ok:false, error:'JSON inválido' }); }
    }
    if (fsFile.trim()) payload.file = fsFile;
    if (saveSidecar) payload.save = true;

    const r = await fetch('/api/v1/fs/hash', {
      method:'POST', headers:{'Content-Type':'application/json'}, body: JSON.stringify(payload)
    }).then(r=>r.json());
    setHashOut(r);
  };

  return (
    <div className="ritual">
      <div className="ritual-header">
        <h1>Laboratorio · M2/M3</h1>
        <div className="toolbar">
          <a className="btn" href="/library">Abrir Biblioteca</a>
        </div>
      </div>

      <Stepper steps={[
        { key:'vcalc', title:'Vcalc', state: 'current' },
        { key:'llpe',  title:'LL_PE', state: 'todo' },
        { key:'ds',    title:'Diario Sistema', state: 'todo' },
        { key:'hash',  title:'HASH_FS', state: 'todo' },
      ]} />

      <div className="grid">
        <div className="col">
          {/* VCALC */}
          <section className="card">
            <div style={{display:'flex', alignItems:'end', gap:'1rem', justifyContent:'space-between', flexWrap:'wrap'}}>
              <h2 style={{margin:0}}>VCALC</h2>
              <div style={{display:'flex', gap:'.5rem'}}>
                <select value={mode} onChange={e=>setMode(e.target.value as Mode)} className="input">
                  <option>M1</option><option>M2</option><option>M3</option>
                </select>
                <a className="btn ghost" href={vcalcClassicURL} target="_blank" rel="noreferrer">Abrir calculadora clásica ↗</a>
              </div>
            </div>

            <div className="field">
              <label className="label">Objeto</label>
              <input className="input" value={obj} onChange={e=>setObj(e.target.value)} placeholder="p. ej. Llave / Prisma / ..." />
            </div>

            <div className="field">
              <label className="label">Triada</label>
              <input className="input" value={triada} onChange={e=>setTriada(e.target.value)} placeholder="SIL·UM·Ə" />
            </div>

            <div className="field-row">
              <div className="field">
                <label className="label">Rumbo</label>
                <select className="input" value={rumbo} onChange={e=>setRumbo(e.target.value as Rumbo)}>
                  {RUMBOS.map(r => <option key={r} value={r}>{r}</option>)}
                </select>
              </div>
              <div className="field">
                <label className="label">Clase</label>
                <select className="input" value={clase} onChange={e=>setClase(e.target.value)}>
                  {CLASES.map(c => <option key={c} value={c}>{c}</option>)}
                </select>
              </div>
              <div className="field">
                <label className="label">Ruido</label>
                <input className="input" type="number" min="0" max="1" step="0.01" value={ruido} onChange={e=>setRuido(Number(e.target.value))}/>
              </div>
            </div>

            <TagInput label="Gates" value={gates} onChange={setGates} help="Ej: no_mentira, doble_testigo, ..." />

            {mode === 'M1' && (
              <div className="field">
                <label className="label">Afinidad A</label>
                <input className="input" type="number" min="0" max="1" step="0.0001" value={A} onChange={e=>setA(Number(e.target.value))}/>
              </div>
            )}

            {(mode === 'M2' || mode === 'M3') && (
              <>
                <div className="field-row">
                  <div className="field"><label className="label">w1</label><input className="input" type="number" min="0" max="1" step="0.01" value={w1} onChange={e=>setW1(Number(e.target.value))}/></div>
                  <div className="field"><label className="label">w2</label><input className="input" type="number" min="0" max="1" step="0.01" value={w2} onChange={e=>setW2(Number(e.target.value))}/></div>
                  <div className="field"><label className="label">w3</label><input className="input" type="number" min="0" max="1" step="0.01" value={w3} onChange={e=>setW3(Number(e.target.value))}/></div>
                </div>
                <div className="field-row">
                  <div className="field"><label className="label">a1</label><input className="input" type="number" min="0" max="1" step="0.01" value={a1} onChange={e=>setA1(Number(e.target.value))}/></div>
                  <div className="field"><label className="label">a2</label><input className="input" type="number" min="0" max="1" step="0.01" value={a2} onChange={e=>setA2(Number(e.target.value))}/></div>
                  <div className="field"><label className="label">a3</label><input className="input" type="number" min="0" max="1" step="0.01" value={a3} onChange={e=>setA3(Number(e.target.value))}/></div>
                </div>
              </>
            )}

            {mode === 'M3' && (
              <div className="field-row">
                <div className="field">
                  <label className="label">Δc</label>
                  <select className="input" value={deltaC} onChange={e=>setDeltaC(e.target.value as Delta)}>
                    <option value="up">up</option>
                    <option value="flat">flat</option>
                    <option value="down">down</option>
                  </select>
                </div>
                <div className="field">
                  <label className="label">Δs</label>
                  <select className="input" value={deltaS} onChange={e=>setDeltaS(e.target.value as Delta)}>
                    <option value="up">up</option>
                    <option value="flat">flat</option>
                    <option value="down">down</option>
                  </select>
                </div>
              </div>
            )}

            <div className="actions" style={{display:'flex', gap:'.5rem', flexWrap:'wrap'}}>
              <button className="btn" onClick={runVcalc}>Calcular</button>
              <a className="btn ghost" href={vcalcClassicURL} target="_blank" rel="noreferrer">Abrir calculadora clásica ↗</a>
            </div>

            <div className="field">
              <label className="label">URL clásica generada</label>
              <input className="input" value={vcalcClassicURL} readOnly />
            </div>

            <div className="jsonbox">
              <pre className="json">{vcalcOut ? JSON.stringify(vcalcOut, null, 2) : '// sin cálculo'}</pre>
            </div>
          </section>

          {/* Diario del Sistema */}
          <section className="card">
            <h2>Diario del Sistema</h2>
            <div className="field-row">
              <div className="field"><label className="label">Fecha</label><input className="input" value={dsFecha} onChange={e=>setDsFecha(e.target.value)}/></div>
              <div className="field"><label className="label">Modo</label>
                <select className="input" value={dsModo} onChange={e=>setDsModo(e.target.value)}>
                  <option>M2</option><option>M3</option><option>M1</option><option>M0</option>
                </select>
              </div>
              <div className="field"><label className="label">Tema</label><input className="input" value={dsTema} onChange={e=>setDsTema(e.target.value)}/></div>
              <div className="field"><label className="label">Intención</label><input className="input" value={dsInt} onChange={e=>setDsInt(e.target.value)}/></div>
            </div>
            <div className="field-row">
              <div className="field"><label className="label">CUE</label><input className="input" value={dsCue} onChange={e=>setDsCue(e.target.value)}/></div>
              <div className="field"><label className="label">SeedI</label><input className="input" value={dsSeed} onChange={e=>setDsSeed(e.target.value)}/></div>
              <div className="field"><label className="label">Veredicto</label><input className="input" value={dsVF} onChange={e=>setDsVF(e.target.value)}/></div>
              <div className="field"><label className="label">FS (archivo)</label><input className="input" value={dsFS} onChange={e=>setDsFS(e.target.value)}/></div>
            </div>
            <div className="field-row">
              <div className="field"><label className="label">HASH_FS(10)</label><input className="input" value={dsHash} onChange={e=>setDsHash(e.target.value)}/></div>
            </div>
            <div className="field">
              <label className="label">Notas</label>
              <textarea className="input" rows={4} value={dsNotas} onChange={e=>setDsNotas(e.target.value)} />
            </div>
            <div className="actions">
              <button className="btn" onClick={appendDiarioSistema}>Append Diario</button>
            </div>
            <div className="jsonbox">
              <pre className="json">{dsResp ? JSON.stringify(dsResp, null, 2) : '// sin respuesta'}</pre>
            </div>
          </section>
        </div>

        <div className="col">
          {/* LL_PE */}
          <section className="card">
            <h2>LL_PE</h2>
            <div className="field">
              <label className="label">VF (carta .yaml/.json)</label>
              <input className="input" value={vfPath} onChange={e=>setVfPath(e.target.value)}/>
            </div>
            <div className="field-row">
              <div className="field"><label className="label">SeedI</label><input className="input" value={seed} onChange={e=>setSeed(e.target.value)}/></div>
              <div className="field"><label className="label">CUE</label><input className="input" value={cue} onChange={e=>setCue(e.target.value)}/></div>
            </div>
            <div className="field-row">
              <div className="field"><label className="label">Materia</label><input className="input" value={materia} onChange={e=>setMateria(e.target.value)}/></div>
              <div className="field"><label className="label">Nutria dir (opcional)</label><input className="input" value={nutriaDir} onChange={e=>setNutriaDir(e.target.value)}/></div>
            </div>
            <div className="actions">
              <button className="btn" onClick={runLLPE}>Generar LL_PE</button>
            </div>
            <div className="logbox" aria-live="polite">
              {llpeLogs.length ? <pre className="log">{llpeLogs.join('\n')}</pre> : <p className="help">Sin salida aún.</p>}
            </div>
          </section>

          {/* HASH FS */}
          <section className="card">
            <h2>HASH de FS</h2>
            <div className="field">
              <label className="label">Archivo FS (.json)</label>
              <input className="input" value={fsFile} onChange={e=>setFsFile(e.target.value)}/>
            </div>
            <div className="field">
              <label className="label">o pega FS JSON</label>
              <textarea className="input" rows={6} value={fsJson} onChange={e=>setFsJson(e.target.value)} />
            </div>
            <div className="field">
              <label style={{display:'flex', gap:8, alignItems:'center'}}>
                <input type="checkbox" checked={saveSidecar} onChange={e=>setSaveSidecar(e.target.checked)} />
                Guardar sidecar .hash.json junto al FS
              </label>
            </div>
            <div className="actions">
              <button className="btn" onClick={hashFS}>Calcular HASH</button>
            </div>
            <div className="jsonbox">
              <pre className="json">{hashOut ? JSON.stringify(hashOut, null, 2) : '// sin cálculo'}</pre>
            </div>
          </section>
        </div>
      </div>
    </div>
  );
}
