%% Originally developed by Martin Sievers (Einfach schöner publizieren)
%% based on the faupress.cls class developed by Felix Lammermann (FAU)
%% and Michael Enders (FAU) 
%% Copyright (C) 2020 by FAU University Press
%% 
%% This work may be distributed and/or modified under the
%% conditions of the LaTeX Project Public License (LPPL), either
%% version 1.3c of this license or (at your option) any later
%% version. The latest version of this license is in the file:
%% 
%%  http://www.latex-project.org/lppl.txt
%% 
%% This work is "maintained" (as per LPPL maintenance status) by
%%   Markus Putnings (markus.putnings@fau.de, university-press@fau.de)
%% ---------------------------------------------------------------------
%% 
%% Please note, that this class is a fork of a more generic one called
%% faupress.cls.
%%
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{faupress-mb}[2020/08/24 LaTeX Class for FAU University Press (Maschinenbau)]


%%% LUALATEX %%%

% It is highly recommended to compile the documents based on this class with
% lualatex instead of standard pdflatex, because it makes the use of fonts
% significantly easier. Fallbacks for pdflatex are still included. In order
% to detect whether or not lualatex is used the ifluatex package is included.

\RequirePackage{ifluatex}

% Whenever different commands or packages are required by lualatex or pdflatex
% the ifluatex command is used. Just like here where a class warning is given
% is pdflatex is used.

\ifluatex
% do nothing
\else
\ClassWarning{faupress}{You are not using LuaLaTeX for compilation! It is
  highly recommended to use LuaLaTeX, because it allocates memory dynamically
  (required for very large documents) and because the handling of fonts is more
  flexible.}
\fi

%%% HELPERS %%%

% This package enables calculations within length settings. It is commonly used
% and thus included by default in this class.

\RequirePackage{calc}

% This package allows to define new commands and environments more flexible.
% For example commands with multiple optional arguments can easily be defined.

\RequirePackage{xparse}

% Sometimes you might define shortcuts for words or parts of a sentence.
% Depending whether or not the word is placed in right before a punctuation
% mark, there should be a space after the word or not. The automatic placement
% of such spaces is enabled by the package xspace.

\RequirePackage{xspace}

% Especially when creating new packages or classes if conditions are used all
% the time. This package provides an easy syntax for this as well as method for
% comparision of strings and numbers.

\RequirePackage{ifthen}

% The package provides macros for manipulating strings - testing a string’s
% contents, extracting substrings, substitution of substrings and providing
% numbers such as string length, position of, or number of recurrences of,
% a substring.

\RequirePackage{xstring}
\RequirePackage{etoolbox}

%%% CLASS OPTIONS %%%

% The options for this class shall all be in key-value format, because it is
% way more flexible. For this task the kvoptions package is used. There are
% multiple ways to create options. String options and boolean options are most
% commonly used.

% In this class the string options will in most cases be converted to booleans,
% which makes working with them easier and allows multiple strings to have the
% same effect. The conversion is done in two steps. Firstly new booleans for
% all possible settings are created and initialized as false. Secondly the
% booleans are altered to true depending on the setting is receives from the
% kay-value option.

\RequirePackage{xkeyval}
%\RequirePackage{kvoptions}
%\SetupKeyvalOptions {
%  family = faupress,
%  prefix = faupress@
%}

% The paper format will be set to a size of 17cm × 24cm (also called
% Studienpartitur) as default. The only other option is DIN A5 paper. For this
% option a string is used to identify the paper format, which will later be
% converted to booleans.

\newif\iffaupress@studienpartitur\faupress@studienpartiturfalse
\newif\iffaupress@afive\faupress@afivefalse

\define@choicekey*+{faupress}{paper}[\val\nr]{%
  default,%
  studienpartitur,%
  17x24,%
  a5paper,%
  a5%
}{%
  \ifcase\nr\relax % default
    \faupress@studienpartiturtrue
    \faupress@afivefalse
  \or % studienpartitur
    \faupress@studienpartiturtrue
    \faupress@afivefalse
  \or % 17x24
    \faupress@studienpartiturtrue
    \faupress@afivefalse
  \or % a5paper
    \faupress@studienpartiturfalse
    \faupress@afivetrue
  \or % a5
    \faupress@studienpartiturfalse
    \faupress@afivetrue
  \fi
}{
  \ClassWarning{faupress}{unsupported paper format ignored, default used}
}

% The user will be enabled to decide whether he wants the list of acronyms to
% be splitted in abbreviations and symbols (split) or have a combined list for
% both types (combined). If there are no abbreviations or no symbols used the
% functionality can be turned off partially (no symbol, no abbreviation, only
% symbol, only abbreviation). Furthermore the user can decide to turn off
% everything concerning acronyms (none) to enable own inplementations of
% acronyms and how they are handled. For this option again a string is used.

\newif\iffaupress@acronym\faupress@acronymfalse
\newif\iffaupress@combinedacronym\faupress@combinedacronymfalse
\newif\iffaupress@splitacronym\faupress@splitacronymfalse
\newif\iffaupress@abbreviation\faupress@abbreviationfalse
\newif\iffaupress@symbol\faupress@symbolfalse

