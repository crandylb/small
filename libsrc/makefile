# makefile -- for Small libsrc directory, CRB, May 12, 2014

lib:	cat2.o cat3.o iform.o iread.o
	cp *.o ../lib

cat2.mill:	cat2.s1 ../small.s2m
	stg2 ../small.s2m <cat2.s1 - cat2.mill cat2.lss

cat2.asm:	cat2.mill ../mill2yasm.s2m
	stg2 ../mill2yasm.s2m <cat2.mill - cat2.asm

cat2.o: cat2.asm
	yasm cat2.asm -w -l cat2.lst -f elf32 -o cat2.o

cat3.mill:	cat3.s1 ../small.s2m
	stg2 ../small.s2m <cat3.s1 - cat3.mill cat3.lss

cat3.asm:	cat3.mill ../mill2yasm.s2m
	stg2 ../mill2yasm.s2m <cat3.mill - cat3.asm

cat3.o:	cat3.asm
	yasm cat3.asm -w -l cat3.lst -f elf32 -o cat3.o

iform.mill:	iform.s1 ../small.s2m
	stg2 ../small.s2m <iform.s1 - iform.mill iform.lss

iform.asm:	iform.mill ../mill2yasm.s2m
	stg2 ../mill2yasm.s2m <iform.mill - iform.asm

iform.o:	iform.asm
	yasm iform.asm -w -l iform.lst -f elf32 -o iform.o

iread.mill:	iread.s1 ../small.s2m
	stg2 ../small.s2m <iread.s1 - iread.mill iread.lss

iread.asm:	iread.mill ../mill2yasm.s2m
	stg2 ../mill2yasm.s2m <iread.mill - iread.asm

iread.o:	iread.asm
	yasm iread.asm -w -l iread.lst -f elf32 -o iread.o

clean:
	rm *.mill *.lss *.asm *.o
