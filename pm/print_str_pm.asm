[bits 32]
VIDEO_MEMORY equ 0xb8000    ; Addr of memory mapped display
WHITE_ON_BLACK equ 0x0f     ; Text display mode

; Prints a null-terminated string pointed to by eax
print_str_pm:
    pusha
    mov ebx, VIDEO_MEMORY   ; Make ebx point at video memory
    mov ch, WHITE_ON_BLACK  ; Use cx as character storage, ch is text mode flag
print_str_pm_loop:
    ; Return when null terminator reached
    cmp byte [eax], 0
    je print_str_pm_done

    ; Load char into video memory
    mov cl, [eax]   ; Move char into cl
    mov [ebx], cx   ; Move char and display flag to video memory

    ; Increment pointers
    add eax, 1      ; Move eax to point to the next char
    add ebx, 2      ; Move ebx to the next char slot (2 bytes wide)
    jmp print_str_pm_loop
print_str_pm_done:
    popa
    ret