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
# 08/31/2015 CRB Update testscan and add make testlist
# 09/20/2015 CRB Use updated show.o in lib

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

sc.mill:	sc.s1 ../small.s2m
	stg2 ../small.s2m <sc.s1 - sc.mill sc.lss

sc.asm:	sc.mill ../mill2yasm.s2m
	stg2 ../mill2yasm.s2m <sc.mill - sc.asm

sc.o:	sc.asm
	yasm sc.asm -w -g stabs -l sc.lst -f elf32 -o sc.o

shotoks.mill:	shotoks.s1 ../small.s2m
	stg2 ../small.s2m <shotoks.s1 - shotoks.mill shotoks.lss

shotoks.asm:	shotoks.mill ../mill2yasm.s2m
	stg2 ../mill2yasm.s2m <shotoks.mill - shotoks.asm

shotoks.o:	shotoks.asm
	yasm shotoks.asm -w -g stabs -l shotoks.lst -f elf32 -o shotoks.o

show.mill:	show.s1 ../small.s2m
	stg2 ../small.s2m <show.s1 - show.mill show.lss

show.asm:	show.mill ../mill2yasm.s2m
	stg2 ../mill2yasm.s2m <show.mill - show.asm

show.o:	show.asm
	yasm show.asm -w -g stabs -l show.lst -f elf32 -o show.o

testscan:	testscan.o scan.o ../lib/libs1.a ../libsc/libsc.a
	gcc -m32 testscan.o scan.o $(LIBS)-o testscan

sc:	sc.o scan.o ../lib/libs1.a ../libsc/libsc.a
	gcc -m32 sc.o scan.o $(LIBS)-o sc

test:	testscan
	./testscan scantest.txt ../symacc/initable.dat

testlist:	sc
	./sc sc.s1 ../symacc/initable.dat sc.ch3 sc.ch4

clean:
	rm *.mill *.lss *.asm *.o *.lst testscan sc
