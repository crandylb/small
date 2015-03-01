;* SYMACC.S1 -- Symbol Table Access Module for Small, CRB, Feb 9, 2014
;* 03/14/2014 CRB Add COLLS collision counter
;* 03/20/2014 CRB Move MASKV initialization to initsym, other corrections
;* 03/29/2014 CRB Add A2B40L for use with LEX
;* 04/28/2014 CRB Fix bug in A2B40L and use MASKV for LEN
;* 11/30/2014 CRB Correct comment in DCL TABLE
;* 12/06/2014 CRB Add MASKW initialized in initsym
;* 12/08/2014 CRB Further adjustment for negative packed characters
;* 12/10/2014 CRB Add MOD40K = 53687091
;* 12/12/2014 CRB Initialize VAL and TAG to 0 for new name
;* 12/16/2014 CRB Adjust B402A for negative packed name
;* 02/17/2015 CRB Clean up blank line at139
;
;BEGIN SYMACC;
 global progr
 extern exit
;* Symbols are stored in an array called TABLE that is indexed by a hash
;* function on the first six characters of a name. Each symbol occupies
;* two 32-bit words in the table. The first word contains the compressed
;* base 40 representation of the symbol, and the second word contains the
;* 16-bit VAL and TAG words.
;
;  ENTRY LOOKS,GETS,PUTS,GETWRD; * symbol table acces procedures
 global  LOOKS
 global  GETS
 global  PUTS
 global  GETWRD
;  ENTRY A2B40,A2B40L,B402A;     * ASCII, B40 conversion
 global  A2B40
 global  A2B40L
 global  B402A
;  ENTRY COLLS;                  * Collision counter
 global  COLLS
;  ENTRY MASKV,MASKW,MOD40K;
 global  MASKV
 global  MASKW
 global  MOD40K
;
;  SET TABSIZ=8191;              * prime < 2^13
;  DCL TABLE(TABSIZ);            * table < 2^15 bytes, 4094 symbols
 section .data
TABLE:
 times 8192 dd 0
;  DCL STRING(6);                * space to hold converted ASCII string
STRING:
 times 7 dd 0
;  DCL I,J,CHAR,LEN,B,CODE;      * local variables
I:
 times 1 dd 0
J:
 times 1 dd 0
CHAR:
 times 1 dd 0
LEN:
 times 1 dd 0
B:
 times 1 dd 0
CODE:
 times 1 dd 0
;  DCL MASKE=-2;                 * mask for even number
MASKE:
 dd  -2
;  DCL MASKV=65535;              * mask for low 16 bits
MASKV:
 dd  -1
;  DCL MASKW;                    * mask for signed 32 bits (init in initsym)
MASKW:
 times 1 dd 0
;  DCL MOD40K;                   * use for negative mod 40: 53617091
MOD40K:
 times 1 dd 0
;  DCL COLFLG,COLLS=0;           * collision counter on insertion only
COLFLG:
 times 1 dd 0
COLLS:
 dd  0
;  DCL ANC;                      * anchor
ANC:
 times 1 dd 0
;
;* Convert ASCII STR to base 40 CODE packing 6 characters in 32 bit word
;* Only upper case letters and decimal digits are allowed
;* Return the 32-bit CODE value
;******************************
;PROC A2B40(STR);                * convert ASCII string to base 40
 section .text
; SUBR  A2B40
A2B40:
 push EBP
 mov  EBP,ESP
; NPARS  1
; PAR  STR
; PEND
;  LEN=STR;                      * get length of string
;.GEN =LEN,STR,.BNST,
; L D STR
 mov EBX,[EBP+8] ; STR
 mov EAX,[EBX]
 mov [LEN],EAX
;  IF LEN GT 6; THEN 
;.GEN LEN,=6,.BN-,
 mov EAX,[LEN]
 sub EAX,6
 jle LJ1
;    LEN=6;                      * truncate length to 6
;.GEN =LEN,=6,.BNST,
 mov EAX,6
 mov [LEN],EAX