\define@choicekey*+{faupress}{acronym}[\val\nr]{%
  default,%
  true,%
  false,%
  combined,%
  split,%
  none,%
  noabbreviation,%
  onlyabbreviation,%
  nosymbol,%
  onlysymbol,%
}{%
  \ifcase\nr\relax % default
    \faupress@acronymtrue
    \faupress@combinedacronymfalse
    \faupress@splitacronymtrue
    \faupress@abbreviationfalse
    \faupress@symbolfalse
  \or % true
    \faupress@acronymtrue
    \faupress@combinedacronymfalse
    \faupress@splitacronymtrue
    \faupress@abbreviationfalse
    \faupress@symbolfalse
  \or % false
    \faupress@acronymfalse
    \faupress@combinedacronymfalse
    \faupress@splitacronymfalse
    \faupress@abbreviationfalse
    \faupress@symbolfalse
  \or % combined
    \faupress@acronymtrue
    \faupress@combinedacronymtrue
    \faupress@splitacronymfalse
    \faupress@abbreviationfalse
    \faupress@symbolfalse
  \or % split
    \faupress@acronymtrue
    \faupress@combinedacronymfalse
    \faupress@splitacronymtrue
    \faupress@abbreviationfalse
    \faupress@symbolfalse
  \or % none
    \faupress@acronymfalse
    \faupress@combinedacronymfalse
    \faupress@splitacronymfalse
    \faupress@abbreviationfalse
    \faupress@symbolfalse
  \or % noabbreviation
    \faupress@acronymtrue
    \faupress@combinedacronymfalse
    \faupress@splitacronymfalse
    \faupress@abbreviationfalse
    \faupress@symboltrue
  \or % onlyabbreviation
    \faupress@acronymtrue
    \faupress@combinedacronymfalse
    \faupress@splitacronymfalse
    \faupress@abbreviationtrue
    \faupress@symbolfalse
  \or % nosymbol
    \faupress@acronymtrue
    \faupress@combinedacronymfalse
    \faupress@splitacronymfalse
    \faupress@abbreviationtrue
    \faupress@symbolfalse
  \or % onlysymbol
    \faupress@acronymtrue
    \faupress@combinedacronymfalse
    \faupress@splitacronymfalse
    \faupress@abbreviationfalse
    \faupress@symboltrue
  \fi
}{
  \ClassWarning{faupress}{unsupported acronym option ignored, default used}
}

% The bibliography apparatus implemented in this class can be turned off by a
% class option to enable own implementations to the user. Providently this
% function is also implemented as a string optionin case there will be more
% settings concerning bibliographies in the future. Since one needs a default
% value to reflect the normal behavior and the bibliography is separated in
% three parts, again the word split was used, this does not mean there is a
% combined option!

\newif\iffaupress@bibliography\faupress@bibliographyfalse
\newif\iffaupress@splitbibliography\faupress@splitbibliographyfalse

\define@choicekey*+{faupress}{bibliography}[\val\nr]{%
  default,%
  true,%
  false,%
  split,%
  none,%
}{%
  \ifcase\nr\relax % default
    \faupress@bibliographytrue
    \faupress@splitbibliographytrue
  \or % true
    \faupress@bibliographytrue
    \faupress@splitbibliographytrue
  \or % false
    \faupress@bibliographyfalse
    \faupress@splitbibliographyfalse
  \or % split
    \faupress@bibliographytrue
    \faupress@splitbibliographytrue
  \or % none
    \faupress@bibliographyfalse
    \faupress@splitbibliographyfalse
  \fi
}{
  \ClassWarning{faupress}{unsupported bibliography option ignored, default used}
}

% The template and its language depended parts is available in German and
% English, but not in any other languages. However there might be situations in
% which the user wants to use the microtypographic finesses of another language
% somewhere in the continous text (e.g. a quote from a French or Hungarian
% author). To enable the user to choose one of the two template languages a
% class option is used.  Other languages can be loaded in the individual
% preamble via setotherlanguage (polyglossia) bzw. PassOptionsToPackage
% (babel).

\newif\iffaupress@german\faupress@germanfalse
\newif\iffaupress@english\faupress@englishfalse

\define@choicekey*+{faupress}{language}[\val\nr]{%
  default,%
  german,ngerman,germanb,austrian,naustrian,%
  english,USenglish,american,UKenglish,british,canadian,australian,newzealand,%
}{%
  \ifcase\nr\relax % default
    \faupress@englishfalse
    \faupress@germantrue
  \or % german
    \faupress@englishfalse
    \faupress@germantrue
  \or % ngerman
    \faupress@englishfalse
    \faupress@germantrue
  \or % germanb
    \faupress@englishfalse
    \faupress@germantrue
  \or % austrian
    \faupress@englishfalse
    \faupress@germantrue
  \or % naustrian
    \faupress@englishfalse
    \faupress@germantrue
  \or % english
    \faupress@englishtrue
    \faupress@germanfalse
  \or % USenglish
    \faupress@englishtrue
    \faupress@germanfalse
  \or % american
    \faupress@englishtrue
    \faupress@germanfalse
  \or % UKenglish
    \faupress@englishtrue
    \faupress@germanfalse
  \or % british
    \faupress@englishtrue
    \faupress@germanfalse
  \or % canadian
    \faupress@englishtrue
    \faupress@germanfalse
  \or % australian
    \faupress@englishtrue
    \faupress@germanfalse
  \or % newzealand
    \faupress@englishtrue
    \faupress@germanfalse
  \fi
}{
  \ClassWarning{faupress}{unsupported language option ignored, default used}
}


% After all these options were defined, we need to process them in order to
% make the set values available for the further parts of this class.

\ExecuteOptionsX<faupress>{
  paper = default,%
  acronym = default,%
  bibliography = default,%
  language = default,%
}
\ProcessOptionsX<faupress>


%%% BASE CLASS %%%

% This class shall be based on the KOMA script and more specifically on the
% scrbook class, which is loaded here.

\LoadClass{scrbook}

% The KOMA script has a whole lot of options, that will be set continously
% throughout this class whenever required.

\KOMAoptions{
  listof   = totoc,
  listof   = nochaptergap,
  toc      = chapterentrydotfill,
  captions = tableheading,
  captions = figuresignature,
  headings = optiontoheadandtoc,
  footnotes= multiple,
  numbers  = noenddot
}


%%% MACROTYPOGRAPHY %%%

% The page size and margins can easily be controlled by this package. Usually
% we would not use this package because the definitions made by the KOMA
% classes are very thought-out. However the paper format and margins required
% by FAU Univeristy Press are impossible to achieve with the KOMA classes.

\RequirePackage{geometry}

\iffaupress@studienpartitur
\geometry{
  paperwidth   =  170mm ,
  paperheight  =  240mm ,
  top          =   25mm ,
  bottom       =   20mm ,
  inner        =   25mm ,
  outer        =   20mm ,
  headheight   =   2\baselineskip,%1em ,
  headsep      =   15mm - \headheight,%1em ,
  footskip     =  7.5mm ,
  %showframe,
}
\fi

