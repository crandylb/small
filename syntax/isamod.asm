;* isamod.s1 -- Module of ISA functions for parsing, CRB, Sep 16, 2014
;* 09/29/2014 CRB Add ISASEMI, ISAEQU
;* 03/06/2015 CRB Add ENTRY for ISASEMI, ISAEQU
;* 03/15/2015 CRB Correct mask for OP
;* 05/30/2015 CRB Add ISASET(IT)
;
;* Each function returns True (1) or False (0)
;
;BEGIN ISAMOD;
 global progr
 extern exit
;  EXT TOKENS;                       * access tokens array in scan
 extern  TOKENS
;  ENT ISAINT,ISASYM,ISASET;
 global  ISAINT
 global  ISASYM
 global  ISASET
;  ENT ISAPLU,ISAMIN,ISAAST,ISASLA;  * arithmetic operators
 global  ISAPLU
 global  ISAMIN
 global  ISAAST
 global  ISASLA
;  ENT ISALP,ISARP;                  * parentheses
 global  ISALP
 global  ISARP
;  ENT ISASEMI,ISAEQU;               * semicolon and equal sign
 global  ISASEMI
 global  ISAEQU
;
;  DCL LKIND;                        * lexical kind
 section .data
LKIND:
 times 1 dd 0
;  DCL TTYPE;                        * type code
TTYPE:
 times 1 dd 0
;  DCL OP;                           * operator code
OP:
 times 1 dd 0
;
;* token is a literal integer evaluated by lex
;  PROC ISAINT(IT);                  * is an integer
 section .text
; SUBR  ISAINT
ISAINT:
 push EBP
 mov  EBP,ESP
; NPARS  1
; PAR  IT
; PEND
;    LKIND=TOKENS(IT) SHR 28 AND 7;
;.GEN =LKIND,=TOKENS,IT,=2,.BNSHL,.BC+,.UA,=28,.BNSHR,=7,.BCAND,.BNST,
; L D IT
 mov EBX,[EBP+8] ; IT
 mov EAX,[EBX]
 sal EAX,2
 add EAX,TOKENS
 mov EAX,[EAX]
 sar EAX,28
 and EAX,7
 mov [LKIND],EAX
;    IF LKIND EQ 2; THEN RETURN 1;
;.GEN LKIND,=2,.BN-,
 mov EAX,[LKIND]
 sub EAX,2
 jne LJ1
;.GEN =1,
 mov EAX,1
; RETN  ISAINT,1
 mov ESP,EBP
 pop EBP
 ret
;    ELSE RETURN 0;
 jmp LJ2
LJ1:
;.GEN =0,
 mov EAX,0
; RETN  ISAINT,1
 mov ESP,EBP
 pop EBP
 ret
;    ENDIF
LJ2:
;  ENDPROC
;
;* token is a symbol in symbol table and not a keyword
;  PROC ISASYM(IT);                  * is a symbol
; SUBR  ISASYM
ISASYM:
 push EBP
 mov  EBP,ESP
; NPARS  1
; PAR  IT
; PEND
;    LKIND=TOKENS(IT) SHR 28 AND 7;
;.GEN =LKIND,=TOKENS,IT,=2,.BNSHL,.BC+,.UA,=28,.BNSHR,=7,.BCAND,.BNST,
; L D IT
 mov EBX,[EBP+8] ; IT
 mov EAX,[EBX]
 sal EAX,2
 add EAX,TOKENS
 mov EAX,[EAX]
 sar EAX,28
 and EAX,7
 mov [LKIND],EAX
;    TTYPE=TOKENS(IT+3) SHR 8 AND 15;
;.GEN =TTYPE,=TOKENS,IT,=3,.BC+,=2,.BNSHL,.BC+,.UA,=8,.BNSHR,=15,.BCAND,.BNST,
; L D IT
 mov EBX,[EBP+8] ; IT
 mov EAX,[EBX]
 add EAX,3
 sal EAX,2
 add EAX,TOKENS
 mov EAX,[EAX]
 sar EAX,8
 and EAX,15
 mov [TTYPE],EAX
;    IF LKIND EQ 1; THEN IF TTYPE NE 3;
;.GEN LKIND,=1,.BN-,
 mov EAX,[LKIND]
 dec EAX
 jne LJ3
;.GEN TTYPE,=3,.BN-,
 mov EAX,[TTYPE]
 sub EAX,3
