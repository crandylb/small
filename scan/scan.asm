;* SCAN.S1 -- Frontend scan for Small, CRB, Feb 19, 2014
;* 04/06/2014 CRB Rewite for new LEX and TOKENS array
;* 06/22/2014 CRB Use BUFF in initsym
;* 07/24/2014 CRB Tinkering
;* 11/25/2014 CRB Separate out shotoks
;* 12/22/2014 CRB Initialize TOKENS to zero inside loop
;* 12/31/2014 CRB Handle LKIND=0 at end-of-line
;* 01/06/2015 CRB Change TOKNUM to TINDEX, more comments
;* 02/02/2015 CRB Change way TOKENS are counted
;* 08/04/2015 CRB Add LISTNG for source listing output
;* 09/04/2015 CRB Cleanup for listing output
;* 09/11/2015 CRB Adding TSTFLG to control SHOTOKS
;
;  BEGIN SCAN;
 global progr
 extern exit
;  ENTRY SCAN;
 global  SCAN
;  ENTRY TOKENS;                   * make TOKENS global for parsing
 global  TOKENS
;
;  EXT PROC SHOTOKS;               * used only for testing
 extern SHOTOKS
;  EXT PROC READ,WRITE,IFORM;
 extern READ
 extern  WRITE
 extern  IFORM
;  EXT PROC LEX;
 extern LEX
;  EXT PROC CAT2,CAT3;
 extern CAT2
 extern  CAT3
;  EXT BUFF;                       * use BUFF in initsym
 extern  BUFF
;  EXT MASKV;
 extern  MASKV
;  EXT TSTFLG;
 extern  TSTFLG
;  ENT OUTCH;
 global  OUTCH
;
;  SET MAXTOK=127;                 * maximum number of tokens in a line
;  DCL INCH=1,OUTCH=3,STATUS;
 section .data
INCH:
 dd  1
OUTCH:
 dd  3
STATUS:
 times 1 dd 0
;  DCL EOF=0;
EOF:
 dd  0
;  DCL LEXEME(4);                  * attributes for a lexical token
LEXEME:
 times 5 dd 0
;  DCL LKIND;                      * lexical KIND code
LKIND:
 times 1 dd 0
;  DCL ICHAR,MODE;
ICHAR:
 times 1 dd 0
MODE:
 times 1 dd 0
;  DCL STAR=('*');                 * asterisk
STAR:
 dd  42
;  DCL SEMICO=(';');               * semicolon
SEMICO:
 dd  59
;  DCL FIRSTC;                     * first character of current token
FIRSTC:
 times 1 dd 0
;  DCL TOKENS(MAXTOK*4);           * array of tokens in current line
TOKENS:
 times 509 dd 0
;  DCL TINDEX;                     * current token index
TINDEX:
 times 1 dd 0
;  MSG COMMNT='* ';                * prefix for comment in mill output
COMMNT:
 dd  2
 dd  42
 dd  32
;
;PROC SCAN;                        * frontend scanner for Small
 section .text
; SUBR  SCAN
SCAN:
 push EBP
 mov  EBP,ESP
; NPARS  0
; PEND
;  DO WHILE 1;
LJ1:
;.GEN =1,=0,.BN-,
 mov EAX,1
 or EAX,EAX
 jz LJ2
;    TOKENS=0;                     * reinitialize to zero for each loop
;.GEN =TOKENS,=0,.BNST,
 mov EAX,0
 mov [TOKENS],EAX
;    MODE=1;                       * MODE 1 allows comments
;.GEN =MODE,=1,.BNST,
 mov EAX,1
 mov [MODE],EAX
;    STATUS=READ(INCH,BUFF);
;.GEN =STATUS,(INCH,BUFF),.UFREAD,.BNST,
; NARGS  2
 push INCH
 push BUFF
 call READ
 add  ESP,4*2
 mov [STATUS],EAX
;    IF STATUS EQ EOF;             * end of source input file
;.GEN STATUS,EOF,.BN-,
 mov EAX,[STATUS]
 sub EAX,[EOF]
