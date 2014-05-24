;* initsym.s1 -- Initialize Symbol Table, CRB, Feb 26, 2014
;* 03/14/2014 CRB Add COLLS collision counter and token KIND
;* 03/18/2014 CRB Randomize single char ops, add INDEX output
;* 04/03/2014 CRB Use integer value from LEX in LEXEME(1)
;* 05/10/2014 CRB Ude INDEX from LEXEME(1) to set VAL and TAG with PUTS
;
;BEGIN INITSYM;
 global progr
 extern exit
;ENT INITSYM;
 global  INITSYM
;ENT DMPLIST;
 global  DMPLIST
;ENT BUFF;
 global  BUFF
;START INIT;
 global  INIT
 section .text
progr:
 push EBP
 mov  EBP,ESP
 jmp INIT
;
;EXT PROC READ,WRITE;
 extern READ
 extern  WRITE
;EXT PROC LEX;
 extern LEX
;EXT PROC A2B40,B402A;
 extern A2B40
 extern  B402A
;EXT PROC A2B40L;
 extern A2B40L
;EXT PROC LOOKS,GETS,PUTS,GETWRD;
 extern LOOKS
 extern  GETS
 extern  PUTS
 extern  GETWRD
;EXT PROC IREAD,IFORM,CAT2;
 extern IREAD
 extern  IFORM
 extern  CAT2
;EXT COLLS,MASKV;
 extern  COLLS
 extern  MASKV
;
;DCL I,J,EOF=0,STATUS;
 section .data
I:
 times 1 dd 0
J:
 times 1 dd 0
EOF:
 dd  0
STATUS:
 times 1 dd 0
;DCL BUFF(127);
BUFF:
 times 128 dd 0
;DCL INCH=1,SCRCH=2,OUTCH=3;
INCH:
 dd  1
SCRCH:
 dd  2
OUTCH:
 dd  3
;DCL LEXEME(4);
LEXEME:
 times 5 dd 0
;DCL INDEX,WORDS,KIND,TTYPE,TAG,TAGS,VAL,ATTR;
INDEX:
 times 1 dd 0
WORDS:
 times 1 dd 0
KIND:
 times 1 dd 0
TTYPE:
 times 1 dd 0
TAG:
 times 1 dd 0
TAGS:
 times 1 dd 0
VAL:
 times 1 dd 0
ATTR:
 times 1 dd 0
;DCL COUNT=0,LIST(60);
COUNT:
 dd  0
LIST:
 times 61 dd 0
;DCL STAR=('*');
STAR:
 dd  42
;DCL DOT=('.');
DOT:
 dd  46
;DCL QUOTE=39;                   * ASCII single qoute mark
QUOTE:
 dd  39
;MSG BLANKS='          ';
BLANKS:
 dd  10
 dd  32
 dd  32
 dd  32
 dd  32
 dd  32
 dd  32
 dd  32
 dd  32
 dd  32
 dd  32
;MSG SCRATCH='          ';
SCRATCH:
 dd  10
 dd  32
 dd  32
 dd  32
 dd  32
 dd  32
 dd  32
 dd  32
 dd  32
 dd  32
 dd  32
;MSG COLLISIONS='Collisions: ';
COLLISIONS:
 dd  12
 dd  67
 dd  111
 dd  108
 dd  108
 dd  105
 dd  115
 dd  105
 dd  111
 dd  110
 dd  115
 dd  58
 dd  32
;SET PRIM18=61;                  * prime 
;DCL ANC;                        * anchor
ANC:
 times 1 dd 0
;
;LABEL INIT;
 section .text
INIT:
;  CALL INITSYM;
; NARGS  0
 call INITSYM
;  CALL DMPLIST;
; NARGS  0
 call DMPLIST
;RETURN
; RETN  ,
 mov ESP,EBP
 pop EBP
 ret
;
;PROC INITSYM;
; SUBR  INITSYM
INITSYM:
 push EBP
 mov  EBP,ESP
; NPARS  0
; PEND
;  MASKV=(32767 SHL 1) OR 1;     * fudge correct value of mask
;.GEN =MASKV,=32767,=1,.BNSHL,=1,.BCOR,.BNST,
 mov EAX,32767
 sal EAX,1
 or EAX,1
 mov [MASKV],EAX
;  STATUS=READ(SCRCH,BUFF);      * read first line from chan 2
;.GEN =STATUS,(SCRCH,BUFF),.UFREAD,.BNST,
; NARGS  2
 push SCRCH
 push BUFF
 call READ
 add  ESP,4*2
 mov [STATUS],EAX
