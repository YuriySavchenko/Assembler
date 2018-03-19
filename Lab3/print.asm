section .text

%macro print 2
    mov eax, 4      ; sys_write
    mov ebx, 1      ; std_out
    mov ecx, %1     ; mov string for print
    mov edx, %2     ; mov length of string
    
    int 0x80

%endmacro


