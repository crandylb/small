;* testlex.s1 -- Test LEX.S1, CRB, Jan 14, 2014
;
;  ENTRY TESTLEX;
 global  TESTLEX
;  BEGIN TESTLEX;
 global progr
 extern exit
;  START TESTLEX;
 global  TESTLEX
 section .text
progr:
 push EBP
 mov  EBP,ESP
 jmp TESTLEX
;  ENTRY BUFF;                   * make BUFF buffer global for LEX
 global  BUFF
;
;  EXTERNAL PROC READ,WRITE;
 extern READ
 extern  WRITE
;  EXTERNAL PROC LEX,CAT2;
 extern LEX
 extern  CAT2
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
;  MSG GREET='Begin Small LEX Test'
GREET:
 dd  20
 dd  66
 dd  101
 dd  103
 dd  105
 dd  110
 dd  32
 dd  83
 dd  109
 dd  97
 dd  108
 dd  108
 dd  32
 dd  76
 dd  69
 dd  88
 dd  32
 dd  84
 dd  101
 dd  115
 dd  116
;  DCL KIND,KINDN;
KIND:
 times 1 dd 0
KINDN:
 times 1 dd 0
;  DCL ICHAR;
ICHAR:
 times 1 dd 0
;
;LABEL TESTLEX;
 section .text
TESTLEX:
;  CALL WRITE(OUTCH,GREET);
; NARGS  2
 push OUTCH
 push GREET
 call WRITE
 add  ESP,4*2
;  REPEAT 
LJ2:
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
LJ6:
;.GEN ICHAR,BUFF,.BN-,
 mov EAX,[ICHAR]
; -  BUFF
 sub EAX,[BUFF]
 jg LJ7
;      KIND=LEX(ICHAR,LEXEME);
;.GEN =KIND,(ICHAR,LEXEME),.UFLEX,.BNST,
; NARGS  2
 push ICHAR
 push LEXEME
 call LEX
 add  ESP,4*2
 mov [KIND],EAX
;      SCRATCH(1)=KIND+'0';        * insert KIND as decimal digit
;.GEN =SCRATCH,=1,=2,.BNSHL,.BC+,KIND,=48,.BC+,.BNST,
 mov EAX,1
 sal EAX,2
 add EAX,SCRATCH
 mov [TZ1],EAX
 mov EAX,[KIND]
 add EAX,48
 mov EDX,EAX
 mov EAX,[TZ1]
 mov [EAX],EDX
;      SCRATCH(2)=' ';             * follow with space
;.GEN =SCRATCH,=2,=2,.BNSHL,.BC+,=32,.BNST,
 mov EAX,2
 sal EAX,2
 add EAX,SCRATCH
 mov [TZ],EAX
 mov EAX,32
 mov EDX,EAX
 mov EAX,[TZ]
 mov [EAX],EDX
;      SCRATCH(3)=' ';             * terminate line
;.GEN =SCRATCH,=3,=2,.BNSHL,.BC+,=32,.BNST,
 mov EAX,3
 sal EAX,2
 add EAX,SCRATCH
 mov [TZ],EAX
 mov EAX,32
 mov EDX,EAX
 mov EAX,[TZ]
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
;*      CALL WRITE(OUTCH,LEXEME);
;      ENDDO
 jmp LJ6
LJ7:
;    UNTIL STATUS EQ EOF;
;.GEN STATUS,EOF,.BN-,
 mov EAX,[STATUS]
; -  EOF
 sub EAX,[EOF]
 jne LJ2
LJ3:
;  RETURN
; RETN  ,
 mov ESP,EBP
 pop EBP
 ret
;
;END
 section .data
TZ:
 times 2 dd 0
 section .text
 section .data
TZ1:
 times 1 dd 0
 section .text
 end
