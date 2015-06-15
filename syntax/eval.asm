;* eval.s1 -- Britten's Archaic Expression Evaluator, CRB, Sep 23, 2014
;* 09/29/2014 CRB tinkered with the coding
;* 10/20/2014 CRB more tinkering
;* 03/09/2015 CRB Add STP reinitialization
;* 03/11/2015 CRB RETURN EXPR after UNTIL ISASEMI
;* 03/15/2015 CRB Delete extraneous PCOUNT after ISAINT
;* 03/15/2015 CRB Add LABB
;* 03/16/2015 CRB Add LABO
;* 03/20/2015 CRB Advance IT after semicolon
;* 04/23/2015 CRB Add symbolic operands and error messages
;* 05/03/2015 CRB Fix logical structure error
;* 05/06/2015 CRB Add error messages
;* 05/22/2015 CRB Add another error message
;* 05/31/2015 CRB Use ISASET instead of ISASYM
;
;BEGIN EVAL;
 global progr
 extern exit
;
;  ENT EVAL;
 global  EVAL
;  EXT ERRCNT;                   * global error counter
 extern  ERRCNT
;  EXT TOKENS;
 extern  TOKENS
;  EXT MASKV;
 extern  MASKV
;  EXT PROC ISAINT;
 extern ISAINT
;  EXT PROC ISASET;
 extern ISASET
;  EXT PROC ISAPLU;
 extern ISAPLU
;  EXT PROC ISAMIN;
 extern ISAMIN
;  EXT PROC ISAAST;
 extern ISAAST
;  EXT PROC ISASLA;
 extern ISASLA
;  EXT PROC ISALP;
 extern ISALP
;  EXT PROC ISARP;
 extern ISARP
;  EXT PROC ISASEMI;
 extern ISASEMI
;  EXT PROC GETS;
 extern GETS
;  EXT PROC ERROR;
 extern ERROR
;
;  SET PLUS=43;                  * ASCII +
;  SET MINUS=45;                 * ASCII -
;  SET STAR=42;                  * ASCII *
;  SET SLASH=47;                 * ASCII /
;  SET LPAREN=40;                * ASCII left parenthesis
;  SET RPAREN=41;                * ASCII right parenthesis
;
;  DCL AOP,MOP;                  * add operator, mult operator
 section .data
AOP:
 times 1 dd 0
MOP:
 times 1 dd 0
;  DCL NUMB,TERM=1,EXPR=0;
NUMB:
 times 1 dd 0
TERM:
 dd  1
EXPR:
 dd  0
;  DCL PCOUNT;                   * parenthesis level count
PCOUNT:
 times 1 dd 0
;  DCL VAL,TAG;
VAL:
 times 1 dd 0
TAG:
 times 1 dd 0
;  MSG ERROPD=' Operand expected';
ERROPD:
 dd  17
 dd  32
 dd  79
 dd  112
 dd  101
 dd  114
 dd  97
 dd  110
 dd  100
 dd  32
 dd  101
 dd  120
 dd  112
 dd  101
 dd  99
 dd  116
 dd  101
 dd  100
;  MSG ERROPR=' Operator expected';
ERROPR:
 dd  18
 dd  32
 dd  79
 dd  112
 dd  101
 dd  114
 dd  97
 dd  116
 dd  111
 dd  114
 dd  32
 dd  101
 dd  120
 dd  112
 dd  101
 dd  99
 dd  116
 dd  101
 dd  100
;  MSG ERRMRP=' Missing right paren'; 
ERRMRP:
 dd  20
 dd  32
 dd  77
 dd  105
 dd  115
 dd  115
 dd  105
 dd  110
 dd  103
 dd  32
 dd  114
 dd  105
 dd  103
 dd  104
 dd  116
 dd  32
 dd  112
 dd  97
 dd  114
 dd  101
 dd  110
;  MSG ERREXP=' Extra right paren';
ERREXP:
 dd  18
 dd  32
 dd  69
 dd  120
 dd  116
 dd  114
 dd  97
 dd  32
 dd  114
 dd  105
 dd  103
 dd  104
 dd  116
 dd  32
 dd  112
 dd  97
 dd  114
 dd  101
 dd  110
;  MSG ERRMTR=' Missing terminator';
ERRMTR:
 dd  19
 dd  32
 dd  77
 dd  105
 dd  115
 dd  115
 dd  105
 dd  110
 dd  103
 dd  32
 dd  116
 dd  101
 dd  114
 dd  109
 dd  105
 dd  110
 dd  97
 dd  116
 dd  111
 dd  114
