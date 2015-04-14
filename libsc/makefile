# makefile -- for Small compiler module lib directory, CRB, Nov 09, 2014
# 02/07/2015 CRB Add scan.o module
# 02/23/2015 CRB Add shotoks.o
# 02/24/2015 CRB Add initsym

libsc.a:	lex.o symacc.o initsym.o scan.o shotoks.o
	ar -rs libsc.a lex.o symacc.o initsym.o scan.o shotoks.o

libsc:	libsc.a
	cp libsc.a sc.a
