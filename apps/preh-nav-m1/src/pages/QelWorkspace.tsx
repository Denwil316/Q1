import React, { useEffect, useRef, useState } from 'react';
import TagInput from '../components/TagInput';
import Stepper from '../components/Stepper';

type Delta = 'up'|'flat'|'down';

export default function QelWorkspace() {
  // ---------- Vcalc ----------
  const [obj, setObj] = useState<string>('Kael/Prisma');
  const [A, setA] = useState<number>(0.62);
  const [rumbo, setRumbo] = useState<string>('C');
  const [clase, setClase] = useState<string>('singular');
  const [gates, setGates] = useState<string[]>(['no_mentira','doble_testigo']);
  const [ruido, setRuido] = useState<number>(0.12);
  const [deltaC, setDeltaC] = useState<Delta>('flat');
  const [deltaS, setDeltaS] = useState<Delta>('flat');
  const [vcalcOut, setVcalcOut] = useState<any>(null);
  const runVcalc = async () => {
    setVcalcOut(null);
    const payload = {
      obj, A, rumbo, clase,
      gates: gates.join(','),
      ruido,
      delta: { c: deltaC, s: deltaS }
    };
    const r = await fetch('/api/v1/vcalc', { method:'POST', headers:{'Content-Type':'application/json'}, body: JSON.stringify(payload)}).then(r=>r.json());
    setVcalcOut(r);
  };

  // ---------- LL_PE ----------
  const [vfPath, setVfPath] = useState<string>('docs/core/cartas/LLPE_Kosmos8_Primera_v1.3.yaml');
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
    const r = await fetch('/api/v1/llpe', { method:'POST', headers:{'Content-Type':'application/json'}, body: JSON.stringify(payload)}).then(r=>r.json());
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
    const r = await fetch('/api/v1/diario/sistema/append', { method:'POST', headers:{'Content-Type':'application/json'}, body: JSON.stringify(payload)}).then(r=>r.json());
    setDsResp(r);
  };

  // ---------- Hash de FS ----------
  const [fsFile, setFsFile] = useState<string>('docs/fs/FS_251020.json');
  const [fsJson, setFsJson] = useState<string>('');
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

    const r = await fetch('/api/v1/fs/hash', { method:'POST', headers:{'Content-Type':'application/json'}, body: JSON.stringify(payload)}).then(r=>r.json());
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
            <h2>Vcalc</h2>
            <div className="field">
              <label className="label">Objeto</label>
              <input className="input" value={obj} onChange={e=>setObj(e.target.value)}/>
            </div>
            <div className="field-row">
              <div className="field"><label className="label">Afinidad (A)</label><input className="input" type="number" step="0.0001" value={A} onChange={e=>setA(Number(e.target.value))}/></div>
              <div className="field"><label className="label">Rumbo</label>
                <select className="input" value={rumbo} onChange={e=>setRumbo(e.target.value)}>
                  <option>C</option><option>N</option><option>S</option><option>E</option><option>W</option><option>O</option>
                </select>
              </div>
              <div className="field"><label className="label">Clase</label>
                <select className="input" value={clase} onChange={e=>setClase(e.target.value)}>
                  <option>basica</option><option>singular</option><option>rara</option><option>único</option><option>metálica</option><option>obsidiana</option>
                </select>
              </div>
              <div className="field"><label className="label">Ruido</label><input className="input" type="number" min="0" max="1" step="0.01" value={ruido} onChange={e=>setRuido(Number(e.target.value))}/></div>
            </div>
            <TagInput label="Gates" value={gates} onChange={setGates} help="Ej: no_mentira, doble_testigo, ..." />
            <div className="field-row">
              <div className="field"><label className="label">Δc</label>
                <select className="input" value={deltaC} onChange={e=>setDeltaC(e.target.value as Delta)}>
                  <option value="down">down</option><option value="flat">flat</option><option value="up">up</option>
                </select>
              </div>
              <div className="field"><label className="label">Δs</label>
                <select className="input" value={deltaS} onChange={e=>setDeltaS(e.target.value as Delta)}>
                  <option value="down">down</option><option value="flat">flat</option><option value="up">up</option>
                </select>
              </div>
            </div>
            <div className="actions">
              <button className="btn" onClick={runVcalc}>Calcular</button>
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
