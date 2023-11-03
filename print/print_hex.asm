; Print byte value in al as 0x00 string
print_hex:
    pusha
    mov bl, al      ; Move original value to bl

    ; Print char '0'
    mov al, '0'
    call print_char

    ; Print char 'x'
    mov al, 'x'
    call print_char

    ; Print high nibble
    mov al, bl      ; Move original value to al
    shr al, 4       ; Shift right 4 bits to bring first 4 bits to last
    call print_hex_last_bits

    ; Print low nibble
    mov al, bl      ; Move original value to al
    call print_hex_last_bits

    ; End
    popa
    ret
print_hex_last_bits:
    and ax, 0x000f  ; Isolate last 4 bites
    mov si, ax      ; Move al to si for address index
    mov al, byte [hex_digits + si] ; Load the corresponding hex character by the 4bit offset
    call print_char
    ret
hex_digits:
    db "0123456789ABCDEF"