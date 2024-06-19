section .data
    ; Adjacency matrix for the graph (5x5)
    graph db  0, 10, 0, 30, 100,
               10, 0, 50, 0, 0,
               0, 50, 0, 20, 10,
               30, 0, 20, 0, 60,
               100, 0, 10, 60, 0

    ; Number of nodes
    num_nodes db 5

    ; Initialize arrays for shortest paths and visited nodes
    distances db 0, 255, 255, 255, 255
    visited   db 0, 0, 0, 0, 0

section .bss
    ; Index variables and temporary storage
    i resb 1
    j resb 1
    min_distance resb 1
    min_index resb 1
    new_distance resb 1

section .text
    global _start

_start:
    ; Dijkstra's algorithm implementation

    ; Loop through all nodes
    mov byte [i], 0

main_loop:
    ; Find the unvisited node with the smallest distance
    mov byte [min_distance], 255
    mov byte [min_index], -1

    mov byte [j], 0
find_min:
    mov al, [visited + j]
    cmp al, 0
    jne next_j
    mov al, [distances + j]
    cmp al, [min_distance]
    jae next_j
    mov al, [distances + j]
    mov [min_distance], al
    mov al, [j]
    mov [min_index], al
next_j:
    inc byte [j]
    cmp byte [j], [num_nodes]
    jne find_min

    ; Mark the selected node as visited
    mov al, [min_index]
    mov byte [visited + eax], 1

    ; Update distances for neighbors of the selected node
    mov al, [min_index]
    movzx eax, al
    imul eax, byte [num_nodes]
    mov esi, eax ; esi points to the start of the row in the adjacency matrix

    mov byte [j], 0
update_distances:
    ; Skip if the node is already visited
    mov al, [visited + j]
    cmp al, 1
    je next_j_update

    ; Calculate new possible distance
    mov al, [graph + esi + j]
    cmp al, 0
    je next_j_update
    add al, [min_distance]
    mov [new_distance], al

    ; Update the distance if it's smaller
    mov al, [distances + j]
    cmp al, [new_distance]
    jbe next_j_update
    mov al, [new_distance]
    mov [distances + j], al

next_j_update:
    inc byte [j]
    cmp byte [j], [num_nodes]
    jne update_distances

    ; Check if all nodes are visited
    inc byte [i]
    cmp byte [i], [num_nodes]
    jne main_loop

end:
    ; Exit the program
    mov eax, 1 ; sys_exit
    xor ebx, ebx
    int 0x80
