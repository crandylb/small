# makefile -- for Small libsrc directory, CRB, May 12, 2014
# 11/09/2014 CRB add libsc for small compiler modules
# 02/03/2015 CRB Add show utility
# 02/07/2015 CRB Add module scan for small compiler
# 02/23/2015 CRB Add shotoks
# 02/24/2015 CRB Add initsym
# 02/25/2015 CRB Update lib and libsc

lib:	show.o cat2.o cat3.o iform.o iread.o
	cp -a cat2.o cat3.o iform.o iread.o ../lib

libsc:	scan.o shotoks.o lex.o symacc.o initsym.o
	cp -a scan.o shotoks.o lex.o symacc.o initsym.o ../libsc

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

symacc.mill:	symacc.s1 ../small.s2m
	stg2 ../small.s2m <symacc.s1 - symacc.mill symacc.lss

symacc.asm:	symacc.mill ../mill2yasm.s2m
	stg2 ../mill2yasm.s2m <symacc.mill - symacc.asm

symacc.o:	symacc.asm
	yasm symacc.asm -w -l symacc.lst -f elf32 -o symacc.o

initsym.mill:	initsym.s1 ../small.s2m
	stg2 ../small.s2m <initsym.s1 - initsym.mill initsym.lss

initsym.asm:	initsym.mill ../mill2yasm.s2m
	stg2 ../mill2yasm.s2m <initsym.mill - initsym.asm

initsym.o:	initsym.asm
	yasm initsym.asm -w -l initsym.lst -f elf32 -o initsym.o

lex.mill:	lex.s1 ../small.s2m
	stg2 ../small.s2m <lex.s1 - lex.mill lex.lss

lex.asm:	lex.mill ../mill2yasm.s2m
	stg2 ../mill2yasm.s2m <lex.mill - lex.asm

lex.o:	lex.asm
	yasm lex.asm -w -l lex.lst -f elf32 -o lex.o

show.mill:	show.s1 ../small.s2m
	stg2 ../small.s2m <show.s1 - show.mill show.lss

show.asm:	show.mill ../mill2yasm.s2m
	stg2 ../mill2yasm.s2m <show.mill - show.asm

show.o:	show.asm
	yasm show.asm -w -l show.lst -f elf32 -o show.o

shotoks.mill:	shotoks.s1 ../small.s2m
	stg2 ../small.s2m <shotoks.s1 - shotoks.mill shotoks.lss

shotoks.asm:	shotoks.mill ../mill2yasm.s2m
	stg2 ../mill2yasm.s2m <shotoks.mill - shotoks.asm

shotoks.o:	shotoks.asm
	yasm shotoks.asm -w -l shotoks.lst -f elf32 -o shotoks.o

scan.mill:	scan.s1 ../small.s2m
	stg2 ../small.s2m <scan.s1 - scan.mill scan.lss

scan.asm:	scan.mill ../mill2yasm.s2m
	stg2 ../mill2yasm.s2m <scan.mill - scan.asm

scan.o:	scan.asm
	yasm scan.asm -w -l scan.lst -f elf32 -o scan.o

clean:
	rm *.mill *.lss *.asm *.o
