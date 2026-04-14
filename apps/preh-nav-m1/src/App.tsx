// apps/preh-nav-m1/src/App.tsx
import React, { Suspense, lazy } from 'react'
import { BrowserRouter, Routes, Route, Link, Outlet, useNavigate, Navigate } from 'react-router-dom'
import Sidebar from './components/Sidebar'
import { useManifest } from './components/ManifestContext'
import DocViewer from './components/DocViewer'

import './styles.css'

const RitualStudio = lazy(() => import('./pages/RitualStudio'))
const QelWizard = lazy(() => import('./pages/QelWizard'))
const VcalcPage = lazy(() => import('./pages/VcalcPage'))
const QelWorkspace = lazy(() => import('./pages/QelWorkspace'))

function LoadingFallback() {
  return <div style={{ padding: 16 }}>Cargando...</div>
}

// Un “guard” para que si el Provider fallara, no truene la UI:
function useSafeManifest() {
  try {
    return useManifest()
  } catch {
    return { reload: () => {} } as { reload: () => void }
  }
}

function Shell() {
  const nav = useNavigate()
  const { reload } = useSafeManifest()

  return (
    <div className="layout">
      <aside className="sidebar">
        <Sidebar onOpenPath={(slug)=> nav(`/doc/${slug}`)} />
      </aside>
      <main className="main">
        <header className="topbar">
          <Link to="/" className="brand">PREH-NAV · QEL</Link>
          <button onClick={reload} style={{marginLeft:12}}>Actualizar listado</button>
          <Link to="/altar" style={{marginLeft:'auto', fontSize:12}}>Ritual Studio</Link>
          <nav style={{marginLeft:12, display:'flex', gap:8}}>
            <Link to="/via" style={{fontSize:12}}>Vía</Link>
            <Link to="/laboratorio" style={{fontSize:12}}>Laboratorio</Link>
          </nav>
          <nav className="topnav">
            <Link to="/altar">Altar</Link>
            <Link to="/via">Vía</Link>
            <Link to="/laboratorio">Laboratorio</Link>
            <Link to="/laboratorio/vcalc">VCALC</Link>
          </nav>
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
      <p><Link to="/altar">Ir a Ritual Studio</Link></p>
    </div>
  )
}

function LabLayout() {
  return (
    <div>
      {/* pestañas rápidas del laboratorio */}
      <nav style={{display:'flex', gap:8, marginBottom:12}}>
        <Link to="/laboratorio" className="pill">Workspace</Link>
        <Link to="/laboratorio/vcalc" className="pill">VCALC</Link>
      </nav>
      <Outlet />
    </div>
  )
}

export default function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route element={<Shell />}>
          <Route index element={<Home />} />
          <Route path="/" element={<Navigate to="/altar" replace />} />
          <Route path="altar" element={<Suspense fallback={<LoadingFallback />}><RitualStudio /></Suspense>} />
          <Route path="via" element={<Suspense fallback={<LoadingFallback />}><QelWizard /></Suspense>} />
          <Route path="doc/:slug" element={<DocViewer />} />

          {/* Laboratorio con VCALC anidado */}
          <Route path="laboratorio" element={<LabLayout />}>
            <Route index element={<Suspense fallback={<LoadingFallback />}><QelWorkspace /></Suspense>} />
            <Route path="vcalc" element={<Suspense fallback={<LoadingFallback />}><VcalcPage /></Suspense>} />
          </Route>

          {/* Compatibilidad: /vcalc → /laboratorio/vcalc */}
          <Route path="vcalc" element={<Navigate to="/laboratorio/vcalc" replace />} />
        </Route>
      </Routes>
    </BrowserRouter>
  )
}
