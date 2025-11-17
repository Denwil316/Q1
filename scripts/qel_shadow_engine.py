#!/usr/bin/env python3
# qel_shadow_engine.py — Motor mínimo de Perfilación de Sombras (sin dependencias)
# Lee narrativa .md + FS.json → escribe perfil.json + misiones.md

import argparse, json, re, os, datetime, hashlib

def read_text(p):
    with open(p, 'r', encoding='utf-8', errors='ignore') as f:
        return f.read()

def read_json(p):
    with open(p, 'r', encoding='utf-8', errors='ignore') as f:
        return json.load(f)

def kv_from_md(md, key):
    # admite "key=val" o "key: val" (tolerante a '#')
    m = re.search(rf"^[#\s]*{re.escape(key)}\s*[:=]\s*\"?([^\n\"]+)\"?", md, re.MULTILINE)
    return m.group(1).strip() if m else ""

def first_cue(md):
    m = re.search(r"^[#\s]*\[QEL::ECO[^\n]+", md, re.MULTILINE)
    return m.group(0).strip() if m else ""

def parse_context_tags(md):
    """
    Lee líneas tipo:
      #contexto: fonema=Vun; triada=Voh-Thon-A; arquetipo=Puente
      #criterio: entregar evidencia X en ≤ 20 min con ritmo 9-0-9
    """
    ctx = {}
    for line in md.splitlines():
        if line.strip().lower().startswith("#contexto:"):
            body = line.split(":",1)[1]
            for par in body.split(";"):
                if "=" in par:
                    k,v = par.split("=",1)
                    ctx[k.strip().lower()] = v.strip()
        if line.strip().lower().startswith("#criterio:"):
            ctx.setdefault("criterios", []).append(line.split(":",1)[1].strip())
    return ctx

def derive_short_id(seed, file_bn):
    raw = (seed + "|" + file_bn).encode("utf-8")
    return hashlib.sha1(raw).hexdigest()[:6]

def affinity_from(fs, ctx):
    # afinidades sencillas (semilla para prototipo)
    rumbo = fs.get("rumbo","Centro")
    modo  = fs.get("modo","M1")
    fonema = ctx.get("fonema","")
    triada = ctx.get("triada","")
    # vector semilla legible
    return {
        "rumbo": rumbo,
        "modo": modo,
        "fonema": fonema,
        "triada": triada,
        "peso_sem": 0.8 if fonema or triada else 0.6,
        "peso_op": 0.7 if ctx.get("criterios") else 0.5
    }

def generate_missions(fs, ctx, texto):
    """
    Banco mínimo de plantillas:
      - Sondaje (lectura dirigida) → evidencia semántica (τ_sem)
      - Pulso 9-0-9 (operativo) → evidencia temporal (τ_op)
      - Interfaz (puente) → evidencia social/testigo
    """
    tema = fs.get("tema","Perfilación")
    rumbo = fs.get("rumbo","Centro")
    criterios = ctx.get("criterios", [])
    base = []

    base.append({
        "id": "M1-sondaje",
        "titulo": f"Sondaje de sentido ({tema})",
        "tipo": "semantica",
        "instruccion": "Extrae 3 frases núcleo que contengan tu conflicto/deseo y re-escríbelas en modo ‘no-mentira’.",
        "evidencia": "Archivo MD con 3 frases núcleo y breve justificación.",
        "tau_sem_min": 0.75, "tau_op_min": 0.0,
        "rumbo": rumbo
    })
    base.append({
        "id": "M2-pulso",
        "titulo": "Pulso 9-0-9 (ritmo somático-verbal)",
        "tipo": "operativa",
        "instruccion": "Graba un audio/nota con 3 ciclos de respiración 9-0-9 y una frase guía por ciclo.",
        "evidencia": "Archivo de audio o MD con marcas de tiempo (≥ 3 ciclos).",
        "tau_sem_min": 0.6, "tau_op_min": 0.7,
        "rumbo": rumbo
    })
    base.append({
        "id": "M3-puente",
        "titulo": "Interfaz-Puente",
        "tipo": "social",
        "instruccion": "Entrega una evidencia compartible (enlace, imagen o breve demo) que muestre tu ‘Puente’ activo.",
        "evidencia": "URL/imagen + 3 líneas de contexto.",
        "tau_sem_min": 0.7, "tau_op_min": 0.65,
        "rumbo": rumbo
    })
    # Si el usuario ya dejó criterios, los añadimos como misión puntual
    for i, c in enumerate(criterios, start=1):
      base.append({
        "id": f"M4-criterio-{i}",
        "titulo": "Criterio declarado",
        "tipo": "criterio",
        "instruccion": c,
        "evidencia": "Lo que se especifique en el criterio.",
        "tau_sem_min": 0.7, "tau_op_min": 0.7,
        "rumbo": rumbo
      })
    return base

