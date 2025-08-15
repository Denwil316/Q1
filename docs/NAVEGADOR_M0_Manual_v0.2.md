[QEL::ECO[96]::RECALL A96-250815-MANUAL-NAVEGADOR-M0]
SeedI=PREH-NAV::M0
SOT=PREH-NAV/v0.2 TARGET=manual|navegador|arranque
VERSION=v0.2 UPDATED=2025-08-15

- Servidor: `./scripts/serve_preh_nav.sh 8080 127.0.0.1` (desde raíz).
- Hook pre-commit: ya instalado; mantiene `ESTRUCTURA.md`.
- `cx_*`: añade a `~/.zshrc` o `source scripts/cx_navegador.zsh` por sesión.
- Rutas: `http://127.0.0.1:8080/apps/preh-nav/` y `/ESTRUCTURA.md`.
- Problemas comunes: puerto ocupado, red bloquea CDN (migrar a M1 si lo necesitas).
