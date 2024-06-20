section .data
    fib_result dd 0

section .text
    global _start

_start:
    mov ecx, 10        ; Fibonacci term to calculate
    xor eax, eax       ; F(n-2)
    mov ebx, 1         ; F(n-1)
    cmp ecx, 1
    jbe end_fib

fib_loop:
    mov edx, eax
    add eax, ebx       ; F(n) = F(n-1) + F(n-2)
    mov ebx, edx       ; Update F(n-1)
    loop fib_loop

end_fib:
    mov [fib_result], eax

    ; Exit program
    mov eax, 1         ; sys_exit
    xor ebx, ebx       ; Exit code 0
    int 0x80
