;* LEX.S1 -- Lexical Scanner for Small, CRB, Oct 11,2007
;* Testing, CRB, Oct 24, 2012
;* Restoring State matrix to original, CRB, Oct 30, 2012
;* Fix end of line detection, CRB, Jan 13, 2014
;* Rewrite, CRB, Apr 2,2014
;* More mods, CRB, Apr 14, 2014
;* Distinguish between LKIND (lexical) and TKIND (token) CRB, May 15, 2014
;* Fix obo error in single character token CRB, Dec 3, 2014
;
;  BEGIN LEX;
 global progr
 extern exit
;  ENTRY LEX;
 global  LEX
;  EXTERN BUFF;                  * input line passed as global
 extern  BUFF
;  EXT PROC A2B40L;
 extern A2B40L
;  EXT PROC LOOKS;
 extern LOOKS
;  SET PRIM18=61;                * 18th prime used to hash ASCII chars
;
;* character type codes
;* T array is indexed by 7-bit ASCII character code using zero indexing
;  DCL  T=( 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1); * 1 space
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
;  DCL T2=( 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1); * 2 alphabetic
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
;  DCL T3=( 1, 5, 5, 5, 5, 5, 5, 4, 5, 5, 5, 5, 5, 5, 5, 5); * 3 digit
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
;  DCL T4=( 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 5, 5, 5, 5, 5, 5); * 4 quote mark
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
;  DCL T5=( 5, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2); * 5 other
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
;  DCL T6=( 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 5, 5, 5, 5, 5); 
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
;  DCL T7=( 5, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2); 
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
;  DCL T8=( 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 5, 5, 5, 5, 5);
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
;  DCL S=30;                   * S(0) contains size
S:
 dd  30
;    DCL S1=( 1, 2, 3, 4, 6);  * offset 0    1 spaces
S1:
 dd  1
 dd  2
 dd  3
 dd  4
 dd  6
;    DCL S2=(-1, 2, 2,-1,-1);  * offset 5    2 name
S2:
 dd  -1
 dd  2
 dd  2
 dd  -1
 dd  -1
;    DCL S3=(-2,-2, 3,-2,-2);  * offset 10   3 integer
S3:
 dd  -2
 dd  -2
 dd  3
 dd  -2
 dd  -2
;    DCL S4=( 4, 4, 4, 5, 4);  * offset 15   4 quoted string
S4:
 dd  4
 dd  4
 dd  4
 dd  5
 dd  4
;    DCL S5=(-3,-3,-3, 4,-3);  * offset 20   5 other
S5:
 dd  -3
 dd  -3
 dd  -3
 dd  4
 dd  -3
;    DCL S6=(-4,-4,-4,-4,-4);  * offset 25
S6:
 dd  -4
 dd  -4
 dd  -4
 dd  -4
 dd  -4
;  DCL SROW=( 6, 0, 5,10,15,20,25); * aux offset vector
SROW:
 dd  6
 dd  0
 dd  5
 dd  10
 dd  15
 dd  20
 dd  25
;
;  DCL CTYPE;     * type of character
CTYPE:
 times 1 dd 0
;  DCL STATE;     * state variable
STATE:
 times 1 dd 0
;  DCL LKIND;     * lexical kind 1: name, 2: int, 3: string, 4, special
LKIND:
 times 1 dd 0
;  DCL TKIND;     * token kind 0..7 for operators and keywords in initable
TKIND:
 times 1 dd 0
;  DCL I;         * local character index in BUFF
I:
 times 1 dd 0
;  DCL CHAR;      * current local character
CHAR:
 times 1 dd 0
;  DCL ANCHOR;    * anchor start of token non-blank characters
ANCHOR:
 times 1 dd 0
;  DCL NUM;       * integer value
NUM:
 times 1 dd 0
;  DCL INDEX,WORDS;
INDEX:
 times 1 dd 0
WORDS:
 times 1 dd 0
;  DCL VAL,TAG;
VAL:
 times 1 dd 0
TAG:
 times 1 dd 0
;
;*---------------
;  PROC LEX(INEXT,LEXEME);
 section .text
; SUBR  LEX
LEX:
 push EBP
 mov  EBP,ESP
; NPARS  2
; PAR  INEXT
; PAR  LEXEME
; PEND
;    STATE=1;     * initialize current state
;.GEN =STATE,=1,.BNST,
 mov EAX,1
 mov [STATE],EAX
;    I=INEXT;     * local index in BUFF
;.GEN =I,INEXT,.BNST,
; L D INEXT
 mov EBX,[EBP+12] ; INEXT
 mov EAX,[EBX]
 mov [I],EAX
;    ANCHOR=0;    * initialize no anchor
;.GEN =ANCHOR,=0,.BNST,
 mov EAX,0
 mov [ANCHOR],EAX
;    NUM=0;       * integer value of token
;.GEN =NUM,=0,.BNST,
 mov EAX,0
 mov [NUM],EAX
