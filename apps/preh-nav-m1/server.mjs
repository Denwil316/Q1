// apps/preh-nav-m1/server.mjs
// -------------------------------------------------------------
// PREH-NAV API: Biblioteca + VCALC + Flujo Ritual (Promote→Microreg→Finalize)
// + Diario del Sistema + ListadoR sesiones + LL_PE + HASH_FS
// -------------------------------------------------------------
import express from 'express';
import cors from 'cors';
import { spawn } from 'child_process';
import path from 'path';
import { fileURLToPath } from 'url';
import fs from 'fs';
import crypto from 'crypto';

// -------------------------------------------------------------
// App base
// -------------------------------------------------------------
const app = express();
app.use(express.json({ limit: '2mb' }));
app.use(cors({ origin: true }));

// -------------------------------------------------------------
// Paths y helpers
// -------------------------------------------------------------
const __filename = fileURLToPath(import.meta.url);
const __dirname  = path.dirname(__filename);

// server.mjs → apps/preh-nav-m1 → sube dos niveles al root del repo
const ROOT = path.resolve(__dirname, '..', '..');
const joinRoot = (...p) => path.join(ROOT, ...p);

const SCRIPTS     = joinRoot('scripts');
const DOCS        = joinRoot('docs');
const DOCS_CORE   = joinRoot('docs', 'core');
const DOCS_FS     = joinRoot('docs', 'fs');   // carpeta de FS JSON
const DOCS_RIT    = joinRoot('docs', 'ritual');
const PREH_PUBLIC = path.join(__dirname, 'public');
const MANIFEST    = path.join(PREH_PUBLIC, 'sot-manifest.json'); // (si tu script lo genera aquí)
const GEN_MANIFEST= path.join(__dirname, 'scripts', 'generate_manifest.mjs');
const DIST        = path.join(__dirname, 'dist');

const SCRIPT_PROMOTE  = path.join(SCRIPTS, 'qel_promote_mac.sh');
const SCRIPT_MICROREG = path.join(SCRIPTS, 'qel_atlas_microreg.sh');
const SCRIPT_FINALIZE = path.join(SCRIPTS, 'qel_session_finalize.sh');
const SCRIPT_VCALC    = path.join(SCRIPTS, 'qel_vcalc.sh');
const SCRIPT_LLPE     = path.join(SCRIPTS, 'qel_pe_generate.mjs'); // tu script LL_PE

// Forzamos QEL_FS_DIR a docs/fs (se puede sobreescribir desde el entorno)
process.env.QEL_FS_DIR = process.env.QEL_FS_DIR || DOCS_FS;

// util
function ensureDir(p) { if (!fs.existsSync(p)) fs.mkdirSync(p, { recursive: true }); }
function ensureParentDir(filePath){ ensureDir(path.dirname(filePath)); }
function str(v) { return String(v ?? '').trim(); }
function isInsideRoot(abs) {
  const rel = path.relative(ROOT, abs);
  return !rel.startsWith('..') && !path.isAbsolute(rel);
}
function resolveSafe(relPath) {
  const abs = path.resolve(ROOT, relPath);
  if (!isInsideRoot(abs)) throw new Error(`path_outside_root: ${relPath}`);
  return abs;
}
function fileExists(p, mustExec = false) {
  try {
    fs.accessSync(p, fs.constants.R_OK | (mustExec ? fs.constants.X_OK : 0));
    return true;
  } catch { return false; }
}
function defaultDiarioPath() {
  // busca primero en docs/core/diarios, luego en docs/core
  const p1 = joinRoot('docs', 'core', 'diarios', 'QEL_Diario_del_Conjurador_v1.2.md');
  const p2 = joinRoot('docs', 'core', 'QEL_Diario_del_Conjurador_v1.2.md');
  return fileExists(p1) ? p1 : p2;
}
function defaultListadoPath() {
  return joinRoot('docs', 'core', 'QEL_ListadoR_master_v1.0.md');
}

// ---------- NUEVOS: rutas del Sistema ----------
const DIARIO_SIS   = joinRoot('docs','core','diarios','QEL_Diario_Sistema_v1.2.md');
const LISTADOR_SES = joinRoot('docs','memory','listador','QEL_ListadoR_sesiones.md');

