# makefile -- test recursive factorial, CRB, Dec 30, 2013

testfact.mill:	testfact.s1 ../small.s2m
	stg2 ../small.s2m <testfact.s1 - testfact.mill testfact.lss

testfact.asm:	testfact.mill ../mill2yasm.s2m
	stg2 ../mill2yasm.s2m <testfact.mill - testfact.asm

testfact.o:	testfact.asm
	yasm testfact.asm -w -g stabs -l testfact.lst -f elf32 -o testfact.o

testfact:	testfact.o iform.o iread.o fact.o
	gcc -m32 ../grandios.dbug.o ../smallio.o iform.o iread.o fact.o testfact.o  -g -o testfact

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

fact.mill:	fact.s1 ../small.s2m
	stg2 ../small.s2m <fact.s1 - fact.mill fact.lss

fact.asm:	fact.mill ../mill2yasm.s2m
	stg2 ../mill2yasm.s2m <fact.mill - fact.asm

fact.o:	fact.asm
	yasm fact.asm -w -g stabs -l fact.lst -f elf32 -o fact.o

clean:
	rm *.mill *.lss *.asm *.o testfact