;    ENDIF
LJ1:
;  I=LEN;
;.GEN =I,LEN,.BNST,
 mov EAX,[LEN]
 mov [I],EAX
;  CODE=0;                       * init B40 code
;.GEN =CODE,=0,.BNST,
 mov EAX,0
 mov [CODE],EAX
;  DO WHILE I GT 0;
LJ2:
;.GEN I,=0,.BN-,
 mov EAX,[I]
 or EAX,EAX
 jle LJ3
;    CHAR=STR(I);                * read charaters in reverse order
;.GEN =CHAR,=STR,I,=2,.BNSHL,.BC+,.UA,.BNST,
 mov EAX,[I]
 sal EAX,2
; + D =STR
 mov EBX,[EBP+8] ; STR
 add EAX,EBX
 mov EAX,[EAX]
 mov [CHAR],EAX
;    IF CHAR LE 57; THEN 
;.GEN CHAR,=57,.BN-,
 mov EAX,[CHAR]
 sub EAX,57
 jg LJ4
;      B=CHAR-21;                * digits 0..9 -> 27..36
;.GEN =B,CHAR,=21,.BN-,.BNST,
 mov EAX,[CHAR]
 sub EAX,21
 mov [B],EAX
;    ELSE IF CHAR LE 90; THEN 
 jmp LJ5
LJ4:
;.GEN CHAR,=90,.BN-,
 mov EAX,[CHAR]
 sub EAX,90
 jg LJ6
;      B=CHAR-64;                * upper case A..Z -> 1..26
;.GEN =B,CHAR,=64,.BN-,.BNST,
 mov EAX,[CHAR]
 sub EAX,64
 mov [B],EAX
;    ELSE IF CHAR LE 122; THEN 
 jmp LJ7
LJ6:
;.GEN CHAR,=122,.BN-,
 mov EAX,[CHAR]
 sub EAX,122
 jg LJ8
;      B=CHAR-96;                * lower case a..z -> 1..26
;.GEN =B,CHAR,=96,.BN-,.BNST,
 mov EAX,[CHAR]
 sub EAX,96
 mov [B],EAX
;      ENDIF ENDIF ENDIF
LJ8:
LJ7:
LJ5:
;    CODE=40*CODE+B;             * calculate base 40 code
;.GEN =CODE,=40,CODE,.BC*,B,.BC+,.BNST,
 mov EAX,40
 imul dword [CODE]
 add EAX,[B]
 mov [CODE],EAX
;    I=I-1;                      * decrement I for next character
;.GEN =I,I,=1,.BN-,.BNST,
 mov EAX,[I]
 dec EAX
 mov [I],EAX
;    ENDDO
 jmp LJ2
LJ3:
;  RETURN CODE;                  * return accumulated base 40 code
;.GEN CODE,
 mov EAX,[CODE]
; RETN  A2B40,1
 mov ESP,EBP
 pop EBP
 ret
;  ENDPROC
;
;* Use this version to grab a token from a substring
;* SUBSTR contains length SHL 8 and anchor starting index
;******************************
;PROC A2B40L(SUBSTR,STR);        * convert ASCII string to base 40
; SUBR  A2B40L
A2B40L:
 push EBP
 mov  EBP,ESP
; NPARS  2
; PAR  SUBSTR
; PAR  STR
; PEND
;  ANC=SUBSTR AND 255;           * get anchor starting index
;.GEN =ANC,SUBSTR,=255,.BCAND,.BNST,
; L D SUBSTR
 mov EBX,[EBP+12] ; SUBSTR
 mov EAX,[EBX]
 and EAX,255
 mov [ANC],EAX
;  LEN=SUBSTR SHR 8 AND 255;     * get length of string
;.GEN =LEN,SUBSTR,=8,.BNSHR,=255,.BCAND,.BNST,
; L D SUBSTR
 mov EBX,[EBP+12] ; SUBSTR
 mov EAX,[EBX]
 sar EAX,8
 and EAX,255
 mov [LEN],EAX
