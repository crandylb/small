# makefile -- for small on github, CRB, Jan 1, 2014

smallio.o:	smallio.c grandios.h
	gcc -c -m32 -g smallio.c -o smallio.o
