;* SHOTOKS.S1 -- Show tokens for current line, CRB, Nov 18, 2014
;* 12/01/2014 CRB Moved from scan module
;* 12/14/2014 CRB Add unpacked user name
;* 12/22/2014 CRB Adding comments
;* 12/27/2014 CRB Hacking
;* 02/17/2015 CRB Fix seg fault from integer tokens
;
;  BEGIN SHOTOKS;
 global progr
 extern exit
;  ENT SHOTOKS;
 global  SHOTOKS
;
;  EXT TOKENS;
 extern  TOKENS
;  EXT PROC WRITE,IFORM;
 extern WRITE
 extern  IFORM
;  EXT PROC CAT2,CAT3;
 extern CAT2
 extern  CAT3
;  EXT PROC B402A,GETWRD;
 extern B402A
 extern  GETWRD
;  EXT BUFF;                       * use BUFF in initsym
 extern  BUFF
;  EXT MASKV;
 extern  MASKV
;
;  SET MAXTOK=127;                 * maximum number of tokens in a line
;  DCL OUTCH=3;
 section .data
OUTCH:
 dd  3
;  DCL LKIND;                      * lexical KIND code
LKIND:
 times 1 dd 0
;  DCL TOKNUM;                     * current token index
TOKNUM:
 times 1 dd 0
;  DCL TOKEN;
TOKEN:
 times 1 dd 0
;  DCL SUBSTR,OP;
SUBSTR:
 times 1 dd 0
OP:
 times 1 dd 0
;  DCL DEBUG(MAXTOK),TMP(31);
DEBUG:
 times 128 dd 0
TMP:
 times 32 dd 0
;  MSG SPACES='                   ';
SPACES:
 dd  19
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
 dd  32
 dd  32
 dd  32
 dd  32
 dd  32
 dd  32
 dd  32
 dd  32
 dd  32
;  DCL B40;
B40:
 times 1 dd 0
;  SET PRIM18=61;
;
;PROC SHOTOKS;                     * show tokens for current line
 section .text
; SUBR  SHOTOKS
SHOTOKS:
 push EBP
 mov  EBP,ESP
; NPARS  0
; PEND
;  TOKNUM=1;
;.GEN =TOKNUM,=1,.BNST,
 mov EAX,1
 mov [TOKNUM],EAX
;  DO WHILE TOKNUM LE 4*TOKENS;
LJ1:
;.GEN TOKNUM,=4,TOKENS,.BC*,.BN-,
 mov EAX,4
 imul dword [TOKENS]
 mov [T1Z],EAX
 mov EAX,[TOKNUM]
 sub EAX,[T1Z]
 jg LJ2
;    TOKEN=TOKENS(TOKNUM);
;.GEN =TOKEN,=TOKENS,TOKNUM,=2,.BNSHL,.BC+,.UA,.BNST,
 mov EAX,[TOKNUM]
 sal EAX,2
 add EAX,TOKENS
 mov EAX,[EAX]
 mov [TOKEN],EAX
;    LKIND=(TOKEN SHR 28) AND 15;
;.GEN =LKIND,TOKEN,=28,.BNSHR,=15,.BCAND,.BNST,
 mov EAX,[TOKEN]
 sar EAX,28
 and EAX,15
 mov [LKIND],EAX
;    DEBUG(1)=LKIND+'0';
;.GEN =DEBUG,=1,=2,.BNSHL,.BC+,LKIND,=48,.BC+,.BNST,
 mov EAX,1
 sal EAX,2
 add EAX,DEBUG
 mov [T1Z1],EAX
 mov EAX,[LKIND]
 add EAX,48
 mov EDX,EAX
 mov EAX,[T1Z1]
 mov [EAX],EDX
;    DEBUG(2)=' ';
;.GEN =DEBUG,=2,=2,.BNSHL,.BC+,=32,.BNST,
 mov EAX,2
 sal EAX,2
 add EAX,DEBUG
 mov [T1Z],EAX
 mov EAX,32
 mov EDX,EAX
 mov EAX,[T1Z]
 mov [EAX],EDX
;    DEBUG(3)=' ';
;.GEN =DEBUG,=3,=2,.BNSHL,.BC+,=32,.BNST,
 mov EAX,3
 sal EAX,2
 add EAX,DEBUG
 mov [T1Z],EAX
 mov EAX,32
 mov EDX,EAX
 mov EAX,[T1Z]
 mov [EAX],EDX
;    DEBUG=3;
;.GEN =DEBUG,=3,.BNST,
 mov EAX,3
 mov [DEBUG],EAX
;    SUBSTR=TOKEN AND MASKV;
;.GEN =SUBSTR,TOKEN,MASKV,.BCAND,.BNST,
 mov EAX,[TOKEN]
 and EAX,[MASKV]
 mov [SUBSTR],EAX
;    CALL CAT3(DEBUG,SUBSTR,BUFF);
; NARGS  3
 push DEBUG
 push SUBSTR
 push BUFF
 call CAT3
 add  ESP,4*3
;    CALL CAT2(DEBUG,SPACES);
; NARGS  2
 push DEBUG
 push SPACES
 call CAT2
 add  ESP,4*2
;    DEBUG=14;
;.GEN =DEBUG,=14,.BNST,
 mov EAX,14
 mov [DEBUG],EAX
;
;    TMP=10;                       * set size of TMP
;.GEN =TMP,=10,.BNST,
 mov EAX,10
 mov [TMP],EAX
