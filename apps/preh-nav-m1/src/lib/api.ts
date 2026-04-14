// apps/preh-nav-m1/src/lib/api.ts
import type { Job, LibraryResponse, FS } from '../types';

export type { Job };

async function j<T>(p: Promise<Response>): Promise<T> {
  const r = await p
  if (!r.ok) {
    const err = await r.json().catch(() => ({ error: `HTTP ${r.status}` }))
    throw new Error(err.error || `HTTP ${r.status}`)
  }
  return r.json()
}

export async function getLibrary() {
  return j<LibraryResponse>(fetch('/api/v1/library'))
}

export async function sessionNew(fsPayload: FS) {
  return j<{ ok: boolean; file: string }>(
    fetch('/api/v1/session/new', { method:'POST', headers:{'Content-Type':'application/json'}, body: JSON.stringify(fsPayload) })
  )
}

export async function startPromote(p: { file: string; rubro?: string; titulo?: string; rumbo?: string }): Promise<Job> {
  return j<Job>(fetch('/api/v1/promote', { method:'POST', headers:{'Content-Type':'application/json'}, body: JSON.stringify(p) }))
}

export async function startMicroreg(p: { kind?: string; file: string; title?: string; gates?: string; rumbo?: string; triada?: string; obj?: string; clase?: string }): Promise<Job> {
  return j<Job>(fetch('/api/v1/microreg', { method:'POST', headers:{'Content-Type':'application/json'}, body: JSON.stringify(p) }))
}

export async function startFinalize(p: { fecha: string; seed: string; cue: string; vf: string; fsJson?: string; diarioFile?: string; listadorFile?: string }): Promise<Job> {
  return j<Job>(fetch('/api/v1/finalize', { method:'POST', headers:{'Content-Type':'application/json'}, body: JSON.stringify(p) }))
}

// NUEVOS: canon M0/M1 (sin LL_PE/Vcalc)
export async function startRitualCanonM0M1(p: {
  file: string; fecha: string; seed: string; cue: string; vf: string;
  fs: any; rubro?: string; titulo?: string; rumbo?: string; kind?: string; title?: string;
}): Promise<Job> {
  return j<Job>(fetch('/api/v1/ritual/canon/m0m1', { method:'POST', headers:{'Content-Type':'application/json'}, body: JSON.stringify(p) }))
}

// LL_PE para M2/M3
export async function startLLPE(p: { file?: string; vf?: string; seed?: string; cue?: string; materia?: string; nutriaDir?: string; }): Promise<Job> {
  return j<Job>(fetch('/api/v1/llpe', { method:'POST', headers:{'Content-Type':'application/json'}, body: JSON.stringify(p) }))
}

// HASH FS
export async function fsHash(p: { file?: string; fs?: any; save?: boolean }) {
  return j<{ ok:boolean; hash10:string; saved?:string }>(fetch('/api/v1/fs/hash', { method:'POST', headers:{'Content-Type':'application/json'}, body: JSON.stringify(p) }))
}

// Diario Sistema
export async function diarioSistemaAppend(p: {
  fecha: string; modo: string; tema: string; intencion: string;
  cue: string; seed: string; vf: string; fsFile?: string; hash_fs10?: string;
  notas?: string; altar?: any;
}) {
  return j<{ ok:boolean; file:string }>(fetch('/api/v1/diario/sistema/append', { method:'POST', headers:{'Content-Type':'application/json'}, body: JSON.stringify(p) }))
}

// ListadoR sesiones
export async function listadorSesionesAppend(p: { fecha:string; seed:string; tema:string; result?:string; hash_fs10?:string }) {
  return j<{ ok:boolean; file:string }>(fetch('/api/v1/listador/sesiones/append', { method:'POST', headers:{'Content-Type':'application/json'}, body: JSON.stringify(p) }))
}

// SSE
export function connectLogs(jobId: string, onLine: (s:string)=>void, onEnd?: (ok:boolean)=>void) {
  const es = new EventSource(`/api/v1/logs/${jobId}`)
  es.onmessage = (ev) => {
    try {
      const data = JSON.parse(ev.data)
      if (data.line) onLine(String(data.line))
      if (data.done) { onEnd?.(data.code===0); es.close() }
    } catch {}
  }
  return () => es.close()
}
