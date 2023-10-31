[bits 16]       ; 16 bits mode
[org 0x7c00]    ; Boot memory starts at offset 7c00

; Initialize stack pointers to 0x8000
mov bp, 0x8000
mov sp, bp

; Print string
mov ax, boot_msg
call print_str

; Load from disk
mov bx, 0x9000
mov dh, 5
mov dl, 0
call load_disk

; End of program
jmp $

; Read from target device from second to n+1 sectors to destination
; Input - bx: destination pointer, dh: number of sectors to read, dl: device to read from
load_disk:
    push dx ; store dx for comparison later
    
    ; Request read from disk
    mov ah, 0x02        ; BIOS read sector function
    mov al, dh          ; Read number of sectors indicated in dh
    mov ch, 0x00        ; Read from cylinder 0
    mov dh, 0x00        ; Read from head 0
    mov cl, 0x02        ; Read from second sector (After boot sector)
    int 0x13            ; BIOS interrupt

    ; Check if error occured by checking the carry flag
    jc load_disk_err

    ; Check if number of sectors read are correct
    pop dx
    cmp dh, al ; DH = requested number of sectors, AL = actual number of sectors read
    jne load_disk_err
    ret
load_disk_err:
    mov ax, disk_err_msg
    call print_str
    jmp $

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

; Strings with \r\n\0 at the end
boot_msg: db 'System Booted.', 13, 10, 0
disk_err_msg: db 'Failed to read disk.', 13, 10, 0

; Padding and magic BIOS number.
times 510 - ($-$$) db 0
dw 0xaa55

; Pad rest of the disk
times 512 db 0xaa
times 512 db 0xff