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