;  DO WHILE STATUS NE EOF;
LJ2:
;.GEN STATUS,EOF,.BN-,
 mov EAX,[STATUS]
 sub EAX,[EOF]
 jz LJ3
;    IF BUFF(1) NE STAR;         * skip comment line
;.GEN =BUFF,=1,=2,.BNSHL,.BC+,.UA,STAR,.BN-,
 mov EAX,1
 sal EAX,2
 add EAX,BUFF
 mov EAX,[EAX]
 sub EAX,[STAR]
;      THEN 
 jz LJ4
;      I=1;
;.GEN =I,=1,.BNST,
 mov EAX,1
 mov [I],EAX
;
;      KIND=LEX(I,LEXEME);       * get a symbol
;.GEN =KIND,(I,LEXEME),.UFLEX,.BNST,
; NARGS  2
 push I
 push LEXEME
 call LEX
 add  ESP,4*2
 mov [KIND],EAX
;      ANC=LEXEME AND 255;       * extract the anchor from LEXEME(0)
;.GEN =ANC,LEXEME,=255,.BCAND,.BNST,
 mov EAX,[LEXEME]
 and EAX,255
 mov [ANC],EAX
;      IF BUFF(ANC) EQ QUOTE; THEN 
;.GEN =BUFF,ANC,=2,.BNSHL,.BC+,.UA,QUOTE,.BN-,
 mov EAX,[ANC]
 sal EAX,2
 add EAX,BUFF
 mov EAX,[EAX]
 sub EAX,[QUOTE]
 jne LJ6
;          WORDS=BUFF(ANC+1)*PRIM18; * use ASCII code
;.GEN =WORDS,=BUFF,ANC,=1,.BC+,=2,.BNSHL,.BC+,.UA,PRIM18,.BC*,.BNST,
 mov EAX,[ANC]
 inc EAX
 sal EAX,2
 add EAX,BUFF
 mov EAX,[EAX]
 imul EAX,61
 mov [WORDS],EAX
;          TAGS=1;               * bit for single ASCII character
;.GEN =TAGS,=1,.BNST,
 mov EAX,1
 mov [TAGS],EAX
;          INDEX=LOOKS(WORDS,VAL,TAG); * use this INDEX in PUTS below
;.GEN =INDEX,(WORDS,VAL,TAG),.UFLOOKS,.BNST,
; NARGS  3
 push WORDS
 push VAL
 push TAG
 call LOOKS
 add  ESP,4*3
 mov [INDEX],EAX
;        ELSE 
 jmp LJ8
LJ6:
;          WORDS=A2B40L(LEXEME,BUFF);  * convert to B40
;.GEN =WORDS,(LEXEME,BUFF),.UFA2B40L,.BNST,
; NARGS  2
 push LEXEME
 push BUFF
 call A2B40L
 add  ESP,4*2
 mov [WORDS],EAX
;          TAGS=0;               * bit for normal base 40 coding
;.GEN =TAGS,=0,.BNST,
 mov EAX,0
 mov [TAGS],EAX
;          INDEX=LEXEME(1);      * save INDEX returned from LEX
;.GEN =INDEX,=LEXEME,=1,=2,.BNSHL,.BC+,.UA,.BNST,
 mov EAX,1
 sal EAX,2
 add EAX,LEXEME
 mov EAX,[EAX]
 mov [INDEX],EAX
;        ENDIF
LJ8:
;
;      KIND=LEX(I,LEXEME);       * get the TTYPE code
;.GEN =KIND,(I,LEXEME),.UFLEX,.BNST,
; NARGS  2
 push I
 push LEXEME
 call LEX
 add  ESP,4*2
 mov [KIND],EAX
;      TTYPE=LEXEME(1);
;.GEN =TTYPE,=LEXEME,=1,=2,.BNSHL,.BC+,.UA,.BNST,
 mov EAX,1
 sal EAX,2
 add EAX,LEXEME
 mov EAX,[EAX]
 mov [TTYPE],EAX
;
;      KIND=LEX(I,LEXEME);       * get VAL for this keyword
;.GEN =KIND,(I,LEXEME),.UFLEX,.BNST,
; NARGS  2
 push I
 push LEXEME
 call LEX
 add  ESP,4*2
 mov [KIND],EAX
;      VAL=LEXEME(1);
;.GEN =VAL,=LEXEME,=1,=2,.BNSHL,.BC+,.UA,.BNST,
 mov EAX,1
 sal EAX,2
 add EAX,LEXEME
 mov EAX,[EAX]
 mov [VAL],EAX
