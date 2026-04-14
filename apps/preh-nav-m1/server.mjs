// apps/preh-nav-m1/server.mjs
// -------------------------------------------------------------
// PREH-NAV API: Biblioteca + VCALC + Flujo Ritual (Promote→Microreg→Finalize)
// + Diario del Sistema + ListadoR sesiones + LL_PE + HASH_FS
// -------------------------------------------------------------
import express from 'express';
import cors from 'cors';
import rateLimit from 'express-rate-limit';
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

const ALLOWED_ORIGINS = (process.env.ALLOWED_ORIGINS || 'http://localhost:5173,http://localhost:3030').split(',');
app.use(cors({ origin: ALLOWED_ORIGINS }));

const apiLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 100,
  message: { error: 'too_many_requests' },
  standardHeaders: true,
  legacyHeaders: false,
});
app.use('/api/', apiLimiter);

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
const DOCS_ATLAS  = joinRoot('docs', 'atlas');
const DOCS_TOOLS  = joinRoot('docs', 'tools');
const MEMORY_DIR  = joinRoot('memory');
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
const ALLOWED_EXTENSIONS = ['.md', '.json', '.txt', '.html', '.css', '.js', '.ts', '.tsx', '.yaml', '.yml', '.sh', '.mjs', '.cjs'];
const BLOCKED_EXTENSIONS = ['.exe', '.sh', '.bat', '.cmd', '.ps1', '.so', '.dll', '.dylib', '.env', '.key', '.pem'];

