section .data
    array db 1, 3, 5, 7, 9, 11, 13, 15
    array_size equ 8
    target db 7
    found_index db -1

section .bss
    low resb 1
    high resb 1
    mid resb 1

section .text
    global _start

_start:
    mov byte [low], 0
    mov byte [high], array_size - 1

binary_search:
    mov al, [low]
    add al, [high]
    shr al, 1
    mov [mid], al

    movzx eax, byte [mid]
    movzx ebx, byte [array + eax]
    cmp ebx, [target]
    je found

    cmp ebx, [target]
    jl greater

    mov al, [mid]
    dec al
    mov [high], al
    jmp binary_search

greater:
    mov al, [mid]
    inc al
    mov [low], al
    jmp binary_search

found:
    mov [found_index], [mid]

end:
    ; Exit program
    mov eax, 1        ; sys_exit
    xor ebx, ebx      ; exit code 0
    int 0x80