;
;      KIND=LEX(I,LEXEME);       * get the VALE token KIND code
;.GEN =KIND,(I,LEXEME),.UFLEX,.BNST,
; NARGS  2
 push I
 push LEXEME
 call LEX
 add  ESP,4*2
 mov [KIND],EAX
;      KIND=LEXEME(1);
;.GEN =KIND,=LEXEME,=1,=2,.BNSHL,.BC+,.UA,.BNST,
 mov EAX,1
 sal EAX,2
 add EAX,LEXEME
 mov EAX,[EAX]
 mov [KIND],EAX
;      TAG=(TAGS SHL 4 OR TTYPE) SHL 8 OR KIND; * set TAG word parts
;.GEN =TAG,TAGS,=4,.BNSHL,TTYPE,.BCOR,=8,.BNSHL,KIND,.BCOR,.BNST,
 mov EAX,[TAGS]
 sal EAX,4
 or EAX,[TTYPE]
 sal EAX,8
 or EAX,[KIND]
 mov [TAG],EAX
;
;      KIND=LEX(I,LEXEME);       * get the ATTR bits
;.GEN =KIND,(I,LEXEME),.UFLEX,.BNST,
; NARGS  2
 push I
 push LEXEME
 call LEX
 add  ESP,4*2
 mov [KIND],EAX
;      ATTR=LEXEME(1);
;.GEN =ATTR,=LEXEME,=1,=2,.BNSHL,.BC+,.UA,.BNST,
 mov EAX,1
 sal EAX,2
 add EAX,LEXEME
 mov EAX,[EAX]
 mov [ATTR],EAX
;      VAL=ATTR SHL 8 OR VAL;    * ATTR in MSB, ID number in LSB
;.GEN =VAL,ATTR,=8,.BNSHL,VAL,.BCOR,.BNST,
 mov EAX,[ATTR]
 sal EAX,8
 or EAX,[VAL]
 mov [VAL],EAX
;
;      CALL PUTS(INDEX,VAL,TAG); * set VAL and TAG for this symbol
; NARGS  3
 push INDEX
 push VAL
 push TAG
 call PUTS
 add  ESP,4*3
;      COUNT=COUNT+1;
;.GEN =COUNT,COUNT,=1,.BC+,.BNST,
 mov EAX,[COUNT]
 inc EAX
 mov [COUNT],EAX
;      LIST(COUNT)=INDEX;        * save INDEX of this keyword
;.GEN =LIST,COUNT,=2,.BNSHL,.BC+,INDEX,.BNST,
 mov EAX,[COUNT]
 sal EAX,2
 add EAX,LIST
 mov [T1Z],EAX
 mov EAX,[INDEX]
 mov EDX,EAX
 mov EAX,[T1Z]
 mov [EAX],EDX
;      ENDIF
LJ4:
;    STATUS=READ(SCRCH,BUFF);    * read next line
;.GEN =STATUS,(SCRCH,BUFF),.UFREAD,.BNST,
; NARGS  2
 push SCRCH
 push BUFF
 call READ
 add  ESP,4*2
 mov [STATUS],EAX
;    ENDDO
 jmp LJ2
LJ3:
;  RETURN
; RETN  INITSYM,0
 mov ESP,EBP
 pop EBP
 ret
;ENDPROC
 section .data
T1Z:
 times 2 dd 0
 section .text
;
;PROC DMPLIST;
; SUBR  DMPLIST
DMPLIST:
 push EBP
 mov  EBP,ESP
; NPARS  0
; PEND
;  I=1;
;.GEN =I,=1,.BNST,
 mov EAX,1
 mov [I],EAX
;  DO WHILE I LE COUNT;
LJ16:
;.GEN I,COUNT,.BN-,
 mov EAX,[I]
 sub EAX,[COUNT]
 jg LJ17
;    INDEX=LIST(I);
;.GEN =INDEX,=LIST,I,=2,.BNSHL,.BC+,.UA,.BNST,
 mov EAX,[I]
 sal EAX,2
 add EAX,LIST
 mov EAX,[EAX]
 mov [INDEX],EAX
;    CALL GETWRD(INDEX,WORDS);   * get coded symbol from table
; NARGS  2
 push INDEX
 push WORDS
 call GETWRD
 add  ESP,4*2
;    CALL GETS(INDEX,VAL,TAG);   * also get VAL and TAG
; NARGS  3
 push INDEX
 push VAL
 push TAG
 call GETS
 add  ESP,4*3
;    TTYPE=TAG SHR 8;            * get the type and TAGS field
;.GEN =TTYPE,TAG,=8,.BNSHR,.BNST,
 mov EAX,[TAG]
 sar EAX,8
 mov [TTYPE],EAX
