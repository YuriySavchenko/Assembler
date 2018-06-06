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

    mov ecx, dword [esi]                            ; write to EDX float number 
    mov dword [mnt], ecx                            ; write value from EAX to { mnt }
    and ecx, 080000000h                             ; cut oldest bit
    cmp ecx, 0                                      ; compare EDX with zero
    je .write_edx                                   ; ability for jump on { .loop_int }
    mov byte [sign], 1                              ; write sign
    
    .write_edx:
    mov ecx, dword [esi]                            ; write to EDX float number

    .cut_M:
    and ecx, 07F800000h                             ; cut bits from 23 postion until 31
    and dword [mnt], 0007FFFFFh                     ; cut bits from 0 position until 23
    or dword [mnt], 000800000h                      ; set 23 bit as 1
    shl dword [mnt], 8                              ; left shift on 8 bits 
    shr ecx, 23                                     ; right shift on 23 bits
    mov edx, dword [mnt]                            ; write value from { mnt  } to EDX
    cmp ecx, 127                                    ; substruction { EDX = EDX - 126 }
    jng .invert_sub                                 ; ability for jump on { .invert_sub }
    sub ecx, 126                                    ; substraction { EDX = EDX - 126 }
    xor eax, eax                                    ; fill EAX via nulls
    shld eax, edx, cl                               ; left shift { EAX <- EDX } on count in CL
    shl dword [mnt], cl                             ; left shift value in { mnt } on count in CL
    jmp .label_2                                    ; jump on { .label_2 }
    .invert_sub:                                    
    mov eax, 126                                    ; write to EAX value 126
    sub eax, ecx                                    ; substruction { EAX = 126 - ECX }
    mov ecx, eax                                    ; write to ECX result of substruction
    xor eax, eax                                    ; fill EAX via nulls
    shrd eax, edx, cl                               ; right shift { EAX -> EDX } on count in CL
    shr dword [mnt], cl                             ; right shift value in { mnt } on count in CL
    jmp .label_1                                    ; jump on { .label_1 }

    .label_1:
    xor eax, eax                                    ; fill EAX via nulls

    .label_2:
    mov dword [integer], eax                        ; mov value in EAX to variable { integer }
    xor edx, edx                                    ; fill EDX via nulls
    xor ecx, ecx                                    ; fill ECX via nulls

    mov dl, 46                                      ; write to CL code of symbol "."
    mov byte [edi+57], dl                           ; write in result string symbol from CL
    xor edx, edx                                    ; fill EDX via nulls
    xor ecx, ecx                                    ; fill ECX via nulls
    xor eax, eax                                    ; fill EAX via nulls
    mov ebp, dword [mnt]                            ; copy value from variable { mnt } to EBP
    mov ecx, dword [mnt]                            ; copy value from variable { mnt } to ECX
    mov esi, 58                                     ; write to ESI number 58

    .loop_float:
    clc                                             ; set CF as 0
    shld eax, ebp, 1                                ; left shift { EAX <- EBP } on 1 bit
    shl ebp, 1                                      ; left shift EBP on 1 bit
    clc                                             ; set CF as 0
    shld edx, ecx, 3                                ; left shift { EDX <- ECX } on 3 bits
    shl ecx, 3                                      ; left shift ECX on 3 bits
    clc                                             ; set CF as 0
    
    adc ebp, ecx                                    ; addition { EBP = EBP + ECX }
    adc eax, 0                                      ; addition { EBP = EBP + CF }
    add edx, eax                                    ; addition { EDX = EDX + EAX }
    add edx, 48                                     ; transform number in EDX to symbol
    mov byte [edi+esi], dl                          ; write symbol to result string
    mov ecx, ebp                                    ; copy value from EBP to ECX
    xor eax, eax                                    ; fill EAX via nulls
    xor edx, edx                                    ; fill EDX via nulls
    inc esi                                         ; ESI++
    
    cmp esi, 64                                     ; compare ESI with 64
    jne .loop_float                                 ; ability for jump to { .loop_float }

    mov esi, 1                                      ; write number 1 to ESI 
    mov ebx, 57                                     ; rite number 57 to EBX
    mov eax, dword [integer]                        ; copy value from variable { integer } to EAX
    cmp eax, 0                                      ; compare EAX with 0
    je .write_null                                  ; ability for jump { .write_null } 
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
    mov dl, 48                                      ; write code of symbol to DL
    mov byte [edi+ebx-1], dl                        ; write symbol on result string
    dec ebx                                         ; EBX--
    cmp byte [sign], 0                              ; compare value in variable { sign } with 0
    je .exit                                        ; ability for jump on { .exit }
    
    .write_sign:
    xor edx, edx                                    ; fill EDX via nulls
    mov edx, 45                                     ; symbol "-" as sign
    mov byte [edi+ebx-1], dl                        ; write symbol of sign in begin of result
    
    .exit:
    pop ebp                                         ; remove pointer on the STACK
    ret 12                                          ; return parametrs from STACK
    
;======================= data ======================
segment readable writeable
;===================================================

sign        db 0                                    ; value for save signum
floatNum    db 10 dup(0)                            ; string for save fractional part
mnt         dd 0                                    ; variable for saving exponenta
integer     dd 0                                    ; variable for saving mantissa