// ---------- HASH_FS helpers ----------
function normalizeJsonForHash(obj) {
  const sort = (v) => {
    if (Array.isArray(v)) return v.map(sort);
    if (v && typeof v === 'object') {
      return Object.keys(v).sort().reduce((acc,k)=>{ acc[k]=sort(v[k]); return acc; },{});
    }
    return v;
  };
  return JSON.stringify(sort(obj));
}
function sha1_10(s) {
  return crypto.createHash('sha1').update(s).digest('hex').slice(0,10);
}

// spawn promisificado + callback de logs
function runScript(bin, args = [], opts = {}) {
  return new Promise((resolve, reject) => {
    const child = spawn(bin, args, {
      cwd: ROOT,
      shell: true, // permite flags con comillas
      env: { ...process.env, ...(opts.env || {}) },
    });
    let out = '', err = '';
    const onData = (d) => {
      const s = d.toString();
      out += s;
      opts.onData && opts.onData(s);
    };
    child.stdout.on('data', onData);
    child.stderr.on('data', onData);
    child.on('error', (e) => reject(Object.assign(new Error('spawn_error'), { err: String(e) })));
    child.on('close', (code) => {
      if (code === 0) resolve({ code, out, err });
      else reject(Object.assign(new Error('script_failed'), { code, out, err }));
    });
  });
}

// -------------------------------------------------------------
// Estáticos (colecciones directas)
// -------------------------------------------------------------
app.use('/docs',   express.static(path.join(__dirname, 'public', 'docs'))); // publicados
app.use('/core',   express.static(DOCS_CORE));
app.use('/ritual', express.static(DOCS_RIT));
app.use('/memory', express.static(joinRoot('memory')));
app.use('/atlas',  express.static(joinRoot('docs', 'atlas')));

// IMPORTANTE: servir /public SIN index.html (para que no tape el SPA)
app.use(express.static(PREH_PUBLIC, { index: false }));

// -------------------------------------------------------------
// Build del frontend (sin loops)
// -------------------------------------------------------------
async function ensureBuiltOnce() {
  const distIndex = path.join(DIST, 'index.html');
  const force     = String(process.env.FORCE_BUILD||'').trim() === '1';
  const autoBuild = String(process.env.AUTO_BUILD||'').trim() === '1'; // por defecto OFF

  if (!force && !autoBuild && fs.existsSync(distIndex)) return;

  console.log('[build] reconstruyendo frontend (motivo:',
    force ? 'FORCE_BUILD=1' : (autoBuild ? 'AUTO_BUILD=1' : 'dist ausente'), ') …');

  await new Promise((resolve, reject) => {
    const p = spawn('npm', ['run', 'build'], { cwd: __dirname, shell: true, stdio: 'inherit' });
    p.on('close', (code) => (code === 0 ? resolve() : reject(new Error('build_failed'))));
  });
  console.log('[build] listo.');
}
await ensureBuiltOnce();

// Endpoint manual para rebuild
app.post('/api/v1/dev/rebuild', async (_req, res) => {
  try {
    console.log('[build] rebuild solicitado vía API');
    await new Promise((resolve, reject) => {
      const p = spawn('npm', ['run', 'build'], { cwd: __dirname, shell: true, stdio: 'inherit' });
      p.on('close', (code) => (code === 0 ? resolve() : reject(new Error('build_failed'))));
    });
    res.json({ ok: true, src: 'src/*', out: 'dist/*' });
  } catch (e) {
    res.status(500).json({ ok: false, error: String(e) });
  }
});

// -------------------------------------------------------------
// SPA (Vite build) + rutas conocidas
// -------------------------------------------------------------
// Sirve primero los assets de dist (pero OJO: NO el index, lo controlamos nosotros)
app.use(express.static(DIST, {
  index: false,
  setHeaders: (res, p) => {
    if (p.endsWith('index.html')) res.setHeader('Cache-Control', 'no-store');
  }
}));

// Helper para responder SIEMPRE con el index de dist y dejar un header de debug
function sendDistIndex(res) {
  res.setHeader('Cache-Control', 'no-store');
  res.setHeader('X-Index-From', path.join(DIST, 'index.html'));
  res.sendFile(path.join(DIST, 'index.html'));
}

// Rutas SPA conocidas
const SPA_ROUTES = ['/', '/altar', '/via', '/laboratorio', '/doc', '/library'];
SPA_ROUTES.forEach(r => {
  app.get(r, (_req, res) => sendDistIndex(res));
});

