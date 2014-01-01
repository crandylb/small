;* TESTCAT.S1 -- Test CAT2 in Small, CRB, Dec 18, 2013
;
;  ENTRY TESTCAT;
 global  TESTCAT
;  BEGIN TESTCAT;
 global progr
 extern exit
;  START TESTCAT;
 global  TESTCAT
 section .text
progr:
 push EBP
 mov  EBP,ESP
 jmp TESTCAT
;
;  EXT PROC CAT2,WRITE;
 extern CAT2
 extern  WRITE
;
;  DCL OUTCH=3;
 section .data
OUTCH:
 dd  3
;  MSG HELLO='Hello';
HELLO:
 dd  5
 dd  72
 dd  101
 dd  108
 dd  108
 dd  111
;  DCL PAD=(15*' ');
PAD:
 dd  32
 dd  32
 dd  32
 dd  32
 dd  32
 dd  32
 dd  32
 dd  32
 dd  32
 dd  32
 dd  32
 dd  32
 dd  32
 dd  32
 dd  32
;  MSG SMALLW=' Small World.';
SMALLW:
 dd  13
 dd  32
 dd  83
 dd  109
 dd  97
 dd  108
 dd  108
 dd  32
 dd  87
 dd  111
 dd  114
 dd  108
 dd  100
 dd  46
;
;LABEL TESTCAT;
 section .text
TESTCAT:
;  CALL WRITE(OUTCH,HELLO);
; NARGS  2
 push OUTCH
 push HELLO
 call WRITE
 add  ESP,4*2
;  CALL WRITE(OUTCH,SMALLW);
; NARGS  2
 push OUTCH
 push SMALLW
 call WRITE
 add  ESP,4*2
;  CALL CAT2(HELLO,SMALLW);
; NARGS  2
 push HELLO
 push SMALLW
 call CAT2
 add  ESP,4*2
;  CALL WRITE(OUTCH,HELLO);
; NARGS  2
 push OUTCH
 push HELLO
 call WRITE
 add  ESP,4*2
;  RETURN
; RETN  ,
 mov ESP,EBP
 pop EBP
 ret
;END
 end
