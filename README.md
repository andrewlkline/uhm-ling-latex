# uhm-ling-latex

LaTeX templates for the Department of Linguistics, University of Hawaiʻi at Mānoa:

- **`uhmdiss`**: a dissertation (and MA thesis) class that follows the UHM Graduate Education *eTD Style & Policy Guide* (October 2018, still the current edition as of November 2026).
- **`uhmqp`**: a qualifying-paper class with journal **profiles**. QPs go to the department, and review is not blind. They are styled like a target journal so they can later be reformatted for real submission. Profiles: `langsci` (default), `ldc`, `ol`, `stuf`, plus a documented `blank` profile for writing new ones.
- **`uhmbook`**: a book class in the Language Science Press style, for monographs and edited volumes, with covers, imprint, table of contents and indexes. It has no LSP branding.
- **`uhm-ling-core`**: the shared package all the classes load. It handles fonts, glossing, tables, the bibliography, the abbreviations list and page-break discipline.

The aim is to replace copying preambles from old projects. Everything compiles the same way locally (Positron/VS Code with LaTeX Workshop, or `latexmk`) and on Overleaf.

## Quick start

**New QP or dissertation, simplest route (works anywhere, including Overleaf):**

1. Build the template folders:
   ```bash
   scripts/build-templates.sh
   ```
   This creates `dist/uhm-qp-template/` and `dist/uhm-diss-template/`, each with a `.zip`. Every folder holds `main.tex`, `references.bib` and `latexmkrc`, plus copies of all the class files.
2. **Local:** copy a folder, edit `main.tex`, and run `latexmk main.tex`.
   **Overleaf:** New Project > Upload Project, then choose the zip. The `latexmkrc` selects XeLaTeX, whatever Overleaf's Compiler menu says (unless you pick LuaLaTeX there). A fresh project's first compile takes about 9 s (three passes plus Biber); later recompiles are one pass of about 2–3 s, because Overleaf keeps the build files.

**Your own machine, without copying the class files into each project:**

```bash
scripts/install-local.sh
```

This symlinks `src/` into your TEXMFHOME (`~/Library/texmf/tex/latex/uhm-ling`), so `\documentclass{uhmqp}` works in any folder and edits in `src/` apply everywhere. Copy only `templates/qp/` (or `templates/diss/`) into a new project. Undo with `scripts/install-local.sh --remove`. A project that also contains copies of the class files uses those copies, because the current folder is searched first.

**Positron / VS Code (LaTeX Workshop):** each template has a `.vscode/settings.json` that makes saving the file build with `latexmk`, so the folder's `latexmkrc` chooses the engine (XeLaTeX). Open the template's own folder (not a parent folder) as the workspace so this setting applies.

## Requirements

- **Engine:** XeLaTeX (the default) or LuaLaTeX, both tested; the packages use `fontspec` and refuse to run under pdfLaTeX.
  - **Why XeLaTeX:** LuaLaTeX caches fonts, and on a fresh machine (every new Overleaf project) building that cache adds about 9 s to the first run. That pushed the templates past the compile time of Overleaf's free plan. XeLaTeX has no such cache. Measured cold-start full builds: LuaLaTeX ~22 s, XeLaTeX ~9 s.
  - **When to use LuaLaTeX:** the dissertation's `check` report needs it (`latexmk -lualatex main.tex`, or LuaLaTeX in Overleaf's Compiler menu). LuaLaTeX also adds microtype font expansion.
  - **Overleaf's Compiler menu** (default pdfLaTeX) overrides `$pdf_mode` in `latexmkrc`, so the templates' `latexmkrc` also sets `$pdflatex = 'xelatex %O %S'`. Choosing LuaLaTeX or XeLaTeX in the menu still works as labelled.
  - **Passes:** `latexmkrc` runs `makeindex` for the abbreviations list itself and ignores biblatex's `.run.xml` log, so a full build is three passes, not four.
