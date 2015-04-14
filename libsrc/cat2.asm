;* CAT2 -- CONCATENATE THE MESSAGES MSG1 AND MSG2
;*
;    BEGIN CAT2;
 global progr
 extern exit
;    ENT CAT2;
 global  CAT2
;    DCL I,J;
 section .data
I:
 times 1 dd 0
J:
 times 1 dd 0
;*---------------
;    PROC CAT2(MSG1,MSG2);
 section .text
; SUBR  CAT2
CAT2:
 push EBP
 mov  EBP,ESP
; NPARS  2
; PAR  MSG1
; PAR  MSG2
; PEND
;      I=MSG1+1;
;.GEN =I,MSG1,=1,.BC+,.BNST,
; L D MSG1
 mov EBX,[EBP+12] ; MSG1
 mov EAX,[EBX]
 inc EAX
 mov [I],EAX
;      J=1;
;.GEN =J,=1,.BNST,
 mov EAX,1
 mov [J],EAX
;      DO WHILE J LE MSG2;     * COPY MSG2 INTO AND FOLLOWING MSG1
LJ1:
;.GEN J,MSG2,.BN-,
 mov EAX,[J]
; - D MSG2
 mov EBX,[EBP+8] ; MSG2
 sub EAX,[EBX]
 jg LJ2
;        MSG1(I)=MSG2(J);
;.GEN =MSG1,I,=2,.BNSHL,.BC+,=MSG2,J,=2,.BNSHL,.BC+,.UA,.BNST,
 mov EAX,[I]
 sal EAX,2
; + D =MSG1
 mov EBX,[EBP+12] ; MSG1
 add EAX,EBX
 mov [T1Z1],EAX
 mov EAX,[J]
 sal EAX,2
; + D =MSG2
 mov EBX,[EBP+8] ; MSG2
 add EAX,EBX
 mov EAX,[EAX]
 mov EDX,EAX
 mov EAX,[T1Z1]
 mov [EAX],EDX
;        I=I+1;
;.GEN =I,I,=1,.BC+,.BNST,
 mov EAX,[I]
 inc EAX
 mov [I],EAX
;        J=J+1;
;.GEN =J,J,=1,.BC+,.BNST,
 mov EAX,[J]
 inc EAX
 mov [J],EAX
;        ENDDO
 jmp LJ1
LJ2:
;      MSG1=MSG1+MSG2;         * SET LENGTH OF RESULT MESSAGE
;.GEN =MSG1,MSG1,MSG2,.BC+,.BNST,
; L D MSG1
 mov EBX,[EBP+12] ; MSG1
 mov EAX,[EBX]
; + D MSG2
 mov EBX,[EBP+8] ; MSG2
 add EAX,[EBX]
; ST D MSG1
 mov EBX,[EBP+12] ; MSG1
 mov [EBX],EAX
;      RETURN
; RETN  CAT2,2
 mov ESP,EBP
 pop EBP
 ret
;      ENDPROC
 section .data
T1Z1:
 times 1 dd 0
 section .text
;    END
 end
