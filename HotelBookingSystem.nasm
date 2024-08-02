section .data
    rooms db "1. Single Room", 0, "2. Double Room", 0, "3. Suite", 0
    rooms_count equ 3
    booked_rooms db 0, 0, 0                  ; Array to track booked rooms (0 = not booked, 1 = booked)
    customer_names db 30 dup (0)             ; Array to store customer names (3 rooms * 10 chars per name)
    menu db "1. View Rooms", 10, "2. Book a Room", 10, "3. View Booked Rooms", 10, "4. Exit", 0
    prompt db "Choose an option: ", 0
    book_prompt db "Enter room number to book: ", 0
    name_prompt db "Enter your name: ", 0
    invalid_option db "Invalid option. Try again.", 10, 0
    booked_success db "Room booked successfully!", 10, 0
    already_booked db "Room already booked!", 10, 0
    no_bookings db "No rooms booked yet.", 10, 0

section .bss
    option resb 1
    room_number resb 1
    customer_name resb 10

section .text
    global _start

_start:
    ; Display the menu
    mov eax, 4
    mov ebx, 1
    mov ecx, menu
    mov edx, 55
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
    je view_rooms
    cmp byte [option], '2'
    je book_room
    cmp byte [option], '3'
    je view_booked_rooms
    cmp byte [option], '4'
    je exit_program

    ; Invalid option
    mov eax, 4
    mov ebx, 1
    mov ecx, invalid_option
    mov edx, 25
    int 0x80
    jmp _start

view_rooms:
    ; Display available rooms
    mov eax, 4
    mov ebx, 1
    mov ecx, rooms
    mov edx, 45
    int 0x80
    jmp _start

book_room:
    ; Prompt for room number
    mov eax, 4
    mov ebx, 1
    mov ecx, book_prompt
    mov edx, 27
    int 0x80

    ; Read room number
    mov eax, 3
    mov ebx, 0
    mov ecx, room_number
    mov edx, 1
    int 0x80

    ; Convert ASCII to integer (1-3)
    sub byte [room_number], '1'
    cmp byte [room_number], 0
    jb invalid_option
    cmp byte [room_number], 2
    ja invalid_option

    ; Check if room is already booked
    movzx eax, byte [room_number]
    movzx ebx, byte [booked_rooms + eax]
    cmp ebx, 1
    je already_booked_message

    ; Prompt for customer name
    mov eax, 4
    mov ebx, 1
    mov ecx, name_prompt
    mov edx, 17
    int 0x80

    ; Read customer name
    mov eax, 3
    mov ebx, 0
    mov ecx, customer_name
    mov edx, 10
    int 0x80

    ; Book the room and store the customer name
    mov byte [booked_rooms + eax], 1
    mov esi, eax
    mov edi, customer_name
    lea ecx, [customer_names + esi * 10]
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

view_booked_rooms:
    ; Check if any rooms are booked
    mov ecx, rooms_count
    mov ebx, booked_rooms
    mov edi, 0
    mov esi, 0

check_bookings:
    cmp byte [ebx + esi], 1
    jne skip_room
    inc edi

skip_room:
    inc esi
    loop check_bookings

    ; No rooms booked
    cmp edi, 0
    je no_booked_message

    ; Display booked rooms and customer names
    mov ecx, rooms_count
    mov ebx, booked_rooms
    mov esi, 0
    mov edx, 14

display_booked_rooms:
    cmp byte [ebx + esi], 1
    jne skip_display

    ; Display room
    mov eax, 4
    mov ebx, 1
    lea ecx, [rooms + esi * edx]
    int 0x80

    ; Display customer name
    mov eax, 4
    mov ebx, 1
    lea ecx, [customer_names + esi * 10]
    mov edx, 10
    int 0x80
    mov eax, 4
    mov ebx, 1
    mov ecx, 10
    int 0x80

skip_display:
    inc esi
    loop display_booked_rooms
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
   
