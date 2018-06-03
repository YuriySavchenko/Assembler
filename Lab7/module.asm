;==================== invoke modules  ===================
;include 'longop.asm'
;========================================================

;перший параметр - адреса буфера результату (рядка символів)
;другий параметр - адреса числа
;третій параметр - розрядність числа у бітах (має бути кратна 8)

segment readable executable

StrHex_MY: 
    push ebp
    mov ebp, esp
    mov ecx, [ebp+8] ;кількість бітів числа
    cmp ecx, 0
    jle .exitp
    shr ecx, 3 ;кількість байтів числа
    mov esi, [ebp+12] ;адреса числа
    mov ebx, [ebp+16] ;адреса буфера результату

.cycle:
	mov dl, byte [esi+ecx-1] ;байт числа - це дві hex-цифри
	mov al, dl
	shr al, 4 ;старша цифра
	call HexSymbol_MY
	mov byte [ebx], al

	mov al, dl ;молодша цифра
	call HexSymbol_MY
	mov byte [ebx+1], al
	mov eax, ecx
	cmp eax, 4
	jle .next
	dec eax
	and eax, 3 ;проміжок розділює групи по вісім цифр
	cmp al, 0
	jne .next
	mov byte [ebx+2], 32 ;код символа проміжку
	inc ebx

.next:
	add ebx, 2
	dec ecx
	jnz .cycle
	mov byte [ebx], 0 ;рядок закінчується нулем

.exitp:
	pop ebp
	ret 12

;ця процедура обчислює код hex-цифри
;параметр - значення AL
;результат -> AL

HexSymbol_MY:
	and al, 0Fh
	add al, 48 ;так можна тільки для цифр 0-9
	cmp al, 58
	jl .exitp
	add al, 7 ;для цифр A,B,C,D,E,F
    ret

.exitp:
    ret

;====================== StrDec =====================
StrDec_MY:
;===================================================

    push ebp                                        ; write EBP to STACK
    mov ebp, esp                                    ; write pointer on STACK to EBP
    
    mov ebx, [ebp+8]                                ; count of bits in result str
    mov ecx, [ebp+12]                               ; count of groups in value 
    mov esi, [ebp+16]                               ; ESI = value
    mov edi, [ebp+20]                               ; EDI = result
    
    mov ebp, 10                                     ; EBP = 10  
    xor edx, edx                                    ; fill EDX via zeros
    
    .loop_div:
    
    mov eax, dword [esi+ecx*4-4]                    ; cut group of bits by position
    
    .label1:

    div ebp                                         ; division 
    add edx, 48                                     ; transform into a symbol
    mov byte [edi+ebx-1], dl                        ; writing symbol in string
    dec ebx                                         ; EBX--
    xor edx, edx                                    ; fill EDX via zeros

    cmp eax, 0                                      ; compare EAX with 0
    je .label2                                      ; ability for jump on { .label2 }
    jmp .label1                                     ; jump on { .label1 }
    
    .label2:
    xor edx, edx                                    ; fill EDX via zeros
    dec ecx                                         ; ECX--
    
    cmp ecx, 0                                      ; compare ECX with 0
    je .label3                                      ; ability for jump on { .label3 }
    mov dl, 32                                      ; EDX = code of space symbol
    mov byte [edi+ebx-1], dl                        ; writing space symbol in string
    dec ebx                                         ; EBX--
    xor edx, edx                                    ; fill EDX via zeros
    jmp .loop_div                                   ; jump on { .loop_div }
    
    .label3:
       
    pop ebp                                         ; remove pointer on the STACK
    ret 16                                          ; return parametrs from STACK


