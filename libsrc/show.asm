;* show.s1 -- Utility to show a name and value, CRB, Dec 30, 2014
;
;BEGIN SHOW;
 global progr
 extern exit
;
;  ENT SHOW;
 global  SHOW
;  EXT PROC IFORM, CAT2, WRITE;
 extern IFORM
 extern   CAT2
 extern   WRITE
;  EXT OUTCH;                    * output channel number
 extern  OUTCH
;  DCL BUFFER(31);
 section .data
BUFFER:
 times 32 dd 0
;
;PROC SHOW(NAME,VAL);
 section .text
; SUBR  SHOW
SHOW:
 push EBP
 mov  EBP,ESP
; NPARS  2
; PAR  NAME
; PAR  VAL
; PEND
;  BUFFER=10;                    * initialize buffer for iform
;.GEN =BUFFER,=10,.BNST,
 mov EAX,10
 mov [BUFFER],EAX
;  CALL IFORM(VAL,BUFFER);       * format value into buffer
; ARGT D VAL
 mov EBX,[EBP+8] ; VAL
; NARGS  2
; ARG D VAL
 push EBX
 push BUFFER
 call IFORM
 add  ESP,4*2
;  BUFFER=BUFFER+1;              * bump the character count
;.GEN =BUFFER,BUFFER,=1,.BC+,.BNST,
 mov EAX,[BUFFER]
 inc EAX
 mov [BUFFER],EAX
;  BUFFER(BUFFER)=' ';           * append a space to buffer
;.GEN =BUFFER,BUFFER,=2,.BNSHL,.BC+,=32,.BNST,
 mov EAX,[BUFFER]
 sal EAX,2
 add EAX,BUFFER
 mov [T1Z],EAX
 mov EAX,32
 mov EDX,EAX
 mov EAX,[T1Z]
 mov [EAX],EDX
;  CALL CAT2(BUFFER,NAME);       * concatenate name into buffer
; ARGT D NAME
 mov EBX,[EBP+12] ; NAME
; NARGS  2
 push BUFFER
; ARG D NAME
 push EBX
 call CAT2
 add  ESP,4*2
;  CALL WRITE(OUTCH,BUFFER);     * write the buffer out
; NARGS  2
 push OUTCH
 push BUFFER
 call WRITE
 add  ESP,4*2
;  RETURN;
; RETN  SHOW,2
 mov ESP,EBP
 pop EBP
 ret
;ENDPROC
 section .data
T1Z:
 times 2 dd 0
 section .text
;END
 end
