# makefile -- for test numeric I/I, IREAD, IFORM, CRB, Dec 27, 2013

testnio.mill:	testnio.s1 ../small.s2m
	stg2 ../small.s2m <testnio.s1 - testnio.mill testnio.lss

testnio.asm:	testnio.mill ../mill2yasm.s2m
	stg2 ../mill2yasm.s2m <testnio.mill - testnio.asm

testnio.o:	testnio.asm
	yasm testnio.asm -w -g stabs -l testnio.lst -f elf32 -o testnio.o

testnio:	testnio.o iform.o iread.o
	gcc -m32 ../grandios.dbug.o ../smallio.o testnio.o iform.o iread.o -g -o testnio

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
	rm *.mill *.lss *.asm *.o testnio
