#!/usr/bin/env bash
# Compile the templates against src/ with every profile and engine, and
# check the results. Usage:
#   scripts/test.sh                 # everything
#   scripts/test.sh qp ldc lualatex # one template/profile/engine
# Output PDFs land in build/test/. Exit status is non-zero on any failure.
set -u
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OUT="$ROOT/build/test"
mkdir -p "$OUT"
export TEXINPUTS="$ROOT/src//:"

PROFILES=(langsci ldc ol stuf blank)
ENGINES=(lualatex xelatex)
want_tpl="${1:-all}"; want_prof="${2:-all}"; want_eng="${3:-all}"
fail=0

check_pdf() {  # $1 = pdf, $2 = log
  local pdf="$1" log="$2" ok=1
  if grep -q '^!' "$log"; then echo "    ERROR in log:"; grep -A2 '^!' "$log" | head -6 | sed 's/^/      /'; ok=0; fi
  if grep -qE 'undefined references|Citation .* undefined|Reference .* undefined' "$log"; then
    echo "    unresolved references/citations"; ok=0; fi
  if pdffonts "$pdf" | tail -n +3 | awk '{print $(NF-4)}' | grep -q no; then
    echo "    a font is NOT embedded"; ok=0; fi
  if pdffonts "$pdf" | tail -n +3 | grep -qi 'Type 3'; then
    echo "    Type 3 (bitmap) font present"; ok=0; fi
  local over; over=$(grep -c '^Overfull \\hbox' "$log" || true)
  [ "$over" -gt 0 ] && echo "    note: $over overfull hbox(es)"
  return $((1-ok))
}

run() {  # $1 template dir, $2 jobname, $3 engine, $4 extra preamble (profile)
  local tpl="$1" job="$2" eng="$3" pre="$4"
  local work="$OUT/$job"; rm -rf "$work"; mkdir -p "$work"
  cp -R "$ROOT/templates/$tpl/." "$work/"
  ( cd "$work" && [ -n "$pre" ] && sed -i '' "s/profile = langsci/profile = $pre/" main.tex
    latexmk -"$eng" -interaction=nonstopmode -halt-on-error main.tex >/dev/null 2>&1 )
  local rc=$?
  if [ -f "$work/main.pdf" ]; then cp "$work/main.pdf" "$OUT/$job.pdf"; fi
  printf '%-32s ' "$job"
  if [ $rc -ne 0 ] || [ ! -f "$work/main.pdf" ]; then
    echo "FAIL (latexmk rc=$rc)"; grep -A3 '^!' "$work/main.log" 2>/dev/null | head -8 | sed 's/^/      /'; fail=1; return; fi
  local mcheck=0
  if [ "$tpl" = diss ]; then
    python3 "$ROOT/scripts/check-margins.py" "$work/main.pdf" >"$work/margins.txt" || mcheck=1
  fi
  if check_pdf "$work/main.pdf" "$work/main.log" >"$work/check.txt" && [ $mcheck -eq 0 ]; then
    echo "ok ($(pdfinfo "$work/main.pdf" | awk '/^Pages/{print $2}') pp)"; cat "$work/check.txt"
  else echo "FAIL"; cat "$work/check.txt"; [ -f "$work/margins.txt" ] && cat "$work/margins.txt"; fail=1; fi
}

for eng in "${ENGINES[@]}"; do
  [ "$want_eng" != all ] && [ "$want_eng" != "$eng" ] && continue
  if [ "$want_tpl" = all ] || [ "$want_tpl" = qp ]; then
    for p in "${PROFILES[@]}"; do
      [ "$want_prof" != all ] && [ "$want_prof" != "$p" ] && continue
      run qp "qp-$p-$eng" "$eng" "$p"
    done
  fi
  if [ "$want_tpl" = all ] || [ "$want_tpl" = diss ]; then
    [ -d "$ROOT/templates/diss" ] && [ -f "$ROOT/templates/diss/main.tex" ] && run diss "diss-$eng" "$eng" ""
  fi
done
exit $fail
