;* FACT -- Example Recursive Function
;  BEGIN FACT;
 global progr
 extern exit
;  ENTRY FACT;
 global  FACT
;
;* DCL RECURSIVE RETURN(8);   * return address stack
;  DCL STP=0,STK(12);         * local parameter stack
 section .data
STP:
 dd  0
STK:
 times 13 dd 0
;  DCL R,T;                   * local variables
R:
 times 1 dd 0
T:
 times 1 dd 0
;*---------------  FACTORIAL EXAMPLE
;  RECURSIVE PROCEDURE FACT(N);
 section .text
; SUBR  FACT
FACT:
 push EBP
 mov  EBP,ESP
; RECUR P FACT
; NPARS  1
; PAR  N
; PEND
;    IF N LE 1;
;.GEN N,=1,.BN-,
; L D N
 mov EBX,[EBP+8] ; N
 mov EAX,[EBX]
 dec EAX
;      THEN RETURN 1;         * terminate the recursion
 jg LJ1
;.GEN =1,
 mov EAX,1
; RETN  FACT,1
 mov ESP,EBP
 pop EBP
 ret
;      ELSE 
 jmp LJ2
LJ1:
;        STP=STP+1;
;.GEN =STP,STP,=1,.BC+,.BNST,
 mov EAX,[STP]
 inc EAX
 mov [STP],EAX
;	STK(STP)=N;          * stack the parameter
;.GEN =	STK,STP,=2,.BNSHL,.BC+,N,.BNST,
 mov EAX,[STP]
 sal EAX,2
 add EAX,	STK
 mov [T1Z],EAX
; L D N
 mov EBX,[EBP+8] ; N
 mov EAX,[EBX]
 mov EDX,EAX
 mov EAX,[T1Z]
 mov [EAX],EDX
;	T=N-1;               * compute next parameter
;.GEN =	T,N,=1,.BN-,.BNST,
; L D N
 mov EBX,[EBP+8] ; N
 mov EAX,[EBX]
 dec EAX
 mov [	T],EAX
;	R=FACT(T)*STK(STP);  * recursive call
;.GEN =	R,(T),.UFFACT,=STK,STP,=2,.BNSHL,.BC+,.UA,.BC*,.BNST,
; NARGS  1
 push T
 call FACT
 add  ESP,4*1
 mov [T1Z1],EAX
 mov EAX,[STP]
 sal EAX,2
 add EAX,STK
 mov EAX,[EAX]
 imul dword [T1Z1]
 mov [	R],EAX
;	STP=STP-1;
;.GEN =	STP,STP,=1,.BN-,.BNST,
 mov EAX,[STP]
 dec EAX
 mov [	STP],EAX
;	RETURN R;            * return result
;.GEN R,
 mov EAX,[R]
; RETN  FACT,1
 mov ESP,EBP
 pop EBP
 ret
;      ENDIF
LJ2:
;    ENDPROC
 section .data
T1Z:
 times 2 dd 0
 section .text
 section .data
T1Z1:
 times 1 dd 0
 section .text
;  END
 end
