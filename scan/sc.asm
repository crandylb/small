;* sc.s1 -- Main program for Small Compiler, CRB, Aug 5, 2015
;* Adapted from testscan 03/03/2015
;* 08/31/2015 CRB Fixing up for testlist
;* 09/11/2015 CRB Adding TSTLFG to control SHOTOKS
;
;  ENTRY SC;
 global  SC
;  BEGIN SC;
 global progr
 extern exit
;  START SC;
 global  SC
 section .text
progr:
 push EBP
 mov  EBP,ESP
 jmp SC
;
;  EXT PROC SCAN,INITSYM;
 extern SCAN
 extern  INITSYM
;  EXT PROC WRITE;
 extern WRITE
;  EXT PROC SHOW;
 extern SHOW
;  EXT OUTCH,COLLS;
 extern  OUTCH
 extern  COLLS
;
;  ENT LISTCH;
 global  LISTCH
;  ENT TSTFLG;                     * flag to control SHOTOKS in scan
 global  TSTFLG
;
;  DCL LISTCH=4;                   * listing channel
 section .data
LISTCH:
 dd  4
;  DCL TSTFLG;
TSTFLG:
 times 1 dd 0
;  MSG ERRSUM=' NO ERRORS DETECTED';
ERRSUM:
 dd  19
 dd  32
 dd  78
 dd  79
 dd  32
 dd  69
 dd  82
 dd  82
 dd  79
 dd  82
 dd  83
 dd  32
 dd  68
 dd  69
 dd  84
 dd  69
 dd  67
 dd  84
 dd  69
 dd  68
;  MSG NCOLLS='Collisions';
NCOLLS:
 dd  10
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
;
;LABEL SC;
 section .text
SC:
;  TSTFLG=1;                       * turn on flag for SHOTOKS output
;.GEN =TSTFLG,=1,.BNST,
 mov EAX,1
 mov [TSTFLG],EAX
;  CALL INITSYM;
; NARGS  0
 call INITSYM
;  CALL SCAN;
; NARGS  0
 call SCAN
;  CALL WRITE(LISTCH,ERRSUM);
; NARGS  2
 push LISTCH
 push ERRSUM
 call WRITE
 add  ESP,4*2
;  CALL SHOW(NCOLLS,COLLS);
; NARGS  2
 push NCOLLS
 push COLLS
 call SHOW
 add  ESP,4*2
;  RETURN
; RETN  ,
 mov ESP,EBP
 pop EBP
 ret
;
;END
 end
