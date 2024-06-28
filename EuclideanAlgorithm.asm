section .data
    a dd 56         ; First number
    b dd 98         ; Second number
    gcd_result dd 0 ; Variable to store the GCD result

section .text
    global _start

_start:
    mov eax, [a]    ; Load a into eax
    mov ebx, [b]    ; Load b into ebx

gcd_loop:
    cmp eax, ebx    ; Compare a and b
    je end_gcd      ; If a == b, we've found the GCD

    ja a_greater    ; If a > b, go to a_greater
    sub ebx, eax    ; Else, b = b - a
    jmp gcd_loop    ; Repeat the loop

a_greater:
    sub eax, ebx    ; a = a - b
    jmp gcd_loop    ; Repeat the loop

end_gcd:
    mov [gcd_result], eax ; Store the result in gcd_result

    ; Exit the program
    mov eax, 1      ; sys_exit
    xor ebx, ebx    ; Exit code 0
    int 0x80