// Subrutas SPA (sin comodín '*', Express 5)
app.get(/^\/(altar|via|laboratorio|doc)\/.+$/, (_req, res) => sendDistIndex(res));

// Compat: /vcalc → /laboratorio/vcalc
app.get(['/vcalc', '/vcalc.html'], (_req, res) => {
  res.redirect(302, '/laboratorio/vcalc');
});

// -------------------------------------------------------------
// VCALC (API)
// -------------------------------------------------------------
const okRumbo = new Set(['N','O','E','W','S','C']);
const okClase = new Set(['basica','básica','poco comun','poco común','raro','rara','singular','unico','único','metalica','metálica','obsidiana']);
const okDelta = new Set(['up','flat','down']);

app.post('/api/v1/vcalc', (req, res) => {
  try {
    const {
      obj = '',
      A = 0.60,
      rumbo = 'C',
      clase = 'singular',
      gates = [],
      ruido = 0,
      delta = { c: 'flat', s: 'flat' }
    } = req.body || {};

    if (!obj || !String(obj).trim()) return res.status(400).json({ error: 'obj requerido' });
    const R = String(rumbo || 'C').toUpperCase();
    if (!okRumbo.has(R)) return res.status(400).json({ error: 'rumbo inválido' });
    if (!okClase.has(String(clase))) return res.status(400).json({ error: 'clase inválida' });
    if (!delta || !okDelta.has(delta.c) || !okDelta.has(delta.s)) return res.status(400).json({ error: 'delta inválido' });

    const g = (Array.isArray(gates) ? gates : String(gates).split(','))
      .map(s => String(s || '').trim())
      .filter(Boolean)
      .join(',');

    if (!fileExists(SCRIPT_VCALC, true)) return res.status(500).json({ error: 'script_missing', bin: SCRIPT_VCALC });

    const args = [
      '--obj', obj,
      '--afinidad', Number(A).toFixed(4),
      '--rumbo', R,
      '--clase', String(clase),
      '--gates', g,
      '--ruido', String(Math.max(0, Math.min(Number(ruido) || 0, 1))),
      '--delta-c', delta.c,
      '--delta-s', delta.s,
      '--emit', 'json'
    ];

    const ps = spawn(SCRIPT_VCALC, args, { shell: false, env: { ...process.env, LC_ALL: 'C', LC_NUMERIC: 'C' } });
    const killTimer = setTimeout(() => ps.kill('SIGKILL'), 8000);
    let out = '', err = '';
    ps.stdout.on('data', d => (out += d));
    ps.stderr.on('data', d => (err += d));
    ps.on('error', spErr => { clearTimeout(killTimer); return res.status(500).json({ error: 'spawn_error', detail: String(spErr) }); });
    ps.on('close', code => {
      clearTimeout(killTimer);
      if (code !== 0) return res.status(400).json({ error: 'vcalc_failed', code, stderr: err });
      try { return res.json(JSON.parse(out)); }
      catch { return res.status(500).json({ error: 'json_parse', out }); }
    });
  } catch (e) {
    return res.status(500).json({ error: 'server', detail: String(e) });
  }
});

// -------------------------------------------------------------
// SSE (logs en vivo)
// -------------------------------------------------------------
const jobs = new Map(); // jobId -> { listeners: Set(res) }

function sseInit(res) {
  res.writeHead(200, { 'Content-Type':'text/event-stream', 'Cache-Control':'no-cache', 'Connection':'keep-alive' });
  res.write(':\n\n');
}
function sseSend(res, data) {
  res.write(`data: ${JSON.stringify(data)}\n\n`);
}
function sseBroadcast(jobId, data) {
  const j = jobs.get(jobId);
  if (!j) return;
  for (const r of j.listeners) sseSend(r, data);
}

app.get('/api/v1/logs/:jobId', (req, res) => {
  const { jobId } = req.params;
  sseInit(res);
  if (!jobs.has(jobId)) jobs.set(jobId, { listeners: new Set() });
  jobs.get(jobId).listeners.add(res);
  req.on('close', () => jobs.get(jobId)?.listeners.delete(res));
});

