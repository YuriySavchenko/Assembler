section .data
    
    counter dd 0
    lengh dd 0
    Value_Ai dd 0

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
    ret 12                                ; exit_proc of procedure


; procedure for subtraction numbers increased bit rate

Sub_512_LONGOP:
    push ebp 
    mov ebp, esp
    mov esi, [ebp+16]                     ; ESI - adress of A
    mov ebx, [ebp+12]                    ; EBX - adress of B
    mov edi, [ebp+8]                     ; EDI - adress of Result
    
    mov ecx, 16                          ; count of repeat
    mov edx, 0                           ; number of 32-bit group 

    clc                                  ; set null bit CF for register EFLAGS
    
    .cycle:
    
    mov eax, dword [esi+4*edx]            ; write A to register EAX
    sbb eax, dword [ebx+4*edx]            ; subtruction group of 32-bits
    mov dword [edi+4*edx], eax            ; write result of subtraction of last 32-bit group to register EAX
    
    inc edx                               ; set counter for number of 32-bit group more on 1 point
    dec ecx                               ; set counter less on 1 point

    jnz .cycle                            ; while value in ECX not equal 0 we are repeat cycle

    pop ebp                               ; restoration stack
    ret 12                                ; exit_proc of procedure

; procedure for multiplication number on 32-bit number

Mul_Nx32_LONGOP:
    push ebp
    mov ebp, esp
    mov ecx, [ebp+8]                      ; setup counter
    mov esi, [ebp+16]                     ; ESI = address B
    mov ebp, [ebp+12]                     ; EBP = address A
    
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
    ret 12                                ; exit_proc of procedure

; procedure for multiplication number on number

Mul_NxN_LONGOP:
	push ebp
	mov ebp, esp
	mov eax, [ebp+8]
	mov [lengh], eax
	mov esi, [ebp+12]
	mov edi, [ebp+16]
	mov ebp, [ebp+20]
	
	mov dword [counter], 0

	@cycle_Mul_NxN_out:			; початок зовнішнього циклу1

		mov eax, [counter]			
		inc eax					; збільшуємо лічильник на одиницю
		cmp eax, [lengh]
		jg exit_proc					; вихід з циклу
		mov [counter], eax


		mov ecx, [lengh]			; встановлення лічильника внутрішнього циклу

		mov ebx, dword [esi+4*eax-4]	; записуємо в пам'ять множник Аix32
		mov [Value_Ai], ebx


		xor ebx, ebx				; обнуляємо ebx		

		@cycle_Mul_NxN_in:
			mov eax, Value_Ai
			mul dword [edi+4*ebx]
			
									; встановлення переносу в нуль
			add dword [ebp+4*ebx], eax
			adc dword [ebp+4*ebx+4], edx
			
			jnc @not_res_cor

				mov eax, 1
				add eax, ebx
				stc ; встановлення переносу в одиницю

				res_cor2:
					inc eax
					 
					adc dword [ebp+4*eax], 0
					jb res_cor2

			@not_res_cor:

			inc ebx					; збільшення зсуву на 1
			dec ecx					; зменшуємо лічильник на 1
			jnz @cycle_Mul_NxN_in	; якщо лічильник не 1, то перехід на мітку cycle_Mul_NxN
		
		add ebp,4					; збільшення запису результату зсуву на 1
		jmp @cycle_Mul_NxN_out

		exit_proc:
	        pop ebp
	        ret 16