;      THEN RETURN;
 jne LJ4
; RETN  SCAN,0
 mov ESP,EBP
 pop EBP
 ret
;      ENDIF 
LJ4:
;    LINCNT=LINCNT+1;              * bump line count
;.GEN =LINCNT,LINCNT,=1,.BC+,.BNST,
 mov EAX,[LINCNT]
 inc EAX
 mov [LINCNT],EAX
;    LISTLN=0;                     * initialize listing line buffer
;.GEN =LISTLN,=0,.BNST,
 mov EAX,0
 mov [LISTLN],EAX
;    CALL CAT2(LISTLN,COMMNT);     * insert coment prefix
; NARGS  2
 push LISTLN
 push COMMNT
 call CAT2
 add  ESP,4*2
;    CALL CAT2(LISTLN,BUFF);       * append source line
; NARGS  2
 push LISTLN
 push BUFF
 call CAT2
 add  ESP,4*2
;    CALL WRITE(OUTCH,LISTLN);     * output to mill as comment
; NARGS  2
 push OUTCH
 push LISTLN
 call WRITE
 add  ESP,4*2
;*    LEVEL=1;                      * test level
;    CALL LISTNG;                  * source listing output
; NARGS  0
 call LISTNG
;    ICHAR=1;
;.GEN =ICHAR,=1,.BNST,
 mov EAX,1
 mov [ICHAR],EAX
;    TINDEX=1;
;.GEN =TINDEX,=1,.BNST,
 mov EAX,1
 mov [TINDEX],EAX
;    DO WHILE ICHAR LE BUFF;       * until end of line
LJ8:
;.GEN ICHAR,BUFF,.BN-,
 mov EAX,[ICHAR]
 sub EAX,[BUFF]
 jg LJ9
;      LKIND=LEX(ICHAR,LEXEME);    * call LEX, get LKIND and LEXEME
;.GEN =LKIND,(ICHAR,LEXEME),.UFLEX,.BNST,
; NARGS  2
 push ICHAR
 push LEXEME
 call LEX
 add  ESP,4*2
 mov [LKIND],EAX
;LABEL LEX1;                       * debugging hack
LEX1:
;      IF LKIND EQ 0;              * end of line if null token
;.GEN LKIND,=0,.BN-,
 mov EAX,[LKIND]
 or EAX,EAX
;        THEN GO TO CONTIN; ENDIF 
 jne LJ11
 jmp CONTIN
LJ11:
;      FIRSTC=BUFF(LEXEME AND 255); * extract anchor for 1st char of token
;.GEN =FIRSTC,=BUFF,LEXEME,=255,.BCAND,=2,.BNSHL,.BC+,.UA,.BNST,
 mov EAX,[LEXEME]
 and EAX,255
 sal EAX,2
 add EAX,BUFF
 mov EAX,[EAX]
 mov [FIRSTC],EAX
;      IF MODE; THEN 
;.GEN MODE,=0,.BN-,
 mov EAX,[MODE]
 or EAX,EAX
 jz LJ12
;        IF FIRSTC EQ STAR;        * if MODE 1 and * skip to next
;.GEN FIRSTC,STAR,.BN-,
 mov EAX,[FIRSTC]
 sub EAX,[STAR]
;          THEN GO TO CONTIN;      * if comment ignore rest of line
 jne LJ13
 jmp CONTIN
;          ELSE MODE=0;            * comments not allowed in MODE 0
 jmp LJ14
LJ13:
;.GEN =MODE,=0,.BNST,
 mov EAX,0
 mov [MODE],EAX
;        ENDIF ENDIF
LJ14:
LJ12:
;      IF MODE EQ 0; THEN 
;.GEN MODE,=0,.BN-,
 mov EAX,[MODE]
 or EAX,EAX
 jne LJ15
;        IF FIRSTC EQ SEMICO;      * revert to mode 1 on semicolon
;.GEN FIRSTC,SEMICO,.BN-,
 mov EAX,[FIRSTC]
 sub EAX,[SEMICO]
