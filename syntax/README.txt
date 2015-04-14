README.txt -- For syntax subdirectory, CRB, Apr 7, 2015

Contents of this subdirectory:
README.txt  this file
eval.s1	    expression evaluator module
isamod.s1   module of T/F functions for lexical syntax identification
makefile    make file for modules in this subdirectory
scan.s1	    main input scan module for small compiler
testeval.s1 test program for eval module
expralgorithm.png is a scanned image of the flowchart of the expression
evaluator algorithm

README   Deacribe the contents of this subdirectory which contains syntax 
processing modules of the small compiler as written in Small. These modules 
are described below

eval	 evaluates an infix arithmetic expression containing signed 32-bit
integers and add, subtract, multiply, and divide operators, as well as
parenthesized subexpressions and unary plus or minus signes at the beginning
of an expression. The EVAL function returns the 32-bit integer value of the
expression. The algorithm used is charted in the expralgorithm.png image
file. This evaluator is used in Small in the SET statement and other places
to calculate a compile-time value.

isamod	 is a module of functions that return True (1) or False (0) if the
argument token is a particular syntactic element. For example ISAINT(IT)
returns True if the token indexed by IT is an integer constant, otherwise it
returns False. ISAPLU(IT) is True if the token is a plus sign "+", and so
on. The current functions at this time are:
ISAINT, ISASYM, ISAPLU, ISAMIN, ISAAST, ISASLA, ISALP, ISARP, ISASEMI, ISAEQU.
More such functions will be added as needed.

makefile is used to build the testeval executable test program. Use
  make test
to build and run the test program. For example
  opus:/home/randyl/small/syntax> make test
  ./testeval - ../symacc/initable.dat
  Begin Small eval Test
  -1+2*3/(4-5);
  -1+2*3/(4-5);
  ANSWER =          -7
  opus:/home/randyl/small/syntax> 
Press ctrl-d to send end-of-file to end the test.

scan     is the main input scanning module that ignores white space and
comments and builds a list of tokens for syntax scanning. It uses the lex and
symacc modules to identify tokens and their attributes. When make test is used
to build testeval, scan is modified to call EVALS, a shell in testeval that
calls the eval module to evaluate an arithmetic expression and print the
result. The original unmodified version of scan is maintained in the scan 
development directory and in the libsrc library source directory.

testeval is the test program harness for testing the eval module. It calls the
SCAN module that has been modified to call EVALS. The testeval module contains
the EVALS shell function that calls the EVAL function and prints the result.

expralgorithm.png is a scanned image of the flowchart of the expression
evaluator algorithm. This algorithm handles unary plus or minus at the
beginning of an expression or subexpression, handles add, subtract, multiply,
and divide, with precedence of multiplicative operators, and handles
parenthesized subexpressions. It does not use recursion, but uses an internal
stack for intermediate results. I first created this algorithm sometime in the
sixties and used it in many forms and different languages. It does not use the
usual computer science method, but instead uses straightforward brute force
spaghetti code, code to show it is possible.
