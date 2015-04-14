# makefile -- for syntax directory, CRB, Sep 22, 2014
# 09/27/2014 CRB Add eval
# 11/14/2014 CRB Add testeval
# 03/06/2015 CRB Add testeval executable
# 03/09/2015 CRB Use ../scan/scan.o
# 03/23/2015 CRB Use local patched scan module

LIBS=-L../lib -L../libsc -lsc -ls1 

isamod.mill:	isamod.s1 ../small.s2m
	stg2 ../small.s2m <isamod.s1 - isamod.mill isamod.lss

isamod.asm:	isamod.mill ../mill2yasm.s2m
	stg2 ../mill2yasm.s2m <isamod.mill - isamod.asm

isamod.o:	isamod.asm
	yasm isamod.asm -w -g stabs -l isamod.lst -f elf32 -o isamod.o

eval.mill:	eval.s1 ../small.s2m
	stg2 ../small.s2m <eval.s1 - eval.mill eval.lss

eval.asm:	eval.mill ../mill2yasm.s2m
	stg2 ../mill2yasm.s2m <eval.mill - eval.asm

eval.o:	eval.asm
	yasm eval.asm -w -g stabs -l eval.lst -f elf32 -o eval.o

scan.mill:	../scan/scan.s1 ../small.s2m scan4eval.diff
	cp ../scan/scan.s1 .
	patch -u scan.s1 scan4eval.diff
	stg2 ../small.s2m <scan.s1 - scan.mill scan.lss

scan.asm:	scan.mill ../mill2yasm.s2m
	stg2 ../mill2yasm.s2m <scan.mill - scan.asm

scan.o:	scan.asm
	yasm scan.asm -w -g stabs -l scan.lst -f elf32 -o scan.o

testeval.mill:	testeval.s1 ../small.s2m
	stg2 ../small.s2m <testeval.s1 - testeval.mill testeval.lss

testeval.asm:	testeval.mill ../mill2yasm.s2m
	stg2 ../mill2yasm.s2m <testeval.mill - testeval.asm

testeval.o:	testeval.asm
	yasm testeval.asm -w -g stabs -l testeval.lst -f elf32 -o testeval.o

testeval:	testeval.o eval.o isamod.o scan.o ../lib/libs1.a ../libsc/libsc.a
	gcc -m32 testeval.o eval.o isamod.o scan.o $(LIBS)-o testeval

test:	testeval
	./testeval - ../symacc/initable.dat

clean:
	rm *.mill *.lss *.asm *.o *.lst testeval