;  IF LEN GT 6; THEN 
;.GEN LEN,=6,.BN-,
 mov EAX,[LEN]
 sub EAX,6
 jle LJ9
;    LEN=6;                      * truncate length to 6
;.GEN =LEN,=6,.BNST,
 mov EAX,6
 mov [LEN],EAX
;    ENDIF
LJ9:
;  I=ANC+LEN-1;                    * start at end of token string
;.GEN =I,ANC,LEN,.BC+,=1,.BN-,.BNST,
 mov EAX,[ANC]
 add EAX,[LEN]
 dec EAX
 mov [I],EAX
;  CODE=0;                       * init B40 code
;.GEN =CODE,=0,.BNST,
 mov EAX,0
 mov [CODE],EAX
;  DO WHILE I GE ANC;
LJ10:
;.GEN I,ANC,.BN-,
 mov EAX,[I]
 sub EAX,[ANC]
 jl LJ11
;    CHAR=STR(I);                * read charaters in reverse order
;.GEN =CHAR,=STR,I,=2,.BNSHL,.BC+,.UA,.BNST,
 mov EAX,[I]
 sal EAX,2
; + D =STR
 mov EBX,[EBP+8] ; STR
 add EAX,EBX
 mov EAX,[EAX]
 mov [CHAR],EAX
;    IF CHAR LE 57; THEN 
;.GEN CHAR,=57,.BN-,
 mov EAX,[CHAR]
 sub EAX,57
 jg LJ12
;      B=CHAR-21;                * digits 0..9 -> 27..36
;.GEN =B,CHAR,=21,.BN-,.BNST,
 mov EAX,[CHAR]
 sub EAX,21
 mov [B],EAX
;    ELSE IF CHAR LE 90; THEN 
 jmp LJ13
LJ12:
;.GEN CHAR,=90,.BN-,
 mov EAX,[CHAR]
 sub EAX,90
 jg LJ14
;      B=CHAR-64;                * upper case A..Z -> 1..26
;.GEN =B,CHAR,=64,.BN-,.BNST,
 mov EAX,[CHAR]
 sub EAX,64
 mov [B],EAX
;    ELSE IF CHAR LE 122; THEN 
 jmp LJ15
LJ14:
;.GEN CHAR,=122,.BN-,
 mov EAX,[CHAR]
 sub EAX,122
 jg LJ16
;      B=CHAR-96;                * lower case a..z -> 1..26
;.GEN =B,CHAR,=96,.BN-,.BNST,
 mov EAX,[CHAR]
 sub EAX,96
 mov [B],EAX
;      ENDIF ENDIF ENDIF
LJ16:
LJ15:
LJ13:
;    CODE=40*CODE+B;             * calculate base 40 code
;.GEN =CODE,=40,CODE,.BC*,B,.BC+,.BNST,
 mov EAX,40
 imul dword [CODE]
 add EAX,[B]
 mov [CODE],EAX
;    I=I-1;                      * decrement I for next character
;.GEN =I,I,=1,.BN-,.BNST,
 mov EAX,[I]
 dec EAX
 mov [I],EAX
;    ENDDO
 jmp LJ10
LJ11:
;  RETURN CODE;                  * return accumulated base 40 code
;.GEN CODE,
 mov EAX,[CODE]
; RETN  A2B40L,2
 mov ESP,EBP
 pop EBP
 ret
;  ENDPROC
;
;* Convert base 40 code to ASCII in NAME
;* No return value
;*****************
;PROC B402A(B40,NAME);           * convert base 40 to ASCII string
; SUBR  B402A
B402A:
 push EBP
 mov  EBP,ESP
; NPARS  2
; PAR  B40
; PAR  NAME
; PEND
;  B=B40;
;.GEN =B,B40,.BNST,
; L D B40
 mov EBX,[EBP+12] ; B40
 mov EAX,[EBX]
 mov [B],EAX
