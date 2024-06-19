section .data
    one         dq 1.0             ; Constant 1.0
    five        dq 5.0             ; Constant 5.0
    two         dq 2.0             ; Constant 2.0
    result      dq 0.0             ; Variable to store the result (golden ratio)

section .text
    global _start

_start:
    ; Load 5.0 onto the FPU stack
    fld qword [five]

    ; Calculate the square root of 5.0
    fsqrt

    ; Add 1.0 to the square root of 5.0
    fld qword [one]
    fadd

    ; Divide the result by 2.0
    fld qword [two]
    fdiv

    ; Store the result in the memory location 'result'
    fstp qword [result]

    ; Exit the program
    mov eax, 1        ; sys_exit
    xor ebx, ebx      ; exit code 0
    int 0x80