// -------------------------------------------------------------
// API: Formato Situacional (crear JSON)  → FS_YYMMDD.json
// -------------------------------------------------------------
app.post('/api/v1/session/new', (req, res) => {
  try {
    const p = req.body || {};
    ensureDir(DOCS_FS);
    const yymmdd = (str(p.fecha) || new Date().toISOString().slice(2,10).replace(/-/g,'')).slice(0,6);
    const outFile = path.join(DOCS_FS, `FS_${yymmdd}.json`);
    fs.writeFileSync(outFile, JSON.stringify(p, null, 2), 'utf-8');
    return res.json({ ok: true, file: outFile });
  } catch (e) {
    return res.status(400).json({ ok: false, error: String(e) });
  }
});

// -------------------------------------------------------------
// APIs atómicas: promote / microreg / finalize
// -------------------------------------------------------------
app.post('/api/v1/promote', async (req, res) => {
  const { file, rubro = 'CURADURIA', titulo, rumbo } = req.body || {};
  try { resolveSafe(file); } catch(e){ return res.status(400).json({ error: 'file_invalid', detail: String(e) }); }
  if (!fileExists(SCRIPT_PROMOTE, true)) return res.status(500).json({ error: 'script_missing', bin: SCRIPT_PROMOTE });

  const jobId = `promote-${Date.now()}`;
  jobs.set(jobId, { listeners: new Set() });
  res.json({ ok: true, jobId });

  const args = [
    SCRIPT_PROMOTE,
    '--rubro', `"${str(rubro)}"`,
    '--file', `"${str(file)}"`,
    ...(titulo ? ['--titulo', `"${str(titulo)}"`] : []),
    ...(rumbo ? ['--rumbo', `"${str(rumbo)}"`] : []),
  ];
  try {
    await runScript('bash', args, { onData: (line)=>sseBroadcast(jobId, { line }) });
    sseBroadcast(jobId, { done: true, code: 0 });
  } catch (e) {
    sseBroadcast(jobId, { done: true, code: e.code || 1, err: e.err, out: e.out });
  }
});

app.post('/api/v1/microreg', async (req, res) => {
  const { kind='PROMO', file, title, gates='no_mentira,doble_testigo', rumbo='Centro', triada='SIL·UM·Ə', obj, clase='basica' } = req.body || {};
  try { resolveSafe(file); } catch(e){ return res.status(400).json({ error: 'file_invalid', detail: String(e) }); }
  if (!fileExists(SCRIPT_MICROREG, true)) return res.status(500).json({ error: 'script_missing', bin: SCRIPT_MICROREG });

  const jobId = `microreg-${Date.now()}`;
  jobs.set(jobId, { listeners: new Set() });
  res.json({ ok: true, jobId });

  const args = [
    SCRIPT_MICROREG,
    '--kind', `"${str(kind)}"`,
    '--file', `"${str(file)}"`,
    ...(title ? ['--title', `"${str(title)}"`] : []),
    '--rumbo', `"${str(rumbo)}"`,
    '--triada', `"${str(triada)}"`,
    '--gates', `"${str(gates)}"`,
    ...(obj ? ['--obj', `"${str(obj)}"`] : []),
    '--clase', `"${str(clase)}"`,
  ];
  try {
    await runScript('bash', args, { onData: (line)=>sseBroadcast(jobId, { line }) });
    sseBroadcast(jobId, { done: true, code: 0 });
  } catch (e) {
    sseBroadcast(jobId, { done: true, code: e.code || 1, err: e.err, out: e.out });
  }
});

app.post('/api/v1/finalize', async (req, res) => {
  const { fecha, seed, cue, vf, fsJson, diarioFile, listadorFile } = req.body || {};
  const diar = diarioFile ? resolveSafe(diarioFile) : defaultDiarioPath();
  const list = listadorFile ? resolveSafe(listadorFile) : defaultListadoPath();
  if (!fileExists(SCRIPT_FINALIZE, true)) return res.status(500).json({ error: 'script_missing', bin: SCRIPT_FINALIZE });

  const jobId = `finalize-${Date.now()}`;
  jobs.set(jobId, { listeners: new Set() });
  res.json({ ok: true, jobId });

  const args = [
    SCRIPT_FINALIZE,
    '--fecha', `"${str(fecha)}"`,
    '--seed', `"${str(seed)}"`,
    '--cue', `"${str(cue)}"`,
    '--vf', `"${str(vf)}"`,
    ...(fsJson ? ['--fs-json', `"${str(fsJson)}"`] : []),
    '--diario-file', `"${diar}"`,
    '--listador-file', `"${list}"`,
  ];

  try {
    await runScript('bash', args, { onData: (line)=>sseBroadcast(jobId, { line }) });
    if (fileExists(GEN_MANIFEST)) {
      await runScript('node', [GEN_MANIFEST], { onData: (l)=>sseBroadcast(jobId, { line: `[manifest] ${l}` })});
    }
    sseBroadcast(jobId, { done: true, code: 0 });
  } catch (e) {
    sseBroadcast(jobId, { done: true, code: e.code || 1, err: e.err, out: e.out });
  }
});

