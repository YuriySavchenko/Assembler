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
    
    ;-------------------------------------------------------------------
    ; fransform float number into string
    ;-------------------------------------------------------------------
    push buff
    push valueC
    push 64
    call FloatToDec
    ;-------------------------------------------------------------------
    ;------------------------------------------------------------------- 

    ;------------------------------------------------------------------- 
    ; print float number as string
    ;------------------------------------------------------------------- 
    print buff, 64
    print clr, 2
    print brd, 30
    print clr, 2
    ;-------------------------------------------------------------------
    ;-------------------------------------------------------------------
    
    ;-------------------------------------------------------------------
    ; calculating expression
    ;-------------------------------------------------------------------
    xor edx, edx
    xor ecx, ecx
    fld dword [valueB] 
    fptan
    fdivp st1, st0
    inc edx
    fst dword [arrayTg+edx*4]
    inc edx

    .label_pow:
    fld dword [arrayTg+4]
    fmulp st1, st0 
    fst dword [arrayTg+edx*4]
    inc edx
    cmp edx, 6
    jne .label_pow
    fstp dword [valueM] 
    fld dword [arrayA+ecx*4] 
    inc ecx
    
    .label_sum:
    fld dword [arrayA+ecx*4]
    fld dword [arrayTg+ecx*4]
    fmulp st1, st0
    faddp st1, st0
    inc ecx
    cmp ecx, 6
    jne .label_sum
    fstp dword [result]
    ;-------------------------------------------------------------------
    ;-------------------------------------------------------------------

    ;-------------------------------------------------------------------
    ; transform result of expression to string
    ;-------------------------------------------------------------------
    push buffRes
    push result
    push 64
    call FloatToDec
    ;-------------------------------------------------------------------
    ;-------------------------------------------------------------------

    ;-------------------------------------------------------------------
    ; print string which is result of expression
    ;-------------------------------------------------------------------
    print buffRes, 64
    print clr, 2
    print brd, 30
    print clr, 2
    ;-------------------------------------------------------------------
    ;-------------------------------------------------------------------

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
buffRes db 64 dup(0)                        ; text buffer string for output result of expression

clr     db 0xa, 0xd                         ; step on the new line
brd     db 30 dup ('-')                     ; border

valueC  dd -2.999999                        ; value C
valueM  dd 0.0                              ; variable for saving intermediate value
valueTg dd ?                                ; value for saving tan(valueB)
valueB  dd 0.4                              ; varibale for saving angle B
result  dd ?                                ; result of equation

arrayA  dd 9.0, 1.0, 2.0, 3.0, 4.0, 5.0     ; array A
arrayTg dd 0.0, 0.0, 0.0, 0.0, 0.0, 0.0     ; array tan(valueB)^index
