// [QEL::ECO[96]::RECALL A96-250817-PREH-NAV-REHIDRATA]
import { Outlet, Link, useNavigate } from 'react-router-dom'
import Sidebar from './components/Sidebar'
import { useManifest } from './components/ManifestContext'
import './styles.css'
export default function App(){
  const nav = useNavigate()
  const { reload } = useManifest()
  return (
    <div className="layout">
      <aside className="sidebar"><Sidebar onOpenPath={(slug)=> nav(`/doc/${slug}`)} /></aside>
      <main className="main">
        <header className="topbar">
          <Link to="/" className="brand">PREH-NAV · QEL</Link>
          <button onClick={reload} style={{marginLeft:12}}>Actualizar listado</button>
        </header>        
        <section className="content">
          <div className="welcome">
            <h3>Bienvenida a PREH-NAV</h3>
            <p className="small">Usa la barra lateral para abrir documentos. Si no ves nada, copia tu manifest y docs (ver README).</p>
          </div>
          <Outlet />
        </section>
      </main>
    </div>
  )
}
