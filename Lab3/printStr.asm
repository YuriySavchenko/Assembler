section .text

printStr:
    mov eax, 4
    mov ebx, 1

    int 0x80

    ret
