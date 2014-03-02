;* testscan.s1 -- Test Small scanner using LEX, CRB, Feb 21, 2014
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
;  ENTRY BUFF;                   * make BUFF buffer global for LEX
 global  BUFF
;
;  EXTERNAL PROC READ,WRITE;
 extern READ
 extern  WRITE
;  EXTERNAL PROC LEX,CAT2;
 extern LEX
 extern  CAT2
;  EXT PROC SCAN;
 extern SCAN
;  EXT OUTCH;
 extern  OUTCH
;
;  MSG GREET='Begin Small SCAN Test'
 section .data
GREET:
 dd  21
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
;  CALL SCAN;
; NARGS  0
 call SCAN
;  RETURN
; RETN  ,
 mov ESP,EBP
 pop EBP
 ret
;
;END
 end
