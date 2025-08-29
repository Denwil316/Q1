#!/usr/bin/env node
/* [QEL::ECO[96]::RECALL A96-250828-LLPE-GEN-v1-3]
   SeedI=A96-250824
   SoT=LL-PE/v1.3
   Version=v1.3
   Updated=2025-08-28 */

import fs from 'fs'; import crypto from 'crypto'; import { spawnSync } from 'child_process';

const TAU = 0.62;
const CHI_R = { N:1.00, C:1.00, O:0.95, E:0.95, W:0.90, S:0.88 };
const H_K   = { comun:0.85, 'poco-comun':0.92, 'poco-común':0.92, raro:0.92, singular:1.00, unico:1.00, 'único':1.00 };
const RUB = { canonica:0.95, 'canónica':0.95, directa:0.80, indirecta:0.60 };
const MAT = { // fonema -> altas/medias/bajas
  'Ə': { alta:['vacio','éter','espacio'], media:['plasma'], baja:['solido','sólido','mineral','organico','orgánico'] },
  'UM':{ alta:['tierra','estructura','soporte'], media:['organico','orgánico'], baja:['plasma'] },
  'A': { alta:['aire','gas','umbral'], media:['agua'], baja:['mineral','solido','sólido'] },
  'RA':{ alta:['fuego','luz','plasma'], media:['metal'], baja:['agua'] },
  'KA':{ alta:['metal','cristal','mineral'], media:['tierra'], baja:['vacio','éter'] },
  'THON':{ alta:['liquido','líquido','agua','sangre'], media:['organico','orgánico'], baja:['cristal'] },
  'SIL':{ alta:['organico','orgánico','tejido','polimero','polímero'], media:['red','cristal'], baja:['vacio','éter'] },
};

function sha1(x){ return crypto.createHash('sha1').update(String(x)).digest('hex'); }
function pick(arr, seedHex){ const n=parseInt(seedHex.slice(0,8),16); return arr[n%arr.length]; }
function readAny(path){ const s = fs.readFileSync(path,'utf8'); try{return JSON.parse(s)}catch{}; return s; }
function parseVF(src){ // JSON o YAML plano sencillo
  if(typeof src==='object') return src;
  const o={}; src.split(/\r?\n/).forEach(l=>{const m=l.match(/^\s*([A-Za-z0-9_.-]+)\s*:\s*(.+?)\s*$/); if(m)o[m[1]]=m[2];});
  return o;
}

function materiaAffinityFor(fonema, mat){
  const M = MAT[fonema]||{};
  const m = String(mat||'').toLowerCase();
  if((M.alta||[]).some(x=>m.includes(x))) return RUB.canonica;
  if((M.media||[]).some(x=>m.includes(x))) return RUB.directa;
  if((M.baja||[]).some(x=>m.includes(x)))  return RUB.indirecta;
  return RUB.directa; // default prudente
}
function A_from_pw_materia(p, wArr, materia){
  const f = p.split(/[·\.]/).filter(Boolean);
  const a = f.map(fn=>materiaAffinityFor(fn, materia));
  const A = (wArr[0]*a[0]) + (wArr[1]*a[1]) + (wArr[2]*a[2]);
  return Math.max(0, Math.min(1, A));
}

function buildPE(VF, materia){
  const V = VF.vf || VF;
  const prima = V.prima || V['VF.PRIMA'] || '';
  const cue   = VF.cue || V.cue || '';
  const p     = (V.p || V.triada || 'Ə·UM·A');
  const w     = (V.w || V.pesos || [0.40,0.35,0.25]).map(Number);
  const O     = V.objeto || 'Llave';
  const r     = String(V.rumbo||'C').toUpperCase();
  const k     = (V.clase || 'raro').toLowerCase();
  const gates = (V.gates || ['mediacion','doble']);
  const seed  = sha1([prima,cue,(VF.SeedI||VF.Seed||''),p,w.join(','),O,r,k, (gates||[]).join(','), materia||''].join('|'));
  const tipos = ['orden-triadico','espejo','mapa-objeto','umbral-sustraccion','pliegue-tiempo','tejido-nexo','apertura-llave'];
  const tipo  = pick(tipos, seed);
  const id    = 'PE::'+seed.slice(0,10);
  let texto,validador,meta;
  if(tipo==='orden-triadico'){
    const [on,nu,co]=p.split(/[·\.]/).filter(Boolean).slice(0,3);
    texto = `INV: “${on} en ${r}”. UMB: “Veo ${O}”. PISTA: Ordena triada (onset=${on}, núcleo=${nu}, coda=${co}) con cierre en tejido si Centro. SIL: “UM→Ə→UM”. PRUEBA: “ΔC≥0 & 𝒱≥0.62”.`;
    validador={modo:'mask',data:`${on}·${nu}·${co}`}; meta={seed,slots:{onset:on,nucleo:nu,coda:co},vf_ref:cue,materia};
  } else if(tipo==='apertura-llave'){
    const opciones=['Ə·UM·A','Ə·UM·SIL','UM·A·SIL'];
    texto = `PISTA: Tres patrones llaman a la Llave en ${r}: {${opciones.join(', ')}}. Responde SOLO con uno y justifica (≤9 palabras) “cómo abre sin quebrar el sostén”. PRUEBA 𝒱: max V en ${r}.`;
    validador={modo:'calc',data:{opciones}}; meta={seed,slots:{opciones},vf_ref:cue,materia};
  } else {
    texto = `PISTA: Devuelve el patrón que maximiza 𝒱 (rumbo=${r}) para objeto=${O}. PRUEBA: τ=0.62.`; 
    validador={modo:'calc',data:{opciones:['Ə·UM·A','Ə·UM·SIL','UM·A·SIL']}}; meta={seed,vf_ref:cue,materia};
  }
  const xr=CHI_R[r]||1.00, hk=H_K[k]||1.00;
  const gp = (()=>{ // gates product (mediación, doble, aurora neutralizante)
    let med=1.00,dob=1.00,aur=1.00;
    const g=(gates||[]).map(x=>String(x).toLowerCase());
    if(!(g.includes('mediacion')||g.includes('mediación'))) med=0.80;
    if(!g.includes('doble')) dob=0.90;
    if(g.includes('aurora')||g.includes('contacto_aurora')) aur=0.95;
    return med*dob*aur;
  })();
  const A_auto = A_from_pw_materia(p,w,materia||'');
  return { pe:{id,tipo,texto,validador,meta}, vf:{prima,cue,p,w,O,r,k,gates, xr,hk,gp, A_auto, materia} };
}

