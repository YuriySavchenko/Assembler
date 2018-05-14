segment readable executable

SHR_LONGOP_PROC:
    push ebp
    mov ebp, esp
    
    mov eax, [ebp+8]                        ; number for stilling
    mov edx, [ebp+12]                       ; value for shift in right

    xor edi, edi
    xor ebx, ebx
    xor ecx, ecx
    xor esi, esi

    mov ecx, 23

    mov esi, [edx+ecx*4]
    shr dword [edx+ecx*4], 1
    mov esi, [edx+ecx*4]
    adc edi, 0
    clc

    shr dword [eax+4*ebx], 1

    jnc .label0
    or dword [edx+ecx*4], 080000000h
    mov esi, [edx+ecx*4]
    jmp .loop

    .label0:
    and dword [edx+ecx*4], 07FFFFFFFh
    mov esi, [edx+ecx*4]

    .loop:
    dec ecx
    xor edi, edi
    shr dword [edx+ecx*4], 1
    adc edi, 0 
    
    cmp edi, 0
    jz .label2
    or dword [edx+ecx*4], 080000000h
    jmp .label3

    .label2:
    and dword [edx+ecx*4], 07FFFFFFFh

    .label3:
    jnz .loop

    pop ebp

    ret 8