;  SET STKSIZ=4*30;              * stack size
;  DCL STP=0;                    * stack pointer
STP:
 dd  0
;  DCL STK(STKSIZ);              * push down stack
STK:
 times 121 dd 0
;
;* evaluate infix expression starting at IT in TOKENS array
;  PROC EVAL(IT);
 section .text
; SUBR  EVAL
EVAL:
 push EBP
 mov  EBP,ESP
; NPARS  1
; PAR  IT
; PEND
;    PCOUNT=0;
;.GEN =PCOUNT,=0,.BNST,
 mov EAX,0
 mov [PCOUNT],EAX
;    STP=0;
;.GEN =STP,=0,.BNST,
 mov EAX,0
 mov [STP],EAX
;LABEL LABA;
LABA:
;    AOP=0;
;.GEN =AOP,=0,.BNST,
 mov EAX,0
 mov [AOP],EAX
;    MOP=0;
;.GEN =MOP,=0,.BNST,
 mov EAX,0
 mov [MOP],EAX
;    TERM=1;
;.GEN =TERM,=1,.BNST,
 mov EAX,1
 mov [TERM],EAX
;    EXPR=0;
;.GEN =EXPR,=0,.BNST,
 mov EAX,0
 mov [EXPR],EAX
;* process unary plus or minus
;    IF ISAPLU(IT); THEN AOP=PLUS; IT=IT+4;
;.GEN (IT),.UFISAPLU,=0,.BN-,
; ARGT D IT
 mov EBX,[EBP+8] ; IT
; NARGS  1
; ARG D IT
 push EBX
 call ISAPLU
 add  ESP,4*1
 or EAX,EAX
 jz LJ2
;.GEN =AOP,PLUS,.BNST,
 mov EAX,43   ; PLUS
 mov [AOP],EAX
;.GEN =IT,IT,=4,.BC+,.BNST,
; L D IT
 mov EBX,[EBP+8] ; IT
 mov EAX,[EBX]
 add EAX,4
; ST D IT
 mov EBX,[EBP+8] ; IT
 mov [EBX],EAX
;      ELSE IF ISAMIN(IT); THEN AOP=MINUS; IT=IT+4;
 jmp LJ3
LJ2:
;.GEN (IT),.UFISAMIN,=0,.BN-,
; ARGT D IT
 mov EBX,[EBP+8] ; IT
; NARGS  1
; ARG D IT
 push EBX
 call ISAMIN
 add  ESP,4*1
 or EAX,EAX
 jz LJ5
;.GEN =AOP,MINUS,.BNST,
 mov EAX,45   ; MINUS
 mov [AOP],EAX
;.GEN =IT,IT,=4,.BC+,.BNST,
; L D IT
 mov EBX,[EBP+8] ; IT
 mov EAX,[EBX]
 add EAX,4
; ST D IT
 mov EBX,[EBP+8] ; IT
 mov [EBX],EAX
;      ENDIF ENDIF
LJ5:
LJ3:
;LABEL LABB;
LABB:
;    IF ISALP(IT); THEN          * left parenthesis
;.GEN (IT),.UFISALP,=0,.BN-,
; ARGT D IT
 mov EBX,[EBP+8] ; IT
; NARGS  1
; ARG D IT
 push EBX
 call ISALP
 add  ESP,4*1
 or EAX,EAX
 jz LJ7
;      IT=IT+4;
;.GEN =IT,IT,=4,.BC+,.BNST,
; L D IT
 mov EBX,[EBP+8] ; IT
 mov EAX,[EBX]
 add EAX,4
; ST D IT
 mov EBX,[EBP+8] ; IT
 mov [EBX],EAX
;      PCOUNT=PCOUNT+1;
;.GEN =PCOUNT,PCOUNT,=1,.BC+,.BNST,
 mov EAX,[PCOUNT]
 inc EAX
 mov [PCOUNT],EAX
;      STK(STP)=AOP; STP=STP+1;  * push context
;.GEN =STK,STP,=2,.BNSHL,.BC+,AOP,.BNST,
 mov EAX,[STP]
 sal EAX,2
 add EAX,STK
 mov [T1Z],EAX
 mov EAX,[AOP]
 mov EDX,EAX
 mov EAX,[T1Z]
 mov [EAX],EDX
;.GEN =STP,STP,=1,.BC+,.BNST,
 mov EAX,[STP]
 inc EAX
 mov [STP],EAX
