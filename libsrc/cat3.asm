;* cat3.s1 -- CAT version for substring capture, CRB, Mar 29, 2014
;* 07/25/2014 CRB Fix off-by-one error
;
;  BEGIN CAT3;
 global progr
 extern exit
;  ENTRY CAT3;
 global  CAT3
;
;  DCL I,J,LEN;
 section .data
I:
 times 1 dd 0
J:
 times 1 dd 0
LEN:
 times 1 dd 0
;
;* Append substring from SRC into DEST
;PROC CAT3(DEST,LA,SRC);
 section .text
; SUBR  CAT3
CAT3:
 push EBP
 mov  EBP,ESP
; NPARS  3
; PAR  DEST
; PAR  LA
; PAR  SRC
; PEND
;  LEN=LA SHR 8;                 * extract length of substring
;.GEN =LEN,LA,=8,.BNSHR,.BNST,
; L D LA
 mov EBX,[EBP+12] ; LA
 mov EAX,[EBX]
 sar EAX,8
 mov [LEN],EAX
;  I=LA AND 255;                 * anchor index in SRC
;.GEN =I,LA,=255,.BCAND,.BNST,
; L D LA
 mov EBX,[EBP+12] ; LA
 mov EAX,[EBX]
 and EAX,255
 mov [I],EAX
;  J=DEST+1;                     * CRB 07/25/2014 fixed obo bug
;.GEN =J,DEST,=1,.BC+,.BNST,
; L D DEST
 mov EBX,[EBP+16] ; DEST
 mov EAX,[EBX]
 inc EAX
 mov [J],EAX
;  DEST=DEST+LEN;
;.GEN =DEST,DEST,LEN,.BC+,.BNST,
; L D DEST
 mov EBX,[EBP+16] ; DEST
 mov EAX,[EBX]
 add EAX,[LEN]
; ST D DEST
 mov EBX,[EBP+16] ; DEST
 mov [EBX],EAX
;  DO WHILE LEN;
LJ1:
;.GEN LEN,=0,.BN-,
 mov EAX,[LEN]
 or EAX,EAX
 jz LJ2
;    DEST(J)=SRC(I);
;.GEN =DEST,J,=2,.BNSHL,.BC+,=SRC,I,=2,.BNSHL,.BC+,.UA,.BNST,
 mov EAX,[J]
 sal EAX,2
; + D =DEST
 mov EBX,[EBP+16] ; DEST
 add EAX,EBX
 mov [T1Z1],EAX
 mov EAX,[I]
 sal EAX,2
; + D =SRC
 mov EBX,[EBP+8] ; SRC
 add EAX,EBX
 mov EAX,[EAX]
 mov EDX,EAX
 mov EAX,[T1Z1]
 mov [EAX],EDX
;    I=I+1;
;.GEN =I,I,=1,.BC+,.BNST,
 mov EAX,[I]
 inc EAX
 mov [I],EAX
;    J=J+1;
;.GEN =J,J,=1,.BC+,.BNST,
 mov EAX,[J]
 inc EAX
 mov [J],EAX
;    LEN=LEN-1;
;.GEN =LEN,LEN,=1,.BN-,.BNST,
 mov EAX,[LEN]
 dec EAX
 mov [LEN],EAX
;    ENDDO
 jmp LJ1
LJ2:
;  RETURN
; RETN  CAT3,3
 mov ESP,EBP
 pop EBP
 ret
;  ENDPROC
 section .data
T1Z1:
 times 1 dd 0
 section .text
;
;END
 end
