%include "module.asm"
%include "longop.asm"
%include "print.asm"
%include "exit.asm"

section .data
    numLab      db "Laboratory №4", 0xa, 0xd                    ; number of laboratory
    lenLab      equ $ - numLab                                  ; length of numLab
    nameAuthor  db "Developer: Savchenko Yuriy", 0xa, 0xd       ; name of developer
    lenName     equ $ - nameAuthor                              ; length of name autor
    border      db "--------------------------", 0xa, 0xd       ; string border between lines
    lenB        equ $ - border                                  ; length of border
    clr         db 0xa, 0xd                                     ; step on new line

section .bss
    valueSumA1  resd 19         ; value for addition A1
    valueSumB1  resd 19         ; value for addition B1
    valueSumA2  resd 19         ; value for addition A2
    valueSumB2  resd 19         ; value for addition B2
    valueSubA   resd 16         ; value for subtruction A
    valueSubB   resd 16         ; value for subtruction B
    
    resultSumAB1    resd 19     ; variable for save result of first addition
    resultSumAB2    resd 19     ; variable for save result of second addition
    resultSubAB     resd 16     ; variable for save result of subtruction

    textResultSum1  resb 608    ; variable for save result of first addition as string
    textResultSum2  resb 608    ; variable for save result of second addition as string
    textResultSub   resb 512    ; variable for save result of subtruction as string

section .text
    global _start
 
_start:
    print border, lenB          ; print string border 
    print numLab, lenLab        ; print name of laboratory
    print border, lenB          ; print string border
    print nameAuthor, lenName   ; print name Author 
    print border, lenB          ; print string border

    ; addition first values A and B

    mov eax, 80010001h          ; the first four bits
    mov ecx, 19                 ; count of iterations
    mov edx, 0                  ; position in number

    .fillValuesSum1:
    mov dword [valueSumA1+4*edx], eax               ; write four bits from position in variable A
    mov dword [valueSumB1+4*edx], 80000001h         ; write four bits from position in variable B 
    add eax, 10000h                                 ; magnification value A on 10000h
    inc edx                                         ; increment edx
    dec ecx                                         ; decrement ecx
    jnz .fillValuesSum1                             ; while ecx not equal 0 we are repeat cycle

    push valueSumA1             ; push variable valueSumA1 to stack 
    push valueSumB1             ; push variable valueSumB1 to stack
    push resultSumAB1           ; push variable resultSumAB1 to stack
    call Add_608_LONGOP         ; call function for addition A and B

    push textResultSum1         ; push variable textResultSum1 to stack for save result of addition
    push resultSumAB1           ; push variable which will be translate in string textResultSum1
    push 608                    ; push to stack count of bits result number
    call StrHex_MY              ; call function for translate number in 608-bit number
    
    print textResultSum1, 608   ; view result string 
    print clr, 2                ; view step on new line
    print border, lenB          ; view border line
    
    ; addition second values A and B

    mov eax, 11h                ; the first four bits  
    mov ecx, 19                 ; count of iteratons 
    mov edx, 0                  ; position in number

    .fillValuesSum2
    mov dword [valueSumA2+4*edx], eax               ; write four bits from position in variable A
    mov dword [valueSumB2+4*edx], 80000001h         ; write four bits from position in variable B
    add eax, 1h                                     ; magnification value A on 1h
    inc edx                                         ; increment edx
    dec ecx                                         ; decrement ecx
    jnz .fillValuesSum2                             ; while ecx not equal 0 we are repeat cycle
    
    push valueSumA2             ; push variable valueSumA2 to stack
    push valueSumB2             ; push variable valueSumB2 to stack
    push resultSumAB2           ; push variable resultSumAB2 to stack
    call Add_608_LONGOP         ; call function for addition A and B
    
    push textResultSum2         ; push variable textResultSum2 to stack for save result of addition
    push resultSumAB2           ; push variable which will be translate in string textResultSum2
    push 608                    ; push to stack count of bits result number
    call StrHex_MY              ; call function for translate number in 608-bit number
    
    print textResultSum2, 608   ; view result string
    print clr, 2                ; view step on new line
    print border, lenB          ; view border line
    
    ; subtraction values A and B
    
    mov eax, 0h                 ; the first four bits
    mov ecx, 19                 ; count of iteratons
    mov edx, 0                  ; position in number
    
    .fillValuesSub
    mov dword [valueSubA+4*edx], 0                  ; write four bits from position in variable A
    mov dword [valueSubB+4*edx], eax                ; write four bits from position in variable B
    add eax, 1h                                     ; magnification value A on 1h
    inc edx                                         ; increment edx
    dec ecx                                         ; decrement ecx
    jnz .fillValuesSub                              ; while ecx not equal 0 we are repeat cycle
    
    push valueSubA              ; push variable valueSubA to stack
    push valueSubB              ; push variable valueSubB to stack
    push resultSubAB            ; push variable resultSubAB to stack
    call Sub_512_LONGOP         ; call function for subtruction A and B
    
    push textResultSub          ; push variable textResultSub to stack for save result of subtruction
    push resultSubAB            ; push variable which will be translate in string textResultSub
    push 512                    ; push to stack count of bits result number
    call StrHex_MY              ; call function for translate number in 512-bit number

    print textResultSub, 512    ; view result string
    print clr, 2                ; view step on new line
    print border, lenB          ; view border line
    
    call exit                   ; exit of program
