section .data
    a dd 56
    b dd 98
    gcd_result dd 0

section .text
    global _start

_start:
    mov eax, [a]
    mov ebx, [b]

gcd_loop:
    cmp eax, ebx
    je end_gcd
    ja greater_than_b
    sub ebx, eax
    jmp gcd_loop

greater_than_b:
    sub eax, ebx
    jmp gcd_loop

end_gcd:
    mov [gcd_result], eax

    ; Exit program
    mov eax, 1        ; sys_exit
    xor ebx, ebx      ; exit code 0
    int 0x80
