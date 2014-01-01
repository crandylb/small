;* TESTFACT.S1 -- Test Numeric I/O, CRB, Dec 30, 2013
;
;  ENTRY TESTFACT;
 global  TESTFACT
;  BEGIN TESTFACT;
 global progr
 extern exit
;  START TESTFACT;
 global  TESTFACT
 section .text
progr:
 push EBP
 mov  EBP,ESP
 jmp TESTFACT
;
;  EXT PROC READ,WRITE;
 extern READ
 extern  WRITE
;  EXT PROC IREAD,IFORM;
 extern IREAD
 extern  IFORM
;  EXT PROC FACT;
 extern FACT
;
;  DCL INCH=1;
 section .data
INCH:
 dd  1
;  DCL OUTCH=3;
OUTCH:
 dd  3
;  MSG GREET='Enter a positive number less than 12';
GREET:
 dd  36
 dd  69
 dd  110
 dd  116
 dd  101
 dd  114
 dd  32
 dd  97
 dd  32
 dd  112
 dd  111
 dd  115
 dd  105
 dd  116
 dd  105
 dd  118
 dd  101
 dd  32
 dd  110
 dd  117
 dd  109
 dd  98
 dd  101
 dd  114
 dd  32
 dd  108
 dd  101
 dd  115
 dd  115
 dd  32
 dd  116
 dd  104
 dd  97
 dd  110
 dd  32
 dd  49
 dd  50
;  MSG ANSWER='The factorial is:';
ANSWER:
 dd  17
 dd  84
 dd  104
 dd  101
 dd  32
 dd  102
 dd  97
 dd  99
 dd  116
 dd  111
 dd  114
 dd  105
 dd  97
 dd  108
 dd  32
 dd  105
 dd  115
 dd  58
;  DCL BUFFER(20);
BUFFER:
 times 21 dd 0
;  DCL RESULT(20);
RESULT:
 times 21 dd 0
;  DCL I=1,NUMBER;
I:
 dd  1
NUMBER:
 times 1 dd 0
;  DCL F;
F:
 times 1 dd 0
;
;LABEL TESTFACT;
 section .text
TESTFACT:
;*  BUFFER=1;                    * initialize input buffer
;  RESULT=20;                   * initialize result buffer size
;.GEN =RESULT,=20,.BNST,
 mov EAX,20
 mov [RESULT],EAX
;  CALL WRITE(OUTCH,GREET);
; NARGS  2
 push OUTCH
 push GREET
 call WRITE
 add  ESP,4*2
;  CALL READ(INCH,BUFFER);
; NARGS  2
 push INCH
 push BUFFER
 call READ
 add  ESP,4*2
;  NUMBER=IREAD(I,BUFFER);
;.GEN =NUMBER,(I,BUFFER),.UFIREAD,.BNST,
; NARGS  2
 push I
 push BUFFER
 call IREAD
 add  ESP,4*2
 mov [NUMBER],EAX
;  F=FACT(NUMBER);
;.GEN =F,(NUMBER),.UFFACT,.BNST,
; NARGS  1
 push NUMBER
 call FACT
 add  ESP,4*1
 mov [F],EAX
;  CALL WRITE(OUTCH,ANSWER);
; NARGS  2
 push OUTCH
 push ANSWER
 call WRITE
 add  ESP,4*2
;  CALL IFORM(F,RESULT);
; NARGS  2
 push F
 push RESULT
 call IFORM
 add  ESP,4*2
;  CALL WRITE(OUTCH,RESULT);
; NARGS  2
 push OUTCH
 push RESULT
 call WRITE
 add  ESP,4*2
;  RETURN
; RETN  ,
 mov ESP,EBP
 pop EBP
 ret
;END
 end
