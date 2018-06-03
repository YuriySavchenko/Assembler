section .code
    
; procedure for adding number increased bit rate

Add_608_LONGOP:
    push ebp
    mov ebp, esp
    
    mov esi, [ebp+16]                     ; ESI - adress of A
    mov ebx, [ebp+12]                     ; EBX - adress of B
    mov edi, [ebp+8]                      ; EDI - adress of Result
    
    mov ecx, 19                           ; count of repeat
    mov edx, 0                            ; number of 32-bit group 

    clc                                   ; set null bit CF for register EFLAGS
    
    .cycle:
    
    mov eax, dword [esi+4*edx]            ; write A to register EAX
    adc eax, dword [ebx+4*edx]            ; adding group of 32-bits
    mov dword [edi+4*edx], eax            ; write result of adding of last 32-bit group to register EAX
    
    inc edx                               ; set counter for number of 32-bit group more on 1 point
    dec ecx                               ; set counter less on 1 point

    jnz .cycle                            ; while value in ECX not equal 0 we are repeat cycle

    pop ebp                               ; restoration stack
    ret 12                                ; exit of procedure


; procedure for subtraction numbers increased bit rate

Sub_512_LONGOP:
    push ebp
    mov ebp, esp
    
    mov esi, [ebp+16]                     ; ESI - adress of A
    mov ebx, [ebp+12]                     ; EBX - adress of B
    mov edi, [ebp+8]                      ; EDI - adress of Result
    
    mov ecx, 16                           ; count of repeat
    mov edx, 0                            ; number of 32-bit group 

    clc                                   ; set null bit CF for register EFLAGS
    
    .cycle:
    
    mov eax, dword [esi+4*edx]            ; write A to register EAX
    sbb eax, dword [ebx+4*edx]            ; subtruction group of 32-bits
    mov dword [edi+4*edx], eax            ; write result of subtraction of last 32-bit group to register EAX
    
    inc edx                               ; set counter for number of 32-bit group more on 1 point
    dec ecx                               ; set counter less on 1 point

    jnz .cycle                            ; while value in ECX not equal 0 we are repeat cycle

    pop ebp                               ; restoration stack
    ret 12                                ; exit of procedure
