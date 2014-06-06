README.txt -- small directory contains language Small, CRB, Jan 6, 2014
01/27/2014 CRB Add SmallPocketGuide
01/29/2014 CRB Add testlex
02/01/2014 CRB Add testcase
02/26/2014 CRB Add lib
03/01/2014 CRB Add scan
03/02/2014 CRB Add symacc
03/16/2014 CRB Update symacc, initsym, and initable.dat
03/20/2014 CRB Minor updates to symacc and initsym
05/18/2014 CRB Add cat3 and libsrc
05/23/2014 CRB Update mill2yasm, testlex, and symacc
06/04/2014 CRB Move testinit to own module
06/05/2014 CRB Add runoff subdirectory

The purpose of this directory is to contain files presenting my language
Small.

Contents of this directory:
README.txt       this file
README.md        the README required by GitHub
intro.txt        introduction to Small, what this project is about
LICENSE	         GPLv2 license for original material in this directory
small.s2m        Stage 2 macros that translate Small to Mill
mill2yasm.s2m    Stage 2 macros that translate Mill to yasm assembler
smallio.c        a C program to interface Small I/O to grandios
makefile         a make file to compile smallio.c to smallio.o for Small
thesis.pdf       a reproduction of my 1982 masters thesis on Small
Test Programs:   Directories containing test programs written in Small
  testcat        testing the CAT2 program in Small
  testfact       testing the recursive factorial program FACT in Small
  testnio        testing integer I/O, IREAD and IFORM in Small
  testlex        testing LEX lexical scanner
  testcase       testing CASE statement
  scan           testing prescan with libs1 and lex
lib              a library for Small programs
libsrc		 source files for lib
symacc           symbol table access module
runoff	         paper and listings for 1981 Small Runoff 
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
This set of macros translates Mill to yasm, an x86 assembler used here to
create a 32-bit implementation of Small for x86, i.e. Intel and AMD processors
using the 32-bit 386/486 and beyond instruction sets. For more details see the
implementation notes.
Update 05/23/2014 Added ". ARGT D" macro to transfer a formal parameter used
as an actual parameter in anothed procedure call. This still needs work to be
able to handle more that one such eaxample in a single call.

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
of characters, and 4 for any other individual special character.

Update 05/23/2014 Modified to work with symacc as a compiler/interpreter
module. Alphanumeric tokens are looked up using symacc and properties are
returned in the LEXEME array. Numeric tokens are evaluated as scanned and
value returned in LEXEME(1).

testcase
This directory tests the CASE statement. The case label list is zero indexed
by the value of the case expression. Each case skips to the end of the case
statement on completion.

scan
This directory tests a form of scan that skips comments and process all other
input through lex, the lexical scanner (see testlex). The output file scan.out
shows the result of processing the scan.s1 source file. See the makefile for
an example of using the libs1.a library.

lib
This directory contains libs1.a, a library for Small programs. The library
contains the grandios.o, smallio.o, cat2.o, iform.o, and iread.o object
modules. The makefile shows how the library is made using ar. The library is
used by gcc with -L defining the path to the library, and -ls1 to link any
needed modules. Note that only "s1" is given to the -l option, and "lib" and
".a" will be assumed automatically.

libsrc
This directory contains the source files written in Small for the s1 library
in the lib subdirectory, except for grandios and smallio which contain source
files written in C in their own subdirectories.

symacc
This directory contains an implementation of the symbol table access module,
SYMACC, as outlined in pages 60-66 of thesis. Some changes have been made to
accomodate the 32-bit implementation. A symbol is stored in two 32-bit words,
with six characters packed into the first (even indexed) word using base 40
compression, and the VAL and TAG fields packed into the next (odd indexed)
word. The table is addressed by a hash derived from the packed base 40
name. The table size, 8191, is a Mersenne prime number that provides space for
4,000 symbols in 32k bytes of memory. Collisions are resolved on insertion by
sequential search for the next empty slot, with wraparound until the table is
full. The result is a single namespace with a unique index for every
symbol. The table is initialized with keywords and operators by the initsym
module, where single character operators use their ASCII codes instead of a
base 40 encoding. The n bit (bit 4) of the TAGS field (previously unused) is
set to 1 for these character entries in the table. Use:
    make test
to run the initsym test, where the initable.dat file is read on channel 2, and
the output initsym.out on channel 3 shows each initialized keyword and
operator with its VAL (a unique number for each keyword and operator) and TAG
field (packed TAGS and TYPE).

Update (03/16/14) adds a collision counter to symacc.s1, and token KIND codes
to distinguish keywords, operators, and punctuation characters. Also ATTR
attribute bits for operators. This is intended to aid parsing of tokens. Some
of this may be overkill and more documentation is needed to clarify details.
Update (03/20/2014) minor updates to symacc and initsym. Moved initialization
of MASKV from symacc.s1 to initsym.s1, other typo corrections.

Update 05/23/2014 Modified to work with lex as a compiler/interpreter
module. Input tokens are scanned using lex and properties are eturned in a
LEXEME array for parsing and any other further evaluation. This module also
includes an initialization phase to predefine keywords and alphabetic
operators. 

Update 06/04/2014 Move testinit to own module
The initsym module has been separated into two separate modules: testinit and
initsym so that initsym can be used as symbol table initialization as part of
the Small compiler/interpreter without an embedded test program. In other
words, the test program driver is now moved into its own testinit module. The
makefile has been modified accordingly so that:
     make testinit
builds the initialization test program, and:
     make test
runs the test and generates the initsym.out file to verify the
initialization. 

runoff
This subdirectory contains the 1981 version of Small Runoff, the program used
to format my 1982 thesis describing Small. The file smallrunoffpaper.pdf is a
paper originally by Joe Felsenstein that describes the Runoff program. The
version of the paper here was rewritten by me to describe the version of the
program written in Small.

SmallPocketGuide.odt and .pdf
This quick reference guide contains a summary of Small and Mill, including
character set, statements and declarations, procedures and functions,
expressions and operators, and directives. Also Mill instructions and
pseudo-operations.  The .pdf form may be easier to print in landscape mode.

to be continued...
