;========================= code ============================
segment readable executable
;===========================================================

;========================= data ============================
segment readable writable
;===========================================================

;=================== div procedure table ===================
DIV_LONGOP_10:
;===========================================================

    push ebp                                                ; write EBP to STACK 
    mov ebp, esp                                            ; write pointer on STACK to EBP 

    mov ecx, [ebp+8]                                        ; ECX = count of bits for substraction 
    mov ebx, [ebp+12]                                       ; EBX = devider
    mov edi, [ebp+16]                                       ; EDI = result
    mov esi, [ebp+20]                                       ; ESI = divided

    xor eax, eax                                            ; fill register EAX via zeros

    .loop_div_out:

    mov edx, 32                                             ; EDX = counter for inside loop
    mov ebp, dword [esi+ecx*4-4]                            ; EBP = some bytes from some shift
    
    .loop_div_in:

    shld eax, ebp, 1                                        ; left shift with save carry-over
    shl ebp, 1                                              ; left shift on one point

    cmp eax, ebx                                            ; compare remainder and devider
    jb .label_1
    sub eax, ebx                                            ; substraction EAX = EAX - EBX
    stc                                                     ; set CF as 1
    rcl dword [edi+ecx*4-4], 1                              ; left shift and set young bit as 1
    jmp .label_2
    
    .label_1:

    clc                                                     ; set CF as 0
    rcl dword [edi+ecx*4-4], 1                              ; left shift and set young bit as 0
    
    .label_2:

    dec edx                                                 ; EDX--
    jnz .loop_div_in 
    
    dec ecx                                                 ; ECX--
    jnz .loop_div_out

    pop ebp                                                 ; remove pointer on the STACK
    ret 16                                                  ; return parametrs from STACK

;================== div procedure groups =================
DIV_LONGOP_Nx32:
;=========================================================

    push ebp                                                ; write EBP to STACK
    mov ebp, esp                                            ; write pointer on STACK to EBP

    mov ecx, [ebp+8]                                        ; ECX = count of out loops
    mov ebx, [ebp+12]                                       ; EBX = divider
    mov esi, [ebp+16]                                       ; ESI = divided
    mov edi, [ebp+20]                                       ; EDI = result

    xor edx, edx
    xor eax, eax

    .loop_out:
    
    mov eax, dword [esi+ecx*4-4]                            ; cut group of bits by position
    div ebx                                                 ; dividing 
    mov dword [edi+ecx*4-4], eax                            ; move result on place divided
    
    dec ecx                                                 ; ECX--
    
    jnz .loop_out
    
    pop ebp                                                 ; remove pointer on the STACK
    ret 16                                                  ; return parametrs from STACK

