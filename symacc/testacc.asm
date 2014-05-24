;* TESTACC.S1 -- Test Symbol Table Access, CRB, Feb 14, 2014
;* 04/28/2014 CRB Update, add GETS test
;
;ENT TESTACC;
 global  TESTACC
;BEGIN TESTACC;
 global progr
 extern exit
;START TESTACC;
 global  TESTACC
 section .text
progr:
 push EBP
 mov  EBP,ESP
 jmp TESTACC
;
;EXT PROC LOOKS,GETS,PUTS,GETWRD;
 extern LOOKS
 extern  GETS
 extern  PUTS
 extern  GETWRD
;EXT PROC A2B40,B402A;
 extern A2B40
 extern  B402A
;EXT PROC READ,WRITE,IFORM;
 extern READ
 extern  WRITE
 extern  IFORM
;EXT PROC LEX,CAT2;
 extern LEX
 extern  CAT2
;EXT MASKV;
 extern  MASKV
;
;MSG IFS='IF';
 section .data
IFS:
 dd  2
 dd  73
 dd  70
;MSG THENS='THEN';
THENS:
 dd  4
 dd  84
 dd  72
 dd  69
 dd  78
;MSG ELSES='ELSE';
ELSES:
 dd  4
 dd  69
 dd  76
 dd  83
 dd  69
;MSG PROCES='PROCEDURE';
PROCES:
 dd  9
 dd  80
 dd  82
 dd  79
 dd  67
 dd  69
 dd  68
 dd  85
 dd  82
 dd  69
;MSG PROCS='PROC';
PROCS:
 dd  4
 dd  80
 dd  82
 dd  79
 dd  67
;MSG GREET='Begin SYMACC Test';
GREET:
 dd  17
 dd  66
 dd  101
 dd  103
 dd  105
 dd  110
 dd  32
 dd  83
 dd  89
 dd  77
 dd  65
 dd  67
 dd  67
 dd  32
 dd  84
 dd  101
 dd  115
 dd  116
;MSG TESTIT='Test:               ';
TESTIT:
 dd  20
 dd  84
 dd  101
 dd  115
 dd  116
 dd  58
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
;DCL STAR=('*');
STAR:
 dd  42
;DCL SLASH=('/');
SLASH:
 dd  47
;DCL PLUS=('+');
PLUS:
 dd  43
;DCL MINUS=('-');
MINUS:
 dd  45
;DCL LPAREN=40;
LPAREN:
 dd  40
;DCL RPAREN=41;
RPAREN:
 dd  41
;DCL OUTCH=3;
OUTCH:
 dd  3
;DCL INDEX,VAL,TAG,WORDS,TTYPE;
INDEX:
 times 1 dd 0
VAL:
 times 1 dd 0
TAG:
 times 1 dd 0
WORDS:
 times 1 dd 0
TTYPE:
 times 1 dd 0
;DCL LIST(20);
LIST:
 times 21 dd 0
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
;
;LABEL TESTACC;
 section .text
TESTACC:
;  CALL WRITE(OUTCH,GREET);
; NARGS  2
 push OUTCH
 push GREET
 call WRITE
 add  ESP,4*2
;  MASKV=32767 SHL 1 OR 1;       * initialization needed
;.GEN =MASKV,=32767,=1,.BNSHL,=1,.BCOR,.BNST,
 mov EAX,32767
 sal EAX,1
 or EAX,1
 mov [MASKV],EAX
;  TESTIT=7;
;.GEN =TESTIT,=7,.BNST,
 mov EAX,7
 mov [TESTIT],EAX
;  CALL CAT2(TESTIT,IFS);
; NARGS  2
 push TESTIT
 push IFS
 call CAT2
 add  ESP,4*2
;  CALL WRITE(OUTCH,TESTIT);
; NARGS  2
 push OUTCH
 push TESTIT
 call WRITE
 add  ESP,4*2
;  WORDS=A2B40(IFS);
;.GEN =WORDS,(IFS),.UFA2B40,.BNST,
; NARGS  1
 push IFS
 call A2B40
 add  ESP,4*1
 mov [WORDS],EAX
;  CALL IFORM(WORDS,SCRATCH);
; NARGS  2
 push WORDS
 push SCRATCH
 call IFORM
 add  ESP,4*2
;  CALL WRITE(OUTCH,SCRATCH);
; NARGS  2
 push OUTCH
 push SCRATCH
 call WRITE
 add  ESP,4*2
;  VAL=2;                        * IF
;.GEN =VAL,=2,.BNST,
 mov EAX,2
 mov [VAL],EAX
;  TTYPE=3;                      * Token type = Keyword
;.GEN =TTYPE,=3,.BNST,
 mov EAX,3
 mov [TTYPE],EAX
;  TAG=TTYPE SHL 8;
;.GEN =TAG,TTYPE,=8,.BNSHL,.BNST,
 mov EAX,[TTYPE]
 sal EAX,8
 mov [TAG],EAX
;  INDEX=LOOKS(WORDS,VAL,TAG);
;.GEN =INDEX,(WORDS,VAL,TAG),.UFLOOKS,.BNST,
; NARGS  3
 push WORDS
 push VAL
 push TAG
 call LOOKS
 add  ESP,4*3
 mov [INDEX],EAX
;  SCRATCH=10;
;.GEN =SCRATCH,=10,.BNST,
 mov EAX,10
 mov [SCRATCH],EAX
;  CALL IFORM(INDEX,SCRATCH);
; NARGS  2
 push INDEX
 push SCRATCH
 call IFORM
 add  ESP,4*2
;  CALL WRITE(OUTCH,SCRATCH);
; NARGS  2
 push OUTCH
 push SCRATCH
 call WRITE
 add  ESP,4*2
;  CALL B402A(WORDS,SCRATCH);
; NARGS  2
 push WORDS
 push SCRATCH
 call B402A
 add  ESP,4*2
;  CALL WRITE(OUTCH,SCRATCH);
; NARGS  2
 push OUTCH
 push SCRATCH
 call WRITE
 add  ESP,4*2
;  CALL GETS(INDEX,VAL,TAG);
; NARGS  3
 push INDEX
 push VAL
 push TAG
 call GETS
 add  ESP,4*3
;  CALL IFORM(VAL,SCRATCH);
; NARGS  2
 push VAL
 push SCRATCH
 call IFORM
 add  ESP,4*2
;  CALL WRITE(OUTCH,SCRATCH);
; NARGS  2
 push OUTCH
 push SCRATCH
 call WRITE
 add  ESP,4*2
;  CALL IFORM(TAG,SCRATCH);
; NARGS  2
 push TAG
 push SCRATCH
 call IFORM
 add  ESP,4*2
;  CALL WRITE(OUTCH,SCRATCH);
; NARGS  2
 push OUTCH
 push SCRATCH
 call WRITE
 add  ESP,4*2
;  RETURN;
; RETN  ,
 mov ESP,EBP
 pop EBP
 ret
;END
 end