;    CASE LKIND-1; OF SL1,SL2,SL3,SL4;
;.GEN LKIND,=1,.BN-,=0,.BN-,
 mov EAX,[LKIND]
 dec EAX
 or EAX,EAX
 sal  EAX,2
 add  EAX,LC1
 mov  EAX,[EAX]
 jmp  EAX
 section .data
LC1:
 dd SL1
 dd SL2
 dd SL3
 dd SL4
;LABEL SL1; GO TO SL4;             * symbol
 section .text
 jmp LJ5
SL1:
 jmp SL4
;LABEL SL2;                        * integer
 jmp LJ5
SL2:
;      TOKEN=TOKENS(TOKNUM+1);     * get integer's value
;.GEN =TOKEN,=TOKENS,TOKNUM,=1,.BC+,=2,.BNSHL,.BC+,.UA,.BNST,
 mov EAX,[TOKNUM]
 inc EAX
 sal EAX,2
 add EAX,TOKENS
 mov EAX,[EAX]
 mov [TOKEN],EAX
;LABEL SL3;                        * quote string
 jmp LJ5
SL3:
;      TOKEN=BUFF(TOKEN AND 255);  * extract first char
;.GEN =TOKEN,=BUFF,TOKEN,=255,.BCAND,=2,.BNSHL,.BC+,.UA,.BNST,
 mov EAX,[TOKEN]
 and EAX,255
 sal EAX,2
 add EAX,BUFF
 mov EAX,[EAX]
 mov [TOKEN],EAX
;LABEL SL4;                        * single character token
 jmp LJ5
SL4:
;      TOKEN=TOKENS(TOKNUM+1);     * INDEX of user symbol
;.GEN =TOKEN,=TOKENS,TOKNUM,=1,.BC+,=2,.BNSHL,.BC+,.UA,.BNST,
 mov EAX,[TOKNUM]
 inc EAX
 sal EAX,2
 add EAX,TOKENS
 mov EAX,[EAX]
 mov [TOKEN],EAX
;    ENDCASE 
LJ5:
;
;    CALL IFORM(TOKEN,TMP);        * VAL, OP or INDEX
; NARGS  2
 push TOKEN
 push TMP
 call IFORM
 add  ESP,4*2
;    CALL CAT2(DEBUG,TMP);
; NARGS  2
 push DEBUG
 push TMP
 call CAT2
 add  ESP,4*2
;    DEBUG=DEBUG+1;                * add one more space
;.GEN =DEBUG,DEBUG,=1,.BC+,.BNST,
 mov EAX,[DEBUG]
 inc EAX
 mov [DEBUG],EAX
;    DEBUG(DEBUG)=' ';             * for a blank separator
;.GEN =DEBUG,DEBUG,=2,.BNSHL,.BC+,=32,.BNST,
 mov EAX,[DEBUG]
 sal EAX,2
 add EAX,DEBUG
 mov [T1Z],EAX
 mov EAX,32
 mov EDX,EAX
 mov EAX,[T1Z]
 mov [EAX],EDX
;    IF LKIND EQ 1; THEN 
;.GEN LKIND,=1,.BN-,
 mov EAX,[LKIND]
 dec EAX
 jne LJ8
;        CALL GETWRD(TOKEN,B40);   * get base 40 name code
; NARGS  2
 push TOKEN
 push B40
 call GETWRD
 add  ESP,4*2
;        TMP=0;
;.GEN =TMP,=0,.BNST,
 mov EAX,0
 mov [TMP],EAX
;        CALL B402A(B40,TMP);      * convert B40 code to ASCII
; NARGS  2
 push B40
 push TMP
 call B402A
 add  ESP,4*2
;      ELSE IF LKIND EQ 4; THEN 
 jmp LJ11
LJ8:
;.GEN LKIND,=4,.BN-,
 mov EAX,[LKIND]
 sub EAX,4
 jne LJ12
;        CALL GETWRD(TOKEN,B40);   * get hash base code special char
; NARGS  2
 push TOKEN
 push B40
 call GETWRD
 add  ESP,4*2
;        TMP=1;
;.GEN =TMP,=1,.BNST,
 mov EAX,1
 mov [TMP],EAX
;        TMP(1)=B40/PRIM18;        * convert special char to ASCII
;.GEN =TMP,=1,=2,.BNSHL,.BC+,B40,PRIM18,.BN/,.BNST,
 mov EAX,1
 sal EAX,2
 add EAX,TMP
 mov [T1Z1],EAX
 mov EAX,[B40]
; / 61 PRIM18
 cdq
 mov  ECX,61
 idiv dword ECX
 mov EDX,EAX
 mov EAX,[T1Z1]
 mov [EAX],EDX
;      ELSE GO TO SL5;
 jmp LJ14
LJ12:
 jmp SL5
;      ENDIF ENDIF  
LJ14:
LJ11:
;    CALL CAT2(DEBUG,TMP);
; NARGS  2
 push DEBUG
 push TMP
 call CAT2
 add  ESP,4*2
;LABEL SL5;
SL5:
;    CALL WRITE(OUTCH,DEBUG);
; NARGS  2
 push OUTCH
 push DEBUG
 call WRITE
 add  ESP,4*2
;    TOKNUM=TOKNUM+4;
;.GEN =TOKNUM,TOKNUM,=4,.BC+,.BNST,
 mov EAX,[TOKNUM]
 add EAX,4
 mov [TOKNUM],EAX
;  ENDDO
 jmp LJ1
LJ2:
;  RETURN
; RETN  SHOTOKS,0
 mov ESP,EBP
 pop EBP
 ret
;ENDPROC
 section .data
T1Z:
 times 2 dd 0
 section .text
 section .data
T1Z1:
 times 1 dd 0
 section .text
;
;END
 end
