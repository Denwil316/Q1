[QEL::ECO[96]::RECALL A96-250824-QEL-FORMATOR-MANUAL-V1-0]
SeedI=A96-250824
SoT=FORMATOR/V1.1
Version=v1.1
Updated=2025-08-24
# Manual de Formato R — v1.1 (Integrado · Tejera en Sur)

## Propósito
Citar, rastrear y **promocionar** (Cristalizar) entradas con *cuerpo/ritmo*.

## Núcleo (R‑line)
`R#. Proyecto A96/QEL. (AAAA‑MM‑DD). QEL|A96|<TIPO>|<CUE>|v1.1|<Rumbo> — *<Título>*`

## Procedimiento (Sur)
1. Respira 9‑0‑9 · activa THON.  
2. Redacta **Delta‑Only** (3–9 líneas).  
3. Verifica **Doble Testigo**.  
4. Calcula 𝒱 si M1+.  
5. Si **Cristaliza** → **Promoción**: Árbol/VF + ListadoR.

## Comandos (macOS) — sólo si hay **promoción**
```bash
# Crear entrada R
echo "R$RNUM. Proyecto A96/QEL. ($(date +%F)). QEL|A96|$TIPO|$CUE|v1.1|$RUMBO — *$TITULO*" >> QEL_ListadoR_master_v1.0.md

# Plantilla Delta
cat > delta_${CUE}.md <<'MD'
DELTA=...
APRENDIZAJE=...
LIMITE=...
NEXT=...
MD
```

## Relaciones SoT
- FORMATOR ↔ SOT · DIARIO · GLOSARIO · VF‑ARBOLES · MFH

## Listado R — referencia
- `LISTADOR/A96-250824/FORMATOR/v1.1`

a1f13c990b
