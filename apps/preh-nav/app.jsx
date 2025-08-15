cat > apps/preh-nav/app.jsx <<'JSX'
/* [QEL::ECO[96]::RECALL A96-250815-NAVEGADOR-REACT-M0]
   SeedI=PREH-NAV::M0
   SOT=PREH-NAV/v0.2 TARGET=react|navegador|m0
   VERSION=v0.2 UPDATED=2025-08-15 */

const DATA = {
  meta: {
    fecha: "250815",
    tema: "desarrollo de Navegador Qel",
    intencion: "dejar una interfaz en React navegable",
    modo: "M0",
    rumbo: ["O","S","Centro"],
    tiempo: 30,
    referencias: ["/docs/core"],
    salidas_esperadas: ["Germinación"],
    metricas: { delta_c: "", delta_s: "", V: null, no_mentira: true },
    testigos: { t1: "A81", t2: "A96" },
    triada: "UM-Ə-THON",
    mantra: "Un tejido que refleje lo estudiado en una interfaz que me permita aprender"
  },
  sections: [
    {
      key: "core",
      title: "Core (vivos)",
      tags: ["Diario","Glosario","MFH","Sellos/Cues","Guía SoT"],
      items: [
        { name: "QEL_Diario_del_Conjurador_v1.2.md", path: "/docs/core/QEL_Diario_del_Conjurador_v1.2.md" },
        { name: "QEL_Glosario_v1.2.md", path: "/docs/core/QEL_Glosario_v1.2.md" },
        { name: "QEL_Matriz_Fonemica_Habilidades_v1.2.md", path: "/docs/core/QEL_Matriz_Fonemica_Habilidades_v1.2.md" },
        { name: "QEL_Sellos_y_Cues_Idriell_v1.0.md", path: "/docs/core/QEL_Sellos_y_Cues_Idriell_v1.0.md" },
        { name: "QEL_SoT_Study_Guide_v1.0.md", path: "/memory/QEL_SoT_Study_Guide_v1.0.md" }
      ]
    },
    {
      key: "ritual",
      title: "Ritual",
      tags: ["Meditaciones","Poema-Enigma","CueMachine"],
      items: [
        { name: "QEL_Meditaciones_Primordiales_v1.0.md", path: "/docs/ritual/QEL_Meditaciones_Primordiales_v1.0.md" },
        { name: "QEL_Meditacion_Reiteracion_Lun-Nai_v1.1.md", path: "/docs/ritual/QEL_Meditacion_Reiteracion_Lun-Nai_v1.1.md" },
        { name: "QEL_Poema_Enigma_VF_v1.0.md", path: "/docs/ritual/QEL_Poema_Enigma_VF_v1.0.md" },
        { name: "QEL_Sellos_y_Cues_Idriell_v1.0.md", path: "/docs/ritual/QEL_Sellos_y_Cues_Idriell_v1.0.md" }
      ]
    },
    {
      key: "history",
      title: "Historial",
      tags: ["Versiones previas","Manifiestos"],
      items: [
        { name: "QEL_SoT_Manifest_v0.5.json", path: "/docs/history/QEL_SoT_Manifest_v0.5.json" },
        { name: "QEL_Diario_del_Conjurador_v1.1.md", path: "/docs/history/QEL_Diario_del_Conjurador_v1.1.md" }
      ]
    },
    {
      key: "memory",
      title: "Memoria",
      tags: ["Ledger","Índices","Objetos"],
      items: [
        { name: "QEL_Index_v1.1.md", path: "/memory/QEL_Index_v1.1.md" },
        { name: "QEL_Chat_Index.md", path: "/memory/QEL_Chat_Index.md" },
        { name: "Memoria_de_Qel_Ledger_v0.2.json", path: "/memory/Memoria_de_Qel_Ledger_v0.2.json" }
      ]
    }
  ]
};

function Header({meta}) {
  return (
    <div className="glass header" style={{marginBottom:16}}>
      <div className="h1">PREH · Navegador Qel <span className="pill">M0</span></div>
      <div className="muted">FS · {meta.fecha} · rumbo: {meta.rumbo.join(" / ")} · triada: {meta.triada}</div>
    </div>
  );
}

function Section({section, query}) {
  const q = query.toLowerCase();
  const items = section.items.filter(it => it.name.toLowerCase().includes(q));
  return (
    <div className="glass" style={{marginBottom:16}}>
      <div style={{display:"flex", alignItems:"center", justifyContent:"space-between"}}>
        <h3>{section.title}</h3>
        <div>
          {section.tags.map(t => <span key={t} className="tag">{t}</span>)}
        </div>
      </div>
      <div className="list">
        {items.map(it => (
          <div key={it.name} className="card">
            <div style={{display:"flex", justifyContent:"space-between"}}>
              <strong>{it.name}</strong>
              <span className="muted">↗</span>
            </div>
            <div className="muted">{it.path}</div>
            <div style={{marginTop:8}}>
              <a href={it.path} target="_blank" rel="noreferrer" className="btn">Abrir</a>
            </div>
          </div>
        ))}
        {items.length===0 && <div className="muted">No hay resultados.</div>}
      </div>
    </div>
  );
}

function App() {
  const [query, setQuery] = React.useState("");
  return (
    <div className="wrap">
      <Header meta={DATA.meta} />
      <div className="row">
        <div className="col">
          <input placeholder="Busca por nombre (p.ej., 'Diario', 'MFH', 'CUE')" value={query} onChange={e=>setQuery(e.target.value)} />
        </div>
        <div className="col">
          <a className="btn" href="/ESTRUCTURA.md" target="_blank" rel="noreferrer">Abrir ESTRUCTURA.md</a>
        </div>
      </div>

      {DATA.sections.map(sec => <Section key={sec.key} section={sec} query={query} />)}
      <div className="muted" style={{marginTop:16}}>
        Germinación M0: interfaz simple sin router ni build; lista indexable. Para M1, migrar a Vite/Next y leer un manifest JSON autogenerado del repo.
      </div>
    </div>
  );
}

const root = ReactDOM.createRoot(document.getElementById('root'));
root.render(<App />);
JSX
