import React, { useState } from 'react';
import TagInput from '../components/TagInput';

type Delta = 'up'|'flat'|'down';

export default function VcalcPage() {
  const [obj, setObj] = useState('Kael/Prisma');
  const [A, setA] = useState(0.62);
  const [rumbo, setRumbo] = useState('C');
  const [clase, setClase] = useState('singular');
  const [gates, setGates] = useState<string[]>(['no_mentira','doble_testigo']);
  const [ruido, setRuido] = useState(0.12);
  const [deltaC, setDeltaC] = useState<Delta>('flat');
  const [deltaS, setDeltaS] = useState<Delta>('flat');

  const [out, setOut] = useState<any>(null);
  const run = async () => {
    const payload = { obj, A, rumbo, clase, gates: gates.join(','), ruido, delta: { c: deltaC, s: deltaS } };
    const r = await fetch('/api/v1/vcalc', { method:'POST', headers:{'Content-Type':'application/json'}, body: JSON.stringify(payload) }).then(r=>r.json());
    setOut(r);
  };

  return (
    <div className="ritual">
      <div className="ritual-header">
        <h1>VCALC</h1>
      </div>

      <div className="grid">
        <div className="col">
          <section className="card">
            <h2>Parámetros</h2>
            <div className="field">
              <label className="label">Objeto</label>
              <input className="input" value={obj} onChange={e=>setObj(e.target.value)} />
            </div>
            <div className="field-row">
              <div className="field"><label className="label">Afinidad (A)</label><input className="input" type="number" step="0.0001" value={A} onChange={e=>setA(Number(e.target.value))} /></div>
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

            <TagInput label="Gates" value={gates} onChange={setGates} help="Ej: no_mentira, doble_testigo..." />

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
              <button className="btn" onClick={run}>Calcular</button>
            </div>
          </section>
        </div>

        <div className="col">
          <section className="card">
            <h2>Salida</h2>
            <div className="jsonbox">
              <pre className="json">{out ? JSON.stringify(out, null, 2) : '// sin cálculo'}</pre>
            </div>
          </section>
        </div>
      </div>
    </div>
  );
}
