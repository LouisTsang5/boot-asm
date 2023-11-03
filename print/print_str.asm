; Use ax for string pointer
print_str:
    pusha
    mov si, 0           ; Init offset counter
    mov bx, ax          ; Load string pointer to bx
print_loop:
    ; Load character and check if terminator has been reached
    mov al, [bx + si]   ; Load the character to al
    cmp al, 0           ; Check if null terminator reached
    je print_end        ; Return to end if reached

    ; Print the character
    call print_char

    ; Increase counter and loop again 
    add si, 1           ; Increase offset
    jmp print_loop
print_end:
    popa
    ret

; Print char in al
print_char:
    pusha
    mov ah, 0x0e        ; Teletype BIOS routine
    int 0x10            ; Print the character
    popa
    ret
