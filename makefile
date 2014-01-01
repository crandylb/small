# makefile -- for small directory, CRB, Oct 19, 2012
# added testlex, CRB, Sep 19, 2013
# testsio.s1, CRB, Dec 15, 2013

#--------------- Test SMALL I/O in SMALL

smallio.o:	smallio.c grandios.h
	gcc -c -m32 -g smallio.c -o smallio.o

testsio.mill:	testsio.s1 small.s2m
	stg2 small.s2m <testsio.s1 - testsio.mill testsio.lss

testsio.asm:	testsio.mill mill2yasm.s2m
	stg2 mill2yasm.s2m <testsio.mill - testsio.asm

testsio.o:	testsio.asm
	yasm testsio.asm -w -g stabs -l testsio.lst -f elf32 -o testsio.o

testsio:	testsio.o grandios.dbug.o smallio.o
	gcc -m32 grandios.dbug.o smallio.o testsio.o -g -o testsio

lex.mill:	LEX.S1 small.s2m
	stg2 small.s2m <LEX.S1 - lex.mill lex.lss

lex.asm:	lex.mill mill2yasm.s2m
	stg2 mill2yasm.s2m <lex.mill - lex.asm

lex.o:		lex.asm
	yasm lex.asm -w -g stabs -l lex.lst -f elf32 -o lex.o

testlex.mill:	testlex.s1 small.s2m
	stg2 small.s2m <testlex.s1 - testlex.mill testlex.lss

testlex.asm:	testlex.mill mill2yasm.s2m
	stg2 mill2yasm.s2m <testlex.mill - testlex.asm

testlex.o:	testlex.asm
	yasm testlex.asm -w -g stabs -l testlex.lst -f elf32 -o testlex.o

testlex:	testlex.o lex.o ../grandios/grandios.dbug.o smallio.o
	gcc -g -m32 ../grandios/grandios.dbug.o smallio.o testlex.o lex.o -o testlex
