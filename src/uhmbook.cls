%% uhmbook.cls
%% Book class for UHM Linguistics in the style of a Language Science Press
%% book: monographs and edited volumes, with front and back covers, inside
%% title, imprint, dedication, table of contents, chapters, references and
%% name/language/subject indexes.
%%
%%   \documentclass[bibfile=references.bib]{uhmbook}                 % monograph
%%   \documentclass[collection, bibfile=references.bib]{uhmbook}     % edited volume
%%
%% Like uhmqp, this is a slim, unbranded derivative of langscibook.cls
%% (Language Science Press, LPPL 1.3c; maintained by Sebastian Nordhoff):
%% the page geometry, cover layout, chapter/paper structure (\includepaper),
%% index commands (\ia, \il, \is) and backmatter order follow langscibook.
%% Series pages, logos, ISBN barcodes, licence boilerplate and print-on-demand
%% dust jackets are not reproduced. Use the real langscibook class for a book
%% that Language Science Press will publish.
%% This file is distributed under the LPPL 1.3c or later.
\NeedsTeXFormat{LaTeX2e}[2022/06/01]
\ProvidesClass{uhmbook}[2026/11/24 v0.1 UHM Linguistics book (LangSci look)]

%% ------------------------------------------------------------------
%% Options
%% ------------------------------------------------------------------
%%   collection             edited volume: chapters are papers by different
%%                          authors, added with \includepaper{file}
%%   cover=true|false       front and back cover (default true)
%%   index=true|false       name, language and subject indexes (default true)
%%   draft                  date stamp, overfull-line marks
%%   font=, bibfile=, abbreviations=, lgr=, bib=   passed to uhm-ling-core
\newif\ifuhmbook@collection
\newif\ifuhmbook@cover   \uhmbook@covertrue
\newif\ifuhmbook@index   \uhmbook@indextrue
\newif\ifuhmbook@draft
\DeclareKeys[uhmbook]{
  collection.if       = uhmbook@collection,
  cover.if            = uhmbook@cover,
  index.if            = uhmbook@index,
  draft.if            = uhmbook@draft,
  font.code           = \PassOptionsToPackage{font=#1}{uhm-ling-core},
  bibfile.code        = \PassOptionsToPackage{bibfile=#1}{uhm-ling-core},
  abbreviations.code  = \PassOptionsToPackage{abbreviations=#1}{uhm-ling-core},
  lgr.code            = \PassOptionsToPackage{lgr=#1}{uhm-ling-core},
  bib.code            = \PassOptionsToPackage{bib=#1}{uhm-ling-core},
}
\ProcessKeyOptions[uhmbook]

%% ------------------------------------------------------------------
%% Base class and packages (everything before hyperref, which the core loads)
%% ------------------------------------------------------------------
\LoadClass[
  fontsize    = 11pt,
  twoside,
  open        = right,
  numbers     = noenddot,
  footnotes   = multiple,
  captions    = tableheading,
  headings    = normal,
  chapterprefix = false,
]{scrbook}
\ifuhmbook@collection \KOMAoptions{chapterprefix=true}\fi
%% key=value optional arguments for \chapter[tocentry=..., head=...]{...}
\KOMAoptions{headings=optiontoheadandtoc}

%% Page: 170 x 240 mm, the LSP book format (values from langscibook)
\RequirePackage[papersize={170mm,240mm}, top=27.4mm, bottom=25mm,
                inner=20.5mm, outer=24.5mm, marginparwidth=50pt,
                headsep=8mm]{geometry}
\RequirePackage[autoenlargeheadfoot=off]{scrlayer-scrpage}
\RequirePackage{setspace}
\RequirePackage{floatrow}
\floatsetup{capposition=bottom}
\floatsetup[table]{capposition=top}
\RequirePackage{tikz}
\ifuhmbook@draft \RequirePackage{datetime2}\fi
\ifuhmbook@index
  \RequirePackage{imakeidx}
  \makeindex[intoc=false, columns=2, title=Name index]
  \makeindex[name=lan, intoc=false, columns=2, title=Language index]
  \makeindex[name=sbj, intoc=false, columns=2, title=Subject index]
\fi
\RequirePackage{uhm-ling-core}
\uhmDefaultFont{libertinus}

%% Cited authors go into the name index automatically (as in langscibook)
\ifuhmbook@index
  \ifcsname ExecuteBibliographyOptions\endcsname
    \ExecuteBibliographyOptions{indexing=cite}
  \fi
\fi

%% ------------------------------------------------------------------
%% Metadata
%% ------------------------------------------------------------------
%%   \title{...} \subtitle{...} \author{...}   (editors, in a collection)
%%   \dedication{...}          own page after the imprint
%%   \BackTitle{...}           back-cover title (default: the title)
%%   \BackBody{...}            back-cover blurb
%%   \covercolor{<xcolor>}     e.g. \covercolor{teal!70!black}
%%   \coverseries{...}         small text at the foot of the front cover
%%   Imprint page (all optional):
%%   \publisher{...} \place{...} \bookyear{...} \license{...}
%%   \isbn{...} \bookdoi{...} \typesetter{...} \proofreader{...}
%%   \imprintextra{...}
\newcommand\uhmbook@define[1]{%
  \expandafter\newcommand\expandafter*\csname uhmbook@#1\endcsname{}%
  \expandafter\renewcommand\expandafter*\csname #1\endcsname[1]{%
    \expandafter\renewcommand\expandafter*\csname uhmbook@#1\endcsname{##1}}}
\providecommand*\BackTitle{}\providecommand*\BackBody{}
\providecommand*\publisher{}\providecommand*\license{}
\providecommand*\isbn{}\providecommand*\bookdoi{}
\providecommand*\typesetter{}\providecommand*\proofreader{}
\providecommand*\imprintextra{}\providecommand*\place{}
\providecommand*\bookyear{}\providecommand*\coverseries{}
\renewcommand*\dedication{}% KOMA defines one for its own title pages
\uhmbook@define{BackTitle}
\uhmbook@define{BackBody}
\uhmbook@define{publisher}
\uhmbook@define{place}
\uhmbook@define{bookyear}
\uhmbook@define{license}
\uhmbook@define{isbn}
\uhmbook@define{bookdoi}
\uhmbook@define{typesetter}
\uhmbook@define{proofreader}
\uhmbook@define{imprintextra}
\uhmbook@define{coverseries}
\uhmbook@define{dedication}
\newcommand\uhmbookIfSet[3]{\ifdefempty{#1}{#3}{#2}}
\newcommand*\uhmbook@year{\ifx\uhmbook@bookyear\@empty\the\year\else\uhmbook@bookyear\fi}
\definecolor{uhmbookcover}{RGB}{31,58,92}
\newcommand*\covercolor[1]{\colorlet{uhmbookcover}{#1}}
\date{}

%% Name of the main font set, for the imprint's font credit
\newcommand*\uhmbook@fc{}
\newcommand\uhmbook@setfontcredit{%
  \renewcommand*\uhmbook@fc{}%
  \ifdefstring{\uhmFontName}{charis}{\renewcommand*\uhmbook@fc{Charis SIL}}{}%
  \ifdefstring{\uhmFontName}{libertinus}{\renewcommand*\uhmbook@fc{Libertinus}}{}%
  \ifdefstring{\uhmFontName}{gentium}{\renewcommand*\uhmbook@fc{Gentium Plus}}{}%
  \ifdefstring{\uhmFontName}{stix}{\renewcommand*\uhmbook@fc{STIX Two}}{}%
  \ifdefstring{\uhmFontName}{noto}{\renewcommand*\uhmbook@fc{Noto Serif, Fira Sans}}{}}

%% (ed.) or (eds.) after the editors' names in the imprint
\ExplSyntaxOn
\cs_new:Npn \uhmbook@eds { \tl_if_in:NnTF \@author { \and } { eds. } { ed. } }
\ExplSyntaxOff

%% "Edited by" for collections
\newcommand*\uhmbookEditorPrefix{Edited by}

%% ------------------------------------------------------------------
%% Covers, title and imprint
%% ------------------------------------------------------------------
\newcommand\uhmbook@titleblock{%
  {\bfseries\fontsize{30pt}{34pt}\selectfont\@title\par}% (not the disposition font: it resets the colour)
  \ifx\@subtitle\@empty\else
    \vskip 3mm{\fontsize{18pt}{22pt}\selectfont\@subtitle\par}%
  \fi}

\newcommand\uhmbook@frontcover{%
  \thispagestyle{empty}%
  \begin{tikzpicture}[remember picture, overlay]
    \fill[uhmbookcover] ([xshift=7.5mm,yshift=-7.5mm]current page.north west)
      rectangle ([xshift=-7.5mm,yshift=7.5mm]current page.south east);
    \node[anchor=north west, text width=125mm, align=left, text=white,
          font=\sffamily]
      at ([xshift=17mm,yshift=-20mm]current page.north west)
      {\uhmbook@titleblock\par\vskip 12mm
       {\normalfont\fontsize{18pt}{22pt}\selectfont
        \ifuhmbook@collection\uhmbookEditorPrefix\\\fi
        {\def\and{\\}\@author}\par}};
    \uhmbookIfSet\uhmbook@coverseries{%
      \node[anchor=south west, text width=125mm, align=left, text=white,
            font=\sffamily\small]
        at ([xshift=17mm,yshift=17mm]current page.south west)
        {\uhmbook@coverseries};}{}
  \end{tikzpicture}%
  \null\clearpage
  \thispagestyle{empty}\null\clearpage}

\newcommand\uhmbook@backcover{%
  \cleardoubleevenemptypage
  \thispagestyle{empty}%
  \begin{tikzpicture}[remember picture, overlay]
    \fill[uhmbookcover] ([xshift=7.5mm,yshift=-7.5mm]current page.north west)
      rectangle ([xshift=-7.5mm,yshift=7.5mm]current page.south east);
    \node[anchor=north west, text width=125mm, align=justify, text=white]
      at ([xshift=17mm,yshift=-20mm]current page.north west)
      {{\raggedright\sffamily\fontsize{20pt}{24pt}\selectfont
        \ifx\uhmbook@BackTitle\@empty\@title\else\uhmbook@BackTitle\fi\par}%
       \vskip 10mm
       \uhmbook@BackBody\par};
  \end{tikzpicture}%
  \null}

\newcommand\uhmbook@imprint{%
  \thispagestyle{empty}%
  \begingroup\small\raggedright\setlength{\parindent}{0pt}%
  %% Citation of the book itself, as in langscibook's imprint
  {\def\and{\unskip, }\@author}\ifuhmbook@collection\ (\uhmbook@eds)\fi. \uhmbook@year.
  \emph{\@title\ifx\@subtitle\@empty\else: \@subtitle\fi}.%
  \uhmbookIfSet\uhmbook@publisher{ \uhmbookIfSet\uhmbook@place{\uhmbook@place: }{}\uhmbook@publisher.}{}\par
  \vfill
  \textcopyright\ \uhmbook@year, {\def\and{\unskip, }\@author}\par
  \uhmbookIfSet\uhmbook@license{\uhmbook@license\par}{}%
  \uhmbookIfSet\uhmbook@isbn{ISBN: \uhmbook@isbn\par}{}%
  \uhmbookIfSet\uhmbook@bookdoi{DOI: \uhmbook@bookdoi\par}{}%
  \medskip
  \uhmbookIfSet\uhmbook@typesetter{Typesetting: \uhmbook@typesetter\par}{}%
  \uhmbookIfSet\uhmbook@proofreader{Proofreading: \uhmbook@proofreader\par}{}%
  \uhmbook@setfontcredit
  \ifx\uhmbook@fc\@empty\else Fonts: \uhmbook@fc\par\fi
  Typesetting software: \LaTeX{} (uhmbook class)\par
  \uhmbookIfSet\uhmbook@imprintextra{\medskip\uhmbook@imprintextra\par}{}%
  \endgroup
  \clearpage}

\renewcommand\maketitle{%
  \begingroup
  \hypersetup{pdftitle={\@title}}%
  \ifuhmbook@cover\uhmbook@frontcover\fi
  %% Inside title page (recto)
  \thispagestyle{empty}%
  \begin{flushleft}
    \color{uhmbookcover}\sffamily
    \vspace*{5mm}\uhmbook@titleblock\par
    \vskip 12mm
    {\normalfont\Large
      \ifuhmbook@collection\uhmbookEditorPrefix\\[1ex]\fi
      {\def\and{\\}\@author}\par}
  \end{flushleft}
  \clearpage
  \uhmbook@imprint
  \uhmbookIfSet\uhmbook@dedication{%
    \cleardoublepage\thispagestyle{empty}%
    \vspace*{.3\textheight}%
    \begin{center}\itshape\uhmbook@dedication\end{center}%
    \clearpage}{}%
  \endgroup
  \cleardoublepage}

\ifuhmbook@cover\AtEndDocument{\uhmbook@backcover}\fi

%% ------------------------------------------------------------------
%% Headings, running heads, footnotes, floats (LSP look)
%% ------------------------------------------------------------------
\setkomafont{disposition}{\normalcolor\bfseries}
\setkomafont{chapter}{\huge}
\setkomafont{chapterprefix}{\Large}
\setkomafont{descriptionlabel}{\normalfont\itshape}
\setkomafont{pageheadfoot}{\normalfont\normalcolor}
\setcounter{secnumdepth}{3}
\setcounter{tocdepth}{1}
\raggedbottom
\setlength{\emergencystretch}{2em}
\renewcommand*{\partpagestyle}{empty}
\renewcommand*{\chapterformat}{%
  \ifuhmbook@collection\chapapp~\thechapter\else\thechapter\enskip\fi}

\pagestyle{scrheadings}
\clearpairofpagestyles
\automark[section]{chapter}
\ohead{\headmark}
\ofoot*{\pagemark}
\ifuhmbook@draft
  \AddToHook{begindocument/end}{\ifoot*{\textcolor{gray}{\footnotesize Draft of \DTMnow}}}
  \setlength{\overfullrule}{5pt}
\fi

\newlength{\normalparindent}
\AtBeginDocument{\setlength{\normalparindent}{\parindent}}
\deffootnote[1.5em]{1.5em}{\normalparindent}{\textsuperscript{\thefootnotemark}\enskip}
\renewenvironment{quote}{\list{}{\rightmargin0pt\leftmargin8mm}\item\relax}{\endlist}
\renewcommand{\fps@figure}{htbp}
\renewcommand{\fps@table}{htbp}
\renewcommand{\topfraction}{0.9}
\renewcommand{\bottomfraction}{0.8}
\renewcommand{\textfraction}{0.07}
\renewcommand{\floatpagefraction}{0.7}
\captionsetup{font={stretch=.8,small}, width=.8\textwidth, labelsep=colon}
\setcapindent{0pt}
\AtBeginDocument{\examplesroman}
\crefname{chapter}{Chapter}{Chapters}
%% TOC entries in black, with only the page numbers as links (as LSP books)
\hypersetup{linktoc=page}
\Crefname{chapter}{Chapter}{Chapters}

%% Unnumbered chapter for front- and back-matter pieces (preface,
%% acknowledgments, abbreviations ...), listed in the TOC
\newcommand\uhmbookChapter[1]{\addchap{#1}}

%% Bibliography: "References" as an unnumbered chapter in the backmatter
%% (\printbibliography), or a section at the end of a paper in a
%% collection (\printbibliography inside the paper file)
\ifcsname defbibheading\endcsname
  \defbibheading{bibliography}[\refname]{\addchap{#1}}
  \defbibheading{references}[\refname]{\addchap{#1}}
  \defbibheading{subbibliography}[\refname]{\section*{#1}}
\fi
\AtBeginDocument{\renewcommand*{\refname}{References}}

%% ------------------------------------------------------------------
%% Indexes: \ia{Name} \il{Language} \is{subject}, then \printindexes
%% ------------------------------------------------------------------
\ifuhmbook@index
  \newcommand{\ia}[1]{\index{#1}}
  \newcommand{\il}[1]{\index[lan]{#1}}
  \newcommand{\is}[1]{\index[sbj]{#1}}
  \indexsetup{othercode=\small}
  \ExplSyntaxOn
  %% An index file with entries is more than an empty theindex environment
  \cs_new:Npn \uhmbook@ifindex #1 #2
    { \file_if_exist:nT {#1} { \int_compare:nNnT { \file_size:n {#1} } > { 60 } {#2} } }
  \ExplSyntaxOff
  \newcommand\printindexes{%
    \cleardoublepage\phantomsection
    \addcontentsline{toc}{chapter}{Indexes}%
    \uhmbook@ifindex{\jobname.ind}{%
      \cleardoublepage\phantomsection
      \addcontentsline{toc}{section}{Name index}%
      \markboth{Name index}{Name index}\printindex}%
    \uhmbook@ifindex{lan.ind}{%
      \cleardoublepage\phantomsection
      \addcontentsline{toc}{section}{Language index}%
      \markboth{Language index}{Language index}\printindex[lan]}%
    \uhmbook@ifindex{sbj.ind}{%
      \cleardoublepage\phantomsection
      \addcontentsline{toc}{section}{Subject index}%
      \markboth{Subject index}{Subject index}\printindex[sbj]}}
\else
  \newcommand{\ia}[1]{}\newcommand{\il}[1]{}\newcommand{\is}[1]{}
  \newcommand\printindexes{}
\fi

%% ------------------------------------------------------------------
%% Edited volumes: \includepaper{chapters/smith}
%% ------------------------------------------------------------------
%% A paper is a complete uhmqp document (profile=langsci), so it also
%% compiles on its own:
%%   \documentclass[profile=langsci, bibfile=../references.bib]{uhmqp}
%%   \title{...} \author{A \and B} \affiliation{X \and Y} \abstract{...}
%%   \begin{document} \maketitle ... \printbibliography \end{document}
%% Inside the book, its \documentclass and \usepackage lines are ignored,
%% \maketitle becomes a chapter opening (title, authors, affiliations,
%% abstract), and \printbibliography lists only that paper's references.
%% Put \newleipzig and other definitions in the book's preamble.
\newcommand\uhmbook@ptitle{}\newcommand\uhmbook@pauthor{}
\newcommand\uhmbook@paff{}\newcommand\uhmbook@pabstract{}
\newcommand\uhmbook@pshort{}
\newcommand\uhmbook@paperhead{}
\NewDocumentCommand\includepaper{m}{%
  \begingroup
  \renewcommand\documentclass[2][]{}%
  \renewcommand\usepackage[2][]{}%
  \renewcommand\RequirePackage[2][]{}%
  \renewcommand\newleipzig[3]{}%
  \renewenvironment{document}{}{}%
  \renewcommand\title[1]{\renewcommand\uhmbook@ptitle{##1}}%
  \renewcommand\author[1]{\renewcommand\uhmbook@pauthor{##1}}%
  \providecommand\affiliation{}\providecommand\shorttitle{}%
  \providecommand\shortauthor{}\providecommand\email{}%
  \providecommand\keywords{}\providecommand\qpnote{}\providecommand\abstract{}%
  \renewcommand\affiliation[1]{\renewcommand\uhmbook@paff{##1}}%
  \renewcommand\shorttitle[1]{\renewcommand\uhmbook@pshort{##1}}%
  \renewcommand\shortauthor[1]{}\renewcommand\email[1]{}%
  \renewcommand\keywords[1]{}\renewcommand\qpnote[1]{}%
  \renewcommand\abstract[1]{\renewcommand\uhmbook@pabstract{##1}}%
  \renewcommand\maketitle{\uhmbook@papertitle}%
  %% the paper's own reference list is a section at its end, not a chapter
  \defbibheading{bibliography}[\refname]{\section*{##1}}%
  \begin{refsection}%
    \include{#1}%
  \end{refsection}%
  \endgroup}
\newcommand\uhmbook@papertitle{%
  \cleardoublepage
  \ohead{}%
  \lehead{\textsl{\def\and{\unskip, }\uhmbook@pauthor}}%
  \rohead{\ifx\uhmbook@pshort\@empty\uhmbook@ptitle\else\uhmbook@pshort\fi}%
  \setchapterpreamble[u]{%
    \vskip -1ex
    {\Large\raggedright\def\and{\unskip, }\uhmbook@pauthor\par}%
    \ifx\uhmbook@paff\@empty\else
      {\normalsize\itshape\raggedright\def\and{\unskip; }\uhmbook@paff\par}\fi
    \vskip 1.5\baselineskip
    \ifx\uhmbook@pabstract\@empty\else
      \begin{quote}\small\uhmbook@pabstract\end{quote}\vskip\baselineskip\fi}%
  \chapter[tocentry={\uhmbook@ptitle\protect\newline
                     {\normalfont\protect\def\protect\and{\protect\unskip, }\uhmbook@pauthor}},
           head={\ifx\uhmbook@pshort\@empty\uhmbook@ptitle\else\uhmbook@pshort\fi}]%
          {\uhmbook@ptitle}%
}

\endinput
