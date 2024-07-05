section .data
    array db 5, 1, 4, 2, 8      ; Array to be sorted
    array_size equ 5            ; Size of the array

section .bss
    i resb 1                    ; Loop index i
    j resb 1                    ; Loop index j
    temp resb 1                 ; Temporary storage for swapping

section .text
    global _start

_start:
    mov byte [i], 0             ; Initialize i to 0

outer_loop:
    mov byte [j], 0             ; Initialize j to 0

inner_loop:
    mov al, [array + j]         ; Load array[j] into al
    mov bl, [array + j + 1]     ; Load array[j + 1] into bl
    cmp al, bl                  ; Compare array[j] and array[j + 1]
    jbe no_swap                 ; If array[j] <= array[j + 1], no swap is needed

    ; Swap array[j] and array[j + 1]
    mov [temp], al              ; Store array[j] in temp
    mov [array + j], bl         ; Move array[j + 1] to array[j]
    mov [array + j + 1], [temp] ; Move temp (original array[j]) to array[j + 1]

no_swap:
    inc byte [j]                ; Increment j
    cmp byte [j], array_size - 1; Check if j < array_size - 1
    jb inner_loop               ; If true, repeat inner loop

    inc byte [i]                ; Increment i
    cmp byte [i], array_size - 1; Check if i < array_size - 1
    jb outer_loop               ; If true, repeat outer loop

end_program:
    ; Exit the program
    mov eax, 1                  ; sys_exit
    xor ebx, ebx                ; Exit code 0
    int 0x80
