;* LEX.S1 -- Lexical Scanner for Small, CRB, Oct 11,2007
;* Testing, CRB, Oct 24, 2012
;* Restoring State matrix to original, CRB, Oct 30, 2012
;* Fix end of line detection, CRB, Jan 13, 2014
;
;    BEGIN LEX;
 global progr
 extern exit
;    ENTRY LEX;
 global  LEX
;    EXTERN BUFF;
 extern  BUFF
;
;* character type codes
;* T array is indexed by 7-bit ASCII character code using zero indexing
;      DCL  T=( 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1); * 1 space
 section .data
T:
 dd  1
 dd  1
 dd  1
 dd  1
 dd  1
 dd  1
 dd  1
 dd  1
 dd  1
 dd  1
 dd  1
 dd  1
 dd  1
 dd  1
 dd  1
 dd  1
;      DCL T2=( 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1); * 2 alphabetic
T2:
 dd  1
 dd  1
 dd  1
 dd  1
 dd  1
 dd  1
 dd  1
 dd  1
 dd  1
 dd  1
 dd  1
 dd  1
 dd  1
 dd  1
 dd  1
 dd  1
;      DCL T3=( 1, 5, 5, 5, 5, 5, 5, 4, 5, 5, 5, 5, 5, 5, 5, 5); * 3 digit
T3:
 dd  1
 dd  5
 dd  5
 dd  5
 dd  5
 dd  5
 dd  5
 dd  4
 dd  5
 dd  5
 dd  5
 dd  5
 dd  5
 dd  5
 dd  5
 dd  5
;      DCL T4=( 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 5, 5, 5, 5, 5, 5); * 4 quote mark
T4:
 dd  3
 dd  3
 dd  3
 dd  3
 dd  3
 dd  3
 dd  3
 dd  3
 dd  3
 dd  3
 dd  5
 dd  5
 dd  5
 dd  5
 dd  5
 dd  5
;      DCL T5=( 5, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2); * 5 other
T5:
 dd  5
 dd  2
 dd  2
 dd  2
 dd  2
 dd  2
 dd  2
 dd  2
 dd  2
 dd  2
 dd  2
 dd  2
 dd  2
 dd  2
 dd  2
 dd  2
;      DCL T6=( 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 5, 5, 5, 5, 5); 
T6:
 dd  2
 dd  2
 dd  2
 dd  2
 dd  2
 dd  2
 dd  2
 dd  2
 dd  2
 dd  2
 dd  2
 dd  5
 dd  5
 dd  5
 dd  5
 dd  5
;      DCL T7=( 5, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2); 
T7:
 dd  5
 dd  2
 dd  2
 dd  2
 dd  2
 dd  2
 dd  2
 dd  2
 dd  2
 dd  2
 dd  2
 dd  2
 dd  2
 dd  2
 dd  2
 dd  2
;      DCL T8=( 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 5, 5, 5, 5, 5);
T8:
 dd  2
 dd  2
 dd  2
 dd  2
 dd  2
 dd  2
 dd  2
 dd  2
 dd  2
 dd  2
 dd  2
 dd  5
 dd  5
 dd  5
 dd  5
 dd  5
;
;    DCL S=30;                   * S(0) contains size
S:
 dd  30
;      DCL S1=( 1, 2, 3, 4, 6);  * offset 0    1 spaces
S1:
 dd  1
 dd  2
 dd  3
 dd  4
 dd  6
;      DCL S2=(-1, 2, 2,-1,-1);  * offset 5    2 name
S2:
 dd  -1
 dd  2
 dd  2
 dd  -1
 dd  -1
;      DCL S3=(-2,-2, 3,-2,-2);  * offset 10   3 integer
S3:
 dd  -2
 dd  -2
 dd  3
 dd  -2
 dd  -2
;      DCL S4=( 4, 4, 4, 5, 4);  * offset 15   4 quoted string
S4:
 dd  4
 dd  4
 dd  4
 dd  5
 dd  4
;      DCL S5=(-3,-3,-3, 4,-3);  * offset 20   5 other
S5:
 dd  -3
 dd  -3
 dd  -3
 dd  4
 dd  -3
;      DCL S6=(-4,-4,-4,-4,-4);  * offset 25
S6:
 dd  -4
 dd  -4
 dd  -4
 dd  -4
 dd  -4
;    DCL SROW=( 6, 0, 5,10,15,20,25); * aux offset vector
SROW:
 dd  6
 dd  0
 dd  5
 dd  10
 dd  15
 dd  20
 dd  25
;
;    DCL CTYPE;     * type of character
CTYPE:
 times 1 dd 0
;    DCL STATE;     * state variable
STATE:
 times 1 dd 0
;    DCL KIND;      * kind of token 1: name, 2: int, 3: string, 4, spc
KIND:
 times 1 dd 0
;    DCL I;         * local character index in BUFF
I:
 times 1 dd 0
;    DCL CHAR;      * current local character
CHAR:
 times 1 dd 0