;      THEN RETURN 1;
 jz LJ4
;.GEN =1,
 mov EAX,1
; RETN  ISASYM,1
 mov ESP,EBP
 pop EBP
 ret
;    ENDIF ENDIF
LJ4:
LJ3:
;    RETURN 0;
;.GEN =0,
 mov EAX,0
; RETN  ISASYM,1
 mov ESP,EBP
 pop EBP
 ret
;  ENDPROC
;
;* token is a SET statement symbolic constant
;  PROC ISASET(IT);                  * is a symbol
; SUBR  ISASET
ISASET:
 push EBP
 mov  EBP,ESP
; NPARS  1
; PAR  IT
; PEND
;    LKIND=TOKENS(IT) SHR 28 AND 7;
;.GEN =LKIND,=TOKENS,IT,=2,.BNSHL,.BC+,.UA,=28,.BNSHR,=7,.BCAND,.BNST,
; L D IT
 mov EBX,[EBP+8] ; IT
 mov EAX,[EBX]
 sal EAX,2
 add EAX,TOKENS
 mov EAX,[EAX]
 sar EAX,28
 and EAX,7
 mov [LKIND],EAX
;    TTYPE=TOKENS(IT+3) SHR 8 AND 255;
;.GEN =TTYPE,=TOKENS,IT,=3,.BC+,=2,.BNSHL,.BC+,.UA,=8,.BNSHR,=255,.BCAND,.BNST,
; L D IT
 mov EBX,[EBP+8] ; IT
 mov EAX,[EBX]
 add EAX,3
 sal EAX,2
 add EAX,TOKENS
 mov EAX,[EAX]
 sar EAX,8
 and EAX,255
 mov [TTYPE],EAX
;    IF LKIND EQ 1; THEN IF TTYPE EQ 9;
;.GEN LKIND,=1,.BN-,
 mov EAX,[LKIND]
 dec EAX
 jne LJ5
;.GEN TTYPE,=9,.BN-,
 mov EAX,[TTYPE]
 sub EAX,9
;      THEN RETURN 1;
 jne LJ6
;.GEN =1,
 mov EAX,1
; RETN  ISASET,1
 mov ESP,EBP
 pop EBP
 ret
;    ENDIF ENDIF
LJ6:
LJ5:
;    RETURN 0;
;.GEN =0,
 mov EAX,0
; RETN  ISASET,1
 mov ESP,EBP
 pop EBP
 ret
;  ENDPROC
;
;  PROC ISAPLU(IT);                  * is a plus sign
; SUBR  ISAPLU
ISAPLU:
 push EBP
 mov  EBP,ESP
; NPARS  1
; PAR  IT
; PEND
;    LKIND=TOKENS(IT) SHR 28 AND 7;
;.GEN =LKIND,=TOKENS,IT,=2,.BNSHL,.BC+,.UA,=28,.BNSHR,=7,.BCAND,.BNST,
; L D IT
 mov EBX,[EBP+8] ; IT
 mov EAX,[EBX]
 sal EAX,2
 add EAX,TOKENS
 mov EAX,[EAX]
 sar EAX,28
 and EAX,7
 mov [LKIND],EAX
;    OP=TOKENS(IT+2) AND 255;
;.GEN =OP,=TOKENS,IT,=2,.BC+,=2,.BNSHL,.BC+,.UA,=255,.BCAND,.BNST,
; L D IT
 mov EBX,[EBP+8] ; IT
 mov EAX,[EBX]
 add EAX,2
 sal EAX,2
 add EAX,TOKENS
 mov EAX,[EAX]
 and EAX,255
 mov [OP],EAX
;    IF LKIND EQ 4; THEN IF OP EQ 50;
;.GEN LKIND,=4,.BN-,
 mov EAX,[LKIND]
 sub EAX,4
 jne LJ7
;.GEN OP,=50,.BN-,
 mov EAX,[OP]
 sub EAX,50
;      THEN RETURN 1;
 jne LJ8
;.GEN =1,
 mov EAX,1
; RETN  ISAPLU,1
 mov ESP,EBP
 pop EBP
 ret
;    ENDIF ENDIF
LJ8:
LJ7:
;    RETURN 0;
;.GEN =0,
 mov EAX,0
; RETN  ISAPLU,1
 mov ESP,EBP
 pop EBP
 ret
