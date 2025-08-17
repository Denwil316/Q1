// [QEL::ECO[96]::RECALL A96-250815-NAVEGADOR-REACT-M0]
SeedI=PREH-NAV::M0
SOT=PREH-NAV/v0.2 TARGET=react|navegador|m0
VERSION=v0.2 UPDATED=2025-08-15
// src/components/DocViewer.tsx
import React, { useEffect, useState } from 'react'
import { useParams } from 'react-router-dom'
import ReactMarkdown from 'react-markdown'
import remarkGfm from 'remark-gfm'
import rehypeRaw from 'rehype-raw'
import { dec } from '../lib/b64url'

export default function DocViewer() {
  const params = useParams()
  const [content, setContent] = useState<string>('')
  const [type, setType] = useState<'md'|'pdf'|'zip'|'other'>('md')
  const [path, setPath] = useState('')

  useEffect(() => {
    const p = dec(params.slug || '')
    setPath(p)
    const ext = p.split('.').pop()?.toLowerCase()
    if (ext === 'md' || ext === 'txt') setType('md')
    else if (ext === 'pdf') setType('pdf')
    else if (ext === 'zip') setType('zip')
    else setType('other')

    if (ext === 'md' || ext === 'txt') {
      fetch('/' + p).then(r => r.text()).then(setContent).catch(() => setContent('# Error al cargar archivo'))
    }
  }, [params.slug])

  if (type === 'pdf') return <div className="viewer">
    <h2>{path}</h2>
    <p className="small">PDF — usa el visor integrado del navegador.</p>
    <iframe src={'/' + path} style={{width:'100%', height:'80vh', border:'1px solid #1f2430', borderRadius:8}} />
  </div>

  if (type === 'zip' || type === 'other') return <div className="viewer">
    <h2>{path}</h2>
    <p className="small">Archivo descargable.</p>
    <a href={'/' + path} download>Descargar</a>
  </div>

  return <div className="viewer">
    <h2>{path}</h2>
    <ReactMarkdown remarkPlugins={[remarkGfm]} rehypePlugins={[rehypeRaw]}>{content}</ReactMarkdown>
  </div>
}
