import React, { useEffect, useMemo, useState } from "react";

type Mode = "M1" | "M2" | "M3";
type Delta = "up" | "flat" | "down";
type Rumbo = "N" | "S" | "E" | "W" | "O" | "C";

const RUMBOS: Rumbo[] = ["N", "S", "E", "W", "O", "C"];
const CLASES = ["basica", "básica", "raro", "rara", "singular", "unico", "único", "metalica", "metálica", "obsidiana"];
const STORAGE_KEY = "qel:vcalc:last";

const num = (v: any, d = 0) => {
  const n = Number(v);
  return Number.isFinite(n) ? n : d;
};

function buildQuery(params: Record<string, any>) {
  const q = new URLSearchParams();
  for (const [k, v] of Object.entries(params)) {
    if (v === undefined || v === null) continue;
    const s = typeof v === "string" ? v.trim() : v;
    if (s === "" || Number.isNaN(s)) continue;
    q.set(k, String(s));
  }
  return q.toString();
}

export default function VcalcPage() {
  const [mode, setMode] = useState<Mode>("M1");
  const [obj, setObj] = useState<string>("");
  const [triada, setTriada] = useState<string>("SIL·UM·Ə");
  const [rumbo, setRumbo] = useState<Rumbo>("C");
  const [clase, setClase] = useState<string>("singular");
  const [gates, setGates] = useState<string>("no_mentira,doble_testigo");
  const [ruido, setRuido] = useState<number>(0);

  // M1: afinidad simple
  const [A, setA] = useState<number>(0.6);

  // M2: pesos y afinidades
  const [w1, setW1] = useState<number>(0.5);
  const [w2, setW2] = useState<number>(0.3);
  const [w3, setW3] = useState<number>(0.2);
  const [a1, setA1] = useState<number>(0.7);
  const [a2, setA2] = useState<number>(0.9);
  const [a3, setA3] = useState<number>(0.8);

  // M3: deltas
  const [deltaC, setDeltaC] = useState<Delta>("flat");
  const [deltaS, setDeltaS] = useState<Delta>("flat");

  // cargar guardado
  useEffect(() => {
    try {
      const raw = localStorage.getItem(STORAGE_KEY);
      if (!raw) return;
      const s = JSON.parse(raw);
      setMode(s.mode ?? "M1");
      setObj(s.obj ?? "");
      setTriada(s.triada ?? "SIL·UM·Ə");
      setRumbo((s.rumbo ?? "C") as Rumbo);
      setClase(s.clase ?? "singular");
      setGates(s.gates ?? "no_mentira,doble_testigo");
      setRuido(num(s.ruido, 0));
      setA(num(s.A, 0.6));
      setW1(num(s.w1, 0.5));
      setW2(num(s.w2, 0.3));
      setW3(num(s.w3, 0.2));
      setA1(num(s.a1, 0.7));
      setA2(num(s.a2, 0.9));
      setA3(num(s.a3, 0.8));
      setDeltaC((s.deltaC ?? "flat") as Delta);
      setDeltaS((s.deltaS ?? "flat") as Delta);
    } catch {}
  }, []);

  // guardar
  useEffect(() => {
    const s = { mode, obj, triada, rumbo, clase, gates, ruido, A, w1, w2, w3, a1, a2, a3, deltaC, deltaS };
    try { localStorage.setItem(STORAGE_KEY, JSON.stringify(s)); } catch {}
  }, [mode, obj, triada, rumbo, clase, gates, ruido, A, w1, w2, w3, a1, a2, a3, deltaC, deltaS]);

  const qs = useMemo(() => {
    const base: Record<string, any> = {
      m: mode, obj, triada, rumbo, clase, gates,
      ruido: Math.max(0, Math.min(ruido, 1)).toFixed(2),
    };
    if (mode === "M1") {
      base.A = num(A, 0.6).toFixed(4);
    } else if (mode === "M2") {
      base.w1 = num(w1, 0.5).toFixed(2);
      base.w2 = num(w2, 0.3).toFixed(2);
      base.w3 = num(w3, 0.2).toFixed(2);
      base.a1 = num(a1, 0.7).toFixed(2);
      base.a2 = num(a2, 0.9).toFixed(2);
      base.a3 = num(a3, 0.8).toFixed(2);
      base.m2 = 1; // compatibilidad
    } else if (mode === "M3") {
      base.dc = deltaC;
      base.ds = deltaS;
      // puedes combinar con M2:
      base.w1 = num(w1, 0.5).toFixed(2);
      base.w2 = num(w2, 0.3).toFixed(2);
      base.w3 = num(w3, 0.2).toFixed(2);
      base.a1 = num(a1, 0.7).toFixed(2);
      base.a2 = num(a2, 0.9).toFixed(2);
      base.a3 = num(a3, 0.8).toFixed(2);
    }
    return buildQuery(base);
  }, [mode, obj, triada, rumbo, clase, gates, ruido, A, w1, w2, w3, a1, a2, a3, deltaC, deltaS]);

  const url = useMemo(() => `/vcalc.html?${qs}`, [qs]);

  const copyUrl = async () => {
    try {
      await navigator.clipboard.writeText(url);
      alert("URL copiada al portapapeles");
    } catch {
      // fallback mínimo
    }
  };

  const applyPresetM3 = () => {
    setMode("M3");
    setObj("Llave");
    setTriada("SIL·UM·Ə");
    setRumbo("N");
    setClase("singular");
    setGates("no_mentira,doble_testigo");
    setRuido(0.08);
    setDeltaC("up");
    setDeltaS("flat");
    setW1(0.40); setW2(0.35); setW3(0.25);
    setA1(0.55); setA2(0.95); setA3(0.75);
  };

  return (
    <div className="page-wrap">
      <h1 className="title">Altar · VCALC (M1/M2/M3)</h1>

      {/* Card única: solo controles + acciones; sin iframe */}
      <div className="card" style={{ maxWidth: 980 }}>
        <div className="row two">
          <div>
            <label>Modo</label>
            <select value={mode} onChange={e => setMode(e.target.value as Mode)}>
              <option>M1</option>
              <option>M2</option>
              <option>M3</option>
            </select>
          </div>
          <div style={{ display: "flex", gap: ".5rem", alignItems: "end", justifyContent: "flex-end" }}>
            <a className="ghost" href={url} target="_blank" rel="noreferrer">Abrir calculadora clásica ↗</a>
            <button onClick={copyUrl} title="Copiar URL">Copiar URL</button>
            <button onClick={applyPresetM3} title="Ejemplo M3">Preset M3</button>
          </div>
        </div>

        <div className="row">
          <label>Objeto</label>
          <input value={obj} onChange={e=>setObj(e.target.value)} placeholder="p. ej. Llave / Prisma / ..." />
        </div>

        <div className="row">
          <label>Triada</label>
          <input value={triada} onChange={e=>setTriada(e.target.value)} placeholder="SIL·UM·Ə" />
        </div>

        <div className="row two">
          <div>
            <label>Rumbo</label>
            <select value={rumbo} onChange={e=>setRumbo(e.target.value as Rumbo)}>
              {RUMBOS.map(r => <option key={r} value={r}>{r}</option>)}
            </select>
          </div>
          <div>
            <label>Clase</label>
            <select value={clase} onChange={e=>setClase(e.target.value)}>
              {CLASES.map(c => <option key={c} value={c}>{c}</option>)}
            </select>
          </div>
        </div>

        <div className="row">
          <label>Gates (coma)</label>
          <input value={gates} onChange={e=>setGates(e.target.value)} placeholder="no_mentira,doble_testigo" />
        </div>

        <div className="row">
          <label>Ruido: {ruido.toFixed(2)}</label>
          <input type="range" min={0} max={1} step={0.01} value={ruido} onChange={e=>setRuido(Number(e.target.value))} />
        </div>

        {mode === "M1" && (
          <div className="row">
            <label>Afinidad A: {A.toFixed(4)}</label>
            <input type="range" min={0} max={1} step={0.0001} value={A} onChange={e=>setA(Number(e.target.value))} />
          </div>
        )}

        {(mode === "M2" || mode === "M3") && (
          <>
            <div className="row two">
              <div>
                <label>w1: {w1.toFixed(2)}</label>
                <input type="range" min={0} max={1} step={0.01} value={w1} onChange={e=>setW1(Number(e.target.value))} />
              </div>
              <div>
                <label>w2: {w2.toFixed(2)}</label>
                <input type="range" min={0} max={1} step={0.01} value={w2} onChange={e=>setW2(Number(e.target.value))} />
              </div>
            </div>
            <div className="row two">
              <div>
                <label>w3: {w3.toFixed(2)}</label>
                <input type="range" min={0} max={1} step={0.01} value={w3} onChange={e=>setW3(Number(e.target.value))} />
              </div>
              <div>
                <label>a1: {a1.toFixed(2)}</label>
                <input type="range" min={0} max={1} step={0.01} value={a1} onChange={e=>setA1(Number(e.target.value))} />
              </div>
            </div>
            <div className="row two">
              <div>
                <label>a2: {a2.toFixed(2)}</label>
                <input type="range" min={0} max={1} step={0.01} value={a2} onChange={e=>setA2(Number(e.target.value))} />
              </div>
              <div>
                <label>a3: {a3.toFixed(2)}</label>
                <input type="range" min={0} max={1} step={0.01} value={a3} onChange={e=>setA3(Number(e.target.value))} />
              </div>
            </div>
          </>
        )}

        {mode === "M3" && (
          <div className="row two">
            <div>
              <label>Δc</label>
              <select value={deltaC} onChange={e=>setDeltaC(e.target.value as Delta)}>
                <option value="up">up</option>
                <option value="flat">flat</option>
                <option value="down">down</option>
              </select>
            </div>
            <div>
              <label>Δs</label>
              <select value={deltaS} onChange={e=>setDeltaS(e.target.value as Delta)}>
                <option value="up">up</option>
                <option value="flat">flat</option>
                <option value="down">down</option>
              </select>
            </div>
          </div>
        )}

        <div className="row">
          <label>URL generada</label>
          <input value={url} readOnly />
        </div>

        <p style={{ opacity:.8, fontSize: ".9rem", marginTop: ".5rem" }}>
          La calculadora clásica se abre en una pestaña aparte para maximizar el espacio de trabajo en el Altar.
        </p>
      </div>
    </div>
  );
}
