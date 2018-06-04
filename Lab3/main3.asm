%include "print.asm"                    ; include procedure for view string
%include "module.asm"                   ; include procedure with StrToHex function

section .data
    msg db "Developer: Savchenko Yuriy", 0xa, 0xd                 ; string for initialize author
    clr db 0xa, "---------------------------", 0xa, 0xd           ; clear line or symbol for step on new line 
    len equ $ - msg                                               ; find length of msg
    sclr equ $ - clr                    ; length of clr 

    value1 db 27                        ; 1-byte value for save 27
    value2 db -27                       ; 1-byte value for save -27
    value3 dw 27                        ; 2-byte value for save 27
    value4 dw -27                       ; 2-byte value for save -27
    value5 dd 27                        ; 4-byte value for save 27
    value6 dd -27                       ; 4-byte value for save -27
    value7 dq 27                        ; 8-byte value for save 27
    value8 dq -27                       ; 8-byte value for save -27

    value9 dd 27.0                      ; 4-byte value with floating point for save 27.0
    value10 dd -54.0                    ; 4-byte value with floating point for save -54.0
    value11 dd 27.27                    ; 4-byte value with floating point for save 27.27

    value12 dq 27.0                     ; 8-byte value with floating point for save 27.0
    value13 dq -54.0                    ; 8-byte value with floating point for save -54.0
    value14 dq 27.27                    ; 8-byte value with floating point for save 27.27

    value15 dt 27.0                     ; 10-byte value with floating point for save 27.0
    value16 dt -54.0                    ; 10-byte value with floating point for save -54.0
    value17 dt 27.27                    ; 10-byte value with floating point for save 27.27

section .bss
    TextBuff resb 64                    ; string for save result string

section .text
    global _start                       ; main program

section .code

%macro pushElements 2
    push TextBuff                       ; push to stack string for write result
    push %1                             ; push to stack number which will be translate
    push %2                             ; push to stack count of bits result number
    call StrHex_MY                      ; call function for translate number in 16-system
%endmacro

_start:
    print clr, sclr                     ; view new line
    print msg, len                      ; view author of lab

    ; translate int value1 in 8-bits number

    pushElements value1, 8              ; push parametrs in stack for next translate number
    print TextBuff, 64                  ; view translate number
    print clr, sclr                     ; view new line

    ; translate int value2 in 8-bits number

    pushElements value2, 8              ; push parametrs in stack for next translate number
    print TextBuff, 64                  ; view translate number
    print clr, sclr                     ; view new line

    ; translate int value3 in 16-bits number

    pushElements value3, 16             ; push parametrs in stack for next translate number
    print TextBuff, 64                  ; view translate number
    print clr, sclr                     ; view new line

    ; translate int value4 in 16-bits number

    pushElements value4, 16             ; push parametrs in stack for next translate number
    print TextBuff, 64                  ; view translate number
    print clr, sclr                     ; view new line

    ; translate int value5 in 32-bits number

    pushElements value5, 32             ; push parametrs in stack for next translate number
    print TextBuff, 64                  ; view translate number
    print clr, sclr                     ; view new line

    ; translate int value6 in 32-bits number

    pushElements value6, 32             ; push parametrs in stack for next translate number
    print TextBuff, 64                  ; view translate number
    print clr, sclr                     ; view new line

    ; translate int value7 in 64-bits number

    pushElements value7, 64             ; push parametrs in stack for next translate number
    print TextBuff, 64                  ; view translate number
    print clr, sclr                     ; view new line

    ; translate int value8 in 64-bits number

    pushElements value8, 64             ; push parametrs in stack for next translate number
    print TextBuff, 64                  ; view translate number
    print clr, sclr                     ; view new line

    ; translate number with decimal point value9 in 32-bits number

    pushElements value9, 32             ; push parametrs in stack for next translate number
    print TextBuff, 64                  ; view translate number
    print clr, sclr                     ; view new line

    ; translate number with decimal point value10 in 32-bits number

    pushElements value10, 32            ; push parametrs in stack for next translate number
    print TextBuff, 64                  ; view translate number
    print clr, sclr                     ; view new line

    ; translate number with decimal point value11 in 32-bits number

    pushElements value11, 32            ; push parametrs in stack for next translate number
    print TextBuff, 64                  ; view translate number
    print clr, sclr                     ; view new line

    ; translate number with decimal point value12 in 64-bits number

    pushElements value12, 32            ; push parametrs in stack for next translate number
    print TextBuff, 64                  ; view translate number
    print clr, sclr                     ; view new line

    ; translate number with decimal point value13 in 64-bits number

    pushElements value13, 64            ; push parametrs in stack for next translate number
    print TextBuff, 64                  ; view translate number
    print clr, sclr                     ; view new line

    ; translate number with decimal point value14 in 64-bits number

    pushElements value14, 64            ; push parametrs in stack for next translate number
    print TextBuff, 64                  ; view translate number
    print clr, sclr                     ; view new line

    ; translate number with decimal point value15 in 80-bits number

    pushElements value15, 80            ; push parametrs in stack for next translate number
    print TextBuff, 64                  ; view translate number
    print clr, sclr                     ; view new line

    ; translate number with decimal point value16 in 80-bits number

    pushElements value16, 80            ; push parametrs in stack for next translate number
    print TextBuff, 64                  ; view translate number
    print clr, sclr                     ; view new line

    ; translate number with decimal point value17 in 80-bits number

    pushElements value17, 80            ; push parametrs in stack for next translate number
    print TextBuff, 64                  ; view translate number
    print clr, sclr                     ; view new line

    call exit_Program                   ; call function for correct exit of program

exit_Program:
    mov eax, 1                          ; system_exit
    mov ebx, 0                          ; code of exit
    int 0x80                            ; stop processor
    ret                                 ; exit of procedure

