set -euo pipefail
REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$REPO_ROOT/apps/preh-nav-m1"
node scripts/generate_manifest.mjs
