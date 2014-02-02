# makefile -- for test CASE statement, CRB, Jan 31, 2014

testcase.mill:	testcase.s1 ../small.s2m
	stg2 ../small.s2m <testcase.s1 - testcase.mill testcase.lss

testcase.asm:	testcase.mill ../mill2yasm.s2m
	stg2 ../mill2yasm.s2m <testcase.mill - testcase.asm

testcase.o:	testcase.asm
	yasm testcase.asm -w -g stabs -l testcase.lst -f elf32 -o testcase.o

testcase:	testcase.o
	gcc -m32 ../grandios.dbug.o ../smallio.o testcase.o -g -o testcase

clean:
	rm *.mill *.lss *.asm *.o testcase