;      STK(STP)=MOP; STP=STP+1;
;.GEN =STK,STP,=2,.BNSHL,.BC+,MOP,.BNST,
 mov EAX,[STP]
 sal EAX,2
 add EAX,STK
 mov [T1Z],EAX
 mov EAX,[MOP]
 mov EDX,EAX
 mov EAX,[T1Z]
 mov [EAX],EDX
;.GEN =STP,STP,=1,.BC+,.BNST,
 mov EAX,[STP]
 inc EAX
 mov [STP],EAX
;      STK(STP)=EXPR; STP=STP+1;
;.GEN =STK,STP,=2,.BNSHL,.BC+,EXPR,.BNST,
 mov EAX,[STP]
 sal EAX,2
 add EAX,STK
 mov [T1Z],EAX
 mov EAX,[EXPR]
 mov EDX,EAX
 mov EAX,[T1Z]
 mov [EAX],EDX
;.GEN =STP,STP,=1,.BC+,.BNST,
 mov EAX,[STP]
 inc EAX
 mov [STP],EAX
;      STK(STP)=TERM; STP=STP+1;
;.GEN =STK,STP,=2,.BNSHL,.BC+,TERM,.BNST,
 mov EAX,[STP]
 sal EAX,2
 add EAX,STK
 mov [T1Z],EAX
 mov EAX,[TERM]
 mov EDX,EAX
 mov EAX,[T1Z]
 mov [EAX],EDX
;.GEN =STP,STP,=1,.BC+,.BNST,
 mov EAX,[STP]
 inc EAX
 mov [STP],EAX
;      GO TO LABA;
 jmp LABA
;      ENDIF
LJ7:
;* process operand [needs rewrite]
;    IF ISAINT(IT); THEN 
;.GEN (IT),.UFISAINT,=0,.BN-,
; ARGT D IT
 mov EBX,[EBP+8] ; IT
; NARGS  1
; ARG D IT
 push EBX
 call ISAINT
 add  ESP,4*1
 or EAX,EAX
 jz LJ9
;        NUMB=TOKENS(IT+1);      * get value of integer operand
;.GEN =NUMB,=TOKENS,IT,=1,.BC+,=2,.BNSHL,.BC+,.UA,.BNST,
; L D IT
 mov EBX,[EBP+8] ; IT
 mov EAX,[EBX]
 inc EAX
 sal EAX,2
 add EAX,TOKENS
 mov EAX,[EAX]
 mov [NUMB],EAX
;        IT=IT+4;
;.GEN =IT,IT,=4,.BC+,.BNST,
; L D IT
 mov EBX,[EBP+8] ; IT
 mov EAX,[EBX]
 add EAX,4
; ST D IT
 mov EBX,[EBP+8] ; IT
 mov [EBX],EAX
;      ELSE IF ISASET(IT); THEN 
 jmp LJ10
LJ9:
;.GEN (IT),.UFISASET,=0,.BN-,
; ARGT D IT
 mov EBX,[EBP+8] ; IT
; NARGS  1
; ARG D IT
 push EBX
 call ISASET
 add  ESP,4*1
 or EAX,EAX
 jz LJ12
;        NUMB=TOKENS(IT+1);      * get value of symbolic operand
;.GEN =NUMB,=TOKENS,IT,=1,.BC+,=2,.BNSHL,.BC+,.UA,.BNST,
; L D IT
 mov EBX,[EBP+8] ; IT
 mov EAX,[EBX]
 inc EAX
 sal EAX,2
 add EAX,TOKENS
 mov EAX,[EAX]
 mov [NUMB],EAX
;        IT=IT+4;
;.GEN =IT,IT,=4,.BC+,.BNST,
; L D IT
 mov EBX,[EBP+8] ; IT
 mov EAX,[EBX]
 add EAX,4
; ST D IT
 mov EBX,[EBP+8] ; IT
 mov [EBX],EAX
;        CALL GETS(NUMB,VAL,TAG);
; NARGS  3
 push NUMB
 push VAL
 push TAG
 call GETS
 add  ESP,4*3
;        NUMB=VAL AND MASKV;
;.GEN =NUMB,VAL,MASKV,.BCAND,.BNST,
 mov EAX,[VAL]
 and EAX,[MASKV]
 mov [NUMB],EAX
;      ELSE                      * operand expected error
 jmp LJ14
