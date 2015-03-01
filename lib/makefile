# makefile -- for Small lib directory, CRB, Feb 26, 2014
# 05/12/2014 CRB Add cat3.o
# 02/03/2015 CRB Add show.o

libs1.a:	grandios.o smallio.o cat2.o cat3.o iform.o iread.o show.o
	ar -rs libs1.a grandios.o smallio.o cat2.o cat3.o iform.o iread.o show.o

lib:	libs1.a
	cp libs1.a s1.a
