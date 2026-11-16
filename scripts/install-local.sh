#!/usr/bin/env bash
# Make the classes available to every LaTeX project on this machine by
# symlinking src/ into your personal TeX tree (TEXMFHOME). Edits in src/
# then take effect everywhere immediately, and new projects need only a
# main.tex (no copies of the class files).
#
#   scripts/install-local.sh            # install (symlink)
#   scripts/install-local.sh --remove   # uninstall
#
# Note: a project that also has copies of the class files next to main.tex
# uses those copies (the current folder is searched first).
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TEXMFHOME="$(kpsewhich -var-value TEXMFHOME)"
TARGET="$TEXMFHOME/tex/latex/uhm-ling"

if [ "${1:-}" = "--remove" ]; then
  rm -f "$TARGET"
  echo "removed $TARGET"
  exit 0
fi

mkdir -p "$(dirname "$TARGET")"
if [ -e "$TARGET" ] && [ ! -L "$TARGET" ]; then
  echo "$TARGET exists and is not a symlink; remove it first." >&2
  exit 1
fi
ln -sfn "$ROOT/src" "$TARGET"
echo "linked $TARGET -> $ROOT/src"
kpsewhich uhmqp.cls uhmdiss.cls uhm-ling-core.sty
