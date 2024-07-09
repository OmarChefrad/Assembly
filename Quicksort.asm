section .data
    array db 10, 7, 8, 9, 1, 5 ; Array to be sorted
    array_size equ 6           ; Size of the array

section .bss
    pivot resb 1               ; Temporary storage for the pivot element
    left resb 1                ; Left index for partitioning
    right resb 1               ; Right index for partitioning

section .text
    global _start

_start:
    ; Call quicksort on the entire array
    mov ecx, 0                ; Left index (start of the array)
    mov edx, array_size - 1   ; Right index (end of the array)
    call quicksort

    ; Exit the program
    mov eax, 1                ; sys_exit
    xor ebx, ebx              ; Exit code 0
    int 0x80

quicksort:
    ; Function parameters: ecx (left), edx (right)
    cmp ecx, edx              ; If left >= right, return
    jge qs_return

    ; Partition the array
    mov ebx, ecx              ; Set left index to ecx
    mov esi, edx              ; Set right index to edx
    mov al, [array + ecx]     ; Choose pivot as array[left]
    mov [pivot], al

partition:
    ; Find an element larger than the pivot
    movzx eax, byte [array + ebx]
    cmp eax, [pivot]
    jle skip_left
    jmp skip_right_check

skip_left:
    inc ebx                   ; Increment left index
    cmp ebx, esi              ; If left index >= right index, break
    jge partition_done
    jmp partition

skip_right_check:
    ; Find an element smaller than the pivot
    movzx eax, byte [array + esi]
    cmp eax, [pivot]
    jge skip_right
    jmp skip_left_check

skip_right:
    dec esi                   ; Decrement right index
    cmp ebx, esi              ; If left index >= right index, break
    jge partition_done
    jmp partition

skip_left_check:
    ; Swap elements at left and right indices
    mov al, [array + ebx]
    mov bl, [array + esi]
    mov [array + ebx], bl
    mov [array + esi], al

    inc ebx                   ; Increment left index
    dec esi                   ; Decrement right index
    jmp partition

partition_done:
    movzx eax, byte [esi]
    mov [array + ecx], al
    movzx eax, byte [pivot]
    mov [array + esi], al

    ; Recursively sort the two partitions
    push esi                  ; Save right index
    mov edx, esi              ; Set new right index to partition index
    dec edx
    call quicksort            ; Sort the left partition

    pop esi                   ; Restore right index
    inc esi
    mov ecx, esi              ; Set new left index to partition index + 1
    call quicksort            ; Sort the right partition

qs_return:
    ret