def write_profile_json(perf_path, perfil):
    os.makedirs(os.path.dirname(perf_path), exist_ok=True)
    with open(perf_path, 'w', encoding='utf-8') as f:
        json.dump(perfil, f, ensure_ascii=False, indent=2)

def write_misiones_md(mis_path, perfil, misiones):
    os.makedirs(os.path.dirname(mis_path), exist_ok=True)
    now = datetime.date.today().isoformat()
    cue = perfil.get("cue","[QEL::ECO[96]::RECALL]")
    seed = perfil["seed"]
    sot = "SHADOW/MISIONES/v1.0"
    ver = "v1.0"
    with open(mis_path, 'w', encoding='utf-8') as f:
        f.write(f"""{cue}
SeedI={seed}
SoT={sot}
Version={ver}
Updated={now}

# Misiones de Sombra — {perfil['shadow_id']} ({perfil['affinity']['fonema'] or '—'}/{perfil['affinity']['rumbo']})

> **Rol**: Árbitra en Centro · Forja de misiones a partir de texto-semilla y FS.

## Cartografía mínima
- Fonema: **{perfil['affinity'].get('fonema','')}**
- Triada: **{perfil['affinity'].get('triada','')}**
- Rumbo: **{perfil['affinity'].get('rumbo','')}**
- Modo: **{perfil['affinity'].get('modo','')}**

## Misiones (primera oleada)
""")
        for m in misiones:
            f.write(f"""
### {m['id']} · {m['titulo']}
Tipo: **{m['tipo']}** · Rumbo: **{m['rumbo']}**  
Umbrales: τ_sem ≥ {m['tau_sem_min']} ; τ_op ≥ {m['tau_op_min']}

**Instrucción**  
{m['instruccion']}

**Evidencia esperada**  
{m['evidencia']}
""")
        f.write(f"""

---

## Obsidianas, Aurora y Juicio (desbloqueos)
- **Obsidianas**: se otorga 1 por cada misión con τ_sem y τ_op ≥ umbral (No-Mentira + Doble Testigo).
- **Aurora Tutor**: si en la primera habilidad se activa *cue-exception*, se “escucha la llamada” y se abre **cue-portal** (misión especial de resonancia).
- **Juicio de QEL** (jefe final): tras completar el set de obsidianas, tres pruebas:  
  1) **Claridad** (síntesis semántica)  
  2) **Coherencia** (demostración operativa)  
  3) **Resonancia** (testigo social).  

Al superar las tres, la Sombra cruza a la **Novena Parte** (Camino Luz). Si falla por sombra consciente, enfrenta a su **Aurora** (Camino Sombra) con nueva tríada.
""")

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--file", required=True)
    ap.add_argument("--fs", required=True)
    ap.add_argument("--seed", required=True)
    ap.add_argument("--perfil-out", required=True)
    ap.add_argument("--misiones-out", required=True)
    args = ap.parse_args()

    md = read_text(args.file)
    fs = read_json(args.fs)  # generado por qel_session_new.sh

    cue = kv_from_md(md, "cue") or first_cue(md) or "[QEL::ECO[96]::RECALL]"
    sot = kv_from_md(md, "SoT") or "NUTRIA/TEXTO"
    ver = kv_from_md(md, "Version") or "v0.1"
    upd = kv_from_md(md, "Updated") or datetime.date.today().isoformat()
    ctx = parse_context_tags(md)

    shadow_id = derive_short_id(args.seed, os.path.basename(args.file))
    aff = affinity_from(fs, ctx)
    missions = generate_missions(fs, ctx, md)

    perfil = {
        "seed": args.seed,
        "shadow_id": shadow_id,
        "cue": cue,
        "source": os.path.relpath(args.file),
        "fs": os.path.relpath(args.fs),
        "sot_source": sot,
        "version_source": ver,
        "updated_source": upd,
        "affinity": aff,
        "gates": {
            "no_mentira": True,
            "doble_testigo": True,
            "tau_sem_min": 0.7,
            "tau_op_min": 0.65
        },
        "obsidianas": {
            "objetivo": 3,   # mínimo para abrir Aurora/Juicio en este prototipo
            "obtenidas": 0
        },
        "estado": {
            "camino": "indeterminado", # "luz" | "sombra"
            "avance": "inicio"
        }
    }

    write_profile_json(args.perfil_out, perfil)
    write_misiones_md(args.misiones_out, perfil, missions)

if __name__ == "__main__":
    main()
