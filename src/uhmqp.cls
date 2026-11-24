%% uhmqp.cls
%% Qualifying-paper class for UHM Linguistics, with journal "profiles".
%%
%%   \documentclass[profile=ldc, font=charis]{uhmqp}
%%
%% A profile is a small file uhmqp-profile-<name>.def that sets page
%% layout, fonts, headings, the title block, captions, running heads,
%% examples and bibliography tweaks to approximate a target journal.
%% Profiles shipped: langsci (default), ldc, ol, stuf, blank.
%% Write your own by copying uhmqp-profile-blank.def into your project
%% folder as uhmqp-profile-<yourname>.def.
%%
%% The class is a slim derivative of langscibook.cls (Language Science
%% Press, LPPL 1.3c; maintained by Sebastian Nordhoff): the page geometry,
%% footnote, quote, float and paper-appendix settings of the default
%% profile are taken from it. All covers, imprint, series, ISBN, licence
%% and branding code has been removed. This file is distributed under
%% the LPPL 1.3c or later; it is a modified work and therefore carries a
%% different name.
\NeedsTeXFormat{LaTeX2e}[2022/06/01]
\ProvidesClass{uhmqp}[2026/11/15 v0.1 UHM Linguistics qualifying paper]

%% ------------------------------------------------------------------
%% Options
%% ------------------------------------------------------------------
%%   profile=<name>            journal profile (default: langsci)
%%   font=<set>                charis|libertinus|gentium|stix|noto
%%                             (default: the profile's font)
%%   bibfile=<file.bib>        bibliography database
%%   abbreviations=true|false  gloss-abbreviation list (default true)
%%   lgr=true|false            load langsci-lgr macros (default false)
%%   draft                     date stamp, overfull-line marks
%%   linenumbers               line numbers for committee comments
\newcommand*\uhmqp@profile{langsci}
\newif\ifuhmqp@draft
\newif\ifuhmqp@linenumbers
\DeclareKeys[uhmqp]{
  profile.store       = \uhmqp@profile,
  font.code           = \PassOptionsToPackage{font=#1}{uhm-ling-core},
  bibfile.code        = \PassOptionsToPackage{bibfile=#1}{uhm-ling-core},
  abbreviations.code  = \PassOptionsToPackage{abbreviations=#1}{uhm-ling-core},
  lgr.code            = \PassOptionsToPackage{lgr=#1}{uhm-ling-core},
  bib.code            = \PassOptionsToPackage{bib=#1}{uhm-ling-core},
  draft.if            = uhmqp@draft,
  linenumbers.if      = uhmqp@linenumbers,
}
\ProcessKeyOptions[uhmqp]

\IfFileExists{uhmqp-profile-\uhmqp@profile.def}{}{%
  \ClassError{uhmqp}{Profile `\uhmqp@profile' not found}
    {There is no file uhmqp-profile-\uhmqp@profile.def. Shipped
     profiles: langsci, ldc, ol, stuf, blank.}}

%% ------------------------------------------------------------------
%% Base class and packages
%% ------------------------------------------------------------------
\LoadClass[
  fontsize    = 11pt,
  numbers     = noenddot,
  footnotes   = multiple,
  captions    = tableheading,
  headings    = normal,
]{scrartcl}

\RequirePackage{geometry}
\RequirePackage[autoenlargeheadfoot=off]{scrlayer-scrpage}
\RequirePackage{setspace}
\RequirePackage{floatrow}      % caption position independent of source order
\floatsetup{capposition=bottom}
\floatsetup[table]{capposition=top}
\RequirePackage{datetime2}
\ifuhmqp@linenumbers \RequirePackage[pagewise]{lineno}\fi

%% Everything that must come before hyperref is loaded above; the core
%% package loads hyperref, glossaries and cleveref last.
\RequirePackage{uhm-ling-core}

%% ------------------------------------------------------------------
%% Metadata
%% ------------------------------------------------------------------
%% \title{...}          \shorttitle{...}   (running head)
%% \author{...}         \shortauthor{...}  (running head)
%%     several authors: \author{Name One \and Name Two}
%% \affiliation{...}    several: \affiliation{One \and Two}
%% \email{...}
%% \abstract{...}       (a command, as in langscibook)
%% \keywords{...}       e.g. \keywords{ejectives; Timor; sound change}
%% \qpnote{...}         free text shown on the first page, e.g.
%%                      "Qualifying paper 1, submitted 15 November 2026"
\newcommand*\uhmqpShortTitle{}
\newcommand*\uhmqpShortAuthor{}
\newcommand*\uhmqpAffiliation{}
\newcommand*\uhmqpEmail{}
\newcommand\uhmqpAbstract{}
\newcommand\uhmqpKeywords{}
\newcommand\uhmqpNote{}
\newcommand*\shorttitle[1]{\renewcommand*\uhmqpShortTitle{#1}}
\newcommand*\shortauthor[1]{\renewcommand*\uhmqpShortAuthor{#1}}
\newcommand*\affiliation[1]{\renewcommand*\uhmqpAffiliation{#1}}
\newcommand*\email[1]{\renewcommand*\uhmqpEmail{#1}}
\let\abstract\relax \let\endabstract\relax
\newcommand\abstract[1]{\renewcommand\uhmqpAbstract{#1}}
\newcommand\keywords[1]{\renewcommand\uhmqpKeywords{#1}}
\newcommand\qpnote[1]{\renewcommand\uhmqpNote{#1}}
\newcommand\uhmqpTitle{\@title}
\newcommand\uhmqpAuthor{\@author}
\date{}

%% Helpers for profile writers
%%   \uhmqpIfSet{\macro}{if set}{if empty}
\newcommand\uhmqpIfSet[3]{\ifdefempty{#1}{#3}{#2}}% etoolbox: works for \long macros too
%% Running-head text: the short version if given, else the full one
\newcommand\uhmqpHeadTitle{%
  \ifx\uhmqpShortTitle\@empty \@title \else \uhmqpShortTitle \fi}
\newcommand\uhmqpHeadAuthor{%
  \ifx\uhmqpShortAuthor\@empty {\def\and{\unskip, }\@author}\else \uhmqpShortAuthor \fi}

%% \maketitle calls \uhmqpMakeTitle, which each profile defines.
\newcommand\uhmqpMakeTitle{%
  \begin{center}
    {\Large\bfseries\@title\par}\medskip
    {\def\and{\quad}\@author\par}
    \uhmqpIfSet\uhmqpAffiliation{{\small\def\and{\quad}\uhmqpAffiliation\par}}{}%
  \end{center}
  \uhmqpIfSet\uhmqpAbstract{\begin{quote}\small\uhmqpAbstract\end{quote}}{}%
}
\renewcommand\maketitle{%
  \uhmqpMakeTitle
  \thispagestyle{uhmqpfirst}%
  \ifuhmqp@linenumbers\linenumbers\fi
  \@afterindentfalse\@afterheading
}

%% ------------------------------------------------------------------
%% Defaults shared by all profiles (a profile may override any of these)
%% ------------------------------------------------------------------
\geometry{letterpaper, margin=1in}
\raggedbottom
%% Extra stretch before a justified line runs into the margin. Needed under
%% XeLaTeX (no microtype font expansion) on narrow journal measures with long
%% IPA forms, slashed compounds and URLs.
\setlength{\emergencystretch}{2em}
\setkomafont{disposition}{\normalcolor\bfseries}
\setkomafont{descriptionlabel}{\normalfont\itshape}
\setkomafont{pageheadfoot}{\normalfont\normalcolor}
\setcounter{secnumdepth}{3}% \paragraph is an unnumbered run-in label, as in article
\setcounter{tocdepth}{3}

%% Footnotes (from langscibook)
\newlength{\normalparindent}
\AtBeginDocument{\setlength{\normalparindent}{\parindent}}
\deffootnote[1.5em]{1.5em}{\normalparindent}{\textsuperscript{\thefootnotemark}\enskip}

%% Quotes indented on the left only (from langscibook)
\renewenvironment{quote}{\list{}{\rightmargin0pt\leftmargin8mm}\item\relax}{\endlist}
\renewenvironment{quotation}
  {\list{}{\listparindent 1.5em\parsep\z@\@plus\p@}\item\relax}
  {\endlist}

%% Floats (from langscibook)
\renewcommand{\fps@figure}{htbp}
\renewcommand{\fps@table}{htbp}
\renewcommand{\topfraction}{0.9}
\renewcommand{\bottomfraction}{0.8}
\setcounter{topnumber}{2}
\setcounter{bottomnumber}{2}
\setcounter{totalnumber}{4}
\renewcommand{\textfraction}{0.07}
\renewcommand{\floatpagefraction}{0.7}
\captionsetup{font={small}, labelsep=colon}

%% Appendices in papers (from langscibook):
%%   \begin{paperappendix} \section{Title} ... \end{paperappendix}
%% Per the Generic Style Rules, appendices precede the references.
\providecommand*\appendixname{Appendix}
\newenvironment{paperappendix}
  {\appendix
   \renewcommand*{\sectionformat}{\appendixname~\thesection\autodot\enskip}}
  {}

%% LangSci index commands (\ia name, \il language, \is subject) are accepted
%% and ignored, so a paper written for a uhmbook volume (or a LangSci book)
%% also compiles on its own. In a uhmbook they feed the indexes.
\providecommand*\ia[1]{}
\providecommand*\il[1]{}
\providecommand*\is[1]{}

%% Bibliography heading: unnumbered section titled "References"
\ifcsname printbibliography\endcsname
  \defbibheading{bibliography}[\refname]{%
    \section*{#1}%
    \addcontentsline{toc}{section}{#1}%
    \markboth{#1}{#1}}
\fi
\renewcommand*{\refname}{References}
\providecommand*{\glossaryname}{Abbreviations}
\def\leipzigname{Abbreviations}

%% Page styles: "uhmqpfirst" for the title page, scrheadings elsewhere.
%% Profiles redefine both with \ihead, \ohead, \cfoot, ... as needed.
\newpairofpagestyles[scrheadings]{uhmqpfirst}{}
%% Room for a multi-line note in the first-page footer (as langscibook)
\AddToLayerPageStyleOptions{uhmqpfirst}
  {onselect={\setlength{\footheight}{3\baselineskip}}}
\pagestyle{scrheadings}
\clearpairofpagestyles
\cfoot*{\pagemark}

%% Draft mode
\ifuhmqp@draft
  \setlength{\overfullrule}{5pt}
  \AddToHook{begindocument/end}{%
    \ifoot*{\textcolor{gray}{\footnotesize Draft of \DTMnow}}}
\fi

%% ------------------------------------------------------------------
%% Load the profile
%% ------------------------------------------------------------------
\newcommand*\uhmqpProfileName{\uhmqp@profile}
\input{uhmqp-profile-\uhmqp@profile.def}
\typeout{uhmqp: profile = \uhmqp@profile}

\endinput
