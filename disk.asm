[bits 16]       ; 16 bits mode
[org 0x7c00]    ; Boot memory starts at offset 7c00

mov [boot_device], dl ; BIOS store boot device to dl on startup

; Initialize stack pointers to 0x8000
mov bp, 0x8000
mov sp, bp

; Print string
mov ax, boot_msg
call print_str

; Load from disk
mov bx, 0x9000          ; Load to addr 0x9000
mov dh, 5               ; Load 5 sectors
mov dl, [boot_device]   ; Read from boot device
call load_disk

; Display success message
push ax
mov ax, disk_suc_msg_0
call print_str
pop ax
call print_hex
mov ax, disk_suc_msg_1
call print_str

; End of program
jmp $

boot_device: db 0

; Strings with \r\n\0 at the end
boot_msg: db 'System Booted.', 13, 10, 0
disk_err_msg: db 'Failed to read disk.', 13, 10, 0
disk_suc_msg_0: db 'Successfully read ', 0
disk_suc_msg_1: db ' sectors from disk', 13, 10, 0

%include "./disk/load_disk.asm" ; load disk logic
%include "./print/print_str.asm" ; print str func
%include "./print/print_hex.asm" ; print hex func

; Padding and magic BIOS number.
times 510 - ($-$$) db 0
dw 0xaa55

; Pad rest of the disk
times 512 db 0xaa
times 512 db 0xff