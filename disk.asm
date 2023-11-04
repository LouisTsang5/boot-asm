[bits 16]       ; 16 bits mode
[org 0x7c00]    ; Boot memory starts at offset 7c00

; Define Constants
STACK_ADDR equ 0x9000       ; Addr of stack
CR equ 13                   ; CR char
LF equ 10                   ; LF char

; Initialize stack pointers
mov bp, STACK_ADDR
mov sp, bp

; Print string
mov ax, boot_msg
call print_str

; Switch to 32-bit protected mode (PM)
call switch_to_pm

; End of 16-bit real mode program
jmp $

%include "./print/print_str.asm" ; print str func
%include "./print/print_hex.asm" ; print hex func
%include "./pm/gdt.asm"
%include "./pm/switch_to_pm.asm"
%include "./pm/print_str_pm.asm"

; Program in 32-bit real mode
[bits 32]
BEGIN_PM:
    ; Print message of successfully entering PM
    mov eax, pm_mdoe_msg
    call print_str_pm

    ; End of PM program
    jmp $

; Strings with \r\n\0 at the end
boot_msg: db 'System booted in real mode.', CR, LF, 0
pm_mdoe_msg: db 'Entered 32 bit protected mode.', CR, LF, 0

; Padding and magic BIOS number.
times 510 - ($-$$) db 0
dw 0xaa55