LJ12:
;        ERRCNT=ERRCNT+1;        * bump error count
;.GEN =ERRCNT,ERRCNT,=1,.BC+,.BNST,
 mov EAX,[ERRCNT]
 inc EAX
 mov [ERRCNT],EAX
;        CALL ERROR(IT,ERROPD);
; ARGT D IT
 mov EBX,[EBP+8] ; IT
; NARGS  2
; ARG D IT
 push EBX
 push ERROPD
 call ERROR
 add  ESP,4*2
;        GO TO LABP;
 jmp LABP
;      ENDIF ENDIF
LJ14:
LJ10:
;
;LABEL LABO;                     * operator process loop
LABO:
;    REPEAT 
LJ16:
;      IF IT/4 GE TOKENS; THEN   * check for end of tokens list
;.GEN IT,=4,.BN/,TOKENS,.BN-,
; L D IT
 mov EBX,[EBP+8] ; IT
 mov EAX,[EBX]
 cdq
 mov  ECX,4
 idiv dword ECX
 sub EAX,[TOKENS]
 jl LJ18
;        ERRCNT=ERRCNT+1;
;.GEN =ERRCNT,ERRCNT,=1,.BC+,.BNST,
 mov EAX,[ERRCNT]
 inc EAX
 mov [ERRCNT],EAX
;        CALL ERROR(IT,ERRMTR);  * missing terminator
; ARGT D IT
 mov EBX,[EBP+8] ; IT
; NARGS  2
; ARG D IT
 push EBX
 push ERRMTR
 call ERROR
 add  ESP,4*2
;        GO TO LABP;             * error exit
 jmp LABP
;        ENDIF
LJ18:
;      IF MOP EQ STAR; THEN TERM=TERM*NUMB;              * do multiply
;.GEN MOP,STAR,.BN-,
 mov EAX,[MOP]
 sub EAX,42   ; STAR
 jne LJ20
;.GEN =TERM,TERM,NUMB,.BC*,.BNST,
 mov EAX,[TERM]
 imul dword [NUMB]
 mov [TERM],EAX
;        ELSE IF MOP EQ SLASH; THEN TERM=TERM/NUMB;      * do divide
 jmp LJ21
LJ20:
;.GEN MOP,SLASH,.BN-,
 mov EAX,[MOP]
 sub EAX,47   ; SLASH
 jne LJ22
;.GEN =TERM,TERM,NUMB,.BN/,.BNST,
 mov EAX,[TERM]
 cdq
 idiv dword [NUMB]
 mov [TERM],EAX
;        ELSE TERM=NUMB;
 jmp LJ23
LJ22:
;.GEN =TERM,NUMB,.BNST,
 mov EAX,[NUMB]
 mov [TERM],EAX
;        ENDIF ENDIF
LJ23:
LJ21:
;      MOP=0;
;.GEN =MOP,=0,.BNST,
 mov EAX,0
 mov [MOP],EAX
;* process multiplicative operator
;      IF ISAAST(IT); THEN MOP=STAR; IT=IT+4; GO TO LABB;
;.GEN (IT),.UFISAAST,=0,.BN-,
; ARGT D IT
 mov EBX,[EBP+8] ; IT
; NARGS  1
; ARG D IT
 push EBX
 call ISAAST
 add  ESP,4*1
 or EAX,EAX
 jz LJ25
;.GEN =MOP,STAR,.BNST,
 mov EAX,42   ; STAR
 mov [MOP],EAX
;.GEN =IT,IT,=4,.BC+,.BNST,
; L D IT
 mov EBX,[EBP+8] ; IT
 mov EAX,[EBX]
 add EAX,4
; ST D IT
 mov EBX,[EBP+8] ; IT
 mov [EBX],EAX
 jmp LABB
;        ELSE IF ISASLA(IT); THEN MOP=SLASH; IT=IT+4; GO TO LABB;
 jmp LJ26
LJ25:
;.GEN (IT),.UFISASLA,=0,.BN-,
; ARGT D IT
 mov EBX,[EBP+8] ; IT
; NARGS  1
; ARG D IT
 push EBX
 call ISASLA
 add  ESP,4*1
 or EAX,EAX
 jz LJ28
;.GEN =MOP,SLASH,.BNST,
 mov EAX,47   ; SLASH
 mov [MOP],EAX
;.GEN =IT,IT,=4,.BC+,.BNST,
; L D IT
 mov EBX,[EBP+8] ; IT
 mov EAX,[EBX]
 add EAX,4