;
;    DO WHILE 1;  * process current token in BUFF
LJ1:
;.GEN =1,=0,.BN-,
 mov EAX,1
 or EAX,EAX
 jz LJ2
;      CHAR=BUFF(I);
;.GEN =CHAR,=BUFF,I,=2,.BNSHL,.BC+,.UA,.BNST,
 mov EAX,[I]
 sal EAX,2
 add EAX,BUFF
 mov EAX,[EAX]
 mov [CHAR],EAX
;      IF CHAR EQ -1; THEN       * exit at end of line
;.GEN CHAR,=1,.U-,.BN-,
 mov EAX,1
 neg EAX
 mov [T1Z],EAX
 mov EAX,[CHAR]
 sub EAX,[T1Z]
 jne LJ3
;        EXIT
 jmp LJ2
;      ENDIF
LJ3:
;      CTYPE=T(CHAR);  * get character type
;.GEN =CTYPE,=T,CHAR,=2,.BNSHL,.BC+,.UA,.BNST,
 mov EAX,[CHAR]
 sal EAX,2
 add EAX,T
 mov EAX,[EAX]
 mov [CTYPE],EAX
;      STATE=S(SROW(STATE)+CTYPE);
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
;      IF STATE NE 1; THEN       * stop skipping white space
;.GEN STATE,=1,.BN-,
 mov EAX,[STATE]
 dec EAX
 jz LJ4
;        IF ANCHOR EQ 0; THEN 
;.GEN ANCHOR,=0,.BN-,
 mov EAX,[ANCHOR]
 or EAX,EAX
 jne LJ5
;          ANCHOR=I;             * drop anchor
;.GEN =ANCHOR,I,.BNST,
 mov EAX,[I]
 mov [ANCHOR],EAX
;        ENDIF
LJ5:
;      ENDIF
LJ4:
;      IF STATE EQ 3; THEN       * integer
;.GEN STATE,=3,.BN-,
 mov EAX,[STATE]
 sub EAX,3
 jne LJ6
;        NUM=10*NUM-'0'+CHAR;    * accumulate value
;.GEN =NUM,=10,NUM,.BC*,=48,.BN-,CHAR,.BC+,.BNST,
 mov EAX,10
 imul dword [NUM]
 sub EAX,48
 add EAX,[CHAR]
 mov [NUM],EAX
;      ENDIF
LJ6:
;      IF STATE LT 0; THEN       * if reached terminal state
;.GEN STATE,=0,.BN-,
 mov EAX,[STATE]
 or EAX,EAX
 jge LJ7
;        EXIT                    * drop out of loop
 jmp LJ2
;      ENDIF
LJ7:
;      I=I+1;                    * advance to next character
;.GEN =I,I,=1,.BC+,.BNST,
 mov EAX,[I]
 inc EAX
 mov [I],EAX
;    ENDDO
 jmp LJ1
LJ2:
;
;    INEXT=I;                    * return start index for next token
;.GEN =INEXT,I,.BNST,
 mov EAX,[I]
; ST D INEXT
 mov EBX,[EBP+12] ; INEXT
 mov [EBX],EAX
;    LKIND=-STATE;               * return lexical LKIND of this token
;.GEN =LKIND,STATE,.U-,.BNST,
 mov EAX,[STATE]
 neg EAX
 mov [LKIND],EAX
;    LEXEME=(I-ANCHOR) SHL 8 OR ANCHOR; * length and anchor
;.GEN =LEXEME,I,ANCHOR,.BN-,=8,.BNSHL,ANCHOR,.BCOR,.BNST,
 mov EAX,[I]
 sub EAX,[ANCHOR]
 sal EAX,8
 or EAX,[ANCHOR]
; ST D LEXEME
 mov EBX,[EBP+8] ; LEXEME
 mov [EBX],EAX
;
;    IF LKIND EQ 1; THEN         * name token
;.GEN LKIND,=1,.BN-,
 mov EAX,[LKIND]
 dec EAX
 jne LJ8
;      WORDS=A2B40L(LEXEME,BUFF);
;.GEN =WORDS,(LEXEME,BUFF),.UFA2B40L,.BNST,
; ARGT D LEXEME
 mov EBX,[EBP+8] ; LEXEME
; NARGS  2
; ARG D LEXEME
 push EBX
 push BUFF
 call A2B40L
 add  ESP,4*2
 mov [WORDS],EAX
;      INDEX=LOOKS(WORDS,VAL,TAG);
;.GEN =INDEX,(WORDS,VAL,TAG),.UFLOOKS,.BNST,
; NARGS  3
 push WORDS
 push VAL
 push TAG
 call LOOKS
 add  ESP,4*3
 mov [INDEX],EAX
;      LEXEME(1)=INDEX;
;.GEN =LEXEME,=1,=2,.BNSHL,.BC+,INDEX,.BNST,
 mov EAX,1
 sal EAX,2
; + D =LEXEME
 mov EBX,[EBP+8] ; LEXEME
 add EAX,EBX
 mov [T1Z],EAX
 mov EAX,[INDEX]
 mov EDX,EAX
 mov EAX,[T1Z]
 mov [EAX],EDX
