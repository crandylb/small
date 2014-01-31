# makefile -- test lexical scan, CRB, Jan 1, 2014

testlex.mill:	testlex.s1 ../small.s2m
	stg2 ../small.s2m <testlex.s1 - testlex.mill testlex.lss

testlex.asm:	testlex.mill ../mill2yasm.s2m
	stg2 ../mill2yasm.s2m <testlex.mill - testlex.asm

testlex.o:	testlex.asm
	yasm testlex.asm -w -g stabs -l testlex.lst -f elf32 -o testlex.o

testlex:	testlex.o lex.o ../cat2.o
	gcc -m32 ../grandios.dbug.o ../smallio.o testlex.o lex.o ../cat2.o -g -o testlex

lex.mill:	lex.s1 ../small.s2m
	stg2 ../small.s2m <lex.s1 - lex.mill lex.lss

lex.asm:	lex.mill ../mill2yasm.s2m
	stg2 ../mill2yasm.s2m <lex.mill - lex.asm

lex.o:	lex.asm
	yasm lex.asm -w -g stabs -l lex.lst -f elf32 -o lex.o

iform.mill:	iform.s1 ../small.s2m
	stg2 ../small.s2m <iform.s1 - iform.mill iform.lss

iform.asm:	iform.mill ../mill2yasm.s2m
	stg2 ../mill2yasm.s2m <iform.mill - iform.asm

iform.o:	iform.asm
	yasm iform.asm -w -g stabs -l iform.lst -f elf32 -o iform.o

iread.mill:	iread.s1 ../small.s2m
	stg2 ../small.s2m <iread.s1 - iread.mill iread.lss

iread.asm:	iread.mill ../mill2yasm.s2m
	stg2 ../mill2yasm.s2m <iread.mill - iread.asm

iread.o:	iread.asm
	yasm iread.asm -w -g stabs -l iread.lst -f elf32 -o iread.o

clean:
	rm *.mill *.lss *.asm *.o testlex