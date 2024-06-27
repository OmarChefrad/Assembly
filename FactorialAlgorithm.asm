section .data
    n dd 5           ; The number to calculate the factorial of
    result dd 1      ; Variable to store the result

section .bss
    i resd 1         ; Loop counter

section .text
    global _start

_start:
    mov eax, [n]      ; Load n into eax
    mov [i], eax      ; Store n in loop counter i
    mov dword [result], 1 ; Initialize result to 1

factorial_loop:
    cmp dword [i], 1  ; Check if i is 1
    jle end_loop      ; If i <= 1, end the loop

    mov eax, [result] ; Load current result into eax
    imul eax, [i]     ; Multiply eax (result) by i
    mov [result], eax ; Store the new result back into result

    dec dword [i]     ; Decrement i
    jmp factorial_loop ; Repeat the loop

end_loop:
    ; Result is now stored in the result variable
    ; Exit the program
    mov eax, 1        ; sys_exit
    xor ebx, ebx      ; Exit code 0
    int 0x80
