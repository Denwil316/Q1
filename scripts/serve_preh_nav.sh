SeedI=PREH-NAV::M0
SOT=PREH-NAV/v0.2 TARGET=serve|http|static
VERSION=v0.2 UPDATED=2025-08-15
set -euo pipefail
ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$ROOT"
PORT="${1:-8080}"
BIND="${2:-127.0.0.1}"
echo "PREH · sirviendo Codex en http://$BIND:$PORT  (raíz: $ROOT)"
python3 -m http.server "$PORT" --bind "$BIND"
