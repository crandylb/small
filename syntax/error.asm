;* error.s1 -- Error message handler module for Small compiler, CRB, Apr 22, 2015
;* 04/23/2015 CRB Add RETURN statement
;* 04/27/2015 CRB Access anchor for token at error position detected 
;* 05/08/2015 CRB Adjust error pointer by -1
;
;BEGIN ERROR;
 global progr
 extern exit
;
;  ENT ERROR;
 global  ERROR
;  ENT ERRCNT;
 global  ERRCNT
;
;  EXT PROC WRITE,IFORM,CAT2,CAT3;
 extern WRITE
 extern  IFORM
 extern  CAT2
 extern  CAT3
;  EXT OUTCH;                    * output channel
 extern  OUTCH
;  EXT TOKENS;
 extern  TOKENS
;
;  DCL ERRCNT=0;                 * error count
 section .data
ERRCNT:
 dd  0
;  MSG ERRPTR='----------------------------------------------------------------';
ERRPTR:
 dd  64
 dd  45
 dd  45
 dd  45
 dd  45
 dd  45
 dd  45
 dd  45
 dd  45
 dd  45
 dd  45
 dd  45
 dd  45
 dd  45
 dd  45
 dd  45
 dd  45
 dd  45
 dd  45
 dd  45
 dd  45
 dd  45
 dd  45
 dd  45
 dd  45
 dd  45
 dd  45
 dd  45
 dd  45
 dd  45
 dd  45
 dd  45
 dd  45
 dd  45
 dd  45
 dd  45
 dd  45
 dd  45
 dd  45
 dd  45
 dd  45
 dd  45
 dd  45
 dd  45
 dd  45
 dd  45
 dd  45
 dd  45
 dd  45
 dd  45
 dd  45
 dd  45
 dd  45
 dd  45
 dd  45
 dd  45
 dd  45
 dd  45
 dd  45
 dd  45
 dd  45
 dd  45
 dd  45
 dd  45
 dd  45
;  MSG PTR='^';                  * error pointer
PTR:
 dd  1
 dd  94
;  DCL TMP(128);
TMP:
 times 129 dd 0
;
;  PROC ERROR(IT,ERRMSG);
 section .text
; SUBR  ERROR
ERROR:
 push EBP
 mov  EBP,ESP
; NPARS  2
; PAR  IT
; PAR  ERRMSG
; PEND
;    TMP=0;
;.GEN =TMP,=0,.BNST,
 mov EAX,0
 mov [TMP],EAX
;    * set length of pointer line
;    ERRPTR=(TOKENS(IT) AND 255)-1;  * extract anchor for error token
;.GEN =ERRPTR,=TOKENS,IT,=2,.BNSHL,.BC+,.UA,=255,.BCAND,=1,.BN-,.BNST,
; L D IT
 mov EBX,[EBP+12] ; IT
 mov EAX,[EBX]
 sal EAX,2
 add EAX,TOKENS
 mov EAX,[EAX]
 and EAX,255
 dec EAX
 mov [ERRPTR],EAX
;     CALL CAT2(TMP,ERRPTR);      * copy to TMP
; NARGS  2
 push TMP
 push ERRPTR
 call CAT2
 add  ESP,4*2
;    CALL CAT2(TMP,PTR);         * append pointer ^ char
; NARGS  2
 push TMP
 push PTR
 call CAT2
 add  ESP,4*2
;    CALL CAT2(TMP,ERRMSG);      * append error message
; ARGT D ERRMSG
 mov EBX,[EBP+8] ; ERRMSG
; NARGS  2
 push TMP
; ARG D ERRMSG
 push EBX
 call CAT2
 add  ESP,4*2
;    CALL WRITE(OUTCH,TMP);      * print
; NARGS  2
 push OUTCH
 push TMP
 call WRITE
 add  ESP,4*2
;    RETURN;
; RETN  ERROR,2
 mov ESP,EBP
 pop EBP
 ret
;  ENDPROC
;END
 end
