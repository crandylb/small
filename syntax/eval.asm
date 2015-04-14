;* eval.s1 -- Britten's Archaic Expression Evaluator, CRB, Sep 23, 2014
;* 09/29/2014 CRB tinkered with the coding
;* 10/20/2014 CRB more tinkering
;* 03/09/2015 CRB Add STP reinitialization
;* 03/11/2015 CRB RETURN EXPR after UNTIL ISASEMI
;* 03/15/2015 CRB Delete extraneous PCOUNT after ISAINT
;* 03/15/2015 CRB Add LABB
;* 03/16/2015 CRB Add LABO
;* 03/20/2015 CRB Advance IT after semicolon
;
;BEGIN EVAL;
 global progr
 extern exit
;
;  ENT EVAL;
 global  EVAL
;  EXT TOKENS;
 extern  TOKENS
;  EXT PROC ISAINT;
 extern ISAINT
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
;  SET STKSIZ=30;                * stack size
;  DCL STK(STKSIZ);              * push down stack
STK:
 times 31 dd 0
;  DCL STP=0;                    * stack pointer
STP:
 dd  0
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
;* process unary '+' or '-'
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
;    IF ISALP(IT); THEN 
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
;      STK(STP)=AOP; STP=STP+1;
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
;      ELSE 
 jmp LJ8
LJ7:
;        IF ISAINT(IT); THEN 
;.GEN (IT),.UFISAINT,=0,.BN-,
; ARGT D IT
 mov EBX,[EBP+8] ; IT
; NARGS  1
; ARG D IT
 push EBX
 call ISAINT
 add  ESP,4*1
 or EAX,EAX
 jz LJ10
;          NUMB=TOKENS(IT+1);    * get value of integer
;.GEN =NUMB,=TOKENS,IT,=1,.BC+,=2,.BNSHL,.BC+,.UA,.BNST,
; L D IT
 mov EBX,[EBP+8] ; IT
 mov EAX,[EBX]
 inc EAX
 sal EAX,2
 add EAX,TOKENS
 mov EAX,[EAX]
 mov [NUMB],EAX
;          IT=IT+4;
;.GEN =IT,IT,=4,.BC+,.BNST,
; L D IT
 mov EBX,[EBP+8] ; IT
 mov EAX,[EBX]
 add EAX,4
; ST D IT
 mov EBX,[EBP+8] ; IT
 mov [EBX],EAX
;          REPEAT 
LJ11:
;LABEL LABO;
LABO:
;            IF MOP EQ STAR; THEN TERM=TERM*NUMB;
;.GEN MOP,STAR,.BN-,
 mov EAX,[MOP]
 sub EAX,42   ; STAR
 jne LJ13
;.GEN =TERM,TERM,NUMB,.BC*,.BNST,
 mov EAX,[TERM]
 imul dword [NUMB]
 mov [TERM],EAX
;              ELSE IF MOP EQ SLASH; THEN TERM=TERM/NUMB;
 jmp LJ14
LJ13:
;.GEN MOP,SLASH,.BN-,
 mov EAX,[MOP]
 sub EAX,47   ; SLASH
 jne LJ15
;.GEN =TERM,TERM,NUMB,.BN/,.BNST,
 mov EAX,[TERM]
 cdq
 idiv dword [NUMB]
 mov [TERM],EAX
;              ELSE TERM=NUMB;
 jmp LJ16
LJ15:
;.GEN =TERM,NUMB,.BNST,
 mov EAX,[NUMB]
 mov [TERM],EAX
;              ENDIF ENDIF
LJ16:
LJ14:
;            MOP=0;
;.GEN =MOP,=0,.BNST,
 mov EAX,0
 mov [MOP],EAX
;            IF ISAAST(IT); THEN MOP=STAR; IT=IT+4; GO TO LABB;
;.GEN (IT),.UFISAAST,=0,.BN-,
; ARGT D IT
 mov EBX,[EBP+8] ; IT
; NARGS  1
; ARG D IT
 push EBX
 call ISAAST
 add  ESP,4*1
 or EAX,EAX
 jz LJ18
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
;              ELSE IF ISASLA(IT); THEN MOP=SLASH; IT=IT+4; GO TO LABB;
 jmp LJ19
LJ18:
;.GEN (IT),.UFISASLA,=0,.BN-,
; ARGT D IT
 mov EBX,[EBP+8] ; IT
; NARGS  1
; ARG D IT
 push EBX
 call ISASLA
 add  ESP,4*1
 or EAX,EAX
 jz LJ21
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
;              ENDIF ENDIF
LJ21:
LJ19:
;            IF AOP EQ PLUS; THEN EXPR=EXPR+TERM;
;.GEN AOP,PLUS,.BN-,
 mov EAX,[AOP]
 sub EAX,43   ; PLUS
 jne LJ22
