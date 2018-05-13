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
    shr byte [edx+ecx*4], 1
    mov esi, [edx+ecx*4]
    adc edi, 0
    clc

    shr byte [eax+4*ebx], 1

    jnc .label0
    or dword [edx+ecx*4], 080000000h
    mov esi, [edx+ecx*4]
    jmp .label1

    .label0:
    and dword [edx+ecx*4], 07FFFFFFFh

    .label1:
    dec ecx 
    
    .loop:
    cmp edi, 0
    jz .label2
    or dword [edx+ecx*4], 080000000h
    jmp .label3
    
    .label2:
    and dword [edx+ecx*4], 07FFFFFFFh 

    .label3:
    xor edi, edi
    shr byte [edx+ecx*4], 1
    adc edi, 0
    clc
    dec ecx 
    jnz .loop
    
    pop ebp

    ret 8

