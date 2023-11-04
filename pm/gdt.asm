; Definition of the Global Descriptor Table (GDT)
; The GDT is made up of a list of Segment descriptors (SD)
; 3 SDs are defined: null SD, code SD, and data SD
; Each SD is 8 bytes wide
; This GDT describes a flat segment model where both code and data segments overlaps from 0x0 to 0xffffffff using all 4GB of addressable memory of a 32-bit CPU
gdt_start:

; The first SD is a null descriptor
gdt_null: 
    dd 0x0
    dd 0x0

; The SD for code
; base = 0x0, limit = 0xfffff,
; 1st flags: present = 1, privilege = 00, descriptor type = 1 -> 1001b
; type flags: code = 1, conforming = 0, readable = 1, accessed = 0 -> 1010b
; 2nd flags: granularity = 1, 32-bit default = 1, 64-bit code segmnet = 0, AVL = 0 -> 1100b
gdt_code: 
    ; First 4 bytes
    dw 0xffff       ; Limit (bits 0 - 15)
    dw 0x0          ; Base (bits 16 - 31)
    ; Latter 4 bytes
    db 0x0          ; Base (bits  0 - 7)
    db 10011010b    ; 1st flag and type flags (bits 8 - 15)
    db 11001111b    ; 2nd flag and 4 bits segment limit (bits 16 - 23)
    db 0x0          ; 8 bits of base (bits 24 - 31)

; The SD for data
; Same as code segment exception for type flags
; type flags: code = 0, expand down = 0, writable = 1, accessed: 0 -> 0010b
gdt_data: 
    ; First 4 bytes
    dw 0xffff       ; Limit (bits 0 - 15)
    dw 0x0          ; Base (bits 16 - 31)
    ; Latter 4 bytes
    db 0x0          ; Base (bits  0 - 7)
    db 10010010b    ; 1st flag and type flags (bits 8 - 15)
    db 11001111b    ; 2nd flag and 4 bits segment limit (bits 16 - 23)
    db 0x0          ; 8 bits of base (bits 24 - 31)

gdt_end:    ; End label

; GDT descriptor
; The GDT descriptor describes the size (16 bits) and address (32 bits) of the GDT
gdt_descriptor:
    dw gdt_end - gdt_start - 1  ; Size (-1 for 1 byte offset of the end label)
    dd gdt_start                ; Addr

; Define offsets of SD as constants
; e.g., when ds = DATA_SEQ in PM, the CPU uses the data segment described by the data SD
; SD offsets: 0x0 = NULL, 0x8 = CODE, 0x10 = DATA
CODE_SEQ equ gdt_code - gdt_start
DATA_SEQ equ gdt_data - gdt_start