function resolveSafe(relPath) {
  const abs = path.resolve(ROOT, relPath);
  if (!isInsideRoot(abs)) throw new Error(`path_outside_root: ${relPath}`);
  const ext = path.extname(abs).toLowerCase();
  if (BLOCKED_EXTENSIONS.includes(ext)) throw new Error(`extension_blocked: ${ext}`);
  return abs
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

function sanitizeInput(str, allowChars = /^[a-zA-Z0-9_\-.\s]+$/) {
  const s = String(str ?? '').trim();
  if (!s || !allowChars.test(s)) return null;
  return s;
}

function sanitizePathInput(str) {
  const s = String(str ?? '').trim();
  if (!s || /[&;`$|]/.test(s) || /\.\./.test(s)) return null;
  return s;
}

function isValidFile(file) {
  if (!file || typeof file !== 'string') return false;
  const sanitized = sanitizePathInput(file);
  if (!sanitized) return false;
  try {
    resolveSafe(sanitized);
    return true;
  } catch { return false; }
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

const FETCH_TIMEOUT_MS = 10000;
const FETCH_MAX_RETRIES = 2;

async function fetchWithTimeout(url, options = {}, timeout = FETCH_TIMEOUT_MS) {
  const controller = new AbortController();
  const id = setTimeout(() => controller.abort(), timeout);
  try {
    const response = await fetch(url, { ...options, signal: controller.signal });
    clearTimeout(id);
    return response;
  } catch (e) {
    clearTimeout(id);
    throw e;
  }
}

async function fetchWithRetry(url, options = {}, retries = FETCH_MAX_RETRIES) {
  let lastError;
  for (let i = 0; i < retries; i++) {
    try {
      return await fetchWithTimeout(url, options);
    } catch (e) {
      lastError = e;
      if (i < retries - 1) await new Promise(r => setTimeout(r, 1000 * (i + 1)));
    }
  }
  throw lastError;
}
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
// Publicados (lo que qel_promote_* copia a apps/preh-nav-m1/public/docs)
app.use('/docs',   express.static(path.join(__dirname, 'public', 'docs')));

// Repo (whitelist seguro)
app.use('/core',   express.static(DOCS_CORE));
app.use('/ritual', express.static(DOCS_RIT));
app.use('/atlas',  express.static(DOCS_ATLAS));
app.use('/tools',  express.static(DOCS_TOOLS));
app.use('/fs',     express.static(DOCS_FS));
app.use('/memory', express.static(MEMORY_DIR));

// Biblioteca (HTML estático). Se sirve ANTES del SPA.
const LIBRARY_HTML = path.join(PREH_PUBLIC, 'library.html');
app.get(['/library', '/biblioteca', '/library.html'], (_req, res) => {
  res.setHeader('Cache-Control', 'no-store');
  res.setHeader('X-QEL-Library', 'v0.4');
  res.sendFile(LIBRARY_HTML);
});

// /public estático (SIN index.html; y sin caché en HTML para que iteres rápido)
app.use(express.static(PREH_PUBLIC, {
  index: false,
  setHeaders: (res, filePath) => {
    if (String(filePath).endsWith('.html')) res.setHeader('Cache-Control', 'no-store');
  }
}));

// -------------------------------------------------------------
// Biblioteca: catálogo multi-carpeta (public/docs + repo docs/* + memory)
// -------------------------------------------------------------
const PUBLIC_DOCS = path.join(PREH_PUBLIC, 'docs');

function toPosix(p){ return p.split(path.sep).join('/'); }
function encodeUrlPath(relPosix){
  return String(relPosix).split('/').map(encodeURIComponent).join('/');
}

function classifyPublished(name, relPosix){
  const n = String(name || '').toLowerCase();
  const r = String(relPosix || '').toLowerCase();

  // Si algún día existen subcarpetas dentro de public/docs, respétalas.
  if (r.startsWith('core/')) return 'core';
  if (r.startsWith('ritual/')) return 'ritual';
  if (r.startsWith('atlas/')) return 'atlas';
  if (r.startsWith('memory/')) return 'memory';

  // Heurística por nombre (public/docs suele ser plano)
  if (/(listador|listado?r|listadorr|listador_sesiones)/.test(n)) return 'memory';
  if (/(microsello|vf_prima|vf\-prima|ritual|meditacion|meditaciones|sellos)/.test(n)) return 'ritual';
  if (/(atlas|tarjetas|tarjeta|sot_.*manifest|manifest)/.test(n)) return 'atlas';
  return 'core';
}

function walkFiles(absDir, urlBase, origin, bucket){
  const out = [];
  if (!fs.existsSync(absDir)) return out;

  const skipDirs = new Set(['.git','node_modules','dist','build','.vite','coverage','__pycache__']);
  const maxFiles = 8000;

  const stack = [absDir];
  let seen = 0;

  while (stack.length){
    const dir = stack.pop();
    let ents = [];
    try { ents = fs.readdirSync(dir, { withFileTypes: true }); }
    catch { continue; }

    for (const ent of ents){
      const name = ent.name;
      if (!name) continue;
      if (name.startsWith('.')) continue;
      if (name === '.DS_Store') continue;
      if (ent.isSymbolicLink && ent.isSymbolicLink()) continue;

      const abs = path.join(dir, name);

      if (ent.isDirectory()){
        if (skipDirs.has(name)) continue;
        stack.push(abs);
        continue;
      }
      if (!ent.isFile()) continue;

      if (!/\.(md|txt|json|ya?ml|pdf)$/i.test(name)) continue;

      let stat;
      try { stat = fs.statSync(abs); }
      catch { continue; }

      // Evita archivos gigantes en catálogo (igual puedes servirlos directo si los abres por URL)
      if (stat.size > 25 * 1024 * 1024) continue;

      const rel = toPosix(path.relative(absDir, abs));
      const url = `${urlBase}/${encodeUrlPath(rel)}`;

      out.push({
        name,
        rel,
        url,
        bytes: stat.size,
        mtime: stat.mtimeMs,
        origin,
        bucket,
      });

      seen += 1;
      if (seen >= maxFiles) break;
    }
    if (seen >= maxFiles) break;
  }

  return out;
}

app.get('/api/v1/library', (_req, res) => {
  try {
    const publishedRaw = walkFiles(PUBLIC_DOCS, '/docs', 'pub', 'published');
    const coreRepo     = walkFiles(DOCS_CORE,   '/core',   'repo', 'core');
    const ritualRepo   = walkFiles(DOCS_RIT,    '/ritual', 'repo', 'ritual');
    const atlasRepo    = walkFiles(DOCS_ATLAS,  '/atlas',  'repo', 'atlas');
    const toolsRepo    = walkFiles(DOCS_TOOLS,  '/tools',  'repo', 'tools');
    const fsRepo       = walkFiles(DOCS_FS,     '/fs',     'repo', 'fs');
    const memoryRepo   = walkFiles(MEMORY_DIR,  '/memory', 'repo', 'memory');

    // Publicados → buckets (heurística)
    const published = { all: [], core: [], ritual: [], atlas: [], memory: [] };
    for (const it of publishedRaw){
      const g = classifyPublished(it.name, it.rel);
      it.bucket = g;
      published.all.push(it);
      (published[g] || published.core).push(it);
    }

    const sortByRel = (a,b) => String(a.rel).localeCompare(String(b.rel), 'es');

    const groups = {
      published: published.all.sort(sortByRel),
      core:   [...published.core,   ...coreRepo].sort(sortByRel),
      ritual: [...published.ritual, ...ritualRepo].sort(sortByRel),
      atlas:  [...published.atlas,  ...atlasRepo].sort(sortByRel),
      tools:  toolsRepo.sort(sortByRel),
      fs:     fsRepo.sort(sortByRel),
      memory: [...published.memory, ...memoryRepo].sort(sortByRel),
    };

    const all = [
      ...groups.published,
      ...coreRepo,
      ...ritualRepo,
      ...atlasRepo,
      ...toolsRepo,
      ...fsRepo,
      ...memoryRepo,
    ].sort((a,b)=>{
      const oa = String(a.bucket||'').localeCompare(String(b.bucket||''),'es');
      if (oa) return oa;
      return sortByRel(a,b);
    });

    res.setHeader('Cache-Control', 'no-store');
    res.json({
      ok: true,
      version: 'v0.4',
      roots: {
        published: PUBLIC_DOCS,
        core: DOCS_CORE,
        ritual: DOCS_RIT,
        atlas: DOCS_ATLAS,
        tools: DOCS_TOOLS,
        fs: DOCS_FS,
        memory: MEMORY_DIR,
      },
      exists: {
        published: fs.existsSync(PUBLIC_DOCS),
        core: fs.existsSync(DOCS_CORE),
        ritual: fs.existsSync(DOCS_RIT),
        atlas: fs.existsSync(DOCS_ATLAS),
        tools: fs.existsSync(DOCS_TOOLS),
        fs: fs.existsSync(DOCS_FS),
        memory: fs.existsSync(MEMORY_DIR),
      },
      counts: {
        all: all.length,
        published: groups.published.length,
        core: groups.core.length,
        ritual: groups.ritual.length,
        atlas: groups.atlas.length,
        tools: groups.tools.length,
        fs: groups.fs.length,
        memory: groups.memory.length,
      },
      all,
      ...groups,
    });
  } catch (e) {
    res.status(500).json({ ok: false, error: String(e) });
  }
});


app.use('/docs',   express.static(path.join(__dirname, 'public', 'docs'))); // publicados
app.use('/core',   express.static(DOCS_CORE));
app.use('/ritual', express.static(DOCS_RIT));
app.use('/memory', express.static(MEMORY_DIR));
app.use('/atlas',  express.static(DOCS_ATLAS));
app.use('/tools',  express.static(DOCS_TOOLS));
app.use('/fs',     express.static(DOCS_FS));

// Biblioteca (HTML estático) — /library debe ganarle al fallback SPA
app.get(['/library','/biblioteca'], (_req, res) => {
  res.setHeader('Cache-Control', 'no-store');
  res.sendFile(path.join(PREH_PUBLIC, 'library.html'));
});

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
const SPA_ROUTES = ['/', '/altar', '/via', '/laboratorio', '/doc'];
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
const jobs = new Map(); // jobId -> { listeners: Set(res), created: timestamp }
const JOB_TTL_MS = 30 * 60 * 1000; // 30 min

function cleanupJobs() {
  const now = Date.now();
  for (const [jobId, job] of jobs) {
    if (now - job.created > JOB_TTL_MS || job.listeners.size === 0) {
      jobs.delete(jobId);
    }
  }
}
setInterval(cleanupJobs, 5 * 60 * 1000); // cleanup cada 5 min

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
  if (!jobs.has(jobId)) jobs.set(jobId, { listeners: new Set(), created: Date.now() });
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
  if (!isValidFile(file)) return res.status(400).json({ error: 'file_invalid' });
  const safeRubro = sanitizeInput(rubro) || 'CURADURIA';
  const safeTitulo = sanitizeInput(titulo);
  const safeRumbo = sanitizeInput(rumbo);
  try { resolveSafe(file); } catch(e){ return res.status(400).json({ error: 'file_invalid', detail: String(e) }); }
  if (!fileExists(SCRIPT_PROMOTE, true)) return res.status(500).json({ error: 'script_missing', bin: SCRIPT_PROMOTE });

  const jobId = `promote-${Date.now()}`;
  jobs.set(jobId, { listeners: new Set(), created: Date.now() });
  res.json({ ok: true, jobId });

  const args = [
    SCRIPT_PROMOTE,
    '--rubro', `"${safeRubro}"`,
    '--file', `"${str(file)}"`,
    ...(safeTitulo ? ['--titulo', `"${safeTitulo}"`] : []),
    ...(safeRumbo ? ['--rumbo', `"${safeRumbo}"`] : []),
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
  if (!isValidFile(file)) return res.status(400).json({ error: 'file_invalid' });
  const safeKind = sanitizeInput(kind, /^[A-Z]+$/) || 'PROMO';
  const safeTitle = sanitizeInput(title);
  const safeRumbo = sanitizeInput(rumbo) || 'Centro';
  const safeObj = sanitizeInput(obj);
  const safeClase = sanitizeInput(clase);
  try { resolveSafe(file); } catch(e){ return res.status(400).json({ error: 'file_invalid', detail: String(e) }); }
  if (!fileExists(SCRIPT_MICROREG, true)) return res.status(500).json({ error: 'script_missing', bin: SCRIPT_MICROREG });

  const jobId = `microreg-${Date.now()}`;
  jobs.set(jobId, { listeners: new Set(), created: Date.now() });
  res.json({ ok: true, jobId });

  const args = [
    SCRIPT_MICROREG,
    '--kind', `"${safeKind}"`,
    '--file', `"${str(file)}"`,
    ...(safeTitle ? ['--title', `"${safeTitle}"`] : []),
    '--rumbo', `"${safeRumbo}"`,
    '--triada', `"${triada}"`,
    '--gates', `"${gates}"`,
    ...(safeObj ? ['--obj', `"${safeObj}"`] : []),
    '--clase', `"${safeClase || 'basica'}"`,
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
  const safeFecha = sanitizeInput(fecha, /^[0-9\-]+$/);
  const safeSeed = sanitizeInput(seed);
  const safeCue = sanitizeInput(cue);
  const safeVf = sanitizeInput(vf);
  if (!safeFecha || !safeSeed || !safeCue || !safeVf) {
    return res.status(400).json({ error: 'invalid_params' });
  }
  const diar = diarioFile ? resolveSafe(diarioFile) : defaultDiarioPath();
  const list = listadorFile ? resolveSafe(listadorFile) : defaultListadoPath();
  if (!fileExists(SCRIPT_FINALIZE, true)) return res.status(500).json({ error: 'script_missing', bin: SCRIPT_FINALIZE });

  const jobId = `finalize-${Date.now()}`;
  jobs.set(jobId, { listeners: new Set(), created: Date.now() });
  res.json({ ok: true, jobId });

  const args = [
    SCRIPT_FINALIZE,
    '--fecha', `"${safeFecha}"`,
    '--seed', `"${safeSeed}"`,
    '--cue', `"${safeCue}"`,
    '--vf', `"${safeVf}"`,
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
  if (!isValidFile(file)) return res.status(400).json({ error: 'file_invalid' });
  const safeRubro = sanitizeInput(rubro) || 'CURADURIA';
  const safeTitulo = sanitizeInput(titulo);
  const safeRumbo = sanitizeInput(rumbo);
  const safeKind = sanitizeInput(kind, /^[A-Z]+$/);
  const safeTitle = sanitizeInput(title);
  const safeFecha = sanitizeInput(fecha, /^[0-9\-]+$/);
  const safeSeed = sanitizeInput(seed);
  const safeCue = sanitizeInput(cue);
  const safeVf = sanitizeInput(vf);
  try { resolveSafe(file); } catch(e){ return res.status(400).json({ error: 'file_invalid', detail: String(e) }); }

  const jobId = `ritual-${Date.now()}`;
  jobs.set(jobId, { listeners: new Set(), created: Date.now() });
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
      '--rubro', `"${safeRubro}"`,
      '--file', `"${str(file)}"`,
      ...(safeTitulo ? ['--titulo', `"${safeTitulo}"`] : []),
      ...(safeRumbo ?  ['--rumbo', `"${safeRumbo}"`] : []),
    ], { onData: log });

    // 3) microreg
    await runScript('bash', [
      SCRIPT_MICROREG,
      '--kind', `"${safeKind || 'PROMO'}"`,
      '--file', `"${str(file)}"`,
      ...(safeTitle ? ['--title', `"${safeTitle}"`] : []),
      '--rumbo', `"${safeRumbo || 'Centro'}"`,
      '--triada', `"SIL·UM·Ə"`,
      '--gates', `"no_mentira,doble_testigo"`,
      '--clase', `"basica"`,
    ], { onData: log });

    // 4) finalize
    await runScript('bash', [
      SCRIPT_FINALIZE,
      '--fecha', `"${safeFecha || ''}"`,
      '--seed', `"${safeSeed || ''}"`,
      '--cue', `"${safeCue || ''}"`,
      '--vf', `"${safeVf || ''}"`,
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
    console.error(`[ritual/canon/m0m1] error:`, e);
    sseBroadcast(jobId, { done: true, code: e.code || 1, err: e.err, out: e.out });
  }
});

app.post('/api/v1/ritual/canon/m0m1', async (req,res)=>{
  const { file, fecha, seed, cue, vf, fs, rubro, titulo, rumbo, kind, title } = req.body||{};
  if (!isValidFile(file)) return res.status(400).json({ error:'file_invalid' });
  const safeRubro = sanitizeInput(rubro) || 'CURADURIA';
  const safeTitulo = sanitizeInput(titulo);
  const safeRumbo = sanitizeInput(rumbo);
  const safeKind = sanitizeInput(kind, /^[A-Z]+$/);
  const safeTitle = sanitizeInput(title);
  const safeFecha = sanitizeInput(fecha, /^[0-9\-]+$/);
  const safeSeed = sanitizeInput(seed);
  const safeCue = sanitizeInput(cue);
  const safeVf = sanitizeInput(vf);
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
      '--rubro', `"${safeRubro}"`,
      '--file',  `"${str(file)}"`,
      ...(safeTitulo? ['--titulo', `"${safeTitulo}"`] : []),
      ...(safeRumbo ? ['--rumbo',  `"${safeRumbo}"`] : []),
    ], { onData: log });

    // Microreg
    await runScript('bash', [
      SCRIPT_MICROREG,
      '--kind', `"${safeKind || 'PROMO'}"`,
      '--file', `"${str(file)}"`,
      ...(safeTitle? ['--title', `"${safeTitle}"`] : []),
      '--rumbo', `"${safeRumbo || 'Centro'}"`,
      '--triada', `"SIL·UM·Ə"`,
      '--gates',  `"no_mentira,doble_testigo"`,
      '--clase',  `"basica"`,
    ], { onData: log });

    // Finalize
    await runScript('bash', [
      SCRIPT_FINALIZE,
      '--fecha', `"${safeFecha || ''}"`,
      '--seed',  `"${safeSeed || ''}"`,
      '--cue',   `"${safeCue || ''}"`,
      '--vf',    `"${safeVf || ''}"`,
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
    }catch(e){ console.error(`[sistema] append err:`, e); log(`[sistema] append err: ${e}`); }

    // Manifest
    if (fileExists(GEN_MANIFEST)) {
      await runScript('node', [GEN_MANIFEST], { onData: (l)=>log(`[manifest] ${l}`) });
    }

    sseBroadcast(jobId,{ done:true, code:0 });
  } catch (e) {
    console.error(`[ritual/canon/m0m1] finalize error:`, e);
    sseBroadcast(jobId,{ done:true, code:e.code||1, err:e.err, out:e.out });
  }
});

// -------------------------------------------------------------
// LL_PE endpoint (M2/M3)
// -------------------------------------------------------------
app.post('/api/v1/llpe', async (req, res) => {
  const { file, vf, seed, cue, materia, nutriaDir } = req.body || {};
  if (!file) return res.status(400).json({ error: 'file_required' });
  if (!isValidFile(file)) return res.status(400).json({ error: 'file_invalid' });
  
  try { resolveSafe(file); } catch(e){ return res.status(400).json({ error:'file_invalid', detail:String(e) }); }
  
  const jobId = `llpe-${Date.now()}`;
  jobs.set(jobId,{listeners:new Set(), created:Date.now()});
  res.json({ ok:true, jobId });
  const log = (m)=> sseBroadcast(jobId,{ line:m });
  
  try {
    const scriptPath = path.join(SCRIPTS, 'qel_llpe.sh');
    if (!fs.existsSync(scriptPath)) {
      log(`[llpe] script no encontrado: ${scriptPath}`);
      sseBroadcast(jobId,{ done:true, code:1 });
      return;
    }
    
    const args = [file];
    if (vf) args.push('--vf', vf);
    if (seed) args.push('--seed', seed);
    if (cue) args.push('--cue', cue);
    if (materia) args.push('--materia', materia);
    if (nutriaDir) args.push('--nutria-dir', nutriaDir);
    
    const result = await runScript('bash', [scriptPath, ...args], { onData: (l)=>log(`[llpe] ${l}`) });
    log(`[llpe] completado`);
    sseBroadcast(jobId,{ done:true, code:0 });
  } catch (e) {
    log(`[llpe] error: ${e.message || e}`);
    sseBroadcast(jobId,{ done:true, code:1 });
  }
});

// -------------------------------------------------------------
// FS Hash endpoint
// -------------------------------------------------------------
app.post('/api/v1/fs/hash', (req, res) => {
  const { file, fs: fsObj, save } = req.body || {};
  
  try {
    if (fsObj && typeof fsObj === 'object') {
      const hash10 = sha1_10(normalizeJsonForHash(fsObj));
      let savedPath;
      if (save) {
        ensureDir(DOCS_FS);
        const yymmdd = new Date().toISOString().slice(2,10).replace(/-/g,'').slice(0,6);
        savedPath = path.join(DOCS_FS, `FS_${yymmdd}_hash.json`);
        fs.writeFileSync(savedPath, JSON.stringify({ hash10, fs: fsObj, created: new Date().toISOString() }, null, 2), 'utf-8');
      }
      return res.json({ ok: true, hash10, saved: savedPath });
    }
    
    if (file) {
      if (!isValidFile(file)) return res.status(400).json({ error: 'file_invalid' });
      try { resolveSafe(file); } catch(e){ return res.status(400).json({ error:'file_invalid', detail:String(e) }); }
      const raw = fs.readFileSync(file, 'utf-8');
      const parsed = JSON.parse(raw);
      const hash10 = sha1_10(normalizeJsonForHash(parsed));
      return res.json({ ok: true, hash10 });
    }
    
    return res.status(400).json({ error: 'file_or_fs_required' });
  } catch (e) {
    return res.status(500).json({ ok: false, error: String(e) });
  }
});

// -------------------------------------------------------------
// Health check endpoint
// -------------------------------------------------------------
app.get('/api/v1/health', (_req, res) => {
  res.json({ 
    ok: true, 
    timestamp: new Date().toISOString(),
    uptime: process.uptime(),
    jobs: jobs.size,
    memory: process.memoryUsage()
  });
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
