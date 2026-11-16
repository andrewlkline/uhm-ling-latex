%% uhmdiss.cls
%% Dissertation (and master's thesis) class for UHM Linguistics, following
%% the UHM Graduate Education "eTD Style & Policy Guide" (October 2018,
%% the current edition as of November 2026).  Section numbers in the
%% comments below (e.g. [2.10]) refer to that guide.
%%
%%   \documentclass[bibfile=references.bib]{uhmdiss}
%%
%% Options
%%   type=dissertation|thesis   title-page wording (default dissertation)
%%   font=<set>                 charis (default), libertinus, gentium, stix, noto
%%   fontsize=11pt|12pt         default 12pt; never below 10pt is used [4.2]
%%   floatnumbers=chapter|continuous   "Table 4.1" or "Table 12" [1.7]
%%   justified                  full justification (default ragged right [2.4])
%%   spacing=onehalf|double     body line spacing (default onehalf [2.7])
%%   check                      draft checks: page frame at the 1in margins,
%%                              overfull lines marked, and (LuaLaTeX) a
%%                              per-page report of hyphenated line ends and
%%                              type below 10pt [2.9, 4.2]
%%   nocompress                 write an uncompressed PDF [4.1]
%%   bibfile=, abbreviations=, lgr=   passed to uhm-ling-core
%%
%% Licence: LPPL 1.3c or later.
\NeedsTeXFormat{LaTeX2e}[2022/06/01]
\ProvidesClass{uhmdiss}[2026/11/15 v0.1 UHM dissertation (eTD guide 2018)]

%% ------------------------------------------------------------------
%% Options
%% ------------------------------------------------------------------
\newcommand*\uhmdiss@type{dissertation}
\newcommand*\uhmdiss@fontsize{12pt}
\newcommand*\uhmdiss@floatnumbers{chapter}
\newcommand*\uhmdiss@spacing{onehalf}
\newif\ifuhmdiss@justified
\newif\ifuhmdiss@check
\newif\ifuhmdiss@nocompress
\DeclareKeys[uhmdiss]{
  type.store          = \uhmdiss@type,
  fontsize.store      = \uhmdiss@fontsize,
  floatnumbers.store  = \uhmdiss@floatnumbers,
  spacing.store       = \uhmdiss@spacing,
  justified.if        = uhmdiss@justified,
  check.if            = uhmdiss@check,
  nocompress.if       = uhmdiss@nocompress,
  font.code           = \PassOptionsToPackage{font=#1}{uhm-ling-core},
  bibfile.code        = \PassOptionsToPackage{bibfile=#1}{uhm-ling-core},
  abbreviations.code  = \PassOptionsToPackage{abbreviations=#1}{uhm-ling-core},
  lgr.code            = \PassOptionsToPackage{lgr=#1}{uhm-ling-core},
  bib.code            = \PassOptionsToPackage{bib=#1}{uhm-ling-core},
}
\ProcessKeyOptions[uhmdiss]
\PassOptionsToPackage{links=black}{uhm-ling-core}

%% ------------------------------------------------------------------
%% Base class
%% ------------------------------------------------------------------
\LoadClass[
  fontsize       = \uhmdiss@fontsize,
  paper          = letter,
  oneside,
  open           = any,
  chapterprefix  = true,      % "CHAPTER 1" above the title [2.10.3]
  numbers        = noenddot,
  toc            = listof,    % lists of tables/figures in the TOC [1.6]
  toc            = bibliography,
  listof         = totoc,
  headings       = normal,
  captions       = tableheading,
  footnotes      = multiple,
]{scrreprt}

%% Margins: at least 1in on every side, page number inside the bottom
%% margin's limit ("above the 1 inch margin") [2.3, 2.10]
%% The bottom margin is 1in plus a few points so that the page number's
%% descender space also stays clear of the 1in line.
\RequirePackage[letterpaper, margin=1in, bottom=1.06in, includefoot,
                footskip=0.5in]{geometry}
\ifuhmdiss@check \geometry{showframe}\fi

\RequirePackage{setspace}
\RequirePackage[newcommands]{ragged2e}
\RequirePackage[autoenlargeheadfoot=off]{scrlayer-scrpage}
\RequirePackage[figuresleft]{rotating} % landscape: caption at the binding side [3.1.2]
\RequirePackage{longtable}
\RequirePackage{uhm-ling-core}
\uhmDefaultFont{charis}
%% No character protrusion: it hangs punctuation slightly into the margin,
%% and the guide asks for at least 1in on every side [2.3].
\microtypesetup{protrusion=false}

%% ------------------------------------------------------------------
%% Type size: nothing below 10pt [4.2]
%% ------------------------------------------------------------------
%% With the 12pt class \footnotesize is already 10pt; \scriptsize and
%% \tiny (and \footnotesize at 11pt) are raised to 10pt.
\renewcommand\tiny{\@setfontsize\tiny{10}{12}}
\renewcommand\scriptsize{\@setfontsize\scriptsize{10}{12}}
\ifdim\dimexpr\uhmdiss@fontsize\relax<12pt
  \renewcommand\footnotesize{\@setfontsize\footnotesize{10}{12}}
\fi

%% ------------------------------------------------------------------
%% Line spacing [2.7]: 1.5 (or double) in the text; single in footnotes,
%% floats (tables, captions), block quotes, examples, the TOC and lists
%% (single within an entry, a blank line between entries) and the
%% bibliography.
%% ------------------------------------------------------------------
\ifdefstring{\uhmdiss@spacing}{double}{\doublespacing}{\onehalfspacing}
\AtBeginEnvironment{quote}{\singlespacing}
\AtBeginEnvironment{quotation}{\singlespacing}
\AtBeginEnvironment{exe}{\singlespacing}
\AtBeginEnvironment{longtable}{\singlespacing}

%% Justification [2.4]: ragged right unless "justified"
\ifuhmdiss@justified\else
  \AtBeginDocument{\RaggedRight}
  \setlength{\RaggedRightParindent}{1.5em}
\fi
\setlength{\parindent}{1.5em}

%% ------------------------------------------------------------------
%% Page styles: page number bottom centre on every page, no running
%% heads, no marks around the number [2.10, 2.10.5]
%% ------------------------------------------------------------------
\setkomafont{pageheadfoot}{\normalfont\normalcolor}
\setkomafont{pagenumber}{\normalfont}
\clearpairofpagestyles
\cfoot*{\pagemark}
\pagestyle{scrheadings}
\renewcommand*{\chapterpagestyle}{scrheadings}
\renewcommand*{\partpagestyle}{empty}     % Part cover pages: unnumbered [2.10]
\renewcommand*{\indexpagestyle}{scrheadings}
\automark{}

%% ------------------------------------------------------------------
%% Headings [1.11, 2.2]
%% Major headings (chapters, acknowledgments, abstract, contents, lists,
%% preface, appendices, references) share one style: bold capitals,
%% centred, at the top of a new page. Subheadings: one distinct style per
%% level, not on a new page.
%% Protect object-language words from the capitals with \NoCaseChange{...}.
%% ------------------------------------------------------------------
\newcommand*\uhmdissMajorFont{\normalfont\bfseries\large}
\setkomafont{disposition}{\normalfont\bfseries}
\setkomafont{chapter}{\uhmdissMajorFont}
\setkomafont{chapterprefix}{\uhmdissMajorFont}
\renewcommand*{\raggedchapter}{\centering}
\RedeclareSectionCommand[beforeskip=-1sp, afterskip=2\baselineskip,
  innerskip=0pt, afterindent=false]{chapter}
\renewcommand*{\chapterformat}{\MakeUppercase{\chapappifchapterprefix{\nobreakspace}}\thechapter\autodot}
\renewcommand*{\chapterlinesformat}[3]{%
  \@hangfrom{#2}{\MakeUppercase{#3}}}
\renewcommand*{\chapterlineswithprefixformat}[3]{%
  #2\MakeUppercase{#3}}
%% Level 1: bold, flush left; level 2: bold italic; level 3: italic;
%% level 4: italic, run-in.
\RedeclareSectionCommand[font=\normalsize\bfseries, afterindent=false,
  beforeskip=1.5\baselineskip, afterskip=.75\baselineskip]{section}
\RedeclareSectionCommand[font=\normalsize\bfseries\itshape, afterindent=false,
  beforeskip=1.25\baselineskip, afterskip=.5\baselineskip]{subsection}
\RedeclareSectionCommand[font=\normalsize\mdseries\itshape, afterindent=false,
  beforeskip=1\baselineskip, afterskip=.5\baselineskip]{subsubsection}
\RedeclareSectionCommand[font=\normalsize\mdseries\itshape,
  beforeskip=1\baselineskip, afterskip=-1em]{paragraph}
\setcounter{secnumdepth}{3}
\setcounter{tocdepth}{3}
%% Parts: "PART I" + title on a separate cover page [1.11]
\setkomafont{part}{\uhmdissMajorFont}
\setkomafont{partnumber}{\uhmdissMajorFont}
\renewcommand*{\partformat}{\MakeUppercase{\partname}~\thepart}
\renewcommand*{\addparttocentry}[2]{%
  \addtocentrydefault{part}{#1}{\MakeUppercase{#2}}}

%% Unnumbered major heading used by the front-matter commands and the
%% bibliography: new page, centred bold capitals, listed in the TOC.
\newcommand\uhmdissMajorHeading[1]{%
  \addchap{#1}}

%% ------------------------------------------------------------------
%% Table of contents and lists [1.6-1.9]
%% Dot leaders on every level, sub-levels indented, single spacing within
%% an entry and a blank line between entries.
%% ------------------------------------------------------------------
\AtBeginDocument{%
  \renewcommand*{\contentsname}{Table of contents}%
  \renewcommand*{\listtablename}{List of tables}%
  \renewcommand*{\listfigurename}{List of figures}}
\renewcommand*\@pnumwidth{2.2em}
\newcommand*{\uhmdissAbbrevName}{List of abbreviations}
\DeclareTOCStyleEntry[linefill=\TOCLineLeaderFill, beforeskip=1\baselineskip,
  dynnumwidth=true]{tocline}{chapter}
\DeclareTOCStyleEntry[beforeskip=1\baselineskip]{tocline}{part}
\DeclareTOCStyleEntries[beforeskip=.5\baselineskip]{tocline}{section,subsection,subsubsection}
\DeclareTOCStyleEntries[beforeskip=1\baselineskip, dynnumwidth=true]{tocline}{figure,table}
\AfterTOCHead{\singlespacing}
%% Chapter numbers in the TOC read "CHAPTER 1", matching the heading
\renewcommand*{\addchaptertocentry}[2]{%
  \Ifstr{#1}{}%
    {\addtocentrydefault{chapter}{}{\MakeUppercase{#2}}}%
    {\addtocentrydefault{chapter}{\MakeUppercase{\chapapp}~#1}{\MakeUppercase{#2}}}}
%% The TOC heading itself is not listed in the TOC [1.6]
\setuptoc{toc}{notoc}

%% ------------------------------------------------------------------
%% Floats and captions [3.1, 3.2]
%% "Table 4.1." above the table, "Figure 4.1." below the figure.
%% ------------------------------------------------------------------
\captionsetup{labelsep=period, font={normalsize,singlespacing},
              justification=raggedright, singlelinecheck=true}
\captionsetup[table]{position=above}
\setcapindent{0pt}
\ifdefstring{\uhmdiss@floatnumbers}{continuous}{%
  \counterwithout{table}{chapter}%
  \counterwithout{figure}{chapter}%
}{}
%% Continued long tables: "Table 3. (Continued) Title"  [3.1.2]
%%   in a longtable's \endhead:  \continuedcaption{Title}
\newcommand\continuedcaption[1]{%
  \caption*{\tablename~\thetable. (Continued) #1}}
\renewcommand{\fps@figure}{htbp}
\renewcommand{\fps@table}{htbp}

%% Footnotes: single-spaced, hanging number
\deffootnote[1.5em]{1.5em}{1em}{\textsuperscript{\thefootnotemark}\enskip}

%% ------------------------------------------------------------------
%% Links [1.15]: internal links only, in black; URLs printed as text
%% ------------------------------------------------------------------
\AtBeginDocument{%
  \let\href\@secondoftwo
  \let\url\nolinkurl
}

%% ------------------------------------------------------------------
%% Title page (Sample B) [1.2]
%% ------------------------------------------------------------------
%%   \title{...}                         printed in capitals
%%   \author{Full Name}
%%   \degree{Doctor of Philosophy}       (default; MA thesis: Master of Arts)
%%   \field{Linguistics}                 (default)
%%   \graduation{August}{2027}           month must be May, August or December
%%   \chair{Name}  (\cochair{Name} for each co-chair)
%%   \member{Name}                        once per member
%%   \universityrep{Name}                 printed last
%%   \keywords{four to six, keywords}     optional
\newcommand*\uhmdiss@degree{%
  \ifdefstring{\uhmdiss@type}{thesis}{Master of Arts}{Doctor of Philosophy}}
\newcommand*\uhmdiss@field{Linguistics}
\newcommand*\uhmdiss@month{}
\newcommand*\uhmdiss@year{}
\newcommand\uhmdiss@committee{}
\newcommand\uhmdiss@rep{}
\newcommand\uhmdiss@keywords{}
\newcommand*\degree[1]{\renewcommand*\uhmdiss@degree{#1}}
\newcommand*\field[1]{\renewcommand*\uhmdiss@field{#1}}
\newcommand*\graduation[2]{%
  \renewcommand*\uhmdiss@month{#1}\renewcommand*\uhmdiss@year{#2}%
  \ifboolexpr{test {\ifstrequal{#1}{May}} or test {\ifstrequal{#1}{August}}
              or test {\ifstrequal{#1}{December}}}{}{%
    \ClassError{uhmdiss}{Graduation month must be May, August or December}
      {The eTD guide [1.2] allows only these months. Use the month of
       graduation, not the month of submission.}}}
\newcommand*\chair[1]{\appto\uhmdiss@committee{#1, Chairperson\\}}
\newcommand*\cochair[1]{\appto\uhmdiss@committee{#1, Co-Chairperson\\}}
\newcommand*\member[1]{\appto\uhmdiss@committee{#1\\}}
\newcommand*\universityrep[1]{\renewcommand\uhmdiss@rep{#1\\}}
\newcommand\keywords[1]{\renewcommand\uhmdiss@keywords{#1}}
\date{}

\renewcommand\maketitle{%
  \begin{titlepage}
  \setcounter{page}{1}% the title page is page i, but not numbered [2.10.1]
  \singlespacing\centering
  \hyphenpenalty=10000 \exhyphenpenalty=10000
  \vspace*{0pt}%
  {\setstretch{2}\MakeUppercase{\@title}\par}%
  \vfill
  \parbox{.92\textwidth}{\centering
  \MakeUppercase{A \uhmdiss@type\ submitted to the Graduate Division of the
  University of Hawaiʻi at Mānoa in partial fulfillment of the
  requirements for the degree of}}\par
  \vskip 1.5\baselineskip
  \MakeUppercase{\uhmdiss@degree}\par
  \vskip 1.5\baselineskip
  IN\par
  \vskip 1.5\baselineskip
  \MakeUppercase{\uhmdiss@field}\par
  \vskip 2\baselineskip
  \ifx\uhmdiss@month\@empty
    \ClassError{uhmdiss}{No graduation date}{Use \string\graduation{August}{2027}.}%
  \fi
  \uhmdiss@month\ \uhmdiss@year\par
  \vfill
  By\par
  \vskip 1.5\baselineskip
  \@author\par
  \vfill
  \ifdefstring{\uhmdiss@type}{thesis}{Thesis}{Dissertation} Committee:\par
  \vskip 1.5\baselineskip
  {\setlength{\parskip}{0pt}\uhmdiss@committee\uhmdiss@rep}\par
  \ifx\uhmdiss@keywords\@empty\else
    \vfill
    \parbox{.85\textwidth}{\centering Keywords: \uhmdiss@keywords}\par
  \fi
  \vspace*{0pt}%
  \end{titlepage}
  \setcounter{page}{2}%
  \hypersetup{pdftitle={\@title}, pdfauthor={\@author},
              pdfkeywords={\uhmdiss@keywords}}%
}

%% ------------------------------------------------------------------
%% Front matter [1.1] and main matter [2.10]
%% ------------------------------------------------------------------
%% Order: \maketitle, \copyrightpage, \dedication{}, acknowledgments,
%% abstract, \tableofcontents, \listoftables, \listoffigures,
%% \listofabbreviations, preface, then \mainmatter.
\newcommand\frontmatter{\pagenumbering{roman}}
\newcommand\mainmatter{\clearpage\pagenumbering{arabic}}
\AtBeginDocument{\pagenumbering{roman}}

\newcommand\copyrightpage{%
  \clearpage
  \thispagestyle{scrheadings}%
  \vspace*{\fill}%
  \begin{center}\singlespacing
    Copyright \textcopyright\ \uhmdiss@year\ \@author\par
  \end{center}
  \vspace*{\fill}%
  \clearpage}

%% Dedication: centred, not listed in the TOC [1.6]
\renewcommand\dedication[1]{%
  \clearpage
  \vspace*{\fill}%
  \begin{center}#1\end{center}%
  \vspace*{\fill}%
  \clearpage}

\newenvironment{acknowledgments}
  {\uhmdissMajorHeading{Acknowledgments}}
  {\clearpage}
%% Abstract: double-spaced, titled simply ABSTRACT [1.5]
\let\abstract\relax \let\endabstract\relax
\newenvironment{abstract}
  {\uhmdissMajorHeading{Abstract}\begin{doublespace}}
  {\end{doublespace}\clearpage}
\newenvironment{preface}
  {\uhmdissMajorHeading{Preface}}
  {\clearpage}

%% List of abbreviations: the Leipzig abbreviations collected by
%% \Sg, \Erg, \newleipzig ... on its own page, after the list of figures
%% [1.9]. Pass glossaries options in the optional argument.
\newcommand\listofabbreviations[1][]{%
  \ifcsname printglosses\endcsname
    \printglosses[title={\MakeUppercase{\uhmdissAbbrevName}},
                  toctitle={\MakeUppercase{\uhmdissAbbrevName}},#1]%
  \fi}
\ifcsname setglossarysection\endcsname \setglossarysection{chapter}\fi

%% Bibliography heading: REFERENCES (or e.g. \refname{Literature cited}),
%% a major heading listed in the TOC, single-spaced entries with a blank
%% line between [1.14]
\newcommand*\uhmdissRefName{References}
\newcommand*\referencesname[1]{\renewcommand*\uhmdissRefName{#1}}
\ifcsname defbibheading\endcsname
  \defbibheading{bibliography}[\uhmdissRefName]{%
    \uhmdiss@inappendixfalse\uhmdissMajorHeading{#1}}
  \AtBeginBibliography{\singlespacing}
  \setlength{\bibitemsep}{12pt}
\fi

%% ------------------------------------------------------------------
%% Appendices [1.12]: no cover page; heading centred like a chapter;
%% "APPENDIX A", "APPENDIX B" ... or just "APPENDIX" if there is only one.
%% ------------------------------------------------------------------
\newcounter{uhmdiss@appendices}
\newif\ifuhmdiss@inappendix
\providecommand*\uhmdiss@lastappendices{0}
\g@addto@macro\appendix{%
  \uhmdiss@inappendixtrue
  \renewcommand*{\chapterformat}{%
    \stepcounter{uhmdiss@appendices}%
    \MakeUppercase{\appendixname}%
    \ifnum\uhmdiss@lastappendices=1 \else\nobreakspace\thechapter\fi}%
  \renewcommand*{\addchaptertocentry}[2]{%
    \Ifstr{#1}{}%
      {\addtocentrydefault{chapter}{}{\MakeUppercase{#2}}}%
      {\addtocentrydefault{chapter}{}{\MakeUppercase{\appendixname}%
        \ifnum\uhmdiss@lastappendices=1 \else\ \thechapter\fi:\ \MakeUppercase{#2}}}}%
  \crefalias{chapter}{appendix}%
}
\AtEndDocument{%
  \immediate\write\@auxout{\gdef\string\uhmdiss@lastappendices{\the\value{uhmdiss@appendices}}}}
\crefformat{appendix}{\ifnum\uhmdiss@lastappendices=1 #2appendix#3\else appendix~#2#1#3\fi}
\Crefformat{appendix}{\ifnum\uhmdiss@lastappendices=1 #2Appendix#3\else Appendix~#2#1#3\fi}

%% ------------------------------------------------------------------
%% PDF output [4.1]
%% ------------------------------------------------------------------
\ifuhmdiss@nocompress
  \ifLuaTeX
    \pdfvariable compresslevel=0
    \pdfvariable objcompresslevel=0
  \else\ifXeTeX
    \special{dvipdfmx:config z 0}%
  \fi\fi
\fi

%% ------------------------------------------------------------------
%% Draft checks
%% ------------------------------------------------------------------
\ifuhmdiss@check
  \setlength{\overfullrule}{5pt}
  \ifLuaTeX
    \directlua{dofile(kpse.find_file("uhmdiss-check.lua"))}
    \AtEndDocument{\directlua{uhmdiss_check.report()}}
  \else
    \ClassWarningNoLine{uhmdiss}{The hyphenation and type-size checks need
      LuaLaTeX; with XeLaTeX only the margin frame and overfull-line marks
      are shown}
  \fi
\fi

\endinput
