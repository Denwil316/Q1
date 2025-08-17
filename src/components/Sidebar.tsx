// [QEL::ECO[96]::RECALL A96-250817-PREH-NAV-REHIDRATA]
import React,{useMemo,useState} from 'react'
import Fuse from 'fuse.js'
import {useManifest} from './ManifestContext'
import {enc} from '../lib/b64url'
export default function Sidebar({onOpenPath}:{onOpenPath:(slug:string)=>void}){
  const {manifest,loading,error}=useManifest() as any
  const [q,setQ]=useState('')
  const files=manifest?.files??[]
  const fuse=useMemo(()=>new Fuse(files,{keys:['name','role','path'],threshold:0.3}),[files])
  const results=q?fuse.search(q).map((r:any)=>r.item):files
  if(loading) return <div style={{padding:12}}>Cargando manifest…</div>
  if(error) return <div style={{padding:12,color:'#f99'}}>Error: {error}</div>
  return (<div style={{padding:12}}>
    <input type="search" placeholder="Buscar (nombre, rol, ruta)…" value={q} onChange={e=>setQ(e.target.value)}/>
    <div className="list">
      {results.map((f:any)=>(<div className="card" key={f.path}>
        <h4>{f.name}</h4><div className="small">rol: <span className="badge">{f.role}</span></div>
        <div className="path">{f.path}</div>
        <div style={{marginTop:8}}><button onClick={()=>onOpenPath(enc(f.path))}>Abrir</button></div>
      </div>))}
    </div>
  </div>)
}
