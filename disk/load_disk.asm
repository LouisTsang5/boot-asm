; Read from target device from second to n+1 sectors to destination
; Input - bx: destination pointer, dh: number of sectors to read, dl: device to read from
; Return - al: number of sectors read
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
disk_err_msg: db 'Failed to load disk', 0