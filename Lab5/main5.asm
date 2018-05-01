%include "print.asm"
%include "exit.asm"
%include "longop.asm"
%include "module.asm"

section .data
    
    nameAutor   db  "Developer: Savchenko Yuriy", 0xa, 0xd          ; name of Author
    lenName     equ $-nameAutor                                     ; length of name Author
    border      db "--------------------------------", 0xa, 0xd     ; little border for correct view
    lenBorder   equ $ - border                                      ; lenght of border
    clear       db 0xa, 0xd                                         ; step on new line

    fact_m dd 2                                                     ; value for landslide
    fact_counter dd 63                                              ; counter of repets
    fact_v dd 1, 0, 0, 0, 0, 0, 0, 0, 0, 0                          ; value for save result of operation factorial()
    
    mul_test10 dd 0FFFFFFFFh, 0FFFFFFFFh, 0FFFFFFFFh, 0FFFFFFFFh, 0FFFFFFFFh, 0FFFFFFFFh, 0FFFFFFFFh, 0FFFFFFFFh, 0FFFFFFFFh, 0FFFFFFFFh            ; first operand for multiplication

    mul_test10x32 dd 0FFFFFFFFh, 0FFFFFFFFh, 0FFFFFFFFh, 0FFFFFFFFh, 0FFFFFFFFh, 0FFFFFFFFh, 0FFFFFFFFh, 0FFFFFFFFh, 0FFFFFFFFh, 0FFFFFFFFh, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0                                                           ; second operand for multiplication
    result dd  0FFFFFFFFh, 0, 0, 0, 0, 0, 0, 0, 0, 0

    mul_test110 dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 0C0000000h            ; third value as second operand for multiplication

section .bss

    fact_x_fact resd 20                                             ; value for save first result of multiplication
    mul_result resd 20                                              ; value for save second result of multiplication 
    mul_result_nn resd 20
    mul_result_z resd 20                                            ; value for save third result of multiplication
    
    textBuff resd 64                                                ; text string for save different values which will have been vieved

section .text

    global _start

_start:

    print border, lenBorder                                         ; print on screen border
    print nameAutor, lenName                                        ; print on screen name Author
    print border, lenBorder                                         ; print on screen border
    
    xor eax, eax                                                    ; set null value for EAX
    xor ebx, ebx                                                    ; set null value for EBX

    ; loop for multiplication and calculating factorial

    .cycle_fact:
    
    push fact_v                                                     ; write first operand to STACK
    push fact_m                                                     ; write second operand to STACK
    push 10                                                         ; write to STACK count of 32-bits digits in digit 
    call Mul_Nx32_LONGOP                                            ; call function for multiplication
    
    inc dword [fact_m]                                              ; increment value fact_m
    dec dword [fact_counter]                                        ; decrement value fact_counter
    
    ; calculating of n!
    
    jnz .cycle_fact                                                 ; repeat of loop 

    push textBuff                                                   ; write to STACK text string for result
    push fact_v                                                     ; write to STACK value which has result
    push 320                                                        ; write to STACK count of bits in result number
    call StrHex_MY                                                  ; call function for transformation number to string
    
    print textBuff, 320                                             ; print on screen string which has result of multiplication
    print clear, 2                                                  ; print step in new line
    print border, lenBorder                                         ; print on screen border

    xor eax, eax                                                    ; set null value for EAX
    xor ebx, ebx                                                    ; set null value for EBX

    ; calculating NxN A=B=n!

    push fact_x_fact                                                ; write to STACK variable for save result
    push fact_v                                                     ; write to STACK address of first operand
    push fact_v                                                     ; write to STACK address of second operand
    push 10                                                         ; write to STACK count of 32-bits digits in digit
    call Mul_NxN_LONGOP                                             ; call function for multiplication

    push textBuff                                                   ; write to STACK text string for result
    push fact_x_fact                                                ; write to STACK value which has result
    push 640                                                        ; write to STACK count of bits in result number
    call StrHex_MY                                                  ; call function for transformation number to string
    
    print textBuff, 640                                             ; write to STACK variable for save result
    print clear, 2                                                  ; print step in new line
    print border, lenBorder                                         ; print on screen border

    xor eax, eax                                                    ; set null value for EAX
    xor ebx, ebx                                                    ; set null value for EBX

    ; calculating NxN A=B=111...11

    push mul_result                                                 ; write to STACK variable for save result
    push mul_test10                                                 ; write to STACK address of first operand
    push mul_test10                                                 ; write to STACK address of second operand
    push 10                                                         ; write to STACK count of 32-bits digits in digit
    call Mul_NxN_LONGOP                                             ; call function for multiplication
    
    push textBuff                                                   ; write to STACK text string for result
    push mul_result                                                 ; write to STACK value which has result
    push 640                                                        ; write to STACK count of bits in result number
    call StrHex_MY                                                  ; call function for transformation number to string
    
    print textBuff, 640                                             ; write to STACK variable for save result
    print clear, 2                                                  ; print step in new line
    print border, lenBorder                                         ; print on screen border

    xor eax, eax                                                    ; set null value for EAX
    xor ebx, ebx                                                    ; set null value for EBX

    ; calculating Nx32 A=111...11 B=FFFFFFFF
    
    push mul_result_nn
    push mul_test10x32                                              ; write to STACK variable for save result
    push result                                                ; write to STACK address of first operand
    push 10                                                         ; write to STACK count of 32-bits digits in digit
    call Mul_NxN_LONGOP                                            ; call function for multiplication
    
    push textBuff                                                   ; write to STACK text string for result
    push mul_result_nn                                              ; write to STACK value which has result
    push 640                                                        ; write to STACK count of bits in result number
    call StrHex_MY                                                  ; call function for transformation number to string

    print textBuff, 640                                             ; write to STACK variable for save result
    print clear, 2                                                  ; print step in new line
    print border, lenBorder                                         ; print on screen border

    xor eax, eax                                                    ; set null value for EAX
    xor ebx, ebx                                                    ; set null value for EBX

    ; calculating NxN A=111...11 B=110...00
    
    push mul_result_z                                               ; write to STACK variable for save result
    push mul_test10                                                 ; write to STACK address of first operand
    push mul_test110                                                ; write to STACK address of second operand
    push 10                                                         ; write to STACK count of 32-bits digits in digit
    call Mul_NxN_LONGOP                                             ; call function for multiplication
    
    push textBuff                                                   ; write to STACK text string for result
    push mul_result_z                                               ; write to STACK value which has result
    push 640                                                        ; write to STACK count of bits in result number
    call StrHex_MY                                                  ; call function for transformation number to string
    
    print textBuff, 640                                             ; write to STACK variable for save result
    print clear, 2                                                  ; print step in new line
    print border, lenBorder                                         ; print on screen border

    call exit                                                       ; call function for correct exit of program
