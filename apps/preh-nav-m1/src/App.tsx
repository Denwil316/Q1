// [QEL::ECO[96]::RECALL A96-250817-PREH-NAV-REHIDRATA]
// apps/preh-nav-m1/src/App.tsx
// [QEL::PREH-NAV ::RECALL A37-251021-ALTAR] App raíz con ruta /ritual
import React from 'react'
import { BrowserRouter, Routes, Route, Link, Outlet, useNavigate } from 'react-router-dom'
import Sidebar from './components/Sidebar'
import { useManifest } from './components/ManifestContext'
import RitualStudio from './pages/RitualStudio'
import QelWizard from './pages/QelWizard'
import QelWorkspace from './pages/QelWorkspace'
import './styles.css'

function Shell() {
  const nav = useNavigate()
  const { reload } = useManifest()

  return (
    <div className="layout">
      <aside className="sidebar">
        <Sidebar onOpenPath={(slug)=> nav(`/doc/${slug}`)} />
      </aside>
      <main className="main">
        <header className="topbar">
          <Link to="/" className="brand">PREH-NAV · QEL</Link>
          <button onClick={reload} style={{marginLeft:12}}>Actualizar listado</button>
          <Link to="/ritual" style={{marginLeft:'auto', fontSize:12}}>Ritual Studio</Link>
        </header>
        <section className="content">
          <Outlet />
        </section>
      </main>
    </div>
  )
}

function Home() {
  return (
    <div style={{ padding: 16 }}>
      <h3>Bienvenida a PREH-NAV</h3>
      <p className="small">Usa la barra lateral para abrir documentos. Si no ves nada, copia tu manifest y docs (ver README).</p>
      <p><Link to="/ritual">Ir a Ritual Studio</Link></p>
    </div>
  )
}

export default function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route element={<Shell />}>
          <Route index element={<Home />} />
          <Route path="ritual" element={<RitualStudio />} />
          <Route path="ritual" element={<RitualStudio />} />
          <Route path="wizard" element={<QelWizard />} />
          <Route path="workspace" element={<QelWorkspace />} />
          {/* Si ya tienes rutas de documentos, mantenlas aquí */}
          {/* <Route path="doc/:slug" element={<DocViewer />} /> */}
        </Route>
      </Routes>
    </BrowserRouter>
  )
}
