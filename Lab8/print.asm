segment readable executable

macro print msg, len
{
    mov eax, 4
    mov ebx, 1
    mov ecx, msg
    mov edx, len
    
    int 0x80
}