;.GEN =EXPR,EXPR,TERM,.BC+,.BNST,
 mov EAX,[EXPR]
 add EAX,[TERM]
 mov [EXPR],EAX
;              ELSE IF AOP EQ MINUS; THEN EXPR=EXPR-TERM;
 jmp LJ23
LJ22:
;.GEN AOP,MINUS,.BN-,
 mov EAX,[AOP]
 sub EAX,45   ; MINUS
 jne LJ24
;.GEN =EXPR,EXPR,TERM,.BN-,.BNST,
 mov EAX,[EXPR]
 sub EAX,[TERM]
 mov [EXPR],EAX
;              ELSE EXPR=TERM;
 jmp LJ25
LJ24:
;.GEN =EXPR,TERM,.BNST,
 mov EAX,[TERM]
 mov [EXPR],EAX
;              ENDIF ENDIF
LJ25:
LJ23:
;            AOP=0;
;.GEN =AOP,=0,.BNST,
 mov EAX,0
 mov [AOP],EAX
;            IF ISAPLU(IT); THEN AOP=PLUS; IT=IT+4; GO TO LABB;
;.GEN (IT),.UFISAPLU,=0,.BN-,
; ARGT D IT
 mov EBX,[EBP+8] ; IT
; NARGS  1
; ARG D IT
 push EBX
 call ISAPLU
 add  ESP,4*1
 or EAX,EAX
 jz LJ27
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
;              ELSE IF ISAMIN(IT); THEN AOP=MINUS; IT=IT+4; GO TO LABB;
 jmp LJ28
LJ27:
;.GEN (IT),.UFISAMIN,=0,.BN-,
; ARGT D IT
 mov EBX,[EBP+8] ; IT
; NARGS  1
; ARG D IT
 push EBX
 call ISAMIN
 add  ESP,4*1
 or EAX,EAX
 jz LJ30
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
;              ENDIF ENDIF
LJ30:
LJ28:
;            IF ISARP(IT); THEN 
;.GEN (IT),.UFISARP,=0,.BN-,
; ARGT D IT
 mov EBX,[EBP+8] ; IT
; NARGS  1
; ARG D IT
 push EBX
 call ISARP
 add  ESP,4*1
 or EAX,EAX
 jz LJ32
;              IT=IT+4;
;.GEN =IT,IT,=4,.BC+,.BNST,
; L D IT
 mov EBX,[EBP+8] ; IT
 mov EAX,[EBX]
 add EAX,4
; ST D IT
 mov EBX,[EBP+8] ; IT
 mov [EBX],EAX
;              PCOUNT=PCOUNT-1;
;.GEN =PCOUNT,PCOUNT,=1,.BN-,.BNST,
 mov EAX,[PCOUNT]
 dec EAX
 mov [PCOUNT],EAX
;              NUMB=EXPR;
;.GEN =NUMB,EXPR,.BNST,
 mov EAX,[EXPR]
 mov [NUMB],EAX
;              STP=STP-1; TERM=STK(STP);
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
;              STP=STP-1; EXPR=STK(STP);
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
;              STP=STP-1; MOP=STK(STP);
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
;              STP=STP-1; AOP=STK(STP);
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
;              GO TO LABO;
 jmp LABO
;              ENDIF
LJ32:
;            ELSE 
 jmp LJ33
LJ12:
;              RETURN EXPR;
;.GEN EXPR,
 mov EAX,[EXPR]
; RETN  EVAL,1
 mov ESP,EBP
 pop EBP
 ret
;            ENDIF
LJ33:
;          UNTIL ISASEMI(IT);
;.GEN (IT),.UFISASEMI,=0,.BN-,
; ARGT D IT
 mov EBX,[EBP+8] ; IT
; NARGS  1
; ARG D IT
 push EBX
 call ISASEMI
 add  ESP,4*1
 or EAX,EAX
 jz LJ11
LJ10:
;        IT=IT+4;
;.GEN =IT,IT,=4,.BC+,.BNST,
; L D IT
 mov EBX,[EBP+8] ; IT
 mov EAX,[EBX]
 add EAX,4
; ST D IT
 mov EBX,[EBP+8] ; IT
 mov [EBX],EAX
;        RETURN EXPR;
;.GEN EXPR,
 mov EAX,[EXPR]
; RETN  EVAL,1
 mov ESP,EBP
 pop EBP
 ret
;      ENDIF
LJ8:
;    RETURN 0;                   * error return, need a flag or summat
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
