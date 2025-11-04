# QEL · Codex integración (branch `PreH`) — Notas didácticas

## 0) ¿Qué es una branch?
Una **branch** es una línea de tiempo paralela de tu repo. Trabajamos en `PreH` para no tocar `main`.

## 1) Requisitos
- git instalado (`git --version`)
- repositorio clonado (ej.: `git clone <URL> ~/Projects/codex`)
- activos descargados (ej.: `~/Downloads/qel_assets/`)

## 2) Archivos a copiar
- README_QEL_MASTER_v0.2.1.md
- A81_Notas_Espontaneasv_0.3.md
- CUE-RECOVERY_Plantilla_Caos_v0.2.1.md
- CUE-RECOVERY_Schema_v0.2.1.json
- (opcionales del Tratado) Memoria_de_Qel_Ledger_append_METAHUMANO_v0.1.json, Cue_METAHUMANO_TRATADO_v0.1.txt, Tratado_Metahumano_Nota_v0.1.md

## 3) Ejecutar el script
```bash
bash codex_preh_sync.sh /ruta/a/tu/repo /ruta/a/tu/qel_assets
```
Verás hashes SHA‑256 y un commit en `PreH`.

## 4) Problemas comunes
- “FALTA archivo en assets”: revisa nombres y ruta.
- Credenciales GitHub: usa token/SSH según tu entorno.
- Para revertir: `git reset --hard <hash_anterior>` y `git push -f origin PreH`.

#bash para assets en Descargas:
bash "$HOME/Descargas/Q1/codex_preh_sync.sh" "$HOME/Projects/codex" "$HOME/Descargas/Q1"
SeedI=A37-251015
SoT=UNSET
Version=v1.0
Updated=2025-11-04

991a696d87
