// [QEL::ECO[96]::RECALL A96-250817-PREH-NAV-REHIDRATA]
import React from 'react'
import ReactDOM from 'react-dom/client'
import { createBrowserRouter, RouterProvider } from 'react-router-dom'
import App from './App'
import DocViewer from './components/DocViewer'
import ManifestProvider from './components/ManifestContext'

const router = createBrowserRouter([
  { path: '/', element: <App/>, children: [{ path: 'doc/:slug', element: <DocViewer/> }] }
])
ReactDOM.createRoot(document.getElementById('root')!).render(
  <React.StrictMode>
    <ManifestProvider><RouterProvider router={router} /></ManifestProvider>
  </React.StrictMode>
)
