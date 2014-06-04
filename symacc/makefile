# makefile -- for symacc directory, CRB, Mar 2, 2014
# 05/26/2014 CRB remove testinit to separate module

testacc.mill:   testacc.s1 ../small.s2m
	stg2 ../small.s2m <testacc.s1 - testacc.mill testacc.lss

testacc.asm:    testacc.mill ../mill2yasm.s2m
	stg2 ../mill2yasm.s2m <testacc.mill - testacc.asm

testacc.o:      testacc.asm
	yasm testacc.asm -w -g stabs -l testacc.lst -f elf32 -o testacc.o

testacc:	symacc.o testacc.o ../lib/s1.a
	gcc -m32  symacc.o testacc.o ../lib/s1.a -g -o testacc

initsym.mill:   initsym.s1 ../small.s2m
	stg2 ../small.s2m <initsym.s1 - initsym.mill initsym.lss

initsym.asm:    initsym.mill ../mill2yasm.s2m
	stg2 ../mill2yasm.s2m <initsym.mill - initsym.asm

initsym.o:      initsym.asm
	yasm initsym.asm -w -g stabs -l initsym.lst -f elf32 -o initsym.o


symacc.mill:	symacc.s1 ../small.s2m
	stg2 ../small.s2m <symacc.s1 - symacc.mill symacc.lss

symacc.asm:	symacc.mill ../mill2yasm.s2m
	stg2 ../mill2yasm.s2m <symacc.mill - symacc.asm

symacc.o:	symacc.asm
	yasm symacc.asm -w -g stabs -l symacc.lst -f elf32 -o symacc.o

testinit.mill:	testinit.s1 ../small.s2m
	stg2 ../small.s2m <testinit.s1 - testinit.mill testinit.lss

testinit.asm:	testinit.mill ../mill2yasm.s2m
	stg2 ../mill2yasm.s2m <testinit.mill - testinit.asm

testinit.o:	testinit.asm
	yasm testinit.asm -w -g stabs -l testinit.lst -f elf32 -o testinit.o

testinit:	testinit.o initsym.o symacc.o ../testlex/lex.o
	gcc -m32 testinit.o initsym.o symacc.o ../testlex/lex.o -L../lib -ls1 -g -o testinit

test:		testinit
	./testinit - initable.dat initsym.out
