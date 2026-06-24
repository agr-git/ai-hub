#!/usr/bin/env bash
#
# sync.sh — copy the canonical AI Hub into the Story Engine deploy folder.
#
# Source of truth:  ai-hub/index.html  (this repo)
# Deploy target:    <story-engine>/docs/hub/index.html  (session-gated, served at /dashboard/hub/)
#
# The Story Engine site is baked into a Docker image (COPY docs/), so after
# syncing you must commit the Story Engine repo AND rebuild its container for
# the change to go live. This script does the file copy + optional git commit;
# pass --commit to commit, --push to also push. Rebuild happens on the VPS.
#
# Usage:
#   ./sync.sh                 # copy only
#   ./sync.sh --commit        # copy + commit in the Story Engine repo (on main)
#   ./sync.sh --commit --push # copy + commit + push main
#   STORY_ENGINE=/path ./sync.sh   # override target repo location
#
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC="$HERE/index.html"

# Default: sibling "4P | LinkedIn Story-Led Engine" folder next to ai-hub.
STORY_ENGINE="${STORY_ENGINE:-$HERE/../4P | LinkedIn Story-Led Engine}"
DEST_DIR="$STORY_ENGINE/docs/hub"
DEST="$DEST_DIR/index.html"

if [[ ! -f "$SRC" ]]; then
  echo "✗ source not found: $SRC" >&2; exit 1
fi
if [[ ! -d "$STORY_ENGINE/.git" ]]; then
  echo "✗ Story Engine repo not found at: $STORY_ENGINE" >&2
  echo "  set STORY_ENGINE=/absolute/path and retry." >&2; exit 1
fi

mkdir -p "$DEST_DIR"
cp "$SRC" "$DEST"
echo "✓ synced → $DEST"

DO_COMMIT=false; DO_PUSH=false
for arg in "$@"; do
  case "$arg" in
    --commit) DO_COMMIT=true ;;
    --push)   DO_COMMIT=true; DO_PUSH=true ;;
    *) echo "unknown flag: $arg" >&2; exit 1 ;;
  esac
done

if $DO_COMMIT; then
  if git -C "$STORY_ENGINE" diff --quiet -- "docs/hub/index.html" \
     && git -C "$STORY_ENGINE" diff --cached --quiet -- "docs/hub/index.html" \
     && ! git -C "$STORY_ENGINE" ls-files --error-unmatch "docs/hub/index.html" >/dev/null 2>&1; then
    : # new file, fall through to add/commit
  fi
  git -C "$STORY_ENGINE" add "docs/hub/index.html"
  if git -C "$STORY_ENGINE" diff --cached --quiet; then
    echo "• no changes to commit"; exit 0
  fi
  git -C "$STORY_ENGINE" commit -q -m "chore(hub): sync AI Hub from ai-hub repo"
  echo "✓ committed in Story Engine ($(git -C "$STORY_ENGINE" rev-parse --abbrev-ref HEAD))"
  if $DO_PUSH; then
    git -C "$STORY_ENGINE" push -q origin "$(git -C "$STORY_ENGINE" rev-parse --abbrev-ref HEAD)"
    echo "✓ pushed"
  fi
fi

echo ""
echo "Next: the live site is baked into a Docker image. To publish, on the VPS run:"
echo "  cd <story-engine> && git pull && docker compose build engine && docker compose up -d"
echo "Then it's live at  https://<your-autonomia-domain>/dashboard/hub/  (requires login)"
