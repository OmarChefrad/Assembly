section .data
    tours db "1. Paris", 0, "2. New York", 0, "3. Tokyo", 0
    tours_count equ 3
    booked_tours db 0, 0, 0                ; Array to track booked tours (0 = not booked, 1 = booked)
    phone_numbers db "0000000000", 0, 0    ; Array to store phone numbers associated with booked tours
    menu db "1. View Tours", 10, "2. Book a Tour", 10, "3. View Booked Tours", 10, "4. Exit", 0
    prompt db "Choose an option: ", 0
    book_prompt db "Enter tour number to book: ", 0
    phone_prompt db "Enter phone number: ", 0
    invalid_option db "Invalid option. Try again.", 10, 0
    booked_success db "Tour booked successfully!", 10, 0
    already_booked db "Tour already booked!", 10, 0
    no_bookings db "No tours booked yet.", 10, 0

section .bss
    option resb 1
    tour_number resb 1
    phone_number resb 10

section .text
    global _start

_start:
    ; Display the menu
    mov eax, 4
    mov ebx, 1
    mov ecx, menu
    mov edx, 52
    int 0x80

    ; Prompt user for option
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt
    mov edx, 19
    int 0x80

    ; Read user option
    mov eax, 3
    mov ebx, 0
    mov ecx, option
    mov edx, 1
    int 0x80

    ; Process user option
    cmp byte [option], '1'
    je view_tours
    cmp byte [option], '2'
    je book_tour
    cmp byte [option], '3'
    je view_booked_tours
    cmp byte [option], '4'
    je exit_program

    ; Invalid option
    mov eax, 4
    mov ebx, 1
    mov ecx, invalid_option
    mov edx, 25
    int 0x80
    jmp _start

view_tours:
    ; Display available tours
    mov eax, 4
    mov ebx, 1
    mov ecx, tours
    mov edx, 32
    int 0x80
    jmp _start

book_tour:
    ; Prompt for tour number
    mov eax, 4
    mov ebx, 1
    mov ecx, book_prompt
    mov edx, 27
    int 0x80

    ; Read tour number
    mov eax, 3
    mov ebx, 0
    mov ecx, tour_number
    mov edx, 1
    int 0x80

    ; Convert ASCII to integer (1-3)
    sub byte [tour_number], '1'
    cmp byte [tour_number], 0
    jb invalid_option
    cmp byte [tour_number], 2
    ja invalid_option

    ; Check if tour is already booked
    movzx eax, byte [tour_number]
    movzx ebx, byte [booked_tours + eax]
    cmp ebx, 1
    je already_booked_message

    ; Prompt for phone number
    mov eax, 4
    mov ebx, 1
    mov ecx, phone_prompt
    mov edx, 19
    int 0x80

    ; Read phone number
    mov eax, 3
    mov ebx, 0
    mov ecx, phone_number
    mov edx, 10
    int 0x80

    ; Book the tour and store the phone number
    mov byte [booked_tours + eax], 1
    mov esi, eax
    mov edi, phone_number
    lea ecx, [phone_numbers + esi * 10]
    mov edx, 10
    cld
    rep movsb

    ; Display booking success message
    mov eax, 4
    mov ebx, 1
    mov ecx, booked_success
    mov edx, 22
    int 0x80
    jmp _start

already_booked_message:
    ; Display already booked message
    mov eax, 4
    mov ebx, 1
    mov ecx, already_booked
    mov edx, 18
    int 0x80
    jmp _start

view_booked_tours:
    ; Check if any tours are booked
    mov ecx, tours_count
    mov ebx, booked_tours
    mov edi, 0
    mov esi, 0

check_bookings:
    cmp byte [ebx + esi], 1
    jne skip_tour
    inc edi

skip_tour:
    inc esi
    loop check_bookings

    ; No tours booked
    cmp edi, 0
    je no_booked_message

    ; Display booked tours and phone numbers
    mov ecx, tours_count
    mov ebx, booked_tours
    mov esi, 0
    mov edx, 8

display_booked_tours:
    cmp byte [ebx + esi], 1
    jne skip_display

    ; Display tour
    mov eax, 4
    mov ebx, 1
    lea ecx, [tours + esi * edx]
    int 0x80

    ; Display phone number
    mov eax, 4
    mov ebx, 1
    lea ecx, [phone_numbers + esi * 10]
    mov edx, 10
    int 0x80
    mov eax, 4
    mov ebx, 1
    mov ecx, 10
    int 0x80

skip_display:
    inc esi
    loop display_booked_tours
    jmp _start

no_booked_message:
    ; Display no bookings message
    mov eax, 4
    mov ebx, 1
    mov ecx, no_bookings
    mov edx, 20
    int 0x80
    jmp _start

exit_program:
    ; Exit the program
    mov eax, 1
    xor ebx, ebx
    int 0x80
