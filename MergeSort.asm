section .data
    array db 12, 11, 13, 5, 6, 7 ; Array to be sorted
    array_size equ 6             ; Size of the array

section .bss
    left resb array_size         ; Temporary storage for left subarray
    right resb array_size        ; Temporary storage for right subarray

section .text
    global _start

_start:
    ; Call merge_sort on the entire array
    mov ecx, 0                   ; Left index (start of the array)
    mov edx, array_size - 1      ; Right index (end of the array)
    call merge_sort

    ; Exit the program
    mov eax, 1                   ; sys_exit
    xor ebx, ebx                 ; Exit code 0
    int 0x80

merge_sort:
    ; Function parameters: ecx (left), edx (right)
    cmp ecx, edx                 ; If left >= right, return
    jge ms_return

    ; Find the middle point
    mov eax, ecx
    add eax, edx
    shr eax, 1                   ; middle = (left + right) / 2
    push eax                     ; Save middle on stack

    ; Sort first and second halves
    mov esi, eax                 ; middle
    dec esi
    call merge_sort              ; Sort left half (left to middle)

    pop eax                      ; Restore middle
    push eax                     ; Save middle again
    inc eax
    mov ecx, eax                 ; middle + 1
    call merge_sort              ; Sort right half (middle + 1 to right)

    pop eax                      ; Restore middle
    push edx                     ; Save right index
    call merge                   ; Merge the sorted halves

    pop edx                      ; Restore right index

ms_return:
    ret

merge:
    ; Function parameters: ecx (left), eax (middle), edx (right)
    ; Copy data to temporary arrays left[] and right[]
    push ecx                     ; Save left index
    push eax                     ; Save middle index
    push edx                     ; Save right index

    ; Copy left half to left[]
    mov esi, ecx                 ; left index
    mov edi, 0                   ; left[] index
copy_left:
    cmp esi, eax                 ; Check if left index <= middle
    jg done_copy_left
    mov bl, [array + esi]
    mov [left + edi], bl
    inc esi
    inc edi
    jmp copy_left
done_copy_left:

    ; Copy right half to right[]
    mov esi, eax                 ; middle index
    inc esi                      ; middle + 1
    mov edi, 0                   ; right[] index
copy_right:
    cmp esi, edx                 ; Check if middle + 1 index <= right
    jg done_copy_right
    mov bl, [array + esi]
    mov [right + edi], bl
    inc esi
    inc edi
    jmp copy_right
done_copy_right:

    ; Merge the temporary arrays back into array[l..r]
    pop edx                      ; Restore right index
    pop eax                      ; Restore middle index
    pop ecx                      ; Restore left index

    mov esi, 0                   ; Initial index of left[]
    mov edi, 0                   ; Initial index of right[]
    mov ebx, ecx                 ; Initial index of merged subarray

merge_arrays:
    cmp esi, eax                 ; Check if all elements of left[] are merged
    jge merge_right

    cmp edi, edx                 ; Check if all elements of right[] are merged
    jge merge_left

    ; Pick the smaller element from left[] and right[], and place in array[]
    mov al, [left + esi]
    mov bl, [right + edi]
    cmp al, bl
    jle pick_left

    ; Pick from right[]
    mov [array + ebx], bl
    inc edi
    jmp next_merge

pick_left:
    ; Pick from left[]
    mov [array + ebx], al
    inc esi

next_merge:
    inc ebx
    jmp merge_arrays

merge_left:
    ; Copy remaining elements of left[], if any
    cmp esi, eax
    jge merge_done
    mov al, [left + esi]
    mov [array + ebx], al
    inc esi
    inc ebx
    jmp merge_left

merge_right:
    ; Copy remaining elements of right[], if any
    cmp edi, edx
    jge merge_done
    mov bl, [right + edi]
    mov [array + ebx], bl
    inc edi
    inc ebx
    jmp merge_right

merge_done:
    ret