; ST D IT
 mov EBX,[EBP+8] ; IT
 mov [EBX],EAX
 jmp LABB
;        ENDIF ENDIF
LJ28:
LJ26:
;      IF AOP EQ PLUS; THEN EXPR=EXPR+TERM;              * do add
;.GEN AOP,PLUS,.BN-,
 mov EAX,[AOP]
 sub EAX,43   ; PLUS
 jne LJ29
;.GEN =EXPR,EXPR,TERM,.BC+,.BNST,
 mov EAX,[EXPR]
 add EAX,[TERM]
 mov [EXPR],EAX
;        ELSE IF AOP EQ MINUS; THEN EXPR=EXPR-TERM;      * do subtract
 jmp LJ30
LJ29:
;.GEN AOP,MINUS,.BN-,
 mov EAX,[AOP]
 sub EAX,45   ; MINUS
 jne LJ31
;.GEN =EXPR,EXPR,TERM,.BN-,.BNST,
 mov EAX,[EXPR]
 sub EAX,[TERM]
 mov [EXPR],EAX
;        ELSE EXPR=TERM;
 jmp LJ32
LJ31:
;.GEN =EXPR,TERM,.BNST,
 mov EAX,[TERM]
 mov [EXPR],EAX
;        ENDIF ENDIF
LJ32:
LJ30:
;      AOP=0;
;.GEN =AOP,=0,.BNST,
 mov EAX,0
 mov [AOP],EAX
;* process additive operator
;      IF ISAPLU(IT); THEN AOP=PLUS; IT=IT+4; GO TO LABB;
;.GEN (IT),.UFISAPLU,=0,.BN-,
; ARGT D IT
 mov EBX,[EBP+8] ; IT
; NARGS  1
; ARG D IT
 push EBX
 call ISAPLU
 add  ESP,4*1
 or EAX,EAX
 jz LJ34
;.GEN =AOP,PLUS,.BNST,
 mov EAX,43   ; PLUS
 mov [AOP],EAX
;.GEN =IT,IT,=4,.BC+,.BNST,
; L D IT
 mov EBX,[EBP+8] ; IT
 mov EAX,[EBX]
 add EAX,4
; ST D IT
 mov EBX,[EBP+8] ; IT
 mov [EBX],EAX
 jmp LABB
;        ELSE IF ISAMIN(IT); THEN AOP=MINUS; IT=IT+4; GO TO LABB;
 jmp LJ35
LJ34:
;.GEN (IT),.UFISAMIN,=0,.BN-,
; ARGT D IT
 mov EBX,[EBP+8] ; IT
; NARGS  1
; ARG D IT
 push EBX
 call ISAMIN
 add  ESP,4*1
 or EAX,EAX
 jz LJ37
;.GEN =AOP,MINUS,.BNST,
 mov EAX,45   ; MINUS
 mov [AOP],EAX
;.GEN =IT,IT,=4,.BC+,.BNST,
; L D IT
 mov EBX,[EBP+8] ; IT
 mov EAX,[EBX]
 add EAX,4
; ST D IT
 mov EBX,[EBP+8] ; IT
 mov [EBX],EAX
 jmp LABB
;        ENDIF ENDIF
LJ37:
LJ35:
;      IF ISARP(IT); THEN        * right parenthesis
;.GEN (IT),.UFISARP,=0,.BN-,
; ARGT D IT
 mov EBX,[EBP+8] ; IT
; NARGS  1
; ARG D IT
 push EBX
 call ISARP
 add  ESP,4*1
 or EAX,EAX
 jz LJ39
;        IT=IT+4;
;.GEN =IT,IT,=4,.BC+,.BNST,
; L D IT
 mov EBX,[EBP+8] ; IT
 mov EAX,[EBX]
 add EAX,4
; ST D IT
 mov EBX,[EBP+8] ; IT
 mov [EBX],EAX
;        PCOUNT=PCOUNT-1;
;.GEN =PCOUNT,PCOUNT,=1,.BN-,.BNST,
 mov EAX,[PCOUNT]
 dec EAX
 mov [PCOUNT],EAX
;        NUMB=EXPR;              * promote result and pop context
;.GEN =NUMB,EXPR,.BNST,
 mov EAX,[EXPR]
 mov [NUMB],EAX
;        IF PCOUNT GE 0; THEN    * stack pointer valid
;.GEN PCOUNT,=0,.BN-,
 mov EAX,[PCOUNT]
 or EAX,EAX
 jl LJ40