;  IF B LT 0; THEN               * adjust for negative base 40 code
;.GEN B,=0,.BN-,
 mov EAX,[B]
 or EAX,EAX
 jge LJ17
;      B=(B AND MASKW)+8;
;.GEN =B,B,MASKW,.BCAND,=8,.BC+,.BNST,
 mov EAX,[B]
 and EAX,[MASKW]
 add EAX,8
 mov [B],EAX
;      CHAR=B MOD 40;
;.GEN =CHAR,B,=40,.BNMOD,.BNST,
 mov EAX,[B]
 cdq
 mov  ECX,40
 idiv dword ECX
 mov  EAX,EDX
 mov [CHAR],EAX
;      B=B/40+MOD40K;
;.GEN =B,B,=40,.BN/,MOD40K,.BC+,.BNST,
 mov EAX,[B]
 cdq
 mov  ECX,40
 idiv dword ECX
 add EAX,[MOD40K]
 mov [B],EAX
;    ELSE 
 jmp LJ18
LJ17:
;      CHAR=B MOD 40;
;.GEN =CHAR,B,=40,.BNMOD,.BNST,
 mov EAX,[B]
 cdq
 mov  ECX,40
 idiv dword ECX
 mov  EAX,EDX
 mov [CHAR],EAX
;      B=B/40;
;.GEN =B,B,=40,.BN/,.BNST,
 mov EAX,[B]
 cdq
 mov  ECX,40
 idiv dword ECX
 mov [B],EAX
;    ENDIF
LJ18:
;  I=1;
;.GEN =I,=1,.BNST,
 mov EAX,1
 mov [I],EAX
;  REPEAT 
LJ19:
;    IF CHAR LE 26;
;.GEN CHAR,=26,.BN-,
 mov EAX,[CHAR]
 sub EAX,26
;      THEN CHAR=CHAR+64;        * upper case letter
 jg LJ21
;.GEN =CHAR,CHAR,=64,.BC+,.BNST,
 mov EAX,[CHAR]
 add EAX,64
 mov [CHAR],EAX
;      ELSE CHAR=CHAR+21;        * decimal digit
 jmp LJ22
LJ21:
;.GEN =CHAR,CHAR,=21,.BC+,.BNST,
 mov EAX,[CHAR]
 add EAX,21
 mov [CHAR],EAX
;      ENDIF
LJ22:
;    NAME(I)=CHAR;               * put character in name string
;.GEN =NAME,I,=2,.BNSHL,.BC+,CHAR,.BNST,
 mov EAX,[I]
 sal EAX,2
; + D =NAME
 mov EBX,[EBP+8] ; NAME
 add EAX,EBX
 mov [T5Z],EAX
 mov EAX,[CHAR]
 mov EDX,EAX
 mov EAX,[T5Z]
 mov [EAX],EDX
;    I=I+1;
;.GEN =I,I,=1,.BC+,.BNST,
 mov EAX,[I]
 inc EAX
 mov [I],EAX
;    CHAR=B MOD 40;
;.GEN =CHAR,B,=40,.BNMOD,.BNST,
 mov EAX,[B]
 cdq
 mov  ECX,40
 idiv dword ECX
 mov  EAX,EDX
 mov [CHAR],EAX
;    B=B/40;
;.GEN =B,B,=40,.BN/,.BNST,
 mov EAX,[B]
 cdq
 mov  ECX,40
 idiv dword ECX
 mov [B],EAX
;    IF CHAR EQ 0;
;.GEN CHAR,=0,.BN-,
 mov EAX,[CHAR]
 or EAX,EAX
;      THEN EXIT
 jne LJ23
 jmp LJ20
;      ENDIF
LJ23:
;    UNTIL I GT 6;
;.GEN I,=6,.BN-,
 mov EAX,[I]
 sub EAX,6
 jle LJ19
LJ20:
;  NAME=I-1;                     * set string length
;.GEN =NAME,I,=1,.BN-,.BNST,
 mov EAX,[I]
 dec EAX
; ST D NAME
 mov EBX,[EBP+8] ; NAME
 mov [EBX],EAX