- **Bibliography:** Biber. latexmk runs it automatically.
- **TeX Live 2023 or later.** Developed on TeX Live 2025. Overleaf runs a full TeX Live, so every package and font used here is available there.
- **Fonts:** nothing is bundled. Every font set is loaded **by file name** from TeX Live's own font packages, so output is identical on any machine regardless of what is installed system-wide (see the table below). Andy's system "Charis" (version 7) is not used; TeX Live's Charis SIL 6.101 is.

## Repository layout

```
src/                       the machinery (this is what gets installed/copied)
  uhm-ling-core.sty        shared package
  uhmqp.cls                QP class
  uhmqp-profile-*.def      QP journal profiles
  uhmdiss.cls              dissertation class
  uhmbook.cls              book class (monograph / edited volume, LangSci look)
  uhmdiss-check.lua        LuaLaTeX page checker for uhmdiss [check]
templates/qp/              QP starter: main.tex, references.bib, latexmkrc
templates/diss/            dissertation starter (+ chapters/)
templates/book/            monograph starter (+ chapters/)
templates/volume/          edited-volume starter (chapters/ are uhmqp papers)
scripts/test.sh            compile every template x profile x engine and check
scripts/check-margins.py   scan any PDF for ink inside the 1in margins
scripts/build-templates.sh make dist/ folders + Overleaf zips
scripts/install-local.sh   symlink src/ into TEXMFHOME
reference/                 (git-ignored) style guides, journal templates, sample
                           articles, Andy's old preamble, the original handoff note
```

`reference/` stays out of git because the journal style sheets, Word templates and published PDFs are copyrighted. Keep them locally. A fresh clone will not have them.

## The core package (`uhm-ling-core`)

Both classes load it. It can also be used on its own: `\usepackage[font=charis,bibfile=refs.bib]{uhm-ling-core}`.

| Option | Values | Default |
|---|---|---|
| `font` | `charis`, `libertinus`, `gentium`, `stix`, `noto`, `none` | the profile's font, else `charis` |
| `bibfile` | a `.bib` file | none |
| `bib` | `true`/`false` (load biblatex) | `true` |
| `abbreviations` | `true`/`false` (automatic gloss-abbreviation list) | `true` |
| `lgr` | `true`/`false` (also load `langsci-lgr`: `\SG`, `\PL`, …) | `false` |
| `links` | `color`/`black` | `color` (the dissertation forces `black`) |

**Font sets.** All are OFL fonts that ship with TeX Live.

