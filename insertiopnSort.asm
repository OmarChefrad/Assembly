section .data
    array db 5, 2, 9, 1, 5, 6  ; Array to be sorted
    array_size equ 6           ; Size of the array

section .bss
    i resb 1                   ; Loop index i
    j resb 1                   ; Loop index j
    key resb 1                 ; Temporary storage for the key element

section .text
    global _start

_start:
    mov byte [i], 1            ; Initialize i to 1

outer_loop:
    cmp byte [i], array_size   ; Check if i >= array_size
    jge end_program            ; If true, end the program

    ; Load array[i] into key
    movzx eax, byte [array + i]
    mov [key], al

    ; Initialize j to i - 1
    movzx ebx, byte [i]
    dec ebx
    mov [j], bl

inner_loop:
    cmp byte [j], 0xFF         ; Check if j < 0 (unsigned comparison for negative)
    jbe insert_key             ; If true, insert the key

    movzx eax, byte [j]        ; Load j into eax
    movzx ebx, byte [array + eax] ; Load array[j] into ebx
    cmp ebx, [key]             ; Compare array[j] with key
    jbe insert_key             ; If array[j] <= key, insert the key

    ; Move array[j] to array[j + 1]
    mov byte [array + eax + 1], bl

    ; Decrement j
    dec byte [j]
    jmp inner_loop             ; Repeat the inner loop

insert_key:
    ; Insert key into the correct position
    movzx eax, byte [j]
    inc eax
    movzx ebx, byte [key]
    mov byte [array + eax], bl

    ; Increment i
    inc byte [i]
    jmp outer_loop             ; Repeat the outer loop

end_program:
    ; Exit the program
    mov eax, 1                 ; sys_exit
    xor ebx, ebx               ; Exit code 0
    int 0x80
