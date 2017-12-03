% Identification

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{csl}[2017/01/06 Classe LaTeX pour le MTI du CSL]

%Not verbose
\errorstopmode
\batchmode

% Classe de base
\LoadClass[12pt,letterpaper]{article}

% Packages
\RequirePackage[letterpaper,headheight=15pt,top=3.5cm,left=3.5cm,bottom=2.5cm,right=2.5cm]{geometry}
\RequirePackage[french]{babel}
\RequirePackage{setspace}
\RequirePackage{graphicx}
\RequirePackage{fancyhdr}
\RequirePackage[explicit,compact]{titlesec}
\RequirePackage[normalem]{ulem}
\RequirePackage{titletoc}
\RequirePackage{totcount}
%\RequirePackage{biblatex}
\RequirePackage{csquotes}
\RequirePackage{fontspec}
\RequirePackage{xstring}
\RequirePackage[hang]{footmisc}

% Fonctions préliminaires

\errorcontextlines 10000

\setmainfont[Ligatures=TeX]{TeX Gyre Termes}

\makeatletter
\onehalfspacing
\let\auteur\author

\newcommand{\prof}[1]{
 \wlog{professeur : #1}
 \def\@prof{#1}
}

\newcommand{\classe}[2]{
 \wlog{classe : #2 gr. #1}
 \def\@classe{#2 gr. #1}
}

\newcommand{\classeTitulaire}[1]{
  \def\@titulaire{#1}
}

\newcommand{\nouvelleClasse}[4][\@titulaire]{
  \wlog{#2;#3;#1;#4}
  \DeclareOption{#2}{\prof{#3}\classe{#1}{#4}}
}

\newcommand{\type}[1]{
  \def\@type{#1}
}

\input{csl.cfg}
\ProcessOptions\relax

\AtBeginDocument{\scrollmode}

% Définition de la classe

\pagestyle{fancy}
\fancyhf{}
\rhead{\thepage}
\setlength\parindent{4em}

\makeatletter

%Vars

\newcounter{annexe}

% fonctions

\newcommand{\titre}[2][]{
  \def\@titre{#2}
  \def\@soustitre{#1}
}

\newcommand{\remise}[1]{
  \def\@remise{#1}
}

\newenvironment{metasection}[2][]{
 \begin{metasection*}[#1]{#2}
 \addcontentsline{toc}{subsection}{\textsc{#2}}
}
{
 \end{metasection*}
}

\newenvironment{metasection*}[2][]{
 \newpage
 \newgeometry{top=5cm}
 {\centering\textsc{#2}~\\~\\}
}
{
 \restoregeometry
 \newpage
}

\pagenumbering{arabic}

\newcommand{\pagetitre}{
  \thispagestyle{empty}
  \newgeometry{top=5cm,bottom=1.5cm}
  \begin{center}
   \begin{spacing}{1.0}
    \MakeUppercase{\@titre}~\\
    \MakeLowercase{\@soustitre}
    ~\\[10\baselineskip]
    \@type\\
    présenté à\\
    \@prof
    \\[10\baselineskip]
    par\\
    \@author\\
    \@classe
    \\[10\baselineskip]
    Collège St-Louis\\
    \@remise
   \end{spacing}
  \end{center}
  \restoregeometry
  \newpage
  \setcounter{page}{1}
}

\renewcommand{\contentsname}{Table des Matières}
\dottedcontents{section}[0em]{\bfseries}{1.9em}{1em}
\dottedcontents{subsection}[0em]{}{2.3em}{1em}

\newcommand{\tdm}{
  \begingroup
  \renewcommand{\headrulewidth}{0pt}
  \begin{metasection*}{\contentsname}
   \@starttoc{toc}
  \end{metasection*}
  \fancyhf{}
  \rhead{ii}
  \endgroup
  \setcounter{page}{1}
}

\newenvironment{intro}{
  \newtotcounter{textpages}
  \setcounter{textpages}{\value{page}}
  \ifnum\totvalue{textpages}>8
    \thispagestyle{empty}
    \begin{metasection}{Introduction}
  \fi
}
{
  \ifnum\totvalue{textpages}>8
    \end{metasection}
  \fi
}


\titleformat{\section}
  {\normalsize\bfseries}{}{.25em}{\thesection\quad#1}

\titlespacing{\section}{0mm}{4.5ex}{3ex}
 
\titleformat{\subsection}
  {\normalfont}{}{.25em}{\uline{\thesubsection\ #1}}

\titlespacing{\subsection}{0mm}{3ex}{1.5ex}

\let\soussection\subsection

\newenvironment{conclusion}{
  \setcounter{textpages}{\value{page}}
  \ifnum\totvalue{textpages}>8
    \begin{metasection}{Conclusion}
  \else
    ~\\~\\
  \fi
}
{
  \ifnum\totvalue{textpages}>8
    \end{metasection}
  \fi
}

\newcommand{\printbiblio}{
\batchmode %silence output
\printbibliography[type=book,title={Livres}]
\printbibliography[type=inbook,title={Articles de livre ou d'encyclopédie}
\printbibliography[type=article,title={Articles de périodique}
\printbibliography[type=online,title={Site Internet}
\printbibliography[type=video,title={Document audiovisuel}]
\printbibliography[type=movie,title={Émissions de télévision}]
\printbibliography[type=audio,title={Article de cédérom}]
\printbibliography[type=commentary,title={Entrevue}]
\scrollmode
}

\newcommand{\biblio}{
  \begin{metasection}{Bibliographie}
    \bgroup
      \leftskip 4em
      \parindent -4em
      \begin{spacing}{1.0}
	\printbiblio
      \end{spacing}
    \egroup
  \end{metasection}
}

\def\changemargin#1{\list{}{\rightmargin#1\leftmargin#1}\item[]}
\let\endchangemargin=\endlist

\newcommand*{\rom}[1]{\expandafter\@slowromancap\romannumeral #1@}

\newcommand{\refAnn}[1]{
  \footnote{Voir \textsc{Annexe} \rom{#1} à la page 42}
}

\renewcommand{\cite}{\footnote}%footcite

\renewcommand{\citation}[1]{
  \newsavebox{\@citebox}
  \savebox{\@citebox}{#1}
  \ifdim \wd\@citebox >3\hsize
     \begin{changemargin}{0.1\textwidth}
     \parindent 0pt
     \begin{spacing}{1.0}
     #1
     \end{spacing}
     \end{changemargin}
  \else
     \og #1 \fg
  \fi
}

\newcommand{\fichierbiblio}{\bibliography}

\newenvironment{annexe}[1][]{
  \stepcounter{annexe}
  \begin{metasection}{Annexe \Roman{annexe}}
  \begin{spacing}{1.0}
  \begin{center}
    \textbf{#1}~\\~\\
  \end{center}
}
{
  \end{spacing}
  \end{metasection}
  \newpage
}

\newcommand{\pagedegarde}[1][{Nombre de mots:http://app.uio.no/ifi/texcount/online.php}]{
  \newpage
  \fancyhf{}
  \rfoot{#1}
  \newpage
  \mbox{}
}

\nocite{*}

\makeatother
