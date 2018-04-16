section .data
    
    ; variables which will be using as counters for loops

    counter dd 0
    length dd 0
    Value_Ai dd 0

section .code
    
; procedure for adding number increased bit rate

Add_608_LONGOP:
    push ebp                              ; write EBP to STACK
    mov ebp, esp                          ; write pinter on STACK to register EBP
    
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
    push ebp                              ; write EBP to STACK
    mov ebp, esp                          ; write pinter on STACK to register EBP
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

; procedure for multiplication number on 32-bit number

Mul_Nx32_LONGOP:
    push ebp                              ; write EBP to STACK
    mov ebp, esp                          ; write pinter on STACK to register EBP
    mov ecx, [ebp+8]                      ; setup counter
    mov esi, [ebp+16]                     ; ESI = address A
    mov ebp, [ebp+12]                     ; EBP = address B
    
    xor ebx, ebx                          ; set null value for EBP
    xor edi, edi                          ; set null value for EDI
    
    .cycle:
    
    mov eax, ebp                          ; EAX = A
    mul dword [esi+4*edi]                 ; multiplication of operands

    clc                                   ; set null bit CF for register EFLAGS   
    adc eax, ebx                          ; addition of younger and older digits to the result of past multiplication
    adc edx, 0                            ; addition EDX and null
    mov dword [esi+4*edi], eax            ; write value from EAX to address [EAX+4*EDI]
    mov ebx, edx                          ; write value from EDX to EBX
    
    inc edi                               ; increment EDI
    dec ecx                               ; decrement ECX

    jnz .cycle                            ; while value in ECX not equal 0 we are repeat cycle

    pop ebp                               ; restoration stack
    ret 12                                ; exit of procedure

; procedure for multiplication number on number

Mul_NxN_LONGOP:

	push ebp                              ; write EBP to STACK
	mov ebp, esp                          ; write pointer on STACK to register EBP
	mov eax, [ebp+8]                      ; move value counter to EAX
	mov [length], eax                     ; write value from EAX in variable length
	mov esi, [ebp+12]                     ; ESI = address B 
	mov edi, [ebp+16]                     ; EDI = address A
	mov ebp, [ebp+20]                     ; EBP = address RESULT
	
	mov dword [counter], 0                ; setup variable counter as null

	@cycle_Mul_NxN_out:                   ; begin of first loop

	mov eax, [counter]                    ; write value from variable counter to EAX
	inc eax                               ; increment EAX	
	cmp eax, [length]                     ; equal EAX and variable length 
	jg @exit_proc                         ; exit of program
	mov [counter], eax                    ; write value from EAX to variable counter

	mov ecx, [length]                     ; setup counter for second loop
	mov ebx, dword [esi+4*eax-4]	      ; write to memory Аix32
	mov [Value_Ai], ebx                   ; write value from EBX to variable Value_Ai

	xor ebx, ebx                          ; set null value for EBX

	@cycle_Mul_NxN_in:                    ; begin of second loop

	mov eax, [Value_Ai]                   ; write value from Value_Ai to EAX
	mul dword [edi+4*ebx]                 ; multiplication of operands
		
 	clc                                   ; set null bit CF for register EFLAGS
	add dword [ebp+4*ebx], eax            ; addition without transfer
	adc dword [ebp+4*ebx+4], edx          ; addition with transfer
	
	jnc @not_res_cor                      ; repeat loop

	mov eax, 1                            ; write digit 1 in EAX
	add eax, ebx                          ; addition EAX and EBX without transfer
	stc                                   ; setup transfer as digit 1  

	res_cor2:                             ; begin of res_cor2
	inc eax                               ; increment EAX
		 
	adc dword [ebp+4*eax], 0              ; add value from address and transfer
	jb res_cor2                           ; go to begin res_cor2

	@not_res_cor:                         ; begin of loop not_res_cor

	inc ebx                               ; increment EBX 
	dec ecx                               ; decrement ECX
	jnz @cycle_Mul_NxN_in	              ; if counter not equal 1 then go to cycle_Mul_NxN
		
	add ebp, 4                            ; add digit 4 to register EBP
	jmp @cycle_Mul_NxN_out                ; repeat cycle_Mul_NxN_out

@exit_proc:                               ; procedure for exit of program

 	pop ebp                               ; delete pointer on STACK
 	ret 16                                ; stop procedure
