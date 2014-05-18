;* IFORM -- CONVERT INTEGER TO DECIMAL CHARACTER STRING AS IN I FORMAT
;BEGIN IFORM;                  * CRB OCT 31, 1981
 global progr
 extern exit
;     ENT IFORM;
 global  IFORM
;     DCL N,Q;
 section .data
N:
 times 1 dd 0
Q:
 times 1 dd 0
;     DCL PTR;                 * TEMPORARY STORAGE FOR CONVERSION
PTR:
 times 1 dd 0
;     DCL STAR=('*');
STAR:
 dd  42
;     DCL MINUS=('-');
MINUS:
 dd  45
;*---------------
;PROC IFORM(NUM,BUFF);
 section .text
; SUBR  IFORM
IFORM:
 push EBP
 mov  EBP,ESP
; NPARS  2
; PAR  NUM
; PAR  BUFF
; PEND
;     N=NUM;                   * GET NUMBER TO BE CONVERTED
;.GEN =N,NUM,.BNST,
; L D NUM
 mov EBX,[EBP+12] ; NUM
 mov EAX,[EBX]
 mov [N],EAX
;     PTR=BUFF;                * POINTER INTO USERS BUFFER
;.GEN =PTR,BUFF,.BNST,
; L D BUFF
 mov EBX,[EBP+8] ; BUFF
 mov EAX,[EBX]
 mov [PTR],EAX
;     IF N LT 0; THEN N=-N; ENDIF
;.GEN N,=0,.BN-,
 mov EAX,[N]
 or EAX,EAX
 jge LJ1
;.GEN =N,N,.U-,.BNST,
 mov EAX,[N]
 neg EAX
 mov [N],EAX
LJ1:
;     REPEAT                   * REPEAT UNTIL N IS CONVERTED
LJ2:
;       IF PTR LE 0; THEN GO TO TOOBIG ENDIF
;.GEN PTR,=0,.BN-,
 mov EAX,[PTR]
 or EAX,EAX
 jg LJ4
 jmp TOOBIG
LJ4:
;       Q=N/10;                * GET NEXT QUOTIENT
;.GEN =Q,N,=10,.BN/,.BNST,
 mov EAX,[N]
 cdq
 mov  ECX,10
 idiv dword ECX
 mov [Q],EAX
;       BUFF(PTR)=N-10*Q+'0';  * CONVERT REMAINDER TO CHAR
;.GEN =BUFF,PTR,=2,.BNSHL,.BC+,N,=10,Q,.BC*,.BN-,=48,.BC+,.BNST,
 mov EAX,[PTR]
 sal EAX,2
; + D =BUFF
 mov EBX,[EBP+8] ; BUFF
 add EAX,EBX
 mov [T1Z1],EAX
 mov EAX,10
 imul dword [Q]
 mov [T1Z],EAX
 mov EAX,[N]
 sub EAX,[T1Z]
 add EAX,48
 mov EDX,EAX
 mov EAX,[T1Z1]
 mov [EAX],EDX
;       N=Q;
;.GEN =N,Q,.BNST,
 mov EAX,[Q]
 mov [N],EAX
;       PTR=PTR-1;
;.GEN =PTR,PTR,=1,.BN-,.BNST,
 mov EAX,[PTR]
 dec EAX
 mov [PTR],EAX
;       UNTIL N EQ 0;
;.GEN N,=0,.BN-,
 mov EAX,[N]
 or EAX,EAX
 jne LJ2
LJ3:
;     IF NUM LT 0; THEN 
;.GEN NUM,=0,.BN-,
; L D NUM
 mov EBX,[EBP+12] ; NUM
 mov EAX,[EBX]
 or EAX,EAX
 jge LJ5
;       IF PTR LE 0; THEN GO TO TOOBIG;
;.GEN PTR,=0,.BN-,
 mov EAX,[PTR]
 or EAX,EAX
 jg LJ6
 jmp TOOBIG
;       ELSE BUFF(PTR)=MINUS;  * INSERT MINUS SIGN IF IT FITS
 jmp LJ7
LJ6:
;.GEN =BUFF,PTR,=2,.BNSHL,.BC+,MINUS,.BNST,
 mov EAX,[PTR]
 sal EAX,2
; + D =BUFF
 mov EBX,[EBP+8] ; BUFF
 add EAX,EBX
 mov [T1Z],EAX
 mov EAX,[MINUS]
 mov EDX,EAX
 mov EAX,[T1Z]
 mov [EAX],EDX
;         PTR=PTR-1;
;.GEN =PTR,PTR,=1,.BN-,.BNST,
 mov EAX,[PTR]
 dec EAX
 mov [PTR],EAX
;         ENDIF
LJ7:
;       ENDIF
LJ5:
;     DO WHILE PTR GT 0;       * BLANK OUT ANY UNUSED PART OF BUFF
LJ8:
;.GEN PTR,=0,.BN-,
 mov EAX,[PTR]
 or EAX,EAX
 jle LJ9
;       BUFF(PTR)=' ';
;.GEN =BUFF,PTR,=2,.BNSHL,.BC+,=32,.BNST,
 mov EAX,[PTR]
 sal EAX,2
; + D =BUFF
 mov EBX,[EBP+8] ; BUFF
 add EAX,EBX
 mov [T1Z],EAX
 mov EAX,32
 mov EDX,EAX
 mov EAX,[T1Z]
 mov [EAX],EDX
;       PTR=PTR-1;
;.GEN =PTR,PTR,=1,.BN-,.BNST,
 mov EAX,[PTR]
 dec EAX
 mov [PTR],EAX
;       ENDDO
 jmp LJ8
LJ9:
;     RETURN
; RETN  IFORM,2
 mov ESP,EBP
 pop EBP
 ret
;LABEL TOOBIG                  * CONVERTED NUMBER TOO BIG FOR BUFF
TOOBIG:
;     BUFF(1)=STAR;            * SET FIRST CHAR = * TO NOTE ERROR
;.GEN =BUFF,=1,=2,.BNSHL,.BC+,STAR,.BNST,
 mov EAX,1
 sal EAX,2
; + D =BUFF
 mov EBX,[EBP+8] ; BUFF
 add EAX,EBX
 mov [T1Z],EAX
 mov EAX,[STAR]
 mov EDX,EAX
 mov EAX,[T1Z]
 mov [EAX],EDX
;     RETURN
; RETN  IFORM,2
 mov ESP,EBP
 pop EBP
 ret
;   ENDPROC
 section .data
T1Z:
 times 2 dd 0
 section .text
 section .data
T1Z1:
 times 1 dd 0
 section .text
; END IFORM
 end