// -------------------------------------------------------------
// Orquestadores rituales
// -------------------------------------------------------------
app.post('/api/v1/ritual', async (req, res) => {
  const { file, rubro, titulo, rumbo, kind, title, fs, fecha, seed, cue, vf } = req.body || {};
  try { resolveSafe(file); } catch(e){ return res.status(400).json({ error: 'file_invalid', detail: String(e) }); }

  const jobId = `ritual-${Date.now()}`;
  jobs.set(jobId, { listeners: new Set() });
  res.json({ ok: true, jobId });

  const log = (m)=> sseBroadcast(jobId, { line: m });

  try {
    // 1) Si llega FS embebido, lo escribimos a docs/fs (formato nuevo FS_YYMMDD)
    let fsPath = null;
    if (fs && typeof fs === 'object') {
      ensureDir(DOCS_FS);
      const yymmdd = (str(fs.fecha) || str(fecha) || new Date().toISOString().slice(2,10).replace(/-/g,'')).slice(0,6);
      fsPath = path.join(DOCS_FS, `FS_${yymmdd}.json`);
      fs.writeFileSync(fsPath, JSON.stringify(fs, null, 2), 'utf-8');
      log(`[fs] escrito ${fsPath}`);
    }

    // 2) promote
    await runScript('bash', [
      SCRIPT_PROMOTE,
      '--rubro', `"${str(rubro || 'CURADURIA')}"`,
      '--file', `"${str(file)}"`,
      ...(titulo ? ['--titulo', `"${str(titulo)}"`] : []),
      ...(rumbo ?  ['--rumbo', `"${str(rumbo)}"`] : []),
    ], { onData: log });

    // 3) microreg
    await runScript('bash', [
      SCRIPT_MICROREG,
      '--kind', `"${str(kind || 'PROMO')}"`,
      '--file', `"${str(file)}"`,
      ...(title ? ['--title', `"${str(title)}"`] : []),
      '--rumbo', `"${str(rumbo || 'Centro')}"`,
      '--triada', `"SIL·UM·Ə"`,
      '--gates', `"no_mentira,doble_testigo"`,
      '--clase', `"basica"`,
    ], { onData: log });

    // 4) finalize
    await runScript('bash', [
      SCRIPT_FINALIZE,
      '--fecha', `"${str(fecha)}"`,
      '--seed', `"${str(seed)}"`,
      '--cue', `"${str(cue)}"`,
      '--vf', `"${str(vf)}"`,
      ...(fsPath ? ['--fs-json', `"${fsPath}"`] : []),
      '--diario-file', `"${defaultDiarioPath()}"`,
      '--listador-file', `"${defaultListadoPath()}"`,
    ], { onData: log });

    // 5) manifest
    if (fileExists(GEN_MANIFEST)) {
      await runScript('node', [GEN_MANIFEST], { onData: (l)=>log(`[manifest] ${l}`) });
    }

    sseBroadcast(jobId, { done: true, code: 0 });
  } catch (e) {
    sseBroadcast(jobId, { done: true, code: e.code || 1, err: e.err, out: e.out });
  }
});