;    TAGS=TTYPE SHR 4;           * extract the TAGS bits
;.GEN =TAGS,TTYPE,=4,.BNSHR,.BNST,
 mov EAX,[TTYPE]
 sar EAX,4
 mov [TAGS],EAX
;    TTYPE=TTYPE AND 15;         * isolate the type number
;.GEN =TTYPE,TTYPE,=15,.BCAND,.BNST,
 mov EAX,[TTYPE]
 and EAX,15
 mov [TTYPE],EAX
;    BUFF=0;
;.GEN =BUFF,=0,.BNST,
 mov EAX,0
 mov [BUFF],EAX
;    CALL CAT2(BUFF,BLANKS);     * clear BUFF
; NARGS  2
 push BUFF
 push BLANKS
 call CAT2
 add  ESP,4*2
;    BUFF=0;
;.GEN =BUFF,=0,.BNST,
 mov EAX,0
 mov [BUFF],EAX
;    IF TAGS AND 1; THEN 
;.GEN TAGS,=1,.BCAND,=0,.BN-,
 mov EAX,[TAGS]
 and EAX,1
 or EAX,EAX
 jz LJ21
;        BUFF(1)=WORDS/PRIM18;   * if single character use ASCII
;.GEN =BUFF,=1,=2,.BNSHL,.BC+,WORDS,PRIM18,.BN/,.BNST,
 mov EAX,1
 sal EAX,2
 add EAX,BUFF
 mov [T3Z1],EAX
 mov EAX,[WORDS]
; / 61 PRIM18
 cdq
 mov  ECX,61
 idiv dword ECX
 mov EDX,EAX
 mov EAX,[T3Z1]
 mov [EAX],EDX
;      ELSE 
 jmp LJ22
LJ21:
;        CALL B402A(WORDS,BUFF); * decode symbol into BUFF
; NARGS  2
 push WORDS
 push BUFF
 call B402A
 add  ESP,4*2
;      ENDIF
LJ22:
;    BUFF=8;
;.GEN =BUFF,=8,.BNST,
 mov EAX,8
 mov [BUFF],EAX
;    CALL IFORM(VAL,SCRATCH);    * insert VAL in BUFF
; NARGS  2
 push VAL
 push SCRATCH
 call IFORM
 add  ESP,4*2
;    CALL CAT2(BUFF,SCRATCH);
; NARGS  2
 push BUFF
 push SCRATCH
 call CAT2
 add  ESP,4*2
;    CALL IFORM(TAG,SCRATCH);    * insert TAG in BUFF
; NARGS  2
 push TAG
 push SCRATCH
 call IFORM
 add  ESP,4*2
;    CALL CAT2(BUFF,SCRATCH);
; NARGS  2
 push BUFF
 push SCRATCH
 call CAT2
 add  ESP,4*2
;
;    CALL IFORM(INDEX,SCRATCH);  * show INDEX
; NARGS  2
 push INDEX
 push SCRATCH
 call IFORM
 add  ESP,4*2
;    CALL CAT2(BUFF,SCRATCH);
; NARGS  2
 push BUFF
 push SCRATCH
 call CAT2
 add  ESP,4*2
;    CALL WRITE(OUTCH,BUFF);
; NARGS  2
 push OUTCH
 push BUFF
 call WRITE
 add  ESP,4*2
;
;    I=I+1;
;.GEN =I,I,=1,.BC+,.BNST,
 mov EAX,[I]
 inc EAX
 mov [I],EAX
;    ENDDO
 jmp LJ16
LJ17:
;
;    CALL IFORM(COLLS,SCRATCH);
; NARGS  2
 push COLLS
 push SCRATCH
 call IFORM
 add  ESP,4*2
;    BUFF=0;
;.GEN =BUFF,=0,.BNST,
 mov EAX,0
 mov [BUFF],EAX
;    CALL CAT2(BUFF,COLLISIONS);
; NARGS  2
 push BUFF
 push COLLISIONS
 call CAT2
 add  ESP,4*2
;    CALL CAT2(BUFF,SCRATCH);
; NARGS  2
 push BUFF
 push SCRATCH
 call CAT2
 add  ESP,4*2
;    CALL WRITE(OUTCH,BUFF);
; NARGS  2
 push OUTCH
 push BUFF
 call WRITE
 add  ESP,4*2
;  RETURN
; RETN  DMPLIST,0
 mov ESP,EBP
 pop EBP
 ret
;  ENDPROC
 section .data
T3Z1:
 times 1 dd 0
 section .text
;END
 end