function vcalcJSON({obj,A,r,k,gates,ruido,dc,ds}){
  const cmd = `LC_ALL=C LC_NUMERIC=C scripts/qel vcalc --obj "${obj}" --afinidad ${A.toFixed(3)} --rumbo ${r} --clase ${k} --gates "${gates.join(',')}" --ruido ${ruido||0} --delta-c ${dc} --delta-s ${ds} --emit json`;
  const res = spawnSync('bash',['-lc',cmd],{encoding:'utf8'});
  try{ return JSON.parse((res.stdout||'').trim()) }catch{ return {error:'vcalc-json', raw:res.stdout} }
}

function main(){
  const args=Object.fromEntries(process.argv.slice(2).map((v,i,a)=>v.startsWith('--')?[v.slice(2),a[i+1]??true]:null).filter(Boolean));
  const vfPath=args.vf||args.in||'docs/atlas/Tarjeta_VF_Kosmos8_v1.0.yaml';
  const materia=(args.materia||'').toLowerCase(); // ej. aire|agua|metal|organico|vacio…
  const answer=args.answer||null; const emit=args.emit||'json'; const preset=args.preset||'Apertura';
  const ruido=parseFloat(args.ruido||0); const dc=args['delta-c']||'flat'; const ds=args['delta-s']||'flat'; const tau=parseFloat(args.tau||TAU);
  const raw=parseVF(readAny(vfPath));
  const built=buildPE(raw,materia);
  if(emit==='md'){ console.log(`# Poema-Enigma (v1.3)\n\nID: ${built.pe.id}\nTipo: ${built.pe.tipo}\n\n> ${built.pe.texto}\n`);}
  else{ console.log(JSON.stringify({pe:built.pe, vf:built.vf},null,2)); }
  if(!answer) return;

  // Validación
  const mode=built.pe.validador.modo, data=built.pe.validador.data;
  let ok=false;
  if(mode==='mask'){
    const mask=String(data).trim().toUpperCase();
    ok=(String(answer).trim().split(/\s|—|-/)[0].toUpperCase()===mask);
  } else {
    const opciones=(data.opciones||[]); let best=null,bV=-1;
    for(const opt of opciones){
      const out=vcalcJSON({obj:built.vf.O, A:built.vf.A_auto, r:built.vf.r, k:built.vf.k, gates:built.vf.gates, ruido, dc:dc, ds:ds});
      const V=Number(out?.V||0); if(V>bV){bV=V; best=opt;}
    }
    ok=(String(answer).trim().split(/\s|—|-/)[0].toUpperCase()===(best||'').toUpperCase());
  }
  if(!ok){ console.error(JSON.stringify({error:'validator_fail'},null,2)); process.exit(1); }

  // vcalc final
  const out=vcalcJSON({obj:built.vf.O, A:built.vf.A_auto, r:built.vf.r, k:built.vf.k, gates:built.vf.gates, ruido, dc:dc, ds:ds});
  const V=Number(out?.V||0); if(!(V>=tau)){ console.error(JSON.stringify({error:'V<threshold', V, tau},null,2)); process.exit(2); }

  // Mint
  const seed=built.pe.meta.seed; const hid = (preset==='Puente')? `HAB::K8-PT-NEXO-${seed.slice(0,6).toUpperCase()}` : `HAB::K8-LL-APERT-${seed.slice(0,6).toUpperCase()}`;
  const nombre=(preset==='Puente')? "Tejido de Umbral (Nexo I)" : "Llave de Matrices (Apertura I)";
  const hab={ id:hid, nombre, vf_ref:built.vf.cue||"VF::?", pe_ref:built.pe.id, efecto:(preset==='Puente')?["cierre_en:SIL","ΔS:+","residuo:0"]:["abrir_sello:1","ΔC:+","ρ≤0.02"], params:{ r:built.vf.r, O:built.vf.O, V, materia:built.vf.materia }, cierre:"SIL→UM→Ə" };
  if(emit==='md'){ console.log(`\n---\n**HABILIDAD CRISTALIZADA**\n\n- ID: ${hab.id}\n- Nombre: ${hab.nombre}\n- PE: ${hab.pe_ref}\n- V: ${V.toFixed(2)} (τ=${tau})\n- Materia: ${built.vf.materia||'-'}\n- Efecto: ${hab.efecto.join(', ')}\n`); }
  else{ console.log(JSON.stringify({habilidad:hab, V, tau},null,2)); }
}
main();
