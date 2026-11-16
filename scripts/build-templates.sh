#!/usr/bin/env bash
# Build self-contained template folders and Overleaf-ready zips in dist/.
#
#   scripts/build-templates.sh
#
# Each template gets a copy of every file in src/ next to main.tex, so the
# folder compiles anywhere with TeX Live (including Overleaf) without
# installing anything. Upload a zip on Overleaf with
#   New Project > Upload Project.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DIST="$ROOT/dist"
rm -rf "$DIST"
mkdir -p "$DIST"
VERSION="$(sed -n 's/.*\\ProvidesClass{uhmqp}\[[0-9/]* \(v[0-9.]*\).*/\1/p' "$ROOT/src/uhmqp.cls")"

build() {  # $1 template dir name, $2 output name
  local out="$DIST/$2"
  mkdir -p "$out"
  cp -R "$ROOT/templates/$1/." "$out/"
  cp "$ROOT"/src/*.sty "$ROOT"/src/*.cls "$ROOT"/src/*.def "$ROOT"/src/*.lua "$out/"
  cat > "$out/README.txt" <<EOF
UHM Linguistics LaTeX template ($2, $VERSION)

Compile with XeLaTeX (or LuaLaTeX) and Biber:  latexmk main.tex
On Overleaf: New Project > Upload Project > choose this zip, then Recompile.
The included latexmkrc runs XeLaTeX whatever the Compiler menu says, unless
you choose LuaLaTeX there (needed only for the dissertation's "check" run;
LuaLaTeX's first compile is slow and may exceed Overleaf's free time limit).

The .cls/.sty/.def/.lua files are the template's machinery; edit main.tex
(and chapters/, references.bib). Documentation and updates:
the uhm-ling-latex repository (README.md).
EOF
  ( cd "$DIST" && zip -qr "$2.zip" "$2" )
  echo "built dist/$2/ and dist/$2.zip"
}

build qp   uhm-qp-template
build diss uhm-diss-template
