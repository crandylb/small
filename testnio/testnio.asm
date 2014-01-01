;* TESTNIO.S1 -- Test Numeric I/O, CRB, Dec 29, 2013
;
;  ENTRY TESTNIO;
 global  TESTNIO
;  BEGIN TESTNIO;
 global progr
 extern exit
;  START TESTNIO;
 global  TESTNIO
 section .text
progr:
 push EBP
 mov  EBP,ESP
 jmp TESTNIO
;
;  EXT PROC READ,WRITE;
 extern READ
 extern  WRITE
;  EXT PROC IREAD,IFORM;
 extern IREAD
 extern  IFORM
;
;  DCL INCH=1;
 section .data
INCH:
 dd  1
;  DCL OUTCH=3;
OUTCH:
 dd  3
;  MSG GREET='Enter number';
GREET:
 dd  12
 dd  69
 dd  110
 dd  116
 dd  101
 dd  114
 dd  32
 dd  110
 dd  117
 dd  109
 dd  98
 dd  101
 dd  114
;  MSG ANSWER='Your number is:';
ANSWER:
 dd  15
 dd  89
 dd  111
 dd  117
 dd  114
 dd  32
 dd  110
 dd  117
 dd  109
 dd  98
 dd  101
 dd  114
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
;
;LABEL TESTNIO;
 section .text
TESTNIO:
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
;  CALL WRITE(OUTCH,ANSWER);
; NARGS  2
 push OUTCH
 push ANSWER
 call WRITE
 add  ESP,4*2
;  CALL IFORM(NUMBER,RESULT);
; NARGS  2
 push NUMBER
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
