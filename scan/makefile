# makefile -- test lexical scan, CRB, Feb 21, 2014

testscan.mill:	testscan.s1 ../small.s2m
	stg2 ../small.s2m <testscan.s1 - testscan.mill testscan.lss

testscan.asm:	testscan.mill ../mill2yasm.s2m
	stg2 ../mill2yasm.s2m <testscan.mill - testscan.asm

testscan.o:	testscan.asm
	yasm testscan.asm -w -g stabs -l testscan.lst -f elf32 -o testscan.o

scan.mill:	scan.s1 ../small.s2m
	stg2 ../small.s2m <scan.s1 - scan.mill scan.lss

scan.asm:	scan.mill ../mill2yasm.s2m
	stg2 ../mill2yasm.s2m <scan.mill - scan.asm

scan.o:	scan.asm
	yasm scan.asm -w -g stabs -l scan.lst -f elf32 -o scan.o

testscan:	testscan.o scan.o lex.o ../lib/libs1.a
	gcc -m32 scan.o testscan.o lex.o -L../lib -ls1 -g -o testscan

lex.mill:	lex.s1 ../small.s2m
	stg2 ../small.s2m <lex.s1 - lex.mill lex.lss

lex.asm:	lex.mill ../mill2yasm.s2m
	stg2 ../mill2yasm.s2m <lex.mill - lex.asm

lex.o:	lex.asm
	yasm lex.asm -w -g stabs -l lex.lst -f elf32 -o lex.o

clean:
	rm *.mill *.lss *.asm *.o *.lst testscan