\iffaupress@afive
\geometry{
  paper = a5paper ,
  top          =  23mm ,
  bottom       =  18mm ,
  inner        =  23mm ,
  outer        =  18mm ,
  headheight   =  2\baselineskip,% 1em ,
  headsep      =  13mm - \headheight,%1em ,
  footskip     =   8mm ,
  %showframe,
}
\fi

%

\RequirePackage{lscape}
\RequirePackage{scrhack}
\RequirePackage{scrlayer-scrpage}
\automark[chapter]{chapter}
\automark*[section]{}
\providecommand{\Ifthispageodd}{\ifthispageodd}
\ohead{\parbox[t][2\baselineskip]{\linewidth}{\Ifthispageodd{\raggedleft}{\raggedright}\headmark}}
\pagestyle{scrheadings}
% languages & language depended stuff
%%%MS: Komplett auf babel gewechselt
\iffaupress@german
   \RequirePackage[english,ngerman]{babel}
\else
   \RequirePackage[ngerman,english]{babel}
\fi
\renewcommand*{\ngermanhyphenmins}{32}


\iffaupress@german
  \newcommand*{\abstractname}{Abstract}% Absichtlich
  \newcommand*{\prefacename}{Vorwort}%
  \newcommand*{\introductionname}{Einleitung}%
  \newcommand*{\unitname}{Einheit}%
  \newcommand*{\descriptionname}{Beschreibung}%
  \newcommand*{\abbrname}{Abkürzung}%
  \newcommand*{\Mbibname}{Literaturverzeichnis}%
  \newcommand*{\Pbibname}{Verzeichnis promotionsbezogener, eigener Publikationen}
  \newcommand*{\Sbibname}{Verzeichnis promotionsbezogener, studentischer Arbeiten}
  \newcommand*{\acroname}{Formelzeichen- und Abkürzungsverzeichnis}%
  \newcommand*{\listabbrname}{Abkürzungsverzeichnis}%
  \newcommand*{\listformulaname}{Formelzeichenverzeichnis}%

  \addto\captionsngerman{%
    \renewcommand{\listfigurename}{Bildverzeichnis}%
    \renewcommand{\listtablename}{Tabellenverzeichnis}%
    \renewcommand{\figurename}{Bild}
    \renewcommand{\tablename}{Tabelle}
    \renewcommand{\appendixname}{Anhang}
    \renewcommand{\partname}{Teil}
    \renewcommand{\chaptername}{Kapitel}
    \renewcommand{\figureautorefname}{Bild}
    \renewcommand{\tableautorefname}{Tabelle}
    \renewcommand{\partautorefname}{Teil}
    \renewcommand{\appendixautorefname}{Anhang}
    \renewcommand{\equationautorefname}{Gleichung}
    \renewcommand{\Itemautorefname}{Punkt}
    \renewcommand{\chapterautorefname}{Kapitel}
    \renewcommand{\sectionautorefname}{Abschnitt}
    \renewcommand{\subsectionautorefname}{Unterabschnitt}
    \renewcommand{\subsubsectionautorefname}{Unterunterabschnitt}
    \renewcommand{\paragraphautorefname}{Absatz}
    \renewcommand{\subparagraphautorefname}{Unterabsatz}
    \renewcommand{\Hfootnoteautorefname}{Fußnote}
    \renewcommand{\AMSautorefname}{Gleichung}
    \renewcommand{\theoremautorefname}{Theorem}
    \renewcommand{\pageautorefname}{Seite}
  }
\fi

\iffaupress@english
  \newcommand*{\abstractname}{Kurzzusammenfassung}%Absichtlich
  \newcommand*{\prefacename}{Preface}%
  \newcommand*{\introductionname}{Introduction}%
  \newcommand*{\unitname}{Unit}%
  \newcommand*{\descriptionname}{Description}%
  \newcommand*{\abbrname}{Abbreviation}%
  \newcommand*{\Mbibname}{Bibliography}%
  \newcommand*{\Pbibname}{Own publications referring to this work}
  \newcommand*{\Sbibname}{Students’ theses referring to this work}
  \newcommand*{\acroname}{List of Symbols and Abbreviations}%
  \newcommand*{\listabbrname}{List of Abbreviations}%
  \newcommand*{\listformulaname}{List of Symbols}%
%%%
  \addto\captionsenglish{%
    \renewcommand{\listfigurename}{List of Figures}%
    \renewcommand{\listtablename}{List of Tables}%
    \renewcommand{\figurename}{Figure}
    \renewcommand{\tablename}{Table}
    \renewcommand{\appendixname}{Appendix}
    \renewcommand{\partname}{Part}
    \renewcommand{\chaptername}{chapter}
    \renewcommand{\figureautorefname}{Figure}
    \renewcommand{\tableautorefname}{Table}
    \renewcommand{\partautorefname}{Part}
    \renewcommand{\appendixautorefname}{Appendix}
    \renewcommand{\equationautorefname}{Equation}
    \renewcommand{\Itemautorefname}{item}
    \renewcommand{\chapterautorefname}{chapter}
    \renewcommand{\sectionautorefname}{section}
    \renewcommand{\subsectionautorefname}{subsection}
    \renewcommand{\subsubsectionautorefname}{subsubsection}
    \renewcommand{\paragraphautorefname}{paragraph}
    \renewcommand{\subparagraphautorefname}{subparagraph}
    \renewcommand{\Hfootnoteautorefname}{footnote}
    \renewcommand{\AMSautorefname}{Equation}
    \renewcommand{\theoremautorefname}{Theorem}
    \renewcommand{\pageautorefname}{page}
  }
\fi

\RequirePackage[autostyle]{csquotes}

%%% MATH & SCIENCE %%%

\RequirePackage{mathtools}
\RequirePackage{amssymb}
\RequirePackage{amsfonts}
\RequirePackage{siunitx}
\sisetup{
  math-micro = \text{µ},
  text-micro = µ,
  separate-uncertainty = true,
  round-mode = places,
  round-precision = 3,
  detect-all = true,
  number-math-rm = \normalfont
}

%%% MICROTYPOGRAPHY & FONTS %%%

