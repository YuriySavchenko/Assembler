format ELF executable 3

;============= invoke modules =============
include 'print.asm'
include 'longop.asm'
include 'module.asm'
;==========================================

entry start                                 ; label of start program

;================= code ===================
segment readable executable
;==========================================

start:
    
    ;-------------------------------------------------------------------
    ; print name of Developer
    ;-------------------------------------------------------------------
    print brd, 30
    print clr, 2
    print dev, lenDev
    print name, lenName
    print brd, 30
    print clr, 2
    ;-------------------------------------------------------------------
    ;-------------------------------------------------------------------
    
    push buff
    push valueC
    push 64
    call FloatToDec
    
    print buff, 64
    print clr, 2
    print brd, 30
    print clr, 2

    
;================= exit =================
    mov eax, 1                              ; sys_exit
    mov ebx, 0                              ; code of error
    
    int 0x80
;========================================

;================= data =================
segment readable writeable
;========================================

dev      db "Developer: "                   ; word { developer }
lenDev   = $-dev                            ; length of string { dev }
name     db "Savchenko Yuriy", 0xa, 0xd     ; name of developer
lenName  = $-name                           ; length of string { developer }

buff    db 64 dup(0)                        ; text buffer string for output result

clr     db 0xa, 0xd                         ; step on the new line
brd     db 30 dup ('-')                     ; border

valueC  dd -0.468192                 ; value C
result  dd ?                                ; result of equation