;    DCL J;         * index output character in LEXEME
J:
 times 1 dd 0
;*---------------
;    PROC LEX(INEXT,LEXEME);
 section .text
; SUBR  LEX
LEX:
 push EBP
 mov  EBP,ESP
; NPARS  2
; PAR  INEXT
; PAR  LEXEME
; PEND
;      STATE=1;     * initialize current state
;.GEN =STATE,=1,.BNST,
 mov EAX,1
 mov [STATE],EAX
;      I=INEXT;
;.GEN =I,INEXT,.BNST,
; L D INEXT
 mov EBX,[EBP+12] ; INEXT
 mov EAX,[EBX]
 mov [I],EAX
;      J=1;
;.GEN =J,=1,.BNST,
 mov EAX,1
 mov [J],EAX
;      REPEAT 
LJ1:
;        CHAR=BUFF(I);
;.GEN =CHAR,=BUFF,I,=2,.BNSHL,.BC+,.UA,.BNST,
 mov EAX,[I]
 sal EAX,2
 add EAX,BUFF
 mov EAX,[EAX]
 mov [CHAR],EAX
;        IF CHAR EQ -1; THEN     * end of line
;.GEN CHAR,=1,.U-,.BN-,
 mov EAX,1
 neg EAX
 mov [T1Z],EAX
 mov EAX,[CHAR]
 sub EAX,[T1Z]
 jne LJ3
;          LEXEME=J-1;
;.GEN =LEXEME,J,=1,.BN-,.BNST,
 mov EAX,[J]
 dec EAX
; ST D LEXEME
 mov EBX,[EBP+8] ; LEXEME
 mov [EBX],EAX
;          EXIT
 jmp LJ2
;        ENDIF
LJ3:
;        CTYPE=T(CHAR);  * get character type
;.GEN =CTYPE,=T,CHAR,=2,.BNSHL,.BC+,.UA,.BNST,
 mov EAX,[CHAR]
 sal EAX,2
 add EAX,T
 mov EAX,[EAX]
 mov [CTYPE],EAX
;        STATE=S(SROW(STATE)+CTYPE);
;.GEN =STATE,=S,=SROW,STATE,=2,.BNSHL,.BC+,.UA,CTYPE,.BC+,=2,.BNSHL,.BC+,.UA,.BNST,
 mov EAX,[STATE]
 sal EAX,2
 add EAX,SROW
 mov EAX,[EAX]
 add EAX,[CTYPE]
 sal EAX,2
 add EAX,S
 mov EAX,[EAX]
 mov [STATE],EAX
;        IF STATE LT 0; THEN 
;.GEN STATE,=0,.BN-,
 mov EAX,[STATE]
 or EAX,EAX
 jge LJ4
;          LEXEME=J-1;   * set length of lexeme string
;.GEN =LEXEME,J,=1,.BN-,.BNST,
 mov EAX,[J]
 dec EAX
; ST D LEXEME
 mov EBX,[EBP+8] ; LEXEME
 mov [EBX],EAX
;          EXIT 
 jmp LJ2
;        ELSE 
 jmp LJ5
LJ4:
;          IF STATE NE 1; THEN   * skip white space
;.GEN STATE,=1,.BN-,
 mov EAX,[STATE]
 dec EAX
 jz LJ6
;            LEXEME(J)=CHAR;
;.GEN =LEXEME,J,=2,.BNSHL,.BC+,CHAR,.BNST,
 mov EAX,[J]
 sal EAX,2
; + D =LEXEME
 mov EBX,[EBP+8] ; LEXEME
 add EAX,EBX
 mov [T1Z],EAX
 mov EAX,[CHAR]
 mov EDX,EAX
 mov EAX,[T1Z]
 mov [EAX],EDX
;            J=J+1;
;.GEN =J,J,=1,.BC+,.BNST,
 mov EAX,[J]
 inc EAX
 mov [J],EAX
;          ENDIF
LJ6:
;        ENDIF
LJ5:
;        I=I+1;
;.GEN =I,I,=1,.BC+,.BNST,
 mov EAX,[I]
 inc EAX
 mov [I],EAX
;      UNTIL STATE LT 0;
;.GEN STATE,=0,.BN-,
 mov EAX,[STATE]
 or EAX,EAX
 jge LJ1
LJ2:
;      INEXT=I;
;.GEN =INEXT,I,.BNST,
 mov EAX,[I]
; ST D INEXT
 mov EBX,[EBP+12] ; INEXT
 mov [EBX],EAX
;      KIND=-STATE;
;.GEN =KIND,STATE,.U-,.BNST,
 mov EAX,[STATE]
 neg EAX
 mov [KIND],EAX
;      RETURN KIND;
;.GEN KIND,
 mov EAX,[KIND]
; RETN  LEX,2
 mov ESP,EBP
 pop EBP
 ret
;    ENDPROC
 section .data
T1Z:
 times 2 dd 0
 section .text
;  END
 end
