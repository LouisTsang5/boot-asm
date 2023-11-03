[bits 16]       ; 16 bits mode
[org 0x7c00]    ; Boot memory starts at offset 7c00

; Define Constants
STACK_ADDR equ 0x8000       ; Addr of stack
CR equ 13                   ; CR char
LF equ 10                   ; LF char
DISK_LOAD_ADDR equ 0x9000   ; Addr to load disk image to
DISK_LOAD_N_SECTORS equ 5   ; Number of sectors to read

; BIOS stores boot device to dl on startup
mov [boot_device], dl 

; Initialize stack pointers
mov bp, STACK_ADDR
mov sp, bp

; Print string
mov ax, boot_msg
call print_str

; Load from disk
mov bx, DISK_LOAD_ADDR      ; Load to disk addr
mov dh, DISK_LOAD_N_SECTORS ; Load 5 sectors
mov dl, [boot_device]       ; Read from boot device
call load_disk

; Display success message
push ax
mov ax, disk_suc_msg_0
call print_str
pop ax
call print_hex
mov ax, disk_suc_msg_1
call print_str

; Display loaded values
mov al, [DISK_LOAD_ADDR]
call print_hex
mov al, [DISK_LOAD_ADDR + 512]
call print_hex

; End of program
jmp $

boot_device: db 0

; Strings with \r\n\0 at the end
boot_msg: db 'System Booted.', CR, LF, 0
disk_err_msg: db 'Failed to read disk.', CR, LF, 0
disk_suc_msg_0: db 'Successfully read ', 0
disk_suc_msg_1: db ' sectors from disk', CR, LF, 0

%include "./disk/load_disk.asm" ; load disk logic
%include "./print/print_str.asm" ; print str func
%include "./print/print_hex.asm" ; print hex func

; Padding and magic BIOS number.
times 510 - ($-$$) db 0
dw 0xaa55

; Pad rest of the disk
times 512 db 0xaa
times 512 db 0xff