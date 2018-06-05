;====================== comments ===================
; first operand - address bufer result (string symbols)
; second operand - address of number
; third operand - count bits of number (should be multiple 8)
;===================================================

;======================= code ======================
segment readable executable
;===================================================

;====================== StrDec =====================
StrHex_MY: 
;===================================================

    push ebp                                        ; write EBP to STACK
    mov ebp, esp                                    ; write pointer on STACK to EBP
    mov ecx, [ebp+8]                                ; count bits of number
    cmp ecx, 0                                      ; compare ECX with 0
    jle .exitp                                      ; ability for jump on { .exitp }
    shr ecx, 3                                      ; count bytes of number
    mov esi, [ebp+12]                               ; address of number
    mov ebx, [ebp+16]                               ; address of bufer result

    .cycle:
    mov dl, byte [esi+ecx-1]                        ; byte of number - its two hex numbers
    mov al, dl                                      ; move DL to AL
    shr al, 4                                       ; oldest number
    call HexSymbol_MY                               ; call procedure { HexSymbol_MY }
    mov byte [ebx], al                              ; move one byte from AL to EBX

    mov al, dl                                      ; younger number
    call HexSymbol_MY                               ; call procedure { HexSymbol_MY }
    mov byte [ebx+1], al                            ; move one byte from AL to EBX
    mov eax, ecx                                    ; move ECX to EAX
    cmp eax, 4                                      ; compare EAX with 4
    jle .next                                       ; ability for jump on { .next }
    dec eax                                         ; EAX--
    and eax, 3                                      ; interval that separated groups by 8 bit
    cmp al, 0                                       ; compare AL with 0
    jne .next                                       ; ability for jump on { .next }
    mov byte [ebx+2], 32                            ; code of symbol from interval
    inc ebx                                         ; EBX++ 

    .next:
    add ebx, 2                                      ; addition { EBX = EBX + 2 }
    dec ecx                                         ; ECX--
    jnz .cycle                                      ; ability for jump on { .cycle }
    mov byte [ebx], 0                               ; string has end as null

    .exitp:
    pop ebp                                         ; remove pointer on the STACK
    ret 12                                          ; return parametrs from STACK

; this procedure calculating code of hex-number
; parametr it's value of AL
; result will be written to AL

HexSymbol_MY:
    and al, 0Fh                                     ; cut younger 4 bits
    add al, 48                                      ; we can do this only for numbers 0-9
    cmp al, 58                                      ; compare AL with 58
    jl .exitp                                       ; ability for jump on { .exitp }
    add al, 7                                       ; only for numbers A,B,C,D,E,F
    ret                                             ; exit from procedure

.exitp:
    ret                                             ; alternative exit from procedure

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


;==================== FloatToDec ===================
FloatToDec:
;===================================================

    push ebp                                        ; write EBP to STACK
    mov ebp, esp                                    ; write pointer on STACK to EBP 

    mov ebx, [ebp+8]                                ; ECX = count of bytes in result string
    mov esi, [ebp+12]                               ; ESI = address float number
    mov edi, [ebp+16]                               ; EDI = address of result 

    mov eax, dword [esi]                            ; write value from ESI to EAX
    mov dword [mnt], eax                            ; write value from EAX to { mnt }
    mov edx, dword [esi]                            ; write to EDX float number 
    xor eax, eax                                    ; fill EAX via nulls
    xor ecx, ecx                                    ; fill ECX via nulls
    
    and edx, 080000000h                             ; cut oldest bit
    cmp edx, 0                                      ; compare EDX with zero

    je .write_edx                                   ; ability for jump on { .loop_int }
    mov byte [sign], 1                              ; write sign
    
    .write_edx:
    mov edx, dword [esi]                            ; write to EDX float number

    .cut_M:
    and edx, 07F800000h                             ; cut bits from 23 postion until 31
    and dword [mnt], 0007FFFFFh                     ; cut bits from 0 position until 23
    or dword [mnt], 000800000h                      ; set 23 bit as 1
    shl dword [mnt], 8                              ; left shift on 8 bits 
    shr edx, 23                                     ; right shift on 23 bits
    cmp edx, 127
    jng .label_1
    sub edx, 126                                    ; substraction { EDX = EDX - 126 }
    xor eax, eax                                    ; fill EAX via nulls
    
    .loop_integer:
    shl dword [mnt], 1                              ; left shift EBX on one bit
    rcl eax, 1                                      ; left shift EAX and set younger bit as value from CF
    dec edx                                         ; EDX--
    jnz .loop_integer                               ; ability for jump on { .loop_integer }
    jmp .label_2 

    .label_1:
    xor eax, eax


    .label_2:
    mov dword [integer], eax
    xor edx, edx
    xor ecx, ecx

    mov dl, 46
    mov byte [edi+57], dl
    xor edx, edx
    xor ecx, ecx
    xor eax, eax
    mov ebp, dword [mnt]
    mov ecx, dword [mnt]
    mov esi, 58 

    .loop_float:
    clc
    shld eax, ebp, 1
    shl ebp, 1
    clc
    shld edx, ecx, 3
    shl ecx, 3
    clc
    
    adc ebp, ecx
    adc eax, 0
    add edx, eax
    add edx, 48
    mov byte [edi+esi], dl
    mov ecx, ebp
    xor eax, eax
    xor edx, edx
    inc esi
    
    cmp esi, 64
    jne .loop_float 

    mov esi, 1
    mov ebx, 57
    mov eax, dword [integer]
    cmp eax, 0
    je .write_null
    mov ebp, 10                                     ; write to EBP divider

    .loop_div:
    div ebp                                         ; division on 10  
    add edx, 48                                     ; trasnform number into decimal symbol
    mov byte [edi+ebx-1], dl                        ; write symbol in result string
    xor edx, edx                                    ; fill EDX via nulls
    dec ebx                                         ; ECX--
    
    cmp eax, 0                                      ; compare EAX with 0
    je .label_3                                      ; ability for jump on { .write_point }
    jmp .loop_div                                   ; jump on label { .loop_div }

    .label_3:
    cmp byte [sign], 1                              ; compare EBX with zero
    je .write_sign                                  ; ability to jump { .write_sign }
    jmp .exit                                       ; jump on label { .exit }
    
    .write_null:
    mov dl, 48
    mov byte [edi+ebx-1], dl
    dec ebx
    
    .write_sign:
    xor edx, edx
    mov edx, 45                                     ; symbol "-" as sign
    mov byte [edi+ebx-1], dl                        ; write symbol of sign in begin of result
    
    .exit:
    pop ebp                                         ; remove pointer on the STACK
    ret 12                                          ; return parametrs from STACK
    

segment readable writeable

sign        db 0                                    ; value for save signum
floatNum    db 10 dup(0)                            ; string for save fractional part
mnt         dd 0                                    ; variable for saving mntonenta
integer     dd 0