;  RETURN
; RETN  B402A,2
 mov ESP,EBP
 pop EBP
 ret
;  ENDPROC
 section .data
T5Z:
 times 2 dd 0
 section .text
;
;* Look up a packed symbol (WORDS) in TABLE
;* Insert the new symbol with VAL and TAG if not already in TABLE
;* If collision use next empty slot, if TABLE full return -1
;* If existing entry found return VAL and TAG from TABLE
;* Return value is index of entry in TABLE
;*****************************************
;PROC LOOKS(WORDS,VAL,TAG);      * look up or insert symbol
; SUBR  LOOKS
LOOKS:
 push EBP
 mov  EBP,ESP
; NPARS  3
; PAR  WORDS
; PAR  VAL
; PAR  TAG
; PEND
;  COLFLG=0;                     * reset collision flag
;.GEN =COLFLG,=0,.BNST,
 mov EAX,0
 mov [COLFLG],EAX
;  J=WORDS;
;.GEN =J,WORDS,.BNST,
; L D WORDS
 mov EBX,[EBP+16] ; WORDS
 mov EAX,[EBX]
 mov [J],EAX
;  IF J LT 0; THEN               * fix problem with negative WORDS
;.GEN J,=0,.BN-,
 mov EAX,[J]
 or EAX,EAX
 jge LJ24
;      J=(J AND MASKW)+32;       * remove sign bit, adjust remainder
;.GEN =J,J,MASKW,.BCAND,=32,.BC+,.BNST,
 mov EAX,[J]
 and EAX,[MASKW]
 add EAX,32
 mov [J],EAX
;    ENDIF
LJ24:
;  I=(J MOD TABSIZ) AND MASKE;   * use only even index
;.GEN =I,J,TABSIZ,.BNMOD,MASKE,.BCAND,.BNST,
 mov EAX,[J]
; MOD 8191 TABSIZ
 cdq
 mov  ECX,8191
 idiv dword ECX
 mov  EAX,EDX
 and EAX,[MASKE]
 mov [I],EAX
;  J=I;                          * save starting position
;.GEN =J,I,.BNST,
 mov EAX,[I]
 mov [J],EAX
;  REPEAT 
LJ25:
;    IF TABLE(I) EQ 0;           * found empty slot
;.GEN =TABLE,I,=2,.BNSHL,.BC+,.UA,=0,.BN-,
 mov EAX,[I]
 sal EAX,2
 add EAX,TABLE
 mov EAX,[EAX]
 or EAX,EAX
;      THEN TABLE(I)=WORDS;      * insert symbol
 jne LJ27
;.GEN =TABLE,I,=2,.BNSHL,.BC+,WORDS,.BNST,
 mov EAX,[I]
 sal EAX,2
 add EAX,TABLE
 mov [T7Z],EAX
; L D WORDS
 mov EBX,[EBP+16] ; WORDS
 mov EAX,[EBX]
 mov EDX,EAX
 mov EAX,[T7Z]
 mov [EAX],EDX
;        IF TAG;                 * new symbol name if TAG is zero
;.GEN TAG,=0,.BN-,
; L D TAG
 mov EBX,[EBP+8] ; TAG
 mov EAX,[EBX]
 or EAX,EAX
;          THEN TABLE(I+1)=TAG SHL 16 OR VAL; * pack VAL and TAG
 jz LJ28
;.GEN =TABLE,I,=1,.BC+,=2,.BNSHL,.BC+,TAG,=16,.BNSHL,VAL,.BCOR,.BNST,
 mov EAX,[I]
 inc EAX
 sal EAX,2
 add EAX,TABLE
 mov [T7Z1],EAX
; L D TAG
 mov EBX,[EBP+8] ; TAG
 mov EAX,[EBX]
 sal EAX,16
; OR D VAL
 mov EBX,[EBP+12] ; VAL
 or EAX,[EBX]
 mov EDX,EAX
 mov EAX,[T7Z1]
 mov [EAX],EDX
