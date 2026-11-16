#!/usr/bin/env python3
"""Check that nothing is printed within 1in of any page edge
(UHM eTD guide [2.3]: margins at least 1 inch on every side).

    python3 scripts/check-margins.py thesis.pdf [margin_in_inches] [--dpi N]

Each page is rendered to greyscale with poppler's `pdftoppm` (installed with
TeX Live on macOS via MacTeX/Homebrew poppler, and standard on Linux), and
the four margin bands are scanned for ink: text, rules, images, anything.
No Python packages are needed.

Exits non-zero and lists the offending pages if any ink falls inside the
margin. Antialiasing at the edge of a glyph sitting exactly on the margin
line is tolerated (1 pixel).
"""
import os
import subprocess
import sys
import tempfile

THRESHOLD = 200  # grey value below which a pixel counts as ink (0=black)


def read_pgm(path):
    with open(path, "rb") as f:
        data = f.read()
    # binary PGM: P5\n<w> <h>\n<max>\n<bytes>
    parts, i = [], 0
    while len(parts) < 4:
        while data[i:i + 1].isspace():
            i += 1
        if data[i:i + 1] == b"#":
            while data[i:i + 1] not in (b"\n", b""):
                i += 1
            continue
        j = i
        while not data[j:j + 1].isspace():
            j += 1
        parts.append(data[i:j])
        i = j
    i += 1
    assert parts[0] == b"P5", "expected binary PGM"
    w, h = int(parts[1]), int(parts[2])
    return w, h, data[i:i + w * h]


def ink_extent(w, h, px):
    """Return (left, top, right, bottom) distances in pixels from each edge
    to the nearest ink, or None for a blank page."""
    rows = [any(b < THRESHOLD for b in px[y * w:(y + 1) * w]) for y in range(h)]
    if not any(rows):
        return None
    top = rows.index(True)
    bottom = h - 1 - max(y for y, r in enumerate(rows) if r)
    left, right = w, w
    for y in range(h):
        if not rows[y]:
            continue
        line = px[y * w:(y + 1) * w]
        for x in range(w):
            if line[x] < THRESHOLD:
                left = min(left, x)
                break
        for x in range(w - 1, -1, -1):
            if line[x] < THRESHOLD:
                right = min(right, w - 1 - x)
                break
    return left, top, right, bottom


def main():
    args = [a for a in sys.argv[1:] if not a.startswith("--")]
    dpi = 100
    if "--dpi" in sys.argv:
        dpi = int(sys.argv[sys.argv.index("--dpi") + 1])
        args = [a for a in args if a != str(dpi)]
    if not args:
        sys.exit(__doc__)
    pdf = args[0]
    margin_in = float(args[1]) if len(args) > 1 else 1.0
    need = margin_in * dpi - 1  # 1px antialiasing tolerance
    bad = 0
    with tempfile.TemporaryDirectory() as tmp:
        subprocess.run(["pdftoppm", "-gray", "-r", str(dpi), pdf,
                        os.path.join(tmp, "p")], check=True)
        files = sorted(f for f in os.listdir(tmp) if f.endswith(".pgm"))
        for n, name in enumerate(files, 1):
            w, h, px = read_pgm(os.path.join(tmp, name))
            ext = ink_extent(w, h, px)
            if ext is None:
                continue
            if min(ext) < need:
                bad += 1
                l, t, r, b = (v / dpi for v in ext)
                print(f"page {n}: ink at left {l:.2f}in, top {t:.2f}in, "
                      f"right {r:.2f}in, bottom {b:.2f}in (need {margin_in:.2f}in)")
    print(f"margin check: {bad} of {len(files)} pages have ink inside the "
          f"{margin_in:g}in margin")
    sys.exit(1 if bad else 0)


if __name__ == "__main__":
    main()
