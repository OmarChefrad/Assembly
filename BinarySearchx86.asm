section .data
    array db 1, 3, 5, 7, 9, 11, 13, 15  ; Sorted array
    array_size equ 8                    ; Size of the array
    target db 7                         ; Target value to search for
    found_index db -1                   ; Variable to store the found index

section .bss
    low resb 1                          ; Lower bound
    high resb 1                         ; Upper bound
    mid resb 1                          ; Middle index

section .text
    global _start

_start:
    mov byte [low], 0                   ; Initialize low to 0
    mov byte [high], array_size - 1     ; Initialize high to array_size - 1

binary_search:
    cmp byte [low], [high]              ; Compare low and high
    jg not_found                        ; If low > high, target is not in the array

    ; Calculate mid = (low + high) / 2
    mov al, [low]
    add al, [high]
    shr al, 1
    mov [mid], al

    ; Compare array[mid] with target
    movzx eax, byte [mid]
    movzx ebx, byte [array + eax]
    cmp ebx, [target]
    je found                            ; If array[mid] == target, found it

    cmp ebx, [target]
    jl search_right                     ; If array[mid] < target, search in the right half

    ; Search in the left half
    mov al, [mid]
    dec al
    mov [high], al
    jmp binary_search

search_right:
    ; Search in the right half
    mov al, [mid]
    inc al
    mov [low], al
    jmp binary_search

found:
    mov [found_index], [mid]            ; Store the found index
    jmp end_program

not_found:
    ; Target not found
    mov byte [found_index], -1          ; Store -1 if not found

end_program:
    ; Exit the program
    mov eax, 1                          ; sys_exit
    xor ebx, ebx                        ; Exit code 0
    int 0x80
