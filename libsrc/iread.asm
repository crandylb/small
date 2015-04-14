;* IREAD -- FUNCTION TO SCAN FOR AN INTEGER AND RETURN ITS VALUE
;* CRB OCT 31, 1981
;     BEGIN IREAD;  ENTRY IREAD;
 global progr
 extern exit
 global  IREAD
;     DCL I;                   * LOCAL COPY OF IPTR
 section .data
I:
 times 1 dd 0
;     DCL L;                   * LENGTH OF LINE
L:
 times 1 dd 0
;     DCL N;                   * VALUE OF NUMBER BEING CONVERTED
N:
 times 1 dd 0
;     DCL PLUS=('+'),MINUS=('-'),SIGN;
PLUS:
 dd  43
MINUS:
 dd  45
SIGN:
 times 1 dd 0
;*---------------
;PROC IREAD(IPTR,LINE);
 section .text
; SUBR  IREAD
IREAD:
 push EBP
 mov  EBP,ESP
; NPARS  2
; PAR  IPTR
; PAR  LINE
; PEND
;     SIGN=0;                  * SET SIGN FOR POSITIVE NUMBER
;.GEN =SIGN,=0,.BNST,
 mov EAX,0
 mov [SIGN],EAX
;     N=0;
;.GEN =N,=0,.BNST,
 mov EAX,0
 mov [N],EAX
;     I=IPTR;                  * LOCAL COPY
;.GEN =I,IPTR,.BNST,
; L D IPTR
 mov EBX,[EBP+12] ; IPTR
 mov EAX,[EBX]
 mov [I],EAX
;     L=LINE;                  * ASSUME LINE(0) CONTAINS LENGTH
;.GEN =L,LINE,.BNST,
; L D LINE
 mov EBX,[EBP+8] ; LINE
 mov EAX,[EBX]
 mov [L],EAX
;     DO WHILE LINE(I) EQ ' '; * TRIM LEADING BLANKS
LJ1:
;.GEN =LINE,I,=2,.BNSHL,.BC+,.UA,=32,.BN-,
 mov EAX,[I]
 sal EAX,2
; + D =LINE
 mov EBX,[EBP+8] ; LINE
 add EAX,EBX
 mov EAX,[EAX]
 sub EAX,32
 jne LJ2
;       IF I GE L; THEN IPTR=I; RETURN 0; ENDIF
;.GEN I,L,.BN-,
 mov EAX,[I]
 sub EAX,[L]
 jl LJ3
;.GEN =IPTR,I,.BNST,
 mov EAX,[I]
; ST D IPTR
 mov EBX,[EBP+12] ; IPTR
 mov [EBX],EAX
;.GEN =0,
 mov EAX,0
; RETN  IREAD,2
 mov ESP,EBP
 pop EBP
 ret
LJ3:
;       I=I+1;
;.GEN =I,I,=1,.BC+,.BNST,
 mov EAX,[I]
 inc EAX
 mov [I],EAX
;       ENDDO
 jmp LJ1
LJ2:
;     IF LINE(I) EQ PLUS; THEN GO TO IR1  ENDIF
;.GEN =LINE,I,=2,.BNSHL,.BC+,.UA,PLUS,.BN-,
 mov EAX,[I]
 sal EAX,2
; + D =LINE
 mov EBX,[EBP+8] ; LINE
 add EAX,EBX
 mov EAX,[EAX]
 sub EAX,[PLUS]
 jne LJ4
 jmp IR1
LJ4:
;     IF LINE(I) EQ MINUS; THEN 
;.GEN =LINE,I,=2,.BNSHL,.BC+,.UA,MINUS,.BN-,
 mov EAX,[I]
 sal EAX,2
; + D =LINE
 mov EBX,[EBP+8] ; LINE
 add EAX,EBX
 mov EAX,[EAX]
 sub EAX,[MINUS]
 jne LJ5
;       SIGN=-1;               * SET SIGN FOR NEGATIVE NUMBER
;.GEN =SIGN,=1,.U-,.BNST,
 mov EAX,1
 neg EAX
 mov [SIGN],EAX
;LABEL IR1;
IR1:
;       I=I+1;
;.GEN =I,I,=1,.BC+,.BNST,
 mov EAX,[I]
 inc EAX
 mov [I],EAX
;       DO WHILE LINE(I) EQ ' '; * ALLOW BLANKS AFTER + OR -
LJ6:
;.GEN =LINE,I,=2,.BNSHL,.BC+,.UA,=32,.BN-,
 mov EAX,[I]
 sal EAX,2