app.post('/api/v1/ritual/canon/m0m1', async (req,res)=>{
  const { file, fecha, seed, cue, vf, fs, rubro, titulo, rumbo, kind, title } = req.body||{};
  try { resolveSafe(file); } catch(e){ return res.status(400).json({ error:'file_invalid', detail:String(e) }); }

  const jobId = `ritual-m0m1-${Date.now()}`;
  jobs.set(jobId,{listeners:new Set()});
  res.json({ ok:true, jobId });
  const log = (m)=> sseBroadcast(jobId,{ line:m });

  try {
    // FS
    let fsPath=null, fsHash10='';
    if (fs && typeof fs==='object') {
      ensureDir(DOCS_FS);
      const yymmdd = (str(fs.fecha)||str(fecha)||new Date().toISOString().slice(2,10).replace(/-/g,'')).slice(0,6);
      fsPath = path.join(DOCS_FS, `FS_${yymmdd}.json`);
      fs.writeFileSync(fsPath, JSON.stringify(fs,null,2), 'utf-8');
      fsHash10 = sha1_10(normalizeJsonForHash(fs));
      log(`[fs] ${fsPath} · HASH_FS(10)=${fsHash10}`);
    }

    // Promote
    await runScript('bash', [
      SCRIPT_PROMOTE,
      '--rubro', `"${str(rubro || 'CURADURIA')}"`,
      '--file',  `"${str(file)}"`,
      ...(titulo? ['--titulo', `"${str(titulo)}"`] : []),
      ...(rumbo ? ['--rumbo',  `"${str(rumbo)}"`] : []),
    ], { onData: log });

    // Microreg
    await runScript('bash', [
      SCRIPT_MICROREG,
      '--kind', `"${str(kind || 'PROMO')}"`,
      '--file', `"${str(file)}"`,
      ...(title? ['--title', `"${str(title)}"`] : []),
      '--rumbo', `"${str(rumbo || 'Centro')}"`,
      '--triada', `"SIL·UM·Ə"`,
      '--gates',  `"no_mentira,doble_testigo"`,
      '--clase',  `"basica"`,
    ], { onData: log });

    // Finalize
    await runScript('bash', [
      SCRIPT_FINALIZE,
      '--fecha', `"${str(fecha)}"`,
      '--seed',  `"${str(seed)}"`,
      '--cue',   `"${str(cue)}"`,
      '--vf',    `"${str(vf)}"`,
      ...(fsPath? ['--fs-json', `"${fsPath}"`] : []),
      '--diario-file',  `"${defaultDiarioPath()}"`,
      '--listador-file',`"${defaultListadoPath()}"`,
    ], { onData: log });

    // Diario del Sistema + ListadoR sesiones
    try{
      const ds = await fetch(`http://localhost:${PORT}/api/v1/diario/sistema/append`, {
        method:'POST', headers:{'Content-Type':'application/json'},
        body: JSON.stringify({
          fecha, modo: fs?.modo||'M1', tema: fs?.tema||'', intencion: fs?.intencion||'',
          cue, seed, vf, fsFile: fsPath || '', hash_fs10: fsHash10
        })
      }).then(r=>r.json());
      if (ds.ok) log(`[sistema] diario -> ${ds.file}`);

      const ls = await fetch(`http://localhost:${PORT}/api/v1/listador/sesiones/append`, {
        method:'POST', headers:{'Content-Type':'application/json'},
        body: JSON.stringify({ fecha, seed, tema: fs?.tema||'', result:'OK', hash_fs10: fsHash10 })
      }).then(r=>r.json());
      if (ls.ok) log(`[sistema] listador -> ${ls.file}`);
    }catch(e){ log(`[sistema] append err: ${e}`); }

    // Manifest
    if (fileExists(GEN_MANIFEST)) {
      await runScript('node', [GEN_MANIFEST], { onData: (l)=>log(`[manifest] ${l}`) });
    }

    sseBroadcast(jobId,{ done:true, code:0 });
  } catch (e) {
    sseBroadcast(jobId,{ done:true, code:e.code||1, err:e.err, out:e.out });
  }
});

// -------------------------------------------------------------
// Arranque
// -------------------------------------------------------------
const PORT = process.env.PORT ? Number(process.env.PORT) : 3030;
app.listen(PORT, () => {
  console.log(`PREH-NAV API on http://localhost:${PORT}`);
  console.log(`ROOT: ${ROOT}`);
  console.log(`QEL_FS_DIR: ${process.env.QEL_FS_DIR}`);
});

// (opcional) helper local
export async function runVcalc(payload) {
  const r = await fetch(`http://localhost:${PORT}/api/v1/vcalc`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(payload)
  });
  if (!r.ok) throw new Error('VCALC error');
  return await r.json();
}
