	/* [QEL::ECO[96]::RECALL A96-250817-DOCVIEWER-NOTAS]
	   SOT=PREH-NAV/v0.2 TARGET=visor|notas|localStorage
	   VERSION=v0.2 UPDATED=2025-08-17 */
	import React, { useEffect, useMemo, useState } from 'react'
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
	  const key = useMemo(()=> path ? 'qel-notes:'+path : 'qel-notes:__', [path])
	  const [note, setNote] = useState('')

	  useEffect(() => {
	    const p = dec(params.slug || '')
	    setPath(p)
	    const ext = (p.split('.').pop() || '').toLowerCase()
	    if (ext === 'md' || ext === 'txt') setType('md')
	    else if (ext === 'pdf') setType('pdf')
	    else if (ext === 'zip') setType('zip')
	    else setType('other')
	    if (ext === 'md' || ext === 'txt') {
	      fetch('/' + p).then(r => r.text()).then(setContent).catch(() => setContent('# Error al cargar archivo'))
	    } else {
	      setContent('')
	    }
	  }, [params.slug])

	  useEffect(() => { if (key) { const v = localStorage.getItem(key) || ''; setNote(v)} }, [key])
	  useEffect(() => { if (key) localStorage.setItem(key, note) }, [key, note])

	  const downloadNotes = () => {
	    const blob = new Blob([note], { type: 'text/markdown' })
	    const url = URL.createObjectURL(blob)
	    const a = document.createElement('a')
	    a.href = url
	    a.download = (path || 'documento').replace(/\//g,'__') + '.notes.md'
	    a.click()
	    URL.revokeObjectURL(url)
	  }

	  if (type === 'pdf') return <div className="viewer">
	    <h2>{path}</h2>
	    <p className="small">PDF — usa el visor integrado del navegador.</p>
	    <iframe src={'/' + path} style={{width:'100%', height:'70vh', border:'1px solid #1f2430', borderRadius:8}} />
	    <hr/>
	    <h3>Notas</h3>
	    <textarea value={note} onChange={e=>setNote(e.target.value)} placeholder="Escribe tus notas…" style={{width:'100%', minHeight:180}}/>
	    <div style={{marginTop:8}}><button onClick={downloadNotes}>Exportar notas (.md)</button></div>
	  </div>

	  if (type === 'zip' || type === 'other') return <div className="viewer">
	    <h2>{path}</h2>
	    <p className="small">Archivo descargable.</p>
	    <a href={'/' + path} download>Descargar</a>
	    <hr/>
	    <h3>Notas</h3>
	    <textarea value={note} onChange={e=>setNote(e.target.value)} placeholder="Escribe tus notas…" style={{width:'100%', minHeight:180}}/>
	    <div style={{marginTop:8}}><button onClick={downloadNotes}>Exportar notas (.md)</button></div>
	  </div>

	  return <div className="viewer">
	    <h2>{path}</h2>
	    <ReactMarkdown remarkPlugins={[remarkGfm]} rehypePlugins={[rehypeRaw]}>{content}</ReactMarkdown>
	    <hr/>
	    <h3>Notas</h3>
	    <textarea value={note} onChange={e=>setNote(e.target.value)} placeholder="Escribe tus notas…" style={{width:'100%', minHeight:180}}/>
	    <div style={{marginTop:8}}><button onClick={downloadNotes}>Exportar notas (.md)</button></div>
	  </div>
	}
    