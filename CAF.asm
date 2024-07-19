section .data
    array db 1, 2, 3, 4, 5     ; Array to be processed
    array_size equ 5           ; Size of the array

section .bss
    fib resb array_size        ; Array to store Fibonacci numbers

section .text
    global _start

_start:
    ; Initialize Fibonacci sequence
    mov byte [fib + 0], 1      ; F(0) = 1
    mov byte [fib + 1], 1      ; F(1) = 1

    ; Generate Fibonacci sequence up to array_size
    mov ecx, 2
generate_fib:
    cmp ecx, array_size
    jge end_fib_generation
    mov al, [fib + ecx - 1]
    mov bl, [fib + ecx - 2]
    add al, bl
    mov [fib + ecx], al
    inc ecx
    jmp generate_fib
end_fib_generation:

    ; Perform cyclic addition on the array
    mov ecx, array_size
    sub ecx, 1
cyclic_addition:
    mov esi, 0
    mov ebx, [array + ecx]
cyclic_add_loop:
    cmp esi, ecx
    jge cyclic_add_done
    add [array + esi], bl
    inc esi
    jmp cyclic_add_loop
cyclic_add_done:
    dec ecx
    jns cyclic_addition

    ; Modify the array using Fibonacci sequence
    mov ecx, 0
modify_array:
    cmp ecx, array_size
    jge end_program
    mov al, [array + ecx]
    mov bl, [fib + ecx]
    add al, bl
    mov [array + ecx], al
    inc ecx
    jmp modify_array

end_program:
    ; Exit the program
    mov eax, 1                 ; sys_exit
    xor ebx, ebx               ; Exit code 0
    int 0x80
