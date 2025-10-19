#!/usr/bin/env python3
import sys, re, unicodedata, pathlib

def strip_accents(s):
    return ''.join(c for c in unicodedata.normalize('NFD', s) if unicodedata.category(c)!='Mn')

def slugify(s):
    s = strip_accents(s.lower())
    s = re.sub(r'[^a-z0-9]+', '-', s).strip('-')
    s = re.sub(r'-{2,}', '-', s)
    return s

def anchor_for(title):
    # 1) Apéndices: "Apéndice A) Título"
    m = re.match(r'^\s*ap[ée]ndice\s+([A-Z])\)\s*(.+)$', title, flags=re.I)
    if m:
        return f"apdx-{m.group(1).lower()}-{slugify(m.group(2))}"
    # 2) Capítulos numerados: "3. Lámina V ..." o "3.1 Procedimiento"
    m = re.match(r'^\s*([0-9]+(\.[0-9]+)*)\s+(.+)$', title)
    if m:
        num = m.group(1).replace('.', '-')
        return f"sec-{num}-{slugify(m.group(3))}"
    # 3) Genérico
    return f"sec-{slugify(title)}"

def process(path):
    text = pathlib.Path(path).read_text(encoding='utf-8')
    out_lines=[]
    in_code=False
    fence=re.compile(r'^\s*```')
    head=re.compile(r'^\s*(#{1,6})\s+(.*\S)\s*$')

    for line in text.splitlines():
        if fence.match(line):
            in_code = not in_code
            out_lines.append(line)
            continue
        m = None if in_code else head.match(line)
        out_lines.append(line)
        if m:
            title = m.group(2)
            aid = anchor_for(title)
            # Si ya existe el anchor inmediato, no duplicar
            if not out_lines or not re.search(r'id\s*=\s*"' + re.escape(aid) + r'"', line):
                out_lines.append(f'<a id="{aid}"></a>')
    pathlib.Path(path).write_text('\n'.join(out_lines) + '\n', encoding='utf-8')

if __name__ == "__main__":
    if len(sys.argv)<2:
        print("Uso: qel_inject_anchors.py <archivo> [mas archivos...]")
        sys.exit(2)
    for p in sys.argv[1:]:
        process(p)
    print("[ok] anchors inyectados")