\ifluatex
   \RequirePackage{fontspec}
   \RequirePackage[bold-style=ISO]{unicode-math}
   \defaultfontfeatures{Ligatures={TeX,Common}}
   \setsansfont[
      Path = fonts/,
      Extension      = .ttf,
      UprightFont    = *-light,
      BoldFont       = *-medium,
   ]{helveticaneueltcom}
   
   \setmainfont[
      Path = fonts/,
      Extension         = .ttf,
      UprightFont       = *-regular,
      BoldFont          = *-bold,
      ItalicFont        = *-italic,
      BoldItalicFont    = *-bold-italic,
      SmallCapsFeatures = {RawFeature=+c2sc}
   ]{constantia}
   
   \setmathfont[
      Path = fonts/,
      Extension = .ttf
   ]{cambria-math}
   % Support for better ligatures
   \iffaupress@german
      \usepackage[german]{selnolig}
   \else
      \usepackage[english]{selnolig}
   \fi%
\else
   \RequirePackage[T1]{fontenc}
   \RequirePackage[utf8]{inputenc}
   \RequirePackage[garamond]{mathdesign}
   \RequirePackage{ebgaramond}
\fi
\RequirePackage[%
   final,%
   babel,%
   tracking=smallcaps,%
   expansion=alltext,%
   protrusion=true%
]{microtype}%
\SetTracking{encoding=*,shape=sc}{50}%
\RequirePackage{lipsum}
\RequirePackage{setspace}
\RequirePackage{ragged2e}

%\renewcommand{\sfdefault}{\familydefault}

\iffaupress@studienpartitur
  \KOMAoption{fontsize}{11pt}
  \def\normalsize{%
     \@setfontsize\normalsize{11bp}{13.2bp}%
     \abovedisplayskip 11\p@ \@plus3\p@ \@minus6\p@
     \abovedisplayshortskip \z@ \@plus3\p@
     \belowdisplayshortskip 6.5\p@ \@plus3.5\p@ \@minus3\p@
     \belowdisplayskip \abovedisplayskip
     \let\@listi\@listI
   }
   \def\small{%
      \@setfontsize\small{10bp}{12bp}
      \abovedisplayskip 10\p@ \@plus2\p@ \@minus5\p@
      \abovedisplayshortskip \z@ \@plus3\p@
      \belowdisplayshortskip 6\p@ \@plus3\p@ \@minus3\p@
      \def\@listi{\leftmargin\leftmargini
         \topsep 6\p@ \@plus2\p@ \@minus2\p@
         \parsep 3\p@ \@plus2\p@ \@minus\p@
         \itemsep \parsep}%
      \belowdisplayskip \abovedisplayskip
   }
   \def\footnotesize{%
      \@setfontsize\footnotesize{9bp}{11bp}%
      \abovedisplayskip 8\p@ \@plus2\p@ \@minus4\p@
      \abovedisplayshortskip \z@ \@plus\p@
      \belowdisplayshortskip 4\p@ \@plus2\p@ \@minus2\p@
      \def\@listi{\leftmargin\leftmargini
         \topsep 4\p@ \@plus2\p@ \@minus2\p@
         \parsep 2\p@ \@plus\p@ \@minus\p@
         \itemsep \parsep}%
      \belowdisplayskip \abovedisplayskip
   }
   \def\scriptsize{\@setfontsize\scriptsize\@viiipt{9.5}}
   \def\tiny{\@setfontsize\tiny\@vipt\@viipt}
   \def\large{\@setfontsize\large{12bp}{14bp}}
   \def\Large{\@setfontsize\Large{13bp}{16bp}}
   \def\LaRgE{\@setfontsize\LaRgE{14bp}{17bp}}
   \def\LARGE{\@setfontsize\LARGE{16bp}{20bp}}
   \def\huge{\@setfontsize\huge\@xxpt{25}}
   \def\Huge{\@setfontsize\Huge\@xxvpt{30}}
   \normalsize%
\fi
\iffaupress@afive
  \KOMAoption{fontsize}{10pt}
\fi

