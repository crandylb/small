# makefile -- for test CAT2, CRB, Dec 29, 2013

testcat.mill:	testcat.s1 ../small.s2m
	stg2 ../small.s2m <testcat.s1 - testcat.mill testcat.lss

testcat.asm:	testcat.mill ../mill2yasm.s2m
	stg2 ../mill2yasm.s2m <testcat.mill - testcat.asm

testcat.o:	testcat.asm
	yasm testcat.asm -w -g stabs -l testcat.lst -f elf32 -o testcat.o

testcat:	testcat.o cat2.o
	gcc -m32 ../grandios.dbug.o ../smallio.o testcat.o cat2.o  -g -o testcat

cat2.mill:	cat2.s1 ../small.s2m
	stg2 ../small.s2m <cat2.s1 - cat2.mill cat2.lss

cat2.asm:	cat2.mill ../mill2yasm.s2m
	stg2 ../mill2yasm.s2m <cat2.mill - cat2.asm

cat2.o:	cat2.asm
	yasm cat2.asm -w -g stabs -l cat2.lst -f elf32 -o cat2.o

clean:
	rm *.mill *.lss *.asm *.lst *.o testcat