;      LEXEME(2)=VAL;
;.GEN =LEXEME,=2,=2,.BNSHL,.BC+,VAL,.BNST,
 mov EAX,2
 sal EAX,2
; + D =LEXEME
 mov EBX,[EBP+8] ; LEXEME
 add EAX,EBX
 mov [T1Z],EAX
 mov EAX,[VAL]
 mov EDX,EAX
 mov EAX,[T1Z]
 mov [EAX],EDX
;      LEXEME(3)=TAG;
;.GEN =LEXEME,=3,=2,.BNSHL,.BC+,TAG,.BNST,
 mov EAX,3
 sal EAX,2
; + D =LEXEME
 mov EBX,[EBP+8] ; LEXEME
 add EAX,EBX
 mov [T1Z],EAX
 mov EAX,[TAG]
 mov EDX,EAX
 mov EAX,[T1Z]
 mov [EAX],EDX
;    ELSE IF LKIND EQ 2; THEN    * integer token
 jmp LJ11
LJ8:
;.GEN LKIND,=2,.BN-,
 mov EAX,[LKIND]
 sub EAX,2
 jne LJ12
;      LEXEME(1)=NUM;            * return its binary value
;.GEN =LEXEME,=1,=2,.BNSHL,.BC+,NUM,.BNST,
 mov EAX,1
 sal EAX,2
; + D =LEXEME
 mov EBX,[EBP+8] ; LEXEME
 add EAX,EBX
 mov [T1Z],EAX
 mov EAX,[NUM]
 mov EDX,EAX
 mov EAX,[T1Z]
 mov [EAX],EDX
;    ELSE IF LKIND EQ 4; THEN    * special character token
 jmp LJ13
LJ12:
;.GEN LKIND,=4,.BN-,
 mov EAX,[LKIND]
 sub EAX,4
 jne LJ14
;*      WORDS=BUFF(ANCHOR+1)*PRIM18;
;      WORDS=BUFF(ANCHOR)*PRIM18; * fix obo error CRB 12/03/2014
;.GEN =WORDS,=BUFF,ANCHOR,=2,.BNSHL,.BC+,.UA,PRIM18,.BC*,.BNST,
 mov EAX,[ANCHOR]
 sal EAX,2
 add EAX,BUFF
 mov EAX,[EAX]
 imul EAX,61
 mov [WORDS],EAX
;      INDEX=LOOKS(WORDS,VAL,TAG);
;.GEN =INDEX,(WORDS,VAL,TAG),.UFLOOKS,.BNST,
; NARGS  3
 push WORDS
 push VAL
 push TAG
 call LOOKS
 add  ESP,4*3
 mov [INDEX],EAX
;      LEXEME(1)=INDEX;
;.GEN =LEXEME,=1,=2,.BNSHL,.BC+,INDEX,.BNST,
 mov EAX,1
 sal EAX,2
; + D =LEXEME
 mov EBX,[EBP+8] ; LEXEME
 add EAX,EBX
 mov [T1Z],EAX
 mov EAX,[INDEX]
 mov EDX,EAX
 mov EAX,[T1Z]
 mov [EAX],EDX
;      LEXEME(2)=VAL;
;.GEN =LEXEME,=2,=2,.BNSHL,.BC+,VAL,.BNST,
 mov EAX,2
 sal EAX,2
; + D =LEXEME
 mov EBX,[EBP+8] ; LEXEME
 add EAX,EBX
 mov [T1Z],EAX
 mov EAX,[VAL]
 mov EDX,EAX
 mov EAX,[T1Z]
 mov [EAX],EDX
;      LEXEME(3)=TAG;
;.GEN =LEXEME,=3,=2,.BNSHL,.BC+,TAG,.BNST,
 mov EAX,3
 sal EAX,2
; + D =LEXEME
 mov EBX,[EBP+8] ; LEXEME
 add EAX,EBX
 mov [T1Z],EAX
 mov EAX,[TAG]
 mov EDX,EAX
 mov EAX,[T1Z]
 mov [EAX],EDX
;      ENDIF ENDIF ENDIF
LJ14:
LJ13:
LJ11:
;
;    LEXEME=LKIND SHL 28 OR LEXEME; * use lexical LKIND from final STATE
;.GEN =LEXEME,LKIND,=28,.BNSHL,LEXEME,.BCOR,.BNST,
 mov EAX,[LKIND]
 sal EAX,28
; OR D LEXEME
 mov EBX,[EBP+8] ; LEXEME
 or EAX,[EBX]
; ST D LEXEME
 mov EBX,[EBP+8] ; LEXEME
 mov [EBX],EAX
;    RETURN LKIND;               * return lexical LKIND 1..4
;.GEN LKIND,
 mov EAX,[LKIND]
; RETN  LEX,2
 mov ESP,EBP
 pop EBP
 ret
;  ENDPROC
 section .data
T1Z:
 times 2 dd 0
 section .text
;  END
 end
