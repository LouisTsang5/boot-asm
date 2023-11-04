[bits 16]
; Switch to 32 bit protected mode
switch_to_pm:
    cli                     ; Switch off interrupts until the protected mode interrupt vector is setup
    lgdt [gdt_descriptor]   ; Load the GDT
    
    ; Set first bit of CR0 register to 1 to indicate the switch to protected mode
    mov eax, cr0
    or eax, 0x1
    mov cr0, eax

    ; Make a far jump to 32-bit code by jumping to a new segment
    ; This also forces the CPU to clear the cache of pre-fetched real-mode instructions
    jmp CODE_SEQ:init_pm

[bits 32]
; Init registers and the stack in PM
init_pm:
    ; Point segment registers to the data SD
    mov ax, DATA_SEQ
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    ; Setup stack pointer to point at the top of the free space
    mov ebp, STACK_ADDR
    mov esp, ebp

    call BEGIN_PM