/* [QEL::ECO[96]::RECALL A96-250824-GEN-CORE-MANIFEST]
   SeedI=A96-250824
   SoT=PREH-NAV/CORE-MANIFEST/v0.1
   Version=v0.1
   Updated=2025-08-24 */

import fs from 'fs';
import path from 'path';
import { createHash } from 'crypto';

const ROOT = process.env.REPO_ROOT || process.cwd();
const CORE = path.join(ROOT, 'docs', 'core');
const OUT  = path.join(CORE, 'QEL_SoT_Manifest_v0.8.json');

function walk(dir) {
  const out = [];
  for (const e of fs.readdirSync(dir, { withFileTypes: true })) {
    if (e.name.startsWith('.')) continue;
    const f = path.join(dir, e.name);
    if (e.isDirectory()) out.push(...walk(f));
    else out.push(f);
  }
  return out;
}

function readText(p) {
  try { return fs.readFileSync(p, 'utf8'); } catch { return ''; }
}

function take(re, s) {
  const m = s.match(re);
  return m ? (m[1] || m[0]).trim() : '';
}

function hash10(s) {
  return createHash('sha256').update(s, 'utf8').digest('hex').slice(0, 10);
}

function metaFromFile(full) {
  const rel = full.replace(ROOT + path.sep, '').replace(/\\/g, '/');
  const ext = path.extname(full).toLowerCase();
  if (!['.md', '.markdown', '.json'].includes(ext)) return null;

  const text = readText(full);

  const cue   = take(/^cue\s*=\s*(.+)$/mi, text);
  const seed  = take(/^SeedI\s*=\s*(.+)$/mi, text);
  const sot   = take(/^SoT\s*=\s*(.+)$/mi, text);
  const ver   = take(/^Version\s*=\s*(.+)$/mi, text);
  const upd   = take(/^Updated\s*=\s*(.+)$/mi, text);
  const title = take(/^\#\s+(.+)$/m, text);
  const h10   = take(/^HASH\(10\):\s*([A-Za-z0-9]+)$/mi, text);

  let canon = '';
  if (cue && seed && sot && ver && upd) {
    canon = `CUE=${cue}|SeedI=${seed}|SoT=${sot}|Version=${ver}|Updated=${upd}|Titulo=${title}`;
  }
  const computed = canon ? hash10(canon) : '';

  return {
    name: path.basename(full),
    path: rel,
    title: title || path.basename(full, ext),
    cue, seed,
    sot, version: ver, updated: upd,
    hash10: h10 || (computed || null),
    kind: 'core-doc'
  };
}

function main() {
  if (!fs.existsSync(CORE)) {
    console.error('[core-manifest] No existe docs/core');
    process.exit(1);
  }
  const files = walk(CORE);
  const items = files
    .map(metaFromFile)
    .filter(Boolean)
    .sort((a,b)=>a.name.localeCompare(b.name));

  const nowISO = new Date().toISOString();
  const out = {
    Version: 'v0.8',
    Updated: nowISO,
    manifest: items
  };

  fs.writeFileSync(OUT, JSON.stringify(out, null, 2), 'utf8');
  console.log('[core-manifest] Escrito', OUT, '(', items.length, 'entradas )');
}

main();