| `font=` | Main / sans | Used by |
|---|---|---|
| `charis` | Charis SIL / Arimo | Andy's default; dissertation default |
| `libertinus` | Libertinus Serif / Libertinus Sans | LangSci profile |
| `gentium` | Gentium Plus / Arimo | LD&C profile (LD&C's published font) |
| `stix` | STIX Two Text / Arimo | OL profile. A Times stand-in: unlike TeX Gyre Termes it covers IPA |
| `noto` | Noto Serif / Fira Sans | STUF profile (approximates De Gruyter's design) |

To add a set, define `\uhm@fontset@<name>` in the core, following the existing ones. Fonts are applied at `\begin{document}`. Precedence: the user's `font=`, then the profile's `\uhmDefaultFont{…}`, then Charis.

**What else the core sets up:**
- **Examples:** `langsci-gb4e` (`\ea … \z`, `\gll`, `\glt`, sub-examples). An example's source goes in `\exsource{Author 2020: 12}` after the translation; it is flush right by default, and the STUF profile puts it on its own line.
- **Glosses:** `leipzig` with `glossaries`. `\Sg`, `\Erg`, `\Fsg`, … print in small caps and are collected automatically. Add your own with `\newleipzig{evid}{evid}{evidential}`, which gives `\Evid`. `\printglosses` (QP) or `\listofabbreviations` (dissertation) prints the list. `makeindex` runs between passes through a rule in the templates' `latexmkrc` (copy that file into any project that uses `\printglosses`; without latexmk, run `makeglossaries main` yourself).
- **Tables:** `booktabs`, `tabularx`, `multirow`, `threeparttable` (`\tnote{a}` for lettered table notes), `pdflscape`.
- **Bibliography:** `biblatex` with `langsci-unified`, i.e. the Unified Style Sheet:
  - Citations are Author (Year: pages) with no "p.", and "et al." for three or more authors. The reference list gives every name.
  - Hanging indent of ½ inch.
  - DOIs print as `https://doi.org/…`.
  - `@dataset` entries follow the Tromsø template: Author. Year. Title. Publisher. Locator. Version (accessed date).
- **Page breaks:** no widows or orphans (`\clubpenalty`, `\widowpenalty` = 10000), plus discouraged consecutive hyphens.
- **Helpers (Generic Style Rules):** `\form{x}` (italic object language), `\gloss{x}` ('x'), `\term{x}` (small caps at first definition), `\grapheme{x}` (⟨x⟩).
- **Cross-references:** `cleveref`. `\cref{ex:x}` gives "(3)", sections give "§2.3", tables give "table 1". Profiles override these (STUF: "Section 2.3").

## QP class (`uhmqp`)

```latex
\documentclass[profile=ldc, font=charis, bibfile=references.bib]{uhmqp}
\title{...}  \shorttitle{...}  \author{...}  \affiliation{...}  \email{...}
\abstract{...}  \keywords{...}  \qpnote{Qualifying paper 1, submitted ...}
```

`\abstract{}` is a **command**, as in langscibook, not an environment. `\qpnote{}` is free text printed on the first page, in the slot where a journal prints its volume/licence line. Other options: `draft` (date stamp and overfull-line marks) and `linenumbers` (for committee comments). Appendices go inside `\begin{paperappendix} \section{…} \end{paperappendix}`, before the references.

| Profile | Page | Font | Highlights | Sources |
|---|---|---|---|---|
| `langsci` | 170×240 mm | Libertinus 11pt | LSP chapter look: large left-aligned title, abstract as an indented quote, author/title running heads | `langscibook.cls` |
| `ldc` | US letter | Gentium Plus 10pt | Block paragraphs; bold "1. Introduction" headings; left metadata column on page 1 (holds `\qpnote` and keywords); "**Table 1.** Caption"; italic running title | LD&C Word template; Barlow 2026 and Schapper et al. 2026 |
| `ol` | 6×9 in | STIX Two 10pt | Run-in "1. INTRODUCTION." headings; caps captions above tables *and* figures; 8pt gloss line; "1." footnotes; OL reference format (see below) | OL Word template's style table; vol. 65 articles |
| `stuf` | 155×230 mm | Noto Serif + Fira Sans 10pt | Sans headings and title; "**Abstract:**" run-in; corresponding-author note on page 1; "172 ── Author" running heads; "Section 2.3"; citation lists sorted alphabetically | De Gruyter Mouton Journal Style Sheet v1.3; STUF 78–79 articles |
| `blank` | US letter | Charis 11pt | Every setting a profile can change, commented | — |

**Writing a new profile** (e.g. Diachronica, Language, *Linguistic Typology*):
1. Copy `src/uhmqp-profile-blank.def` to `uhmqp-profile-<name>.def` next to your `main.tex` and use `profile=<name>`.
2. The file is read **after** all packages load, so it is ordinary LaTeX. The blank profile has numbered sections: page, fonts, headings, title block, running heads, captions, footnotes, examples, cross-references, bibliography.
3. Note the source of each value in a comment.
4. To share it, move the finished file into `src/` and add its name to `PROFILES` in `scripts/test.sh`.

A *Linguistic Typology* profile can start from `stuf`: both journals use the same De Gruyter Mouton style sheet, which is generic to Mouton journals and has no journal-specific section. Page design may still differ, so check LT articles before reusing `stuf` as is.

**The bibliography style is always `langsci-unified`.** Profiles adjust it after loading, because biblatex styles cannot be swapped after load. The OL profile makes these changes to approximate OL/Chicago 15:
- Repeated author: `———.`
- "and" instead of "&", with a serial comma in the list.
- `Journal 57:359–409`, or `94(2): 205–9` when there is an issue number.
- Chapters: "In *Book*, ed. by Editor, 238–88."
- Citations: `(Blust 1970:348)`.
- Page ranges abbreviated.

The Chicago page-range abbreviation is approximate: `mkcomprange` keeps at least two digits, so 101–108 becomes 101–08 rather than OL's 101–8.

## Book class (`uhmbook`)

```latex
\documentclass[bibfile=references.bib]{uhmbook}               % monograph
\documentclass[collection, bibfile=references.bib]{uhmbook}   % edited volume
```

It covers what the `langscibook` documentation describes, without the publisher. Templates: `templates/book/` (monograph) and `templates/volume/` (edited volume).

- **Front matter.** `\maketitle` produces:
  - the front cover (a coloured panel with title, subtitle and author; `\covercolor{…}`, optional `\coverseries{…}`);
  - a blank verso, then the inside title page;
  - the imprint page, with a citation of the book and © year and author. Optional lines: `\publisher`, `\place`, `\bookyear`, `\license`, `\isbn`, `\bookdoi`, `\typesetter`, `\proofreader` and `\imprintextra`. A font credit is added automatically;
  - the `\dedication{…}` page, if given.
  
  Then `\tableofcontents` and unnumbered front-matter chapters with `\uhmbookChapter{Preface}`. `\printglosses` gives the abbreviations list.
- **Main and back matter:** `\mainmatter`, then chapters (and `\appendix`), then `\backmatter`. `\printbibliography` gives a "References" chapter, and `\printindexes` prints the name, language and subject indexes, each listed under "Indexes" in the TOC. The back cover (`\BackTitle`, `\BackBody{blurb}`) is added automatically on the last even page. Turn the covers off with `cover=false`.
- **Indexes,** with LangSci's commands: `\ia{Name}`, `\il{Language}` and `\is{subject}`. Cited authors go into the name index automatically (biblatex `indexing=cite`). `imakeidx` runs `makeindex` for all three during the LaTeX run. An index with no entries is left out. Turn indexing off with `index=false`.
- **Edited volumes (`collection`).** Each chapter is a complete `uhmqp` paper with `profile=langsci`, added with `\includepaper{chapters/smith}`, as LangSci's `\includepaper` works. Inside the book:
  - the paper's preamble is ignored;
  - its `\maketitle` becomes a "Chapter n" opening with the authors, affiliations and abstract;
  - its `\printbibliography` lists only that paper's references, as a section at its end;
  - the TOC shows each chapter title with its authors;
  - running heads show the authors on even pages and the (short) title on odd pages.
  
  `\author{…}` on the book is the editors ("Edited by"; "(eds.)" in the imprint). Each paper also compiles on its own: `cd chapters && latexmk smith.tex`. A `latexmkrc` there finds the class files one level up. `uhmqp` accepts `\ia`/`\il`/`\is` and ignores them, so LangSci-style papers compile as QPs too. Put `\newleipzig` and extra packages in the book's preamble.
- **Look:** 170×240 mm, Libertinus, bold serif headings, "1 Introduction" chapters ("Chapter 1" in collections), and captions 80% of the text width, all as langscibook.
- **Not included:** the print-on-demand dust-jacket outputs (`coverbodhc` and the like), series pages, logos and ISBN barcodes. For a book that Language Science Press will publish, use their own `langscibook` class; its output is LSP-branded by design.

## Dissertation class (`uhmdiss`)

```latex
\documentclass[bibfile=references.bib]{uhmdiss}
\title{...} \author{...} \field{Linguistics} \graduation{August}{2027}
\chair{...} \member{...} \member{...} \universityrep{...} \keywords{...}
```

The front matter follows the order in the guide (§1.1):
- `\maketitle`
- `\copyrightpage`
- `\dedication{…}`
- `acknowledgments` (environment)
- `abstract` (environment)
- `\tableofcontents`
- `\listoftables`
- `\listoffigures`
- `\listofabbreviations`
- `preface` (environment)

Then come `\mainmatter`, the chapters, `\appendix` with its chapters, and `\printbibliography`.

**How each guide requirement is implemented** (§ numbers refer to the eTD guide):

| Requirement | Implementation |
|---|---|
| Margins ≥ 1in on every page; page number bottom centre, inside the margin (§2.3, §2.10) | `geometry` with `includefoot` and bottom = 1.06in, so the page number's descender space also stays clear. Character protrusion is off, so no punctuation hangs into the margin. Checked by `scripts/check-margins.py` in the test suite, which rasterises each page and looks for ink (text, rules, images) in the margin bands |
| No running heads; number only, no "page"/dashes (§2.10, §2.10.5) | `scrlayer-scrpage`: empty heads, `\cfoot*{\pagemark}` |
| Title page unnumbered; front matter roman from ii; body arabic from chapter 1 (§2.10.1–2) | `\maketitle` counts as page i; `\mainmatter` |
| Title page as Sample B (§1.2) | Title in capitals; ʻokina and kahakō in "HAWAIʻI AT MĀNOA"; month validated as May/August/December; chair marked "Chairperson", university rep last; no titles. `type=thesis` gives Sample A wording |
| 1.5 spacing; single in footnotes, quotes, tables, examples; abstract double (§2.7, §1.5) | `setspace`; `spacing=double` is also available |
| Left-justified preferred (§2.4) | `ragged2e` `\RaggedRight` with hyphenation; `justified` option |
| No widows/orphans; ≤ 3 hyphens per page, ≤ 2 in a row (§2.7, §2.9) | Penalties in the core; **`check`** option reports violations per page (LuaLaTeX) |
| Major headings share one style; chapters on a new page, centred, "CHAPTER 1 / TITLE" (§2.2, §2.10.3) | Bold capitals, centred. Subheading levels: bold → bold italic → italic → italic run-in |
| TOC: dot leaders, indented levels, lists front matter but not title page/dedication/TOC (§1.6) | KOMA `tocbasic`. Entries are capitalised like the headings, chapters read "CHAPTER 1 …" |
| Lists of tables/figures on their own pages; single within, double between entries (§1.7–1.8) | |
| Tables: "Table N." caption above; figures below; numbering by chapter or continuous (§1.7, §3.1) | `floatnumbers=chapter` (default) or `continuous` |
| Continued tables "Table N. (Continued) …" (§3.1.2) | `longtable` + `\continuedcaption{Title}` in `\endhead` |
| Table notes with letters/symbols under the table (§3.1.3) | `threeparttable` + `\tnote{a}` |
| Landscape tables with caption at the binding side (§3.1.2) | `rotating` with `figuresleft` (`sidewaystable`) |
| Appendices: no cover page; "APPENDIX" alone if only one (§1.12) | Automatic: the class counts appendices (via the .aux) and drops the letter when there is one. Cross-references follow |
| References last unless there is an index (§1.14) | `\referencesname{Literature cited}` changes the heading |
| Type ≥ 10pt everywhere, captions and footnotes included (§4.2) | `\scriptsize`/`\tiny` (and `\footnotesize` at 11pt) raised to 10pt; **`check`** reports any glyph < 10pt |
| Fonts embedded (§4.2.1) | Always the case with LuaLaTeX/XeLaTeX. `scripts/test.sh` verifies with `pdffonts` |
| Internal links fine; external links avoided (§1.15) | Black links; `\href`/`\url` print as plain text |
| No compression, no password (§4.1) | `nocompress` option (off by default; see *Open questions*) |

**Before submitting:** compile once with `check` and read the `uhmdiss check:` lines at the end of the log. Then run:

```bash
python3 scripts/check-margins.py main.pdf
```

`check` also draws a frame at the 1-inch margins and marks overfull lines. Under XeLaTeX only the frame and the overfull marks work.

## Testing

```bash
scripts/test.sh                  # all templates x profiles x engines (~3 min)
scripts/test.sh qp ol lualatex   # one combination
```

PDFs land in `build/test/`. Each run fails on:
- any LaTeX error;
- unresolved citations or references;
- a font that is not embedded;
- a Type 3 font;
- for the dissertation, ink inside the 1in margins.

Overfull boxes are reported but do not fail the run. Last full run (2026-11-15): all 12 combinations pass on TeX Live 2025.

## Design decisions (things that look odd but are deliberate)

- **`uhmqp` is a slim derivative of `langscibook`, not a full fork.** About 80% of `langscibook.cls` is cover, spine, imprint, ISBN, series and licence code that a QP never uses. `uhmqp.cls` is built on `scrartcl` (KOMA-Script, like langscibook). It takes langscibook's paper geometry, footnote, quote, float and `paperappendix` settings, with attribution, and loads the unmodified `langsci-gb4e` and `langsci-unified` from TeX Live. LPPL 1.3c is satisfied: the modified work has a new name and carries the original copyright notice and a statement of modification. No LangSci file is redistributed in modified form.
- **`uhmdiss` is built directly from the 2018 guide, not from the community `uhthesis` class.** `uhthesis` targets the 2014 guide, and its README calls that update beta. Every rule in the table above is traced to a section of the 2018 guide.
- **Profiles are read after all packages load,** so a colleague can write one in plain LaTeX without `##` doubling or load-order puzzles. Hence also "fonts are applied at `\begin{document}`".
- **Major dissertation headings are all capitals.** The guide requires ABSTRACT and every other major heading to share one style. Protect object-language words with `\NoCaseChange{…}` in chapter titles and the title.
- **The gloss-abbreviation list uses leipzig's `block` style.** The default `inline` style suppresses the heading.

## Gotchas found while building (save yourself the debugging)

- **KOMA `\RedeclareSectionCommand`:** a length that *starts* with a macro, e.g. `beforeskip=\baselineskip`, dies with "Extra \else". Write `1\baselineskip`.
- **KOMA `afterindent=bysign`:** a positive `beforeskip` indents the first paragraph after the heading. Add `afterindent=false`.
- **`\renewpairofpagestyles{…}{…}` cannot contain `\par`.** Use `\\` inside a `\parbox`.
- **KOMA TOC `entryformat=\MakeUppercase`** upper-cases internal macros and breaks. Put `\MakeUppercase` around the entry *text* instead (see `\addchaptertocentry` in `uhmdiss.cls`).
- **`langsci-unified` expects a colour `lsDOIGray`,** which only `langscibook` defines; the core defines it. **`langsci-lgr`** needs `xspace` loaded first.
- **`glossaries` must load after `hyperref`; `cleveref` last.** The core handles the order. Classes must load their own packages *before* the core.
- **`\textlangle` maps to U+2329, which most fonts lack.** `\grapheme` uses U+27E8/U+27E9 and falls back to math brackets.
- **biblatex resets `\bibname` at `\begin{document}`.** The dissertation uses its own `\uhmdissRefName` and `\referencesname{}`. The TOC/list names are likewise set `\AtBeginDocument`.
- **`geometry` does not parse `1in+4pt`.** Use `1.06in`.
- **Don't check margins with `pdftotext -bbox`.** Its boxes come from font ascent/descent metrics, not ink, and XeTeX embeds those differently from LuaTeX, so a compliant XeLaTeX PDF appears to violate the margin by 1–2pt. `check-margins.py` rasterises instead.
- **biber on macOS 26: "extracting arm64 binary with lipo failed".** TeX Live 2025's universal `biber` launcher calls `lipo -extract_family`, which current Xcode's `lipo` lacks. Workaround: extract the arm64 binary once (`lipo /Library/TeX/texbin/biber -thin arm64 -output ~/Library/TeX/biber-arm64`) and point latexmk at it in `~/.latexmkrc` (`$biber = "\"$ENV{HOME}/Library/TeX/biber-arm64\" %O %S";`). Any editor recipe that calls `biber` directly needs the same path. This is a machine problem, not a template problem. The templates therefore carry no `% !TEX program` / `% !BIB program` magic comments: LaTeX Workshop obeys those over any recipe and calls plain `biber`. The templates' `.vscode/settings.json` also sets `forceRecipeUsage`.
- **LuaLaTeX is slow on a cold font cache.** The first LuaLaTeX run on a fresh machine (a new Overleaf project) spends about 9 s building luaotfload's font cache, which was enough to hit Overleaf's free compile limit. Hence the XeLaTeX default.
- **latexmk ran a needless fourth pass** because biblatex rewrites `main.run.xml` on every run. `$hash_calc_ignore_pattern{'xml'}` in `latexmkrc` stops that. glossaries' `automake` option also costs a pass; the `makeindex` rule in `latexmkrc` replaces it.
- **Capitals and citation keys.** OL headings and captions are uppercased, which also uppercased citation keys inside them ("Citation EDWARDSGRIMES2026MAP undefined"). The OL profile registers the citation, cross-reference and object-language commands with `\AddToNoCaseChangeList`. Register paper-specific form macros the same way (e.g. `\AddToNoCaseChangeList{\fm}`).
- **`\ifx\macro\@empty` is never true for a macro made with `\newcommand`** (it is `\long`; `\@empty` is not). `\uhmqpIfSet` uses etoolbox's `\ifdefempty`; before that, an unset `\keywords` still printed an empty "Keywords:" label.
- **`\paragraph` is unnumbered in `uhmqp`** (`secnumdepth` 3, as in `article`), because papers use it as a run-in label; the `langsci` profile restores four numbered levels like langscibook. OL's run-in headings add the closing period only if the heading text doesn't already end in `.`, `?` or `!`.
- A harmless `Font shape TU/lmr/bx/sc undefined` warning comes from `leipzig.tex` measuring text before the real fonts are set.

## Open questions and unverified points

- **[verify] Fonts.** The guide says "Post Script Type 1 fonts are required", yet it recommends TrueType fonts. LuaLaTeX/XeLaTeX embed OpenType/TrueType (CID) fonts, not Type 1. Confirm with Graduate Education, or run a draft through ProQuest ETD's validation, that embedded OpenType/TrueType is accepted. It almost certainly is, since the guide's own font list is TrueType.
- **[verify] "No compression".** The guide probably means no image down-sampling or zipped files, not PDF stream compression. `nocompress` exists if they insist; it makes the PDF several times larger.
- **[verify] Overleaf.** Every font and package used ships with TeX Live, and the standalone folders compile with no local setup. An actual upload to Overleaf has not been tested from here.
- **Approximations in profiles:**
  - OL's Chicago page-range abbreviation (see above).
  - De Gruyter's exact fonts are commercial; Noto Serif and Fira Sans stand in.
  - LD&C's coloured table rules and shading are not reproduced.
  - OL tables' alternate-row shading is left to the author (`\rowcolors` from `xcolor`'s `table` option).
- **Not built yet:**
  - Profiles for Diachronica, Language Dynamics and Change, LD&D, Linguistic Typology and *Language*.
  - Index support in the dissertation.
  - Endnote-style "Notes" back matter.
- **Andy's old preamble** used `cleveref` "ex. (3)" for examples. The core now gives "(3)", per the Generic Style Rules. It also used `tabularray`, `ot-tableau` and `tikz`; add those per project in `main.tex`, since not every document needs them.
