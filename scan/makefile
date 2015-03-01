# makefile -- test lexical scan, CRB, Feb 21, 2014
# 06/22/2014 CRB Add initsym and symacc
# 07/05/2014 CRB Use upp-to-date lex from testlex
# 07/25/2014 CRB Try fixed cat3
# 11/22/2014 CRB Modify for separate scan and shotoks
# 12/21/2014 CRB Enable debugging for shotoks
# 12/23/2014 CRB Remove cat3
# 12/29/2014 CRB Add show utility
# 02/04/2015 CRB show module moved to libs1
# 02/09/2015 CRB Now using libsc for small compiler
# 02/24/2015 CRB Final cleanup

LIBS=-L../lib -L../libsc -lsc -ls1 

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

shotoks.mill:	shotoks.s1 ../small.s2m
	stg2 ../small.s2m <shotoks.s1 - shotoks.mill shotoks.lss

shotoks.asm:	shotoks.mill ../mill2yasm.s2m
	stg2 ../mill2yasm.s2m <shotoks.mill - shotoks.asm

shotoks.o:	shotoks.asm
	yasm shotoks.asm -w -g stabs -l shotoks.lst -f elf32 -o shotoks.o

testscan:	testscan.o ../lib/libs1.a ../libsc/libsc.a
	gcc -m32 testscan.o $(LIBS)-o testscan

test:	testscan
	./testscan scantest.txt ../symacc/initable.dat

clean:
	rm *.mill *.lss *.asm *.o *.lst testscan