;  ENDPROC
;
;  PROC ISAMIN(IT);                  * is a minus sign
; SUBR  ISAMIN
ISAMIN:
 push EBP
 mov  EBP,ESP
; NPARS  1
; PAR  IT
; PEND
;    LKIND=TOKENS(IT) SHR 28 AND 7;
;.GEN =LKIND,=TOKENS,IT,=2,.BNSHL,.BC+,.UA,=28,.BNSHR,=7,.BCAND,.BNST,
; L D IT
 mov EBX,[EBP+8] ; IT
 mov EAX,[EBX]
 sal EAX,2
 add EAX,TOKENS
 mov EAX,[EAX]
 sar EAX,28
 and EAX,7
 mov [LKIND],EAX
;    OP=TOKENS(IT+2) AND 255;
;.GEN =OP,=TOKENS,IT,=2,.BC+,=2,.BNSHL,.BC+,.UA,=255,.BCAND,.BNST,
; L D IT
 mov EBX,[EBP+8] ; IT
 mov EAX,[EBX]
 add EAX,2
 sal EAX,2
 add EAX,TOKENS
 mov EAX,[EAX]
 and EAX,255
 mov [OP],EAX
;    IF LKIND EQ 4; THEN IF OP EQ 51;
;.GEN LKIND,=4,.BN-,
 mov EAX,[LKIND]
 sub EAX,4
 jne LJ9
;.GEN OP,=51,.BN-,
 mov EAX,[OP]
 sub EAX,51
;      THEN RETURN 1;
 jne LJ10
;.GEN =1,
 mov EAX,1
; RETN  ISAMIN,1
 mov ESP,EBP
 pop EBP
 ret
;    ENDIF ENDIF
LJ10:
LJ9:
;    RETURN 0;
;.GEN =0,
 mov EAX,0
; RETN  ISAMIN,1
 mov ESP,EBP
 pop EBP
 ret
;  ENDPROC
;
;  PROC ISAAST(IT);                  * is an asterisk
; SUBR  ISAAST
ISAAST:
 push EBP
 mov  EBP,ESP
; NPARS  1
; PAR  IT
; PEND
;    LKIND=TOKENS(IT) SHR 28 AND 7;
;.GEN =LKIND,=TOKENS,IT,=2,.BNSHL,.BC+,.UA,=28,.BNSHR,=7,.BCAND,.BNST,
; L D IT
 mov EBX,[EBP+8] ; IT
 mov EAX,[EBX]
 sal EAX,2
 add EAX,TOKENS
 mov EAX,[EAX]
 sar EAX,28
 and EAX,7
 mov [LKIND],EAX
;    OP=TOKENS(IT+2) AND 255;
;.GEN =OP,=TOKENS,IT,=2,.BC+,=2,.BNSHL,.BC+,.UA,=255,.BCAND,.BNST,
; L D IT
 mov EBX,[EBP+8] ; IT
 mov EAX,[EBX]
 add EAX,2
 sal EAX,2
 add EAX,TOKENS
 mov EAX,[EAX]
 and EAX,255
 mov [OP],EAX
;    IF LKIND EQ 4; THEN IF OP EQ 53;
;.GEN LKIND,=4,.BN-,
 mov EAX,[LKIND]
 sub EAX,4
 jne LJ11
;.GEN OP,=53,.BN-,
 mov EAX,[OP]
 sub EAX,53
;      THEN RETURN 1;
 jne LJ12
;.GEN =1,
 mov EAX,1
; RETN  ISAAST,1
 mov ESP,EBP
 pop EBP
 ret
;    ENDIF ENDIF
LJ12:
LJ11:
;    RETURN 0;
;.GEN =0,
 mov EAX,0
; RETN  ISAAST,1
 mov ESP,EBP
 pop EBP
 ret
;  ENDPROC
;
;  PROC ISASLA(IT);                  * is a slash
; SUBR  ISASLA
ISASLA:
 push EBP
 mov  EBP,ESP
; NPARS  1
; PAR  IT
; PEND
;    LKIND=TOKENS(IT) SHR 28 AND 7;
;.GEN =LKIND,=TOKENS,IT,=2,.BNSHL,.BC+,.UA,=28,.BNSHR,=7,.BCAND,.BNST,
; L D IT
 mov EBX,[EBP+8] ; IT
 mov EAX,[EBX]
 sal EAX,2
 add EAX,TOKENS
 mov EAX,[EAX]
 sar EAX,28
 and EAX,7
 mov [LKIND],EAX