;          ELSE TABLE(I+1)=0;    * set VAL and TAG to 0 for new name
 jmp LJ29
LJ28:
;.GEN =TABLE,I,=1,.BC+,=2,.BNSHL,.BC+,=0,.BNST,
 mov EAX,[I]
 inc EAX
 sal EAX,2
 add EAX,TABLE
 mov [T7Z],EAX
 mov EAX,0
 mov EDX,EAX
 mov EAX,[T7Z]
 mov [EAX],EDX
;          ENDIF
LJ29:
;        IF COLFLG; THEN         * if collision flag on then
;.GEN COLFLG,=0,.BN-,
 mov EAX,[COLFLG]
 or EAX,EAX
 jz LJ30
;          COLLS=COLLS+1;        * count collisions on insertion
;.GEN =COLLS,COLLS,=1,.BC+,.BNST,
 mov EAX,[COLLS]
 inc EAX
 mov [COLLS],EAX
;          ENDIF
LJ30:
;        RETURN I;
;.GEN I,
 mov EAX,[I]
; RETN  LOOKS,3
 mov ESP,EBP
 pop EBP
 ret
;      ELSE IF TABLE(I) EQ WORDS; * found match
 jmp LJ31
LJ27:
;.GEN =TABLE,I,=2,.BNSHL,.BC+,.UA,WORDS,.BN-,
 mov EAX,[I]
 sal EAX,2
 add EAX,TABLE
 mov EAX,[EAX]
; - D WORDS
 mov EBX,[EBP+16] ; WORDS
 sub EAX,[EBX]
;      THEN B=TABLE(I+1);        * retrieve VAL and TAG
 jne LJ32
;.GEN =B,=TABLE,I,=1,.BC+,=2,.BNSHL,.BC+,.UA,.BNST,
 mov EAX,[I]
 inc EAX
 sal EAX,2
 add EAX,TABLE
 mov EAX,[EAX]
 mov [B],EAX
;        VAL=B AND MASKV;
;.GEN =VAL,B,MASKV,.BCAND,.BNST,
 mov EAX,[B]
 and EAX,[MASKV]
; ST D VAL
 mov EBX,[EBP+12] ; VAL
 mov [EBX],EAX
;        TAG=(B SHR 16) AND MASKV;
;.GEN =TAG,B,=16,.BNSHR,MASKV,.BCAND,.BNST,
 mov EAX,[B]
 sar EAX,16
 and EAX,[MASKV]
; ST D TAG
 mov EBX,[EBP+8] ; TAG
 mov [EBX],EAX
;        RETURN I;
;.GEN I,
 mov EAX,[I]
; RETN  LOOKS,3
 mov ESP,EBP
 pop EBP
 ret
;      ENDIF ENDIF
LJ32:
LJ31:
;    I=I+2;                      * try next slot
;.GEN =I,I,=2,.BC+,.BNST,
 mov EAX,[I]
 add EAX,2
 mov [I],EAX
;    COLFLG=1;                   * set collision flag
;.GEN =COLFLG,=1,.BNST,
 mov EAX,1
 mov [COLFLG],EAX
;    IF I GT TABSIZ;
;.GEN I,TABSIZ,.BN-,
 mov EAX,[I]
 sub EAX,8191   ; TABSIZ
;      THEN I=I-TABSIZ;
 jle LJ33
;.GEN =I,I,TABSIZ,.BN-,.BNST,
 mov EAX,[I]
 sub EAX,8191   ; TABSIZ
 mov [I],EAX
;      ENDIF
LJ33:
;    UNTIL I EQ J;               * check for wrap to starting position
;.GEN I,J,.BN-,
 mov EAX,[I]
 sub EAX,[J]
 jne LJ25
LJ26:
;  RETURN -1;                    * table full
;.GEN =1,.U-,
 mov EAX,1
 neg EAX
; RETN  LOOKS,3
 mov ESP,EBP
 pop EBP
 ret
;  ENDPROC
 section .data
