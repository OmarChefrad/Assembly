section .data
    array db 5, 3, 8, 4, 2     ; Array to be sorted
    array_size equ 5           ; Size of the array

section .bss
    i resb 1                   ; Loop index i
    j resb 1                   ; Loop index j
    temp resb 1                ; Temporary variable for swapping

section .text
    global _start

_start:
    mov byte [i], 0            ; Initialize i to 0

outer_loop:
    cmp byte [i], array_size - 1 ; Check if i >= array_size - 1
    jge end_program            ; If true, end the program

    mov byte [j], 0            ; Initialize j to 0

inner_loop:
    cmp byte [j], array_size - 1 - [i] ; Check if j >= array_size - 1 - i
    jge end_inner_loop         ; If true, end the inner loop

    mov al, [array + j]        ; Load array[j] into al
    mov bl, [array + j + 1]    ; Load array[j + 1] into bl
    cmp al, bl                 ; Compare array[j] with array[j + 1]
    jbe skip_swap              ; If array[j] <= array[j + 1], skip the swap

    ; Swap array[j] and array[j + 1]
    mov [temp], al
    mov [array + j], bl
    mov [array + j + 1], [temp]

skip_swap:
    inc byte [j]               ; Increment j
    jmp inner_loop             ; Repeat the inner loop

end_inner_loop:
    inc byte [i]               ; Increment i
    jmp outer_loop             ; Repeat the outer loop

end_program:
    ; Exit the program
    mov eax, 1                 ; sys_exit
    xor ebx, ebx               ; Exit code 0
    int 0x80
