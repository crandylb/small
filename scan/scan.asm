;* SCAN.S1 -- Frontend scan for Small, CRB, Feb 19, 2014
;
;  BEGIN SCAN;
 global progr
 extern exit
;  ENTRY SCAN;
 global  SCAN
;  ENTRY BUFF;                   * make BUFF buffer global for LEX
 global  BUFF
;
;  EXTERNAL PROC READ,WRITE;
 extern READ
 extern  WRITE
;  EXTERNAL PROC LEX,CAT2;
 extern LEX
 extern  CAT2
;  ENT OUTCH;
 global  OUTCH
;
;  DCL BUFF(128),SCRATCH(128);
 section .data
BUFF:
 times 129 dd 0
SCRATCH:
 times 129 dd 0
;  DCL INCH=1,OUTCH=3,STATUS;
INCH:
 dd  1
OUTCH:
 dd  3
STATUS:
 times 1 dd 0
;  DCL EOF=0;
EOF:
 dd  0
;  DCL LEXEME(120);
LEXEME:
 times 121 dd 0
;  DCL KIND;
KIND:
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
;
;PROC SCAN;                        * frontend scanner for Small
 section .text
; SUBR  SCAN
SCAN:
 push EBP
 mov  EBP,ESP
; NPARS  0
; PEND
;  REPEAT 
LJ1:
;LABEL CONTIN;
CONTIN:
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
;    CALL WRITE(OUTCH,BUFF);
; NARGS  2
 push OUTCH
 push BUFF
 call WRITE
 add  ESP,4*2
;    ICHAR=1;
;.GEN =ICHAR,=1,.BNST,
 mov EAX,1
 mov [ICHAR],EAX
;    DO WHILE ICHAR LE BUFF;       * until end of line
LJ5:
;.GEN ICHAR,BUFF,.BN-,
 mov EAX,[ICHAR]
 sub EAX,[BUFF]
 jg LJ6
;      KIND=LEX(ICHAR,LEXEME);     * call LEX, get KIND and LEXEME
;.GEN =KIND,(ICHAR,LEXEME),.UFLEX,.BNST,
; NARGS  2
 push ICHAR
 push LEXEME
 call LEX
 add  ESP,4*2
 mov [KIND],EAX
;      IF MODE; THEN 
;.GEN MODE,=0,.BN-,
 mov EAX,[MODE]
 or EAX,EAX
 jz LJ8
;        IF LEXEME(1) EQ STAR;     * if MODE 1 and * skip to next
;.GEN =LEXEME,=1,=2,.BNSHL,.BC+,.UA,STAR,.BN-,
 mov EAX,1
 sal EAX,2
 add EAX,LEXEME
 mov EAX,[EAX]
 sub EAX,[STAR]
;          THEN GO TO CONTIN;      * input line to ignore comment
 jne LJ9
 jmp CONTIN
;          ELSE MODE=0;            * comments not allowed in MODE 0
 jmp LJ10
LJ9:
;.GEN =MODE,=0,.BNST,
 mov EAX,0
 mov [MODE],EAX
;        ENDIF ENDIF
LJ10:
LJ8:
;      SCRATCH(1)=KIND+'0';        * insert KIND as decimal digit
;.GEN =SCRATCH,=1,=2,.BNSHL,.BC+,KIND,=48,.BC+,.BNST,
 mov EAX,1
 sal EAX,2
 add EAX,SCRATCH
 mov [T1Z1],EAX
 mov EAX,[KIND]
 add EAX,48
 mov EDX,EAX
 mov EAX,[T1Z1]
 mov [EAX],EDX
;      SCRATCH(2)=' ';             * follow with space
;.GEN =SCRATCH,=2,=2,.BNSHL,.BC+,=32,.BNST,
 mov EAX,2
 sal EAX,2
 add EAX,SCRATCH
 mov [T1Z],EAX
 mov EAX,32
 mov EDX,EAX
 mov EAX,[T1Z]
 mov [EAX],EDX
;      SCRATCH=2;                  * number of characters
;.GEN =SCRATCH,=2,.BNST,
 mov EAX,2
 mov [SCRATCH],EAX
;      CALL CAT2(SCRATCH,LEXEME);  * concatenate
; NARGS  2
 push SCRATCH
 push LEXEME
 call CAT2
 add  ESP,4*2
;      CALL WRITE(OUTCH,SCRATCH);
; NARGS  2
 push OUTCH
 push SCRATCH
 call WRITE
 add  ESP,4*2
;      IF MODE EQ 0; THEN 
;.GEN MODE,=0,.BN-,
 mov EAX,[MODE]
 or EAX,EAX
 jne LJ13
;        IF LEXEME(1) EQ SEMICO;
;.GEN =LEXEME,=1,=2,.BNSHL,.BC+,.UA,SEMICO,.BN-,
 mov EAX,1
 sal EAX,2
 add EAX,LEXEME
 mov EAX,[EAX]
 sub EAX,[SEMICO]
;           THEN MODE=1;
 jne LJ14
;.GEN =MODE,=1,.BNST,
 mov EAX,1
 mov [MODE],EAX
;        ENDIF ENDIF
LJ14:
LJ13:
;      ENDDO
 jmp LJ5
LJ6:
;    UNTIL STATUS EQ EOF;
;.GEN STATUS,EOF,.BN-,
 mov EAX,[STATUS]
 sub EAX,[EOF]
 jne LJ1
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
;END
 end
