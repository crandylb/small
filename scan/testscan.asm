;* testscan.s1 -- Test Small scanner using LEX, CRB, Feb 21, 2014
;* 06/16/2014 CRB Add initsym
;* 07/03/2014 CRB Debugging
;* 12/29/2014 CRB Add call to show collision count
;* 03/03/2015 CRB Delete unused BUFF
;
;  ENTRY TESTSCAN;
 global  TESTSCAN
;  BEGIN TESTSCAN;
 global progr
 extern exit
;  START TESTSCAN;
 global  TESTSCAN
 section .text
progr:
 push EBP
 mov  EBP,ESP
 jmp TESTSCAN
;
;  EXTERNAL PROC WRITE;
 extern WRITE
;  EXT PROC SCAN,INITSYM,DMPLIST,SHOTOKS;
 extern SCAN
 extern  INITSYM
 extern  DMPLIST
 extern  SHOTOKS
;  EXT PROC SHOW;
 extern SHOW
;  EXT OUTCH,COLLS;
 extern  OUTCH
 extern  COLLS
;
;  MSG GREET='Begin Small SCAN Test with INITSYM';
 section .data
GREET:
 dd  34
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
 dd  83
 dd  67
 dd  65
 dd  78
 dd  32
 dd  84
 dd  101
 dd  115
 dd  116
 dd  32
 dd  119
 dd  105
 dd  116
 dd  104
 dd  32
 dd  73
 dd  78
 dd  73
 dd  84
 dd  83
 dd  89
 dd  77
;  MSG DONE='Scan Done';
DONE:
 dd  9
 dd  83
 dd  99
 dd  97
 dd  110
 dd  32
 dd  68
 dd  111
 dd  110
 dd  101
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
;LABEL TESTSCAN;
 section .text
TESTSCAN:
;  CALL WRITE(OUTCH,GREET);
; NARGS  2
 push OUTCH
 push GREET
 call WRITE
 add  ESP,4*2
;  CALL INITSYM;
; NARGS  0
 call INITSYM
;  CALL DMPLIST;
; NARGS  0
 call DMPLIST
;  CALL SCAN;
; NARGS  0
 call SCAN
;  CALL WRITE(OUTCH,DONE);
; NARGS  2
 push OUTCH
 push DONE
 call WRITE
 add  ESP,4*2
;  CALL SHOTOKS;
; NARGS  0
 call SHOTOKS
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