T7Z:
 times 2 dd 0
 section .text
 section .data
T7Z1:
 times 1 dd 0
 section .text
;
;* Get VAL and TAG for this INDEX in TABLE
;* No return value
;*****************
;PROC GETS(INDEX,VAL,TAG);       * get VAL and TAG for INDEX
; SUBR  GETS
GETS:
 push EBP
 mov  EBP,ESP
; NPARS  3
; PAR  INDEX
; PAR  VAL
; PAR  TAG
; PEND
;  B=TABLE(INDEX+1);
;.GEN =B,=TABLE,INDEX,=1,.BC+,=2,.BNSHL,.BC+,.UA,.BNST,
; L D INDEX
 mov EBX,[EBP+16] ; INDEX
 mov EAX,[EBX]
 inc EAX
 sal EAX,2
 add EAX,TABLE
 mov EAX,[EAX]
 mov [B],EAX
;  VAL=B AND MASKV;              * get VAL part
;.GEN =VAL,B,MASKV,.BCAND,.BNST,
 mov EAX,[B]
 and EAX,[MASKV]
; ST D VAL
 mov EBX,[EBP+12] ; VAL
 mov [EBX],EAX
;  TAG=(B SHR 16) AND MASKV;     * get TAG part
;.GEN =TAG,B,=16,.BNSHR,MASKV,.BCAND,.BNST,
 mov EAX,[B]
 sar EAX,16
 and EAX,[MASKV]
; ST D TAG
 mov EBX,[EBP+8] ; TAG
 mov [EBX],EAX
;  RETURN
; RETN  GETS,3
 mov ESP,EBP
 pop EBP
 ret
;  ENDPROC
;
;* Put new VAL and TAG for this INDEX in TABLE
;* No return value
;*****************
;PROC PUTS(INDEX,VAL,TAG);       * put VAL and TAG at INDEX
; SUBR  PUTS
PUTS:
 push EBP
 mov  EBP,ESP
; NPARS  3
; PAR  INDEX
; PAR  VAL
; PAR  TAG
; PEND
;  TABLE(INDEX+1)=(TAG SHL 16) OR VAL;
;.GEN =TABLE,INDEX,=1,.BC+,=2,.BNSHL,.BC+,TAG,=16,.BNSHL,VAL,.BCOR,.BNST,
; L D INDEX
 mov EBX,[EBP+16] ; INDEX
 mov EAX,[EBX]
 inc EAX
 sal EAX,2
 add EAX,TABLE
 mov [T11Z1],EAX
; L D TAG
 mov EBX,[EBP+8] ; TAG
 mov EAX,[EBX]
 sal EAX,16
; OR D VAL
 mov EBX,[EBP+12] ; VAL
 or EAX,[EBX]
 mov EDX,EAX
 mov EAX,[T11Z1]
 mov [EAX],EDX
;  RETURN
; RETN  PUTS,3
 mov ESP,EBP
 pop EBP
 ret
;  ENDPROC
 section .data
T11Z1:
 times 1 dd 0
 section .text
;
;* Get packed symbol (WDS) for this index in TABLE
;* No return value
;*****************
;PROC GETWRD(INDEX,WDS);         * get base 40 code at INDEX
; SUBR  GETWRD
GETWRD:
 push EBP
 mov  EBP,ESP
; NPARS  2
; PAR  INDEX
; PAR  WDS
; PEND
;  WDS=TABLE(INDEX);
;.GEN =WDS,=TABLE,INDEX,=2,.BNSHL,.BC+,.UA,.BNST,
; L D INDEX
 mov EBX,[EBP+12] ; INDEX
 mov EAX,[EBX]
 sal EAX,2
 add EAX,TABLE
 mov EAX,[EAX]
; ST D WDS
 mov EBX,[EBP+8] ; WDS
 mov [EBX],EAX
;  RETURN
; RETN  GETWRD,2
 mov ESP,EBP
 pop EBP
 ret
;  ENDPROC
;
;END
 end
