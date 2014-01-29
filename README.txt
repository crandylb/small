README.txt -- small directory contains language Small, CRB, Jan 6, 2014
01/27/2014 CRB Add SmallPocketGuide
01/29/2014 CRB Add testlex

The purpose of this directory is to contain files presenting my language
Small.

Contents of this directory:
README.txt  	 this file
README.md	 the README required by GitHub
intro.txt	 introduction to Small, what this project is about
LICENSE		 GPLv2 license for original material in this directory
small.s2m	 Stage 2 macros that translate Small to Mill
mill2yasm.s2m	 Stage 2 macros that translate Mill to yasm assembler
smallio.c	 a C program to interface Small I/O to grandios
makefile	 a make file to compile smallio.c to smallio.o for Small
thesis.pdf	 a reproduction of my 1982 masters thesis on Small
Test Programs:	 Directories containing test programs written in Small
  testcat	 testing the CAT2 program in Small
  testfact	 testing the recursive factorial program FACT in Small
  testnio	 testing integer I/O, IREAD and IFORM in Small
  testlex        testing LEX lexical scanner
SmallPocketGuide.odt A brief summary of Small and Mill for handy
		 reference
SmallPocketGuide.pdf This version may be easier to print in landscape

README.txt
Describes the contents of this directory.

intro.txt
An introduction giving history and background on Small, how it came about, and
what this currect project is all about.

LICENSE
The General Public License, aka the Gnu Public Lincense, is the license
covering the original material created by me presented in this directory.

small.s2m
The Stage 2 macros in this file translate a program written in Small to the
Mill, machine independent low level language. Mill is intended to be easily
mapped into an actual assembly language by a second pass using Stage 2. See
thesis for information on Mill, and the test directories for makefile to
comiple and run Small programs.

mill2yasm.s2m
This set of macros translate Mill to yasm, an x86 assembler used here to
create a 32-bit implementation of Small for x86, i.e. Intel and AMD processors
using the 32-bit 386/486 and beyond instruction sets. For mor details see the
implementation notes.

smallio.c
This C program interfaces I/O in Small to the conventions used in the grandios
module, the I/O system used in the implementation of Stage 2.

thesis.pdf
This is a reporoduction of my masters thesis that was originally written on
an early personal computer and formatted by Small Runoff, a text formatter
written in Small, and printed from the computer on an electronically
controlled IBM Selectric typewriter.

testcat
This directory illustrates compiling and testing the Small CAT2 program on
page 103 of the thesis reproduction.

testfact
This directory illustrates compiling and testing the Small FACT program on
page 32 of thesis. The program prompts for a number less that 12, then
calculates the factorial recursively and prints the result. This test program
also tests the IFORM and IREAD Small programs from pages 104 and 105 of
thesis.

testnio
This directory illustrates compiling and testing the Small programs IFORM and
IREAD from pages 104 and 105 of thesis.

testlex
This directory tests a version of the LEX lexical scanner described in Chapter
6 of my thesis. The scanner is implemented as a finite state automaton using a
two-dimensional array. Since Small only supports one-dimensional arrays the 2D
array is represented by concatenated 1D arrays. Each call to LEX returns a
KIND code, 1 for a name (identifier), 2 for an integer, 3 for a quoted string
of characters, and 5 for any other individual special character.

SmallPocketGuide.odt and .pdf
This quick reference guide contains a summary of Small and Mill, including
character set, statements and declarations, procedures and functions,
expressions and operators, and directives. Also Mill instructions and
pseudo-operations.  The .pdf form may be easier to print in landscape mode.

to be continued...