;           THEN MODE=1;
 jne LJ16
;.GEN =MODE,=1,.BNST,
 mov EAX,1
 mov [MODE],EAX
;        ENDIF ENDIF
LJ16:
LJ15:
;
;      TOKENS(TINDEX)=LEXEME;      * save current token
;.GEN =TOKENS,TINDEX,=2,.BNSHL,.BC+,LEXEME,.BNST,
 mov EAX,[TINDEX]
 sal EAX,2
 add EAX,TOKENS
 mov [T1Z],EAX
 mov EAX,[LEXEME]
 mov EDX,EAX
 mov EAX,[T1Z]
 mov [EAX],EDX
;      CASE LKIND-1; OF LK1,LK2,LK3,LK4;
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
 dd LK1
 dd LK2
 dd LK3
 dd LK4
;LABEL LK1; GO TO LK4;             * symbol in TABLE
 section .text
 jmp LJ17
LK1:
 jmp LK4
;LABEL LK2; TOKENS(TINDEX+1)=LEXEME(1); * integer value
 jmp LJ17
LK2:
;.GEN =TOKENS,TINDEX,=1,.BC+,=2,.BNSHL,.BC+,=LEXEME,=1,=2,.BNSHL,.BC+,.UA,.BNST,
 mov EAX,[TINDEX]
 inc EAX
 sal EAX,2
 add EAX,TOKENS
 mov [T1Z1],EAX
 mov EAX,1
 sal EAX,2
 add EAX,LEXEME
 mov EAX,[EAX]
 mov EDX,EAX
 mov EAX,[T1Z1]
 mov [EAX],EDX
;LABEL LK3;                        * quote string
 jmp LJ17
LK3:
;LABEL LK4;                        * single character token
 jmp LJ17
LK4:
;        TOKENS(TINDEX+1)=LEXEME(1);
;.GEN =TOKENS,TINDEX,=1,.BC+,=2,.BNSHL,.BC+,=LEXEME,=1,=2,.BNSHL,.BC+,.UA,.BNST,
 mov EAX,[TINDEX]
 inc EAX
 sal EAX,2
 add EAX,TOKENS
 mov [T1Z1],EAX
 mov EAX,1
 sal EAX,2
 add EAX,LEXEME
 mov EAX,[EAX]
 mov EDX,EAX
 mov EAX,[T1Z1]
 mov [EAX],EDX
;        TOKENS(TINDEX+2)=LEXEME(2);
;.GEN =TOKENS,TINDEX,=2,.BC+,=2,.BNSHL,.BC+,=LEXEME,=2,=2,.BNSHL,.BC+,.UA,.BNST,
 mov EAX,[TINDEX]
 add EAX,2
 sal EAX,2
 add EAX,TOKENS
 mov [T1Z1],EAX
 mov EAX,2
 sal EAX,2
 add EAX,LEXEME
 mov EAX,[EAX]
 mov EDX,EAX
 mov EAX,[T1Z1]
 mov [EAX],EDX
;        TOKENS(TINDEX+3)=LEXEME(3);
;.GEN =TOKENS,TINDEX,=3,.BC+,=2,.BNSHL,.BC+,=LEXEME,=3,=2,.BNSHL,.BC+,.UA,.BNST,
 mov EAX,[TINDEX]
 add EAX,3
 sal EAX,2
 add EAX,TOKENS
 mov [T1Z1],EAX
 mov EAX,3
 sal EAX,2
 add EAX,LEXEME
 mov EAX,[EAX]
 mov EDX,EAX
 mov EAX,[T1Z1]
 mov [EAX],EDX
;      ENDCASE 
LJ17:
;
;      TINDEX=TINDEX+4;            * bump token index
;.GEN =TINDEX,TINDEX,=4,.BC+,.BNST,
 mov EAX,[TINDEX]
 add EAX,4
 mov [TINDEX],EAX
