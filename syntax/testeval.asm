;* testeval.s1 -- Test Small scanner using LEX, CRB, Nov 14, 2014
;* 03/03/2015 CRB Delete unused BUFF
;* 03/06/2015 CRB Correct initialization of IT
;* 03/09/2015 CRB Add EVALS eval shell function
;* 03/11/2015 CRB Use CAT2 instead of CAT3, initialize IT=1
;* 03/12/2015 CRB Use local copy of IT in call to EVAL
;* 03/20/2015 CRB Clean up dead code
;
;  ENTRY TESTEVAL;
 global  TESTEVAL
;  BEGIN TESTEVAL;
 global progr
 extern exit
;  START TESTEVAL;
 global  TESTEVAL
 section .text
progr:
 push EBP
 mov  EBP,ESP
 jmp TESTEVAL
;  ENTRY EVALS;                  * eval shell called fron scan
 global  EVALS
;
;  EXTERNAL PROC READ,WRITE;
 extern READ
 extern  WRITE
;  EXTERNAL PROC LEX,CAT2;
 extern LEX
 extern  CAT2
;  EXT PROC SCAN,INITSYM,DMPLIST,SHOTOKS;
 extern SCAN
 extern  INITSYM
 extern  DMPLIST
 extern  SHOTOKS
;  EXT PROC EVAL,IFORM,CAT2;
 extern EVAL
 extern  IFORM
 extern  CAT2
;  EXT OUTCH;                    * global output channel
 extern  OUTCH
;  EXT TOKENS;                   * array of tokens from scan
 extern  TOKENS
;
;  MSG GREET='Begin Small eval Test';
 section .data
GREET:
 dd  21
 dd  66
 dd  101
 dd  103
 dd  105
 dd  110
 dd  32
 dd  83
 dd  109
 dd  97
 dd  108
 dd  108
 dd  32
 dd  101
 dd  118
 dd  97
 dd  108
 dd  32
 dd  84
 dd  101
 dd  115
 dd  116
;  MSG DONE='ANSWER =                ';
DONE:
 dd  24
 dd  65
 dd  78
 dd  83
 dd  87
 dd  69
 dd  82
 dd  32
 dd  61
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
 dd  32
;  DCL IT,ANSWER;
IT:
 times 1 dd 0
ANSWER:
 times 1 dd 0
;  DCL LA,TMP(11);
LA:
 times 1 dd 0
TMP:
 times 12 dd 0
;
;LABEL TESTEVAL;
 section .text
TESTEVAL:
;  CALL WRITE(OUTCH,GREET);
; NARGS  2
 push OUTCH
 push GREET
 call WRITE
 add  ESP,4*2
;  CALL INITSYM;
; NARGS  0
 call INITSYM
;*  CALL DMPLIST;
;  CALL SCAN;
; NARGS  0
 call SCAN
;  RETURN
; RETN  ,
 mov ESP,EBP
 pop EBP
 ret
;
;* eval shell callback function called from scan
;PROC EVALS(I);
; SUBR  EVALS
EVALS:
 push EBP
 mov  EBP,ESP
; NPARS  1
; PAR  I
; PEND
;  IT=I;
;.GEN =IT,I,.BNST,
; L D I
 mov EBX,[EBP+8] ; I
 mov EAX,[EBX]
 mov [IT],EAX
;  ANSWER=EVAL(IT);              * use local copy
;.GEN =ANSWER,(IT),.UFEVAL,.BNST,
; NARGS  1
 push IT
 call EVAL
 add  ESP,4*1
 mov [ANSWER],EAX
;  TMP=10;
;.GEN =TMP,=10,.BNST,
 mov EAX,10
 mov [TMP],EAX
;  CALL IFORM(ANSWER,TMP);
; NARGS  2
 push ANSWER
 push TMP
 call IFORM
 add  ESP,4*2
;  DONE=10;
;.GEN =DONE,=10,.BNST,
 mov EAX,10
 mov [DONE],EAX
;  CALL CAT2(DONE,TMP);
; NARGS  2
 push DONE
 push TMP
 call CAT2
 add  ESP,4*2
;  CALL WRITE(OUTCH,DONE);
; NARGS  2
 push OUTCH
 push DONE
 call WRITE
 add  ESP,4*2
;  RETURN ANSWER;
;.GEN ANSWER,
 mov EAX,[ANSWER]
; RETN  EVALS,1
 mov ESP,EBP
 pop EBP
 ret
;ENDPROC
;
;END
 end