;    OP=TOKENS(IT+2) AND 255;
;.GEN =OP,=TOKENS,IT,=2,.BC+,=2,.BNSHL,.BC+,.UA,=255,.BCAND,.BNST,
; L D IT
 mov EBX,[EBP+8] ; IT
 mov EAX,[EBX]
 add EAX,2
 sal EAX,2
 add EAX,TOKENS
 mov EAX,[EAX]
 and EAX,255
 mov [OP],EAX
;    IF LKIND EQ 4; THEN IF OP EQ 54;
;.GEN LKIND,=4,.BN-,
 mov EAX,[LKIND]
 sub EAX,4
 jne LJ13
;.GEN OP,=54,.BN-,
 mov EAX,[OP]
 sub EAX,54
;      THEN RETURN 1;
 jne LJ14
;.GEN =1,
 mov EAX,1
; RETN  ISASLA,1
 mov ESP,EBP
 pop EBP
 ret
;    ENDIF ENDIF
LJ14:
LJ13:
;    RETURN 0;
;.GEN =0,
 mov EAX,0
; RETN  ISASLA,1
 mov ESP,EBP
 pop EBP
 ret
;  ENDPROC
;
;  PROC ISALP(IT);                  * is a left parenthesis
; SUBR  ISALP
ISALP:
 push EBP
 mov  EBP,ESP
; NPARS  1
; PAR  IT
; PEND
;    LKIND=TOKENS(IT) SHR 28 AND 7;
;.GEN =LKIND,=TOKENS,IT,=2,.BNSHL,.BC+,.UA,=28,.BNSHR,=7,.BCAND,.BNST,
; L D IT
 mov EBX,[EBP+8] ; IT
 mov EAX,[EBX]
 sal EAX,2
 add EAX,TOKENS
 mov EAX,[EAX]
 sar EAX,28
 and EAX,7
 mov [LKIND],EAX
;    OP=TOKENS(IT+2) AND 255;
;.GEN =OP,=TOKENS,IT,=2,.BC+,=2,.BNSHL,.BC+,.UA,=255,.BCAND,.BNST,
; L D IT
 mov EBX,[EBP+8] ; IT
 mov EAX,[EBX]
 add EAX,2
 sal EAX,2
 add EAX,TOKENS
 mov EAX,[EAX]
 and EAX,255
 mov [OP],EAX
;    IF LKIND EQ 4; THEN IF OP EQ 64;
;.GEN LKIND,=4,.BN-,
 mov EAX,[LKIND]
 sub EAX,4
 jne LJ15
;.GEN OP,=64,.BN-,
 mov EAX,[OP]
 sub EAX,64
;      THEN RETURN 1;
 jne LJ16
;.GEN =1,
 mov EAX,1
; RETN  ISALP,1
 mov ESP,EBP
 pop EBP
 ret
;    ENDIF ENDIF
LJ16:
LJ15:
;    RETURN 0;
;.GEN =0,
 mov EAX,0
; RETN  ISALP,1
 mov ESP,EBP
 pop EBP
 ret
;  ENDPROC
;
;  PROC ISARP(IT);                  * is a right parenthesis
; SUBR  ISARP
ISARP:
 push EBP
 mov  EBP,ESP
; NPARS  1
; PAR  IT
; PEND
;    LKIND=TOKENS(IT) SHR 28 AND 7;
;.GEN =LKIND,=TOKENS,IT,=2,.BNSHL,.BC+,.UA,=28,.BNSHR,=7,.BCAND,.BNST,
; L D IT
 mov EBX,[EBP+8] ; IT
 mov EAX,[EBX]
 sal EAX,2
 add EAX,TOKENS
 mov EAX,[EAX]
 sar EAX,28
 and EAX,7
 mov [LKIND],EAX
;    OP=TOKENS(IT+2) AND 255;
;.GEN =OP,=TOKENS,IT,=2,.BC+,=2,.BNSHL,.BC+,.UA,=255,.BCAND,.BNST,
; L D IT
 mov EBX,[EBP+8] ; IT
 mov EAX,[EBX]
 add EAX,2
 sal EAX,2
 add EAX,TOKENS
 mov EAX,[EAX]
 and EAX,255
 mov [OP],EAX
;    IF LKIND EQ 4; THEN IF OP EQ 65;
;.GEN LKIND,=4,.BN-,
 mov EAX,[LKIND]
 sub EAX,4
 jne LJ17