;      TOKENS=TOKENS+1;            * count number of tokens
;.GEN =TOKENS,TOKENS,=1,.BC+,.BNST,
 mov EAX,[TOKENS]
 inc EAX
 mov [TOKENS],EAX
;      ENDDO
 jmp LJ8
LJ9:
;
;LABEL CONTIN;
CONTIN:
;    IF TSTFLG; THEN               * use flag to control output
;.GEN TSTFLG,=0,.BN-,
 mov EAX,[TSTFLG]
 or EAX,EAX
 jz LJ18
;      CALL SHOTOKS;               * used only for testing
; NARGS  0
 call SHOTOKS
;      ENDIF
LJ18:
;    ENDDO
 jmp LJ1
LJ2:
;  RETURN
; RETN  SCAN,0
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
;* Format print line for source listing output
;  DCL LISTCH=4;                   * listing channel
 section .data
LISTCH:
 dd  4
;  DCL LINCNT=0;                   * source line count
LINCNT:
 dd  0
;  DCL LEVEL=0;                    * structure level number
LEVEL:
 dd  0
;  DCL LINSUB=3*256+8;             * substring for line number
LINSUB:
 dd  776
;  DCL LEVSUB=3*256+8;             * substring for level number
LEVSUB:
 dd  776
;  DCL TMP(12);                    * temp buffer for number conversion
TMP:
 times 13 dd 0
;  DCL LISTLN(127);                * buffer for source listing line
LISTLN:
 times 128 dd 0
;  MSG SPACES='  ';                * two spaces
SPACES:
 dd  2
 dd  32
 dd  32
;
;PROC LISTNG;
 section .text
; SUBR  LISTNG
LISTNG:
 push EBP
 mov  EBP,ESP
; NPARS  0
; PEND
;  LISTLN=0;                       * initialize listing buffer
;.GEN =LISTLN,=0,.BNST,
 mov EAX,0
 mov [LISTLN],EAX
;  TMP=10;                         * initialize temp conversion buffer
;.GEN =TMP,=10,.BNST,
 mov EAX,10
 mov [TMP],EAX
;  CALL IFORM(LINCNT,TMP);         * convert line number to string
; NARGS  2
 push LINCNT
 push TMP
 call IFORM
 add  ESP,4*2
;  CALL CAT3(LISTLN,LINSUB,TMP);   * copy line number to listing line
; NARGS  3
 push LISTLN
 push LINSUB
 push TMP
 call CAT3
 add  ESP,4*3
;  IF LEVEL; THEN 
;.GEN LEVEL,=0,.BN-,
 mov EAX,[LEVEL]
 or EAX,EAX
 jz LJ21
;    CALL IFORM(LEVEL,TMP);        * convert level number to string
; NARGS  2
 push LEVEL
 push TMP
 call IFORM
 add  ESP,4*2
;    CALL CAT3(LISTLN,LEVSUB,TMP); * copy level number to output
; NARGS  3
 push LISTLN
 push LEVSUB
 push TMP
 call CAT3
 add  ESP,4*3
;    ELSE CALL CAT2(LISTLN,SPACES);
 jmp LJ24
LJ21:
; NARGS  2
 push LISTLN
 push SPACES
 call CAT2
 add  ESP,4*2
;    ENDIF
LJ24:
;  CALL CAT2(LISTLN,SPACES);       * copy spaces to output
; NARGS  2
 push LISTLN
 push SPACES
 call CAT2
 add  ESP,4*2
;  CALL CAT2(LISTLN,BUFF);         * copy input line to output
; NARGS  2
 push LISTLN
 push BUFF
 call CAT2
 add  ESP,4*2
;  CALL WRITE(LISTCH,LISTLN);      * print the listing line
; NARGS  2
 push LISTCH
 push LISTLN
 call WRITE
 add  ESP,4*2
;  RETURN
; RETN  LISTNG,0
 mov ESP,EBP
 pop EBP
 ret
;ENDPROC
;
;END
 end