;          STP=STP-1; TERM=STK(STP);
;.GEN =STP,STP,=1,.BN-,.BNST,
 mov EAX,[STP]
 dec EAX
 mov [STP],EAX
;.GEN =TERM,=STK,STP,=2,.BNSHL,.BC+,.UA,.BNST,
 mov EAX,[STP]
 sal EAX,2
 add EAX,STK
 mov EAX,[EAX]
 mov [TERM],EAX
;          STP=STP-1; EXPR=STK(STP);
;.GEN =STP,STP,=1,.BN-,.BNST,
 mov EAX,[STP]
 dec EAX
 mov [STP],EAX
;.GEN =EXPR,=STK,STP,=2,.BNSHL,.BC+,.UA,.BNST,
 mov EAX,[STP]
 sal EAX,2
 add EAX,STK
 mov EAX,[EAX]
 mov [EXPR],EAX
;          STP=STP-1; MOP=STK(STP);
;.GEN =STP,STP,=1,.BN-,.BNST,
 mov EAX,[STP]
 dec EAX
 mov [STP],EAX
;.GEN =MOP,=STK,STP,=2,.BNSHL,.BC+,.UA,.BNST,
 mov EAX,[STP]
 sal EAX,2
 add EAX,STK
 mov EAX,[EAX]
 mov [MOP],EAX
;          STP=STP-1; AOP=STK(STP);
;.GEN =STP,STP,=1,.BN-,.BNST,
 mov EAX,[STP]
 dec EAX
 mov [STP],EAX
;.GEN =AOP,=STK,STP,=2,.BNSHL,.BC+,.UA,.BNST,
 mov EAX,[STP]
 sal EAX,2
 add EAX,STK
 mov EAX,[EAX]
 mov [AOP],EAX
;          ENDIF
LJ40:
;        GO TO LABO;             * continue operator loop
 jmp LABO
;        ENDIF
LJ39:
;
;      UNTIL ISASEMI(IT);        * end of expression
;.GEN (IT),.UFISASEMI,=0,.BN-,
; ARGT D IT
 mov EBX,[EBP+8] ; IT
; NARGS  1
; ARG D IT
 push EBX
 call ISASEMI
 add  ESP,4*1
 or EAX,EAX
 jz LJ16
LJ17:
;
;    IT=IT+4;
;.GEN =IT,IT,=4,.BC+,.BNST,
; L D IT
 mov EBX,[EBP+8] ; IT
 mov EAX,[EBX]
 add EAX,4
; ST D IT
 mov EBX,[EBP+8] ; IT
 mov [EBX],EAX
;    IF PCOUNT; THEN ERRCNT=ERRCNT+1;
;.GEN PCOUNT,=0,.BN-,
 mov EAX,[PCOUNT]
 or EAX,EAX
 jz LJ42
;.GEN =ERRCNT,ERRCNT,=1,.BC+,.BNST,
 mov EAX,[ERRCNT]
 inc EAX
 mov [ERRCNT],EAX
;      IF PCOUNT GT 0; THEN      * check for balanced parens
;.GEN PCOUNT,=0,.BN-,
 mov EAX,[PCOUNT]
 or EAX,EAX
 jle LJ43
;        CALL ERROR(IT,ERRMRP);  * missing right paren
; ARGT D IT
 mov EBX,[EBP+8] ; IT
; NARGS  2
; ARG D IT
 push EBX
 push ERRMRP
 call ERROR
 add  ESP,4*2
;        GO TO LABP;
 jmp LABP
;      ELSE 
 jmp LJ45
LJ43:
;        CALL ERROR(IT,ERREXP);  * extra right paren
; ARGT D IT
 mov EBX,[EBP+8] ; IT
; NARGS  2
; ARG D IT
 push EBX
 push ERREXP
 call ERROR
 add  ESP,4*2
;        GO TO LABP;
 jmp LABP
;      ENDIF ENDIF
LJ45:
LJ42:
;    RETURN EXPR;                * return expression value
;.GEN EXPR,
 mov EAX,[EXPR]
; RETN  EVAL,1
 mov ESP,EBP
 pop EBP
 ret
;
;LABEL LABP;
LABP:
;    RETURN 0;                   * error return
;.GEN =0,
 mov EAX,0
; RETN  EVAL,1
 mov ESP,EBP
 pop EBP
 ret
;  ENDPROC
 section .data
T1Z:
 times 2 dd 0
 section .text
;
;END
 end
