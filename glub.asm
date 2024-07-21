section .data
    array db 4, 2, 7, 1, 3     ; Array to be processed
    array_size equ 5           ; Size of the array
    constant equ 0x5A          ; XOR constant

section .bss
    temp resb 1                ; Temporary variable for swapping

section .text
    global _start

_start:
    ; Perform bubble sort on the array
    mov ecx, array_size
    dec ecx
bubble_sort_outer:
    cmp ecx, 0
    jl glub_transformation

    mov esi, 0
bubble_sort_inner:
    mov al, [array + esi]
    mov bl, [array + esi + 1]
    cmp al, bl
    jbe skip_swap

    ; Swap array[esi] and array[esi + 1]
    mov [temp], al
    mov [array + esi], bl
    mov [array + esi + 1], [temp]

skip_swap:
    inc esi
    cmp esi, ecx
    jl bubble_sort_inner

    dec ecx
    jmp bubble_sort_outer

glub_transformation:
    ; Apply unique transformation to the sorted array
    mov ecx, 0
transform_loop:
    cmp ecx, array_size
    jge end_program

    mov al, [array + ecx]
    mov bl, ecx
    mul bl                       ; Multiply array[ecx] by its index
    xor al, constant             ; XOR the result with constant
    mov [array + ecx], al

    inc ecx
    jmp transform_loop

end_program:
    ; Exit the program
    mov eax, 1                   ; sys_exit
    xor ebx, ebx                 ; Exit code 0
    int 0x80
