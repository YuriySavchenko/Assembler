section .code
    
exit:
    mov eax, 1      ; sys_exit
    mov ebx, 0      ; code of error
    
    int 0x80        ; stop processor 

    ret             ; exit of procedure
