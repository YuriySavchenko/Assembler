format ELF executable 3

include 'print.asm'
include 'module.asm'
include 'longop.asm'

entry start

segment readable executable

start:
    push buff
    push value
    push 768
    call StrHex_MY 

    print buff, 768
    print clr, 2

    push numBuff
    push number
    push 32
    call StrHex_MY
    
    print numBuff, 64
    print clr, 2
    
    xor ecx, ecx
    mov ecx, count
    
    .cycle:
    push value
    push number
    call SHR_LONGOP_PROC
    dec byte [count]
    jnz .cycle
    
    push buff
    push value
    push 768
    call StrHex_MY
    
    print buff, 768
    print clr, 2

    push numBuff
    push number
    push 32
    call StrHex_MY
    
    mov eax, 1
    mov ebx, 0
    
    int 0x80

segment readable writeable

value   dd  24 dup (0FFFFFFFFh)
number  dd  3
count   dd  3
buff    db  768 dup(0)
numBuff db  64 dup(0)
clr     db  13, 10

