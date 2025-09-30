// apps/preh-nav-m1/server.mjs
import express from 'express';
import cors from 'cors';
import { spawn } from 'child_process';
import path from 'path';
import { fileURLToPath } from 'url';
// (opcional) si prefieres body-parser: import bodyParser from 'body-parser';

const app = express();
app.use(express.json());                    // o: app.use(bodyParser.json());
app.use(cors({ origin: true }));            // CORS abierto para pruebas

// ----- ROOT robusto (independiente del cwd) -----
const __filename = fileURLToPath(import.meta.url);
const __dirname  = path.dirname(__filename);
// sube dos niveles: apps/preh-nav-m1/ -> apps/ -> (repo root)
const ROOT = path.resolve(__dirname, '..', '..');
const SCRIPT = p => path.join(ROOT, 'scripts', p);

// ----- Validaciones básicas -----
const okRumbo = new Set(['N','O','E','W','S','C']);
const okClase = new Set(['basica','básica','raro','rara','singular','unico','único','metalica','metálica','obsidiana']);
const okDelta = new Set(['up','flat','down']);

// ----- Rutas de cortesía -----
app.get('/', (_req, res) => {
  res.type('text').send('PREH-NAV API OK. Use POST /api/v1/vcalc');
});
app.get('/health', (_req, res) => res.json({ ok: true }));
// (opcional) sirve docs estáticos si quieres verlos en el navegador
app.use('/docs', express.static(path.join(ROOT, 'apps/preh-nav-m1/public/docs')));

// ----- API: vcalc -----
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
    const R = String(rumbo).toUpperCase();
    if (!okRumbo.has(R)) return res.status(400).json({ error: 'rumbo inválido' });
    if (!okClase.has(String(clase))) return res.status(400).json({ error: 'clase inválida' });
    if (!delta || !okDelta.has(delta.c) || !okDelta.has(delta.s)) return res.status(400).json({ error: 'delta inválido' });

    const g = (Array.isArray(gates) ? gates : String(gates).split(','))
      .map(s => String(s || '').trim())
      .filter(Boolean)
      .join(',');

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

    const bin = SCRIPT('qel_vcalc.sh');
    const ps = spawn(bin, args, {
      shell: false,
      env: { ...process.env, LC_ALL: 'C', LC_NUMERIC: 'C' }
    });

    const killTimer = setTimeout(() => ps.kill('SIGKILL'), 8000);

    let out = '', err = '';
    ps.stdout.on('data', d => (out += d));
    ps.stderr.on('data', d => (err += d));
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

// ----- Arranque -----
const PORT = 3030;
app.listen(PORT, () => console.log(`PREH-NAV API on http://localhost:${PORT}`));

// (opcional) helper si vas a llamar desde front
export async function runVcalc(payload) {
  const r = await fetch(`http://localhost:${PORT}/api/v1/vcalc`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(payload)
  });
  if (!r.ok) throw new Error('VCALC error');
  return await r.json();
}