%% Alignment & style of sectioning commands
\setkomafont{disposition}{\normalfont\bfseries}
% Numbering up to \subsubsection
\setcounter{secnumdepth}{3}
% Command for fixed indentation of the sectioning commands
\newcommand*{\@fausectioning}[1]{\makebox[1.1cm][l]{#1}}
% Alignment of sections
\renewcommand*{\chapterformat}{%
  \@fausectioning{\chapappifchapterprefix{\nobreakspace}\thechapter\autodot}}
\renewcommand*{\sectionformat}{\@fausectioning{\thesection\autodot}}
\renewcommand*{\subsectionformat}{\@fausectioning{\thesubsection\autodot}}
\renewcommand*{\subsubsectionformat}{\@fausectioning{\thesubsubsection\autodot}}
\renewcommand*{\chaptermarkformat}{\@hangfrom{\thechapter\autodot\enskip}}
\renewcommand*{\sectionmarkformat}{\@hangfrom{\thesection\autodot\enskip}}

%% Different style in TOC for \frontmatter & \mainmatter
\newcommand\matter@switch{}
\newcommand*{\fauchaptersize}{}
\newcommand*{\fausectionsize}{}
\addtokomafont{chapterentry}{\matter@switch}
%\addtokomafont{chapter}{}
\g@addto@macro\frontmatter{%
   \immediate\write\@auxout{\noexpand\@writefile{toc}{%
      \noexpand\renewcommand\noexpand\matter@switch{\noexpand\small}}%
   }%
   \renewcommand*{\fauchaptersize}{\LaRgE}%
   \renewcommand*{\fausectionsize}{\large}%
}
\g@addto@macro\mainmatter{%
   \immediate\write\@auxout{\noexpand\@writefile{toc}{%
      \noexpand\renewcommand\noexpand\matter@switch{\noexpand\fontsize{11bp}{11bp}\noexpand\selectfont\noexpand\vspace*{0.2\noexpand\baselineskip}}}}%
   \renewcommand*{\fauchaptersize}{\LARGE}%
   \renewcommand*{\fausectionsize}{\Large}%
   \setcounter{table}{0}%
   \setcounter{figure}{0}%
}
\g@addto@macro\backmatter{%
   \KOMAoptions{open=any}%
   \thispagestyle{empty}%
   Reihenübersicht\\
   wird vom Verlag eingefügt.%
}

%% Create chapter with \appendix command
\newcommand{\appendixmore}{%  KOMA-Script macro
  \addchap{\appendixname}
}

% Custom chapters
\newenvironment{preface}{\chapter*{\prefacename}\label{ch:preface}}{}
\newenvironment{introduction}{\chapter{\introductionname}\label{ch:intro}}{}

\RedeclareSectionCommand[
   afterindent   = false,
   beforeskip    = 0pt,
   afterskip     = 1\baselineskip,
   tocbeforeskip = 0.6\baselineskip,
   font          = \fauchaptersize, %16bp
   %tocentryformat= \chaptertocsize,
]{chapter}
\RedeclareSectionCommand[
   afterindent   = false,
   beforeskip    = 0.75\baselineskip,
   afterskip     = 0.01pt,
   tocbeforeskip = 0.25\baselineskip,
   font 	        = \fausectionsize, %13bp
   %tocentryformat= \sectiontocsize,
]{section}
\RedeclareSectionCommand[
   afterindent   = false,
   beforeskip    = 0.75\baselineskip,
   afterskip     = 0.01pt,
   tocbeforeskip = 0pt,
   font          = \large, %12bp
   %tocentryformat= \sectiontocsize,
]{subsection}
\RedeclareSectionCommand[
afterindent   = false,
beforeskip    = 0.50\baselineskip,
afterskip     = 0.01pt,
tocbeforeskip = 0pt,
font          = \normalsize, %11bp
%tocentryformat= \sectiontocsize,
]{subsubsection}
\RedeclareSectionCommand[
   runin         = true,
   beforeskip    = 0.50\baselineskip,
   afterskip     = 1em,
]{paragraph}
\RedeclareSectionCommand[
   runin         = true,
   beforeskip    = 0.50\baselineskip,
   afterskip     = 1em,
]{subparagraph}
\addtokomafont{pagehead}{\footnotesize}
\addtokomafont{pagefoot}{\footnotesize}
\let\raggedchapterentry\raggedright
\let\raggedsectionentry\raggedright
\renewcommand*\@pnumwidth{2em}

\setlength{\parskip}{0.5\baselineskip}
\setlength{\parindent}{0pt}

% lists

\RequirePackage{enumitem}
\setlist[itemize]{leftmargin=*,itemsep=-.5\baselineskip,parsep=.5\baselineskip}
\setlist[itemize,2]{label=\textbullet}
\setlist[enumerate]{leftmargin=*,itemsep=-.5\baselineskip,parsep=.5\baselineskip}
% counter

\RequirePackage{chngcntr}

\counterwithout{figure}{chapter}
\counterwithout{table}{chapter}
\counterwithout{equation}{chapter}

% footnotes

\usepackage[stable,bottom]{footmisc} % Option stable, so you can use \footnote in sectioning commands

\deffootnote[1em]{0pt}{0pt}{\makebox[1em][l]{\textsuperscript{\thefootnotemark}}}
\setfootnoterule[0.75pt]{52mm}
\renewcommand*\footnoterule{%
   \normalsize\ftn@rule@test@values
   \kern-\dimexpr 3.5\p@+\ftn@rule@height\relax
   \ifx\@textbottom\relax\else\vskip \z@ \@plus.05fil\fi
   {\usekomafont{footnoterule}{%
         \hrule \@height\ftn@rule@height \@width\ftn@rule@width}}%
   \kern 3.5\p@}

% quotations
\newenvironment{fauquote}%
   {\addmargin{0.7cm}\fontsize{11bp}{12.5bp}\selectfont}%
   {\endaddmargin}
% floats

\RequirePackage{float}
\RequirePackage{morefloats}
\RequirePackage{flafter}
\setlength{\@fptop}{0pt}
\setlength{\@fpbot}{0pt plus 1fil}
\floatplacement{figure}{htb}
\floatplacement{table}{htb}

%TODO: Evtl. besser die Möglichkeit von scrbook nutzen
\RequirePackage{caption}
\captionsetup{
  singlelinecheck = false,
  format          = plain,
  font            = footnotesize,
  belowskip       = 0pt,
}

\RequirePackage{subcaption}
\RequirePackage{rotating}

% figures

\RequirePackage{graphicx}
\graphicspath{
  {./graphics/},
  {./figures/},
}
\RequirePackage{wrapfig}

% tables

\RequirePackage{booktabs}
\RequirePackage{tabularx}
\RequirePackage{array}

\newcolumntype{L}[1]{>{\raggedright\let\newline\\\arraybackslash\hspace{0pt}}p{#1}}
\newcolumntype{C}[1]{>{\centering\let\newline\\\arraybackslash\hspace{0pt}}p{#1}}
\newcolumntype{R}[1]{>{\raggedleft\let\newline\\\arraybackslash\hspace{0pt}}p{#1}}
%TODO: Prüfen, ob größer Wert sinnvoll
\renewcommand{\arraystretch}{1.3}

\RequirePackage{multicol}
\RequirePackage{multirow}
\RequirePackage{longtable}
\RequirePackage{tabu}
\RequirePackage{dashrule}

% Thickness of rules in tables
\setlength{\arrayrulewidth}{0.75pt}

% colors

\RequirePackage[table]{xcolor}
% \RequirePackage[faculty = nat]{faucolors}

%TODO: Ist tikz wirklich nötig? Könnte auch per Option oder durch Autor im Bedarfsfall geladen werden
\RequirePackage{tikz}


% URLs

\RequirePackage[hyphens]{url}
\urlstyle{same}

% bibliography

\iffaupress@bibliography

  \RequirePackage[
    style = numeric-comp,
    sorting = none,
    doi = false,
    %url = false,
    isbn = false,
    bibencoding = utf8,
    backend = biber,
    defernumbers = true,
    %giveninits = true,
    maxbibnames = 99,
  ]{biblatex}
  
  \AtBeginBibliography{\renewcommand{\makelabel}[1]{\addfontfeatures{Numbers=Tabular}#1}}
  \DeclareNameAlias{default}{family-given}
  \renewcommand*{\multinamedelim}{\addsemicolon\space}
  \renewbibmacro{in:}{}
  \AtEveryBibitem{%
    \clearfield{note}%
    \clearfield{day}%
  }

  \DeclareFieldFormat{url}{\url{#1}}

  % three files for the different parts of the bibliography
  \addbibresource{./references/bibliography.bib}
  \addbibresource{./references/bibliography-own.bib}
  \addbibresource{./references/bibliography-student.bib}

  % Adds keywords depending on filename
  \DeclareSourcemap{
    %
    \maps[datatype = bibtex, overwrite]{
      %
      \map{
        \perdatasource{./references/bibliography-student.bib}
        \step[fieldset = keywords, fieldvalue = {, student}, append]
      }
      %
      \map{
        \perdatasource{./references/bibliography-own.bib}
        \step[fieldset = keywords, fieldvalue = {, own}, append]
      }
      %
    }
    %
  }

  % Command that prints the bibliography in FAU-press style
  \newcommand*{\faupressprintbibliography}{
    %
    \begingroup
    \renewcommand*{\fauchaptersize}{\LaRgE}
    \renewcommand*{\fausectionsize}{\large}
    \sloppy
    \printbibliography[ title = \Mbibname, heading = bibintoc,
                        notkeyword = student, notkeyword = own ]
    \clearpage
    %
    \newrefcontext[labelprefix = P]
    \printbibliography[ title = \Pbibname, heading = subbibliography,
                        keyword = own, resetnumbers ]
    %
    \clearpage
    \newrefcontext[labelprefix = S]
    \renewcommand{\thefootnote}{\fnsymbol{footnote}}
    \printbibliography[ title = \Sbibname, heading = subbibliography,
                        keyword = student, resetnumbers ]
    %\renewcommand{\thefootnote}{\arabic{footnote}}
    \endgroup
    %
  }

  \renewcommand*{\bibsetup}{%
     \interlinepenalty=9999\relax
     \widowpenalty=10000\relax
     \clubpenalty=10000\relax
     \raggedbottom
     \frenchspacing
     \biburlsetup}
     %\raggedright}

	\biburlbigskip=0mu\relax

\fi

% acronyms

\iffaupress@acronym

  \usepackage{acro}

  \ExplSyntaxOn
  % New faupress template baesd on the table template
  % -> changed the default options
  % -> added beforeinner and afterinner as key-value options
  \DeclareTemplateInterface {acro-list} {faupress} {2}
  {
    table       : tokenlist = longtable,
    table-spec  : tokenlist =
    | L{0.25\textwidth} | L{0.75\textwidth-\columnsep}|,
    % Version without ugly vertical lines
    % @{}L{0.25\textwidth}@{\hspace{\columnsep}}L{0.75\textwidth-\columnsep}@{} ,
    foreign-sep : tokenlist = {~} ,
    reverse     : boolean   = false ,
    before      : tokenlist = ,
    after       : tokenlist = ,
    beforeinner : tokenlist = ,  %%% ADDED
    afterinner  : tokenlist =    %%% ADDED
  }

  \DeclareTemplateCode {acro-list} {faupress} {2}
  {
    table       = \l__acro_list_table_tl      ,
    table-spec  = \l__acro_list_table_spec_tl ,
    foreign-sep = \l__acro_foreign_sep_tl ,
    reverse     = \l__acro_list_reverse_long_extra_bool ,
    before      = \l__acro_list_before_tl ,
    after       = \l__acro_list_after_tl ,
    beforeinner = \l__acro_list_beforeinner_tl ,   %%% ADDED
    afterinner  = \l__acro_list_afterinner_tl      %%% ADDED
  }
  {
    \AssignTemplateKeys
    \acro_activate_hyperref_support:
    \bool_if:NTF \l__acro_list_reverse_long_extra_bool
    {
      \cs_set_protected:Npn \acro_print_list_entry:nnnn ##1##2##3##4
      { ##1 & ##3 ##2 ##4 \tabularnewline }
    }
    {
      \cs_set_protected:Npn \acro_print_list_entry:nnnn ##1##2##3##4
      { ##1 & ##2 ##3 ##4 \tabularnewline }
    }
    \acro_build_list_entries:Nnn \l__acro_list_entries_tl {#1} {#2}
    \use:x
    {
      \exp_not:V \l__acro_list_before_tl
      \exp_not:N \begin { \exp_not:V \l__acro_list_table_tl }
        { \exp_not:V \l__acro_list_table_spec_tl }
        \exp_not:V \l__acro_list_beforeinner_tl %%% ADDED
        \exp_not:V \l__acro_list_entries_tl
        \exp_not:V \l__acro_list_afterinner_tl  %%% ADDED
        \exp_not:N \end { \exp_not:V \l__acro_list_table_tl }
      \exp_not:V \l__acro_list_after_tl
    }
  }

  % New faupress template baesd on the table-extra template
  % -> changed the default options
  % -> added beforeinner and afterinner as key-value options
  % -> page number is not in a separate column, but gets append to the description column

  \DeclareTemplateInterface {acro-list} {faupress-extra} {2}
  {
    table       : tokenlist = longtable,
    table-spec  : tokenlist =
    |L{0.15\textwidth} | L{0.15\textwidth} | L{0.7\textwidth-2.25\columnsep}|,
    % Version of the table without ugly vertical lines
    % @{}L{0.15\textwidth}@{\hspace{\columnsep}}L{0.15\textwidth}@{\hspace{\columnsep}}L{0.7\textwidth-2\columnsep}@{},
    foreign-sep : tokenlist = {~} ,
    reverse     : boolean   = true ,
    before      : tokenlist = ,
    after       : tokenlist = ,
    beforeinner : tokenlist = ,  %%% ADDED
    afterinner  : tokenlist =    %%% ADDED
  }

  \DeclareTemplateCode {acro-list} {faupress-extra} {2}
  {
    table       = \l__acro_list_table_tl      ,
    table-spec  = \l__acro_list_table_spec_tl ,
    foreign-sep = \l__acro_foreign_sep_tl ,
    reverse     = \l__acro_list_reverse_long_extra_bool ,
    before      = \l__acro_list_before_tl ,
    after       = \l__acro_list_after_tl,
    beforeinner = \l__acro_list_beforeinner_tl ,   %%% ADDED
    afterinner  = \l__acro_list_afterinner_tl      %%% ADDED
  }
  {
    \AssignTemplateKeys
    \acro_activate_hyperref_support:
    \bool_if:NTF \l__acro_list_reverse_long_extra_bool
    {
      \cs_set_protected:Npn \acro_print_list_entry:nnnn ##1##2##3##4
      { ##1 & ##3 & ##2 ##4 \tabularnewline }
    }
    {
      \cs_set_protected:Npn \acro_print_list_entry:nnnn ##1##2##3##4
      { ##1 & ##2 & ##3 ##4 \tabularnewline }
    }
    \acro_build_list_entries:Nnn \l__acro_list_entries_tl {#1} {#2}
    \use:x
    {
      \exp_not:V \l__acro_list_before_tl
      \exp_not:N \begin { \exp_not:V \l__acro_list_table_tl }
        { \exp_not:V \l__acro_list_table_spec_tl }
        \exp_not:V \l__acro_list_beforeinner_tl %%% ADDED
        \exp_not:V \l__acro_list_entries_tl
        \exp_not:V \l__acro_list_afterinner_tl  %%% ADDED
        \exp_not:N \end { \exp_not:V \l__acro_list_table_tl }
      \exp_not:V \l__acro_list_after_tl
    }
  }
  \ExplSyntaxOff

  % We need to define at least one new list style using the new Templates
  \DeclareAcroListStyle{faupress}{faupress}{
    beforeinner = \toprule \textbf{\abbrname} & \textbf{\descriptionname} \\\midrule\endhead
    \bottomrule\endfoot
  }
  \DeclareAcroListStyle{faupress-extra}{faupress-extra}{
    beforeinner = \toprule \textbf{Symbol} & \textbf{\unitname} &
    \textbf{\descriptionname} \\\midrule\endhead
    \bottomrule\endfoot
  }
  % Extra style for units
  \DeclareAcroExtraStyle{faupress}{inline}{
    brackets = false,
    punct = false
  }

  % Formatting of the acronyms
  \acsetup{hyperref, only-used = false}

  \iffaupress@splitacronym

    \newcommand*{\faupressprintacronyms}[1][]{
      \addchap{\acroname}
      \label{faupressacronyms}
        \acsetup{list-style = faupress, list-heading = section*}
        \printacronyms[name = \listabbrname, exclude-classes = formula, #1]
        \acsetup{list-style = faupress-extra, extra-style = faupress}
        \printacronyms[name = \listformulaname, include-classes=
        formula, #1]
      \cleardoublepage
      \setcounter{table}{0}
    }

  \fi

  \iffaupress@combinedacronym

    \newcommand*{\faupressprintacronyms}[1][]{
      \acsetup{list-style=faupress-extra, extra-style = faupress, list-heading =
      addchap}
      \printacronyms[name = \acroname, #1]
      \cleardoublepage
      \setcounter{table}{0}
    }

  \fi

  \iffaupress@abbreviation

    \newcommand*{\faupressprintacronyms}[1][]{
      \acsetup{list-style=faupress-extra, extra-style = faupress, list-heading =
      addchap}
      \printacronyms[name = \listabbrname, exclude-classes = formula, #1]
      \cleardoublepage
      \setcounter{table}{0}
    }

  \fi

  \iffaupress@symbol

    \newcommand*{\faupressprintacronyms}[1][]{
      \acsetup{list-style=faupress-extra, extra-style = faupress, list-heading =
      addchap}
      \printacronyms[name = \listformulaname, include-classes = formula, #1]
      \cleardoublepage
      \setcounter{table}{0}
    }

  \fi

\fi

%   hyperlinks

\RequirePackage{hyperref}
  \hypersetup{
    linktoc = all,
    hidelinks
  }
\RequirePackage{bookmark}

% Titlepages

% New fields and komafonts for the titlepages
\setkomafont{author}{\bfseries\sffamily\LARGE}
\newcommand{\@firstname}{}
\newcommand{\firstname}[1]{\gdef\@firstname{#1}}
\newcommand{\@lastname}{}
\newcommand{\lastname}[1]{\gdef\@lastname{#1}}
\newcommand{\@degree}{}
\newif\if@degreefirst
\def\degree{\@ifstar{\global\@degreefirstfalse\@@degree}{\global\@degreefirsttrue\@@degree}}
\newcommand{\@@degree}[1]{\gdef\@degree{#1}}
\newcommand{\@origin}{}
\newcommand{\origin}[1]{\gdef\@origin{#1}}

\setkomafont{title}{\bfseries\sffamily\Huge}
\setkomafont{subtitle}{\bfseries\sffamily\LARGE}
\newcommand{\@yearofpublication}{}
\newcommand{\yearofpublication}[1]{\gdef\@yearofpublication{#1}}

\newcommand{\@supervisor}{}
\newcommand{\supervisor}[1]{\gdef\@supervisor{#1}}
\newkomafont{supervisor}{\sffamily\normalsize}
\newkomafont{facultytitle}{\Large\bfseries}
\newkomafont{faculty}{\Large\normalfont}
\newcommand{\@oralexam}{}
\newcommand{\oralexam}[1]{\gdef\@oralexam{#1}}
\newcommand{\@dean}{}
\newcommand{\dean}[1]{\gdef\@dean{#1}}
\newcommand{\@reviewer}{}
\newcommand{\reviewer}[1]{\gdef\@reviewer{#1}}
\newcommand{\@institute}{}
\newcommand{\institute}[1]{\gdef\@institute{#1}}
\newkomafont{institute}{\sffamily\normalsize}

\newcommand{\@series}{}
\newcommand{\series}[1]{\gdef\@series{#1}}
\newcommand{\@volume}{}
\newcommand{\volume}[1]{\gdef\@volume{#1}}
\newcommand{\@printinformation}{}
\newcommand{\printinformation}[1]{\gdef\@printinformation{#1}}
\newcommand{\@doi}{}
\newcommand{\doi}[1]{\gdef\@doi{#1}}
\newcommand{\@isbn}{}
\newcommand{\isbn}[1]{\gdef\@isbn{#1}}
\newcommand{\@eisbn}{}
\newcommand{\eisbn}[1]{\gdef\@eisbn{#1}}
\newcommand{\@issn}{}
\newcommand{\issn}[1]{\gdef\@issn{#1}}

% Check if argument ends with a period. If it does do nothing,
% if it does not add a period. (uses \IfEndWith from xstring)
\newcommand{\@addperiod}[1]{
  \IfEndWith{#1}{.}{#1}{#1.\@}
}

% Ignores linebreaks in the local group it is used in
% by relaxing the common commands \\,\newline,\linebreak

\newcommand{\@ignorelinebreaks}{
  \def\newline{\relax\ifhmode\unskip\fi\space\ignorespaces}
  \def\\{\relax\ifhmode\unskip\fi\space\ignorespaces}
  \def\linebreak{\relax\ifhmode\unskip\fi\space\ignorespaces}
}

% Titlepage of the publisher
\addtokomafont{title}{\hyphenpenalty=10000}
\renewcommand{\maketitle}{%
  % Add 2 empty pages before the title page
  \newpage\null\thispagestyle{empty}
  \newpage\null\thispagestyle{empty}
  \begin{titlepage}
    \setlength{\parindent}{\z@}
    \setlength{\parskip}{\z@}
    \typeout{Typesetting the titlepage!}
    {\raggedright\usekomafont{author} \@firstname\ \@lastname\par}
    \vspace{1em}
    \begin{minipage}[t]{\textwidth}
      \@ignorelinebreaks
      \RaggedRight
      {\usekomafont{title} \@title\par}
      \vspace{1.5em}
      {\usekomafont{subtitle} \@subtitle\par}
    \end{minipage}\par
    \vfill
    \begin{minipage}[t]{\textwidth}
      \RaggedRight
      \usekomafont{institute} \@institute \\
      \usekomafont{supervisor} \@supervisor\par
    \end{minipage}\par
    \vspace{8em}
    {\sffamily\LARGE Erlangen \\
      FAU University Press \\
      \@yearofpublication \par}
    \vskip2em
    \next@tpage
    Bibliografische Information der Deutschen Nationalbibliothek: \\
    Die Deutsche Nationalbibliothek verzeichnet diese Publikation in der
    Deutschen Nationalbibliografie; detaillierte bibliografische Daten sind
    im Internet über \href{http://dnb.d-nb.de}{http://dnb.d-nb.de} abrufbar.\par
    \vspace{2em}
    Bitte zitieren als\\
    {\@ignorelinebreaks
    \@lastname, \@addperiod{\@firstname} \@addperiod{\@yearofpublication} {\itshape\@addperiod{\@title}}
    \ifx\@subtitle\@empty \else {\itshape\@addperiod{\@subtitle}} \fi
    \@series \@addperiod{\@volume} Erlangen: FAU University Press. DOI:~\href{http://dx.doi.org/\@doi}{\@doi}.\par}
    \vspace{2em}
    Das Werk, einschließlich seiner Teile, ist urheberrechtlich geschützt.\\
    Die Rechte an allen Inhalten liegen bei ihren jeweiligen Autoren.
    Sie sind nutzbar unter der Creative Commons Lizenz BY-NC.\par
    \vspace{2em}
    Der vollständige Inhalt des Buchs ist als PDF über den OPUS Server
    der Friedrich-Alexander-Universität Erlangen-Nürnberg abrufbar:\\
    \href{https://opus4.kobv.de/opus4-fau/home}{https://opus4.kobv.de/opus4-fau/home}\par
    \vspace{4em}
    Verlag und Auslieferung:\\
    FAU University Press, Universitätsstraße 4, 91054 Erlangen\par
    \vfill
    \@printinformation\par
    \vfill
    \begin{tabular}{@{}l l}
      ISBN: & \@isbn\ (Druckausgabe) \\
      eISBN: & \@eisbn\ (Online-Ausgabe) \\
      ISSN: & \@issn \\
      DOI: & \@doi
    \end{tabular}
  \end{titlepage}%
}
% Titlepage of the faculty %%% BIS JETZT NUR FUER TECHFAK
\newcommand{\makefacultytitle}{
  \begin{titlepage}
    \setlength{\parindent}{\z@}
    \setlength{\parskip}{\z@}
    \onehalfspacing
    \typeout{Typesetting the faculty titlepage!}
    \centering
    \vspace*{4.8mm}
    {\usekomafont{facultytitle} \@title\par}
    \vfill
    {\usekomafont{faculty}
      Der Technischen Fakultät \\
      der Friedrich-Alexander-Universität\\
      Erlangen-Nürnberg \par}
    \vspace{6mm}
    {\usekomafont{faculty}
      zur \\
      Erlangung des Doktorgrades Dr.-Ing.\par}
    \vspace{34mm}
    {\usekomafont{faculty} vorgelegt von \par}
      \vspace{6.2mm}
    {\usekomafont{faculty}
     \if@degreefirst
      \@degree\ \@firstname\ \@lastname%
     \else 
      \@firstname\ \@lastname,\ \@degree%
     \fi%
    \par}
      \vspace{6.2mm}
    {\usekomafont{faculty} aus \@origin \par}
    \vskip38mm
    \next@tpage
    \raggedright
    \normalfont\normalsize
    \phantom{M}\vfill
    { Als Dissertation genehmigt \\
      von der Technischen Fakultät \\
      der Friedrich-Alexander-Universität Erlangen-Nürnberg\par}
    \vspace{16mm}
    \begin{tabular}{@{}l l}
      \parbox[b]{20ex}{Tag der mündlichen \newline Prüfung:} & \@oralexam\\[1.25em]
      \parbox[b]{20ex}{Vorsitzender des \newline Promotionsorgans:} & \parbox[t]{0.6\textwidth}{\raggedright\@dean}\\[0.5em]
      Gutachter: & \parbox[t]{0.6\textwidth}{\raggedright\@reviewer}
    \end{tabular}
    \vskip18mm
  \end{titlepage}
}

% Supress widows and orphans
\clubpenalty = 10000
\widowpenalty = 10000
\displaywidowpenalty = 10000
% Allow ragged page bottoms
\raggedbottom

\tolerance 1414
\hbadness 1414
\emergencystretch 1.5em
\hfuzz 0.3pt
\interfootnotelinepenalty=10000
\brokenpenalty=9999
\vfuzz \hfuzz
