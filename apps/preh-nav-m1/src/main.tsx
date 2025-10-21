// apps/preh-nav-m1/src/main.tsx
// [QEL::ECO[96]::RECALL A96-250817-PREH-NAV-REHIDRATA]
import React from 'react'
import ReactDOM from 'react-dom/client'
import App from './App'
import ManifestProvider from './components/ManifestContext'
import './styles.css'

ReactDOM.createRoot(document.getElementById('root')!).render(
  <React.StrictMode>
    <ManifestProvider>
      <App />
    </ManifestProvider>
  </React.StrictMode>
)
