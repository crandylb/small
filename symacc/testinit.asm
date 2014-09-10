;* testinit.s1 -- Test program for initsym, CRB, May 26, 2014
;
;BEGIN TESTINIT;
 global progr
 extern exit
;
;START INIT;
 global  INIT
 section .text
progr:
 push EBP
 mov  EBP,ESP
 jmp INIT
;EXT PROC INITSYM,PROC DMPLIST;
 extern INITSYM
 extern DMPLIST
;
;LABEL INIT;
 section .text
INIT:
;  CALL INITSYM;           * initialize symbol table from initable.dat
; NARGS  0
 call INITSYM
;  CALL DMPLIST;           * dump contents of table for verification
; NARGS  0
 call DMPLIST
;RETURN
; RETN  ,
 mov ESP,EBP
 pop EBP
 ret
;END
 end