;.GEN OP,=65,.BN-,
 mov EAX,[OP]
 sub EAX,65
;      THEN RETURN 1;
 jne LJ18
;.GEN =1,
 mov EAX,1
; RETN  ISARP,1
 mov ESP,EBP
 pop EBP
 ret
;    ENDIF ENDIF
LJ18:
LJ17:
;    RETURN 0;
;.GEN =0,
 mov EAX,0
; RETN  ISARP,1
 mov ESP,EBP
 pop EBP
 ret
;  ENDPROC
;
;  PROC ISASEMI(IT);                * is a semicolon
; SUBR  ISASEMI
ISASEMI:
 push EBP
 mov  EBP,ESP
; NPARS  1
; PAR  IT
; PEND
;    LKIND=TOKENS(IT) SHR 28 AND 7;
;.GEN =LKIND,=TOKENS,IT,=2,.BNSHL,.BC+,.UA,=28,.BNSHR,=7,.BCAND,.BNST,
; L D IT
 mov EBX,[EBP+8] ; IT
 mov EAX,[EBX]
 sal EAX,2
 add EAX,TOKENS
 mov EAX,[EAX]
 sar EAX,28
 and EAX,7
 mov [LKIND],EAX
;    OP=TOKENS(IT+2) AND 255;
;.GEN =OP,=TOKENS,IT,=2,.BC+,=2,.BNSHL,.BC+,.UA,=255,.BCAND,.BNST,
; L D IT
 mov EBX,[EBP+8] ; IT
 mov EAX,[EBX]
 add EAX,2
 sal EAX,2
 add EAX,TOKENS
 mov EAX,[EAX]
 and EAX,255
 mov [OP],EAX
;    IF LKIND EQ 4; THEN IF OP EQ 63;
;.GEN LKIND,=4,.BN-,
 mov EAX,[LKIND]
 sub EAX,4
 jne LJ19
;.GEN OP,=63,.BN-,
 mov EAX,[OP]
 sub EAX,63
;      THEN RETURN 1;
 jne LJ20
;.GEN =1,
 mov EAX,1
; RETN  ISASEMI,1
 mov ESP,EBP
 pop EBP
 ret
;    ENDIF ENDIF
LJ20:
LJ19:
;    RETURN 0;
;.GEN =0,
 mov EAX,0
; RETN  ISASEMI,1
 mov ESP,EBP
 pop EBP
 ret
;  ENDPROC
;
;  PROC ISAEQU(IT);                * is an equal sign
; SUBR  ISAEQU
ISAEQU:
 push EBP
 mov  EBP,ESP
; NPARS  1
; PAR  IT
; PEND
;    LKIND=TOKENS(IT) SHR 28 AND 7;
;.GEN =LKIND,=TOKENS,IT,=2,.BNSHL,.BC+,.UA,=28,.BNSHR,=7,.BCAND,.BNST,
; L D IT
 mov EBX,[EBP+8] ; IT
 mov EAX,[EBX]
 sal EAX,2
 add EAX,TOKENS
 mov EAX,[EAX]
 sar EAX,28
 and EAX,7
 mov [LKIND],EAX
;    OP=TOKENS(IT+2) AND 255;
;.GEN =OP,=TOKENS,IT,=2,.BC+,=2,.BNSHL,.BC+,.UA,=255,.BCAND,.BNST,
; L D IT
 mov EBX,[EBP+8] ; IT
 mov EAX,[EBX]
 add EAX,2
 sal EAX,2
 add EAX,TOKENS
 mov EAX,[EAX]
 and EAX,255
 mov [OP],EAX
;    IF LKIND EQ 4; THEN IF OP EQ 67;
;.GEN LKIND,=4,.BN-,
 mov EAX,[LKIND]
 sub EAX,4
 jne LJ21
;.GEN OP,=67,.BN-,
 mov EAX,[OP]
 sub EAX,67
;      THEN RETURN 1;
 jne LJ22
;.GEN =1,
 mov EAX,1
; RETN  ISAEQU,1
 mov ESP,EBP
 pop EBP
 ret
;    ENDIF ENDIF
LJ22:
LJ21:
;    RETURN 0;
;.GEN =0,
 mov EAX,0
; RETN  ISAEQU,1
 mov ESP,EBP
 pop EBP
 ret
;  ENDPROC
;
;END
 end