; + D =LINE
 mov EBX,[EBP+8] ; LINE
 add EAX,EBX
 mov EAX,[EAX]
 sub EAX,32
 jne LJ7
;         IF I GE L; THEN RETURN 0; ENDIF
;.GEN I,L,.BN-,
 mov EAX,[I]
 sub EAX,[L]
 jl LJ8
;.GEN =0,
 mov EAX,0
; RETN  IREAD,2
 mov ESP,EBP
 pop EBP
 ret
LJ8:
;         I=I+1;
;.GEN =I,I,=1,.BC+,.BNST,
 mov EAX,[I]
 inc EAX
 mov [I],EAX
;         ENDDO
 jmp LJ6
LJ7:
;       ENDIF
LJ5:
;     IF LINE(I) LT '0'; THEN RETURN 0; ENDIF
;.GEN =LINE,I,=2,.BNSHL,.BC+,.UA,=48,.BN-,
 mov EAX,[I]
 sal EAX,2
; + D =LINE
 mov EBX,[EBP+8] ; LINE
 add EAX,EBX
 mov EAX,[EAX]
 sub EAX,48
 jge LJ9
;.GEN =0,
 mov EAX,0
; RETN  IREAD,2
 mov ESP,EBP
 pop EBP
 ret
LJ9:
;     IF LINE(I) GT '9'; THEN RETURN 0; ENDIF
;.GEN =LINE,I,=2,.BNSHL,.BC+,.UA,=57,.BN-,
 mov EAX,[I]
 sal EAX,2
; + D =LINE
 mov EBX,[EBP+8] ; LINE
 add EAX,EBX
 mov EAX,[EAX]
 sub EAX,57
 jle LJ10
;.GEN =0,
 mov EAX,0
; RETN  IREAD,2
 mov ESP,EBP
 pop EBP
 ret
LJ10:
;     DO WHILE I LE L;
LJ11:
;.GEN I,L,.BN-,
 mov EAX,[I]
 sub EAX,[L]
 jg LJ12
;       IF LINE(I) LT '0'; THEN EXIT ENDIF
;.GEN =LINE,I,=2,.BNSHL,.BC+,.UA,=48,.BN-,
 mov EAX,[I]
 sal EAX,2
; + D =LINE
 mov EBX,[EBP+8] ; LINE
 add EAX,EBX
 mov EAX,[EAX]
 sub EAX,48
 jge LJ13
 jmp LJ12
LJ13:
;       IF LINE(I) GT '9'; THEN EXIT ENDIF
;.GEN =LINE,I,=2,.BNSHL,.BC+,.UA,=57,.BN-,
 mov EAX,[I]
 sal EAX,2
; + D =LINE
 mov EBX,[EBP+8] ; LINE
 add EAX,EBX
 mov EAX,[EAX]
 sub EAX,57
 jle LJ14
 jmp LJ12
LJ14:
;       N=10*N-'0'+LINE(I);
;.GEN =N,=10,N,.BC*,=48,.BN-,=LINE,I,=2,.BNSHL,.BC+,.UA,.BC+,.BNST,
 mov EAX,10
 imul dword [N]
 sub EAX,48
 mov [T1Z1],EAX
 mov EAX,[I]
 sal EAX,2
; + D =LINE
 mov EBX,[EBP+8] ; LINE
 add EAX,EBX
 mov EAX,[EAX]
 add EAX,[T1Z1]
 mov [N],EAX
;       I=I+1;
;.GEN =I,I,=1,.BC+,.BNST,
 mov EAX,[I]
 inc EAX
 mov [I],EAX
;       ENDDO
 jmp LJ11
LJ12:
;     IF SIGN; THEN N=-N; ENDIF
;.GEN SIGN,=0,.BN-,
 mov EAX,[SIGN]
 or EAX,EAX
 jz LJ15
;.GEN =N,N,.U-,.BNST,
 mov EAX,[N]
 neg EAX
 mov [N],EAX
LJ15:
;     IPTR=I;                  * MOVE INPUT POINTER TO TERMINATING CHAR
;.GEN =IPTR,I,.BNST,
 mov EAX,[I]
; ST D IPTR
 mov EBX,[EBP+12] ; IPTR
 mov [EBX],EAX
;     RETURN N;                * RETURN ACCUMULATED NUMBER AS VALUE
;.GEN N,
 mov EAX,[N]
; RETN  IREAD,2
 mov ESP,EBP
 pop EBP
 ret
;   ENDPROC
 section .data
T1Z1:
 times 1 dd 0
 section .text
; END
 end
