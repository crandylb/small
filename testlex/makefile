# makefile -- test lexical scan, CRB, Jan 1, 2014
# CRB 03/29/2014 using cat3 instead of cat2
# CRB 04/15/2014 lex now using symacc
# CRB 05/23/2014 for github/small/testlex

testlex.mill:	testlex.s1 ../small.s2m
	stg2 ../small.s2m <testlex.s1 - testlex.mill testlex.lss

testlex.asm:	testlex.mill ../mill2yasm.s2m
	stg2 ../mill2yasm.s2m <testlex.mill - testlex.asm

testlex.o:	testlex.asm
	yasm testlex.asm -w -l testlex.lst -f elf32 -o testlex.o

testlex:	testlex.o lex.o ../lib/s1.a ../symacc/symacc.o
	gcc -m32 testlex.o lex.o -L../lib -ls1 ../symacc/symacc.o -o testlex

lex.mill:	lex.s1 ../small.s2m
	stg2 ../small.s2m <lex.s1 - lex.mill lex.lss

lex.asm:	lex.mill ../mill2yasm.s2m
	stg2 ../mill2yasm.s2m <lex.mill - lex.asm

lex.o:	lex.asm
	yasm lex.asm -w -l lex.lst -f elf32 -o lex.o

clean:
	rm *.mill *.lss *.asm *.o testlex
