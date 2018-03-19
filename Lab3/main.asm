%include "printStr.asm"     ; include procedure for view string
%include "module.asm"       ; include procedure with StrToHex function

section .data
    msg db "Developer: Savchenko Yuriy", 0xa, 0xd     ; string for initialize author
    clr db 0xa, 0xd                     ; clear line or symbol for step on new line 
    len equ $ - msg                     ; find length of msg
 
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

_start:
    mov ecx, msg
    mov edx, len
    call printStr
     
    ; int 8 for value1

    push TextBuff
    push value1 
    push 8
    call StrHex_MY

    mov ecx, TextBuff
    mov edx, 64
    call printStr
    
    mov ecx, clr
    mov edx, 2
    call printStr

    ; int 8 for value2

    push TextBuff
    push value2
    push 8
    call StrHex_MY

    mov ecx, TextBuff
    mov edx, 64
    call printStr

    mov ecx, clr
    mov edx, 2
    call printStr

    ; int 16 for value3

    push TextBuff
    push value3
    push 16
    call StrHex_MY

    mov ecx, TextBuff
    mov edx, 64
    call printStr

    mov ecx, clr
    mov edx, 2
    call printStr

    ; int 16 for value4

    push TextBuff
    push value4
    push 16
    call StrHex_MY

    mov ecx, TextBuff
    mov edx, 64
    call printStr

    mov ecx, clr
    mov edx, 2
    call printStr

    ; int 32 for value5

    push TextBuff
    push value5
    push 32
    call StrHex_MY

    mov ecx, TextBuff
    mov edx, 64
    call printStr

    mov ecx, clr
    mov edx, 2
    call printStr

    ; int 32 for value6

    push TextBuff
    push value6
    push 32
    call StrHex_MY

    mov ecx, TextBuff
    mov edx, 64
    call printStr

    mov ecx, clr
    mov edx, 2
    call printStr

    ; int 64 for value7

    push TextBuff
    push value7
    push 64
    call StrHex_MY

    mov ecx, TextBuff
    mov edx, 64
    call printStr

    mov ecx, clr
    mov edx, 2
    call printStr

    ; int 64 for value8

    push TextBuff
    push value8
    push 64
    call StrHex_MY

    mov ecx, TextBuff
    mov edx, 64
    call printStr

    mov ecx, clr
    mov edx, 2
    call printStr

    ; step on new line
    
    mov ecx, clr
    mov edx, 2
    call printStr

    ; number in 32-bits floating point for value9

    push TextBuff
    push value9
    push 32
    call StrHex_MY

    mov ecx, TextBuff
    mov edx, 64
    call printStr

    mov ecx, clr
    mov edx, 2
    call printStr

    ; number in 32-bits floating point for value10

    push TextBuff
    push value10
    push 32
    call StrHex_MY

    mov ecx, TextBuff
    mov edx, 64
    call printStr

    mov ecx, clr
    mov edx, 2
    call printStr

    ; number in 32-bits floating point for value11

    push TextBuff
    push value11
    push 32
    call StrHex_MY

    mov ecx, TextBuff
    mov edx, 64
    call printStr

    mov ecx, clr
    mov edx, 2
    call printStr

    ; number in 64-bits floating point for value12

    push TextBuff
    push value12
    push 64
    call StrHex_MY

    mov ecx, TextBuff
    mov edx, 64
    call printStr

    mov ecx, clr
    mov edx, 2
    call printStr

    ; number in 64-bits floating point for value13

    push TextBuff
    push value13
    push 64
    call StrHex_MY

    mov ecx, TextBuff
    mov edx, 64
    call printStr

    mov ecx, clr
    mov edx, 2
    call printStr

    ; number in 64-bits floating point for value14

    push TextBuff
    push value14
    push 64
    call StrHex_MY

    mov ecx, TextBuff
    mov edx, 64
    call printStr

    mov ecx, clr
    mov edx, 2
    call printStr

    ; number in 80-bits floating point for value15

    push TextBuff
    push value15
    push 80
    call StrHex_MY

    mov ecx, TextBuff
    mov edx, 64
    call printStr

    mov ecx, clr
    mov edx, 2
    call printStr

    ; number in 80-bits floating point for value16

    push TextBuff
    push value16
    push 80
    call StrHex_MY

    mov ecx, TextBuff
    mov edx, 64
    call printStr

    mov ecx, clr
    mov edx, 2
    call printStr

    ; number in 80-bits floating point for value17

    push TextBuff
    push value17
    push 80
    call StrHex_MY

    mov ecx, TextBuff
    mov edx, 64
    call printStr

    mov ecx, clr
    mov edx, 2
    call printStr

    ; call function for step on new line

    mov ecx, clr
    mov edx, 2
    call printStr

    call exit_Program

    int 0x80 

exit_Program:
    mov eax, 1
    mov ebx, 0
    
    int 0x80

    ret
