;* TESTCASE.S1 -- Test CASE statement, CRB, Feb 1, 2014
;
;  ENTRY TESTCASE;
 global  TESTCASE
;  BEGIN TESTCASE;
 global progr
 extern exit
;  START TESTCASE;
 global  TESTCASE
 section .text
progr:
 push EBP
 mov  EBP,ESP
 jmp TESTCASE
;
;  EXT PROC WRITE;
 extern WRITE
;
;  DCL OUTCH=3;
 section .data
OUTCH:
 dd  3
;  DCL I=0;
I:
 dd  0
;  MSG CASETXT='Case 0  ';		* space to plug in case number
CASETXT:
 dd  8
 dd  67
 dd  97
 dd  115
 dd  101
 dd  32
 dd  48
 dd  32
 dd  32
;
;LABEL TESTCASE;
 section .text
TESTCASE:
;  DO WHILE I LT 3;
LJ1:
;.GEN I,=3,.BN-,
 mov EAX,[I]
 sub EAX,3
 jge LJ2
;    CASE I; OF CASE1,CASE2,CASE3;	* case list is zero indexed
;.GEN I,=0,.BN-,
 mov EAX,[I]
 or EAX,EAX
 sal  EAX,2
 add  EAX,LC1
 mov  EAX,[EAX]
 jmp  EAX
 section .data
LC1:
 dd CASE1
 dd CASE2
 dd CASE3
;      LABEL CASE1;
 section .text
 jmp LJ3
CASE1:
;        CASETXT(6)=I+'1';		* convert I to char + 1
;.GEN =CASETXT,=6,=2,.BNSHL,.BC+,I,=49,.BC+,.BNST,
 mov EAX,6
 sal EAX,2
 add EAX,CASETXT
 mov [TZ1],EAX
 mov EAX,[I]
 add EAX,49
 mov EDX,EAX
 mov EAX,[TZ1]
 mov [EAX],EDX
;      LABEL CASE2;
 jmp LJ3
CASE2:
;        CASETXT(7)=I+'1';
;.GEN =CASETXT,=7,=2,.BNSHL,.BC+,I,=49,.BC+,.BNST,
 mov EAX,7
 sal EAX,2
 add EAX,CASETXT
 mov [TZ1],EAX
 mov EAX,[I]
 add EAX,49
 mov EDX,EAX
 mov EAX,[TZ1]
 mov [EAX],EDX
;      LABEL CASE3;
 jmp LJ3
CASE3:
;        CASETXT(8)=I+'1';
;.GEN =CASETXT,=8,=2,.BNSHL,.BC+,I,=49,.BC+,.BNST,
 mov EAX,8
 sal EAX,2
 add EAX,CASETXT
 mov [TZ1],EAX
 mov EAX,[I]
 add EAX,49
 mov EDX,EAX
 mov EAX,[TZ1]
 mov [EAX],EDX
;      ENDCASE 
LJ3:
;      CALL WRITE(OUTCH,CASETXT);
; NARGS  2
 push OUTCH
 push CASETXT
 call WRITE
 add  ESP,4*2
;      I=I+1;
;.GEN =I,I,=1,.BC+,.BNST,
 mov EAX,[I]
 inc EAX
 mov [I],EAX
;    ENDDO
 jmp LJ1
LJ2:
;  RETURN
; RETN  ,
 mov ESP,EBP
 pop EBP
 ret
;  END
 section .data
TZ1:
 times 1 dd 0
 section .text
 end
