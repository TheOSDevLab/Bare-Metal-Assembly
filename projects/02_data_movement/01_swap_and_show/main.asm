org 0x7C00
bits 16

start:
    ; Set video mode to 80x25 color text mode (Mode 03h).
    mov ah, 0x00    ; Function: Set video mode.
    mov al, 0x03    ; Mode: 80x25 color text mode.
    int 0x10        ; Call BIOS.

first_print:
    ; Print variables before swapping.
    mov ah, 0x0E    ; Function: Teletype output.
    mov bh, 0       ; Page number.

    mov al, [one]   ; Load first variable.
    int 0x10        ; Call BIOS.

    mov al, [two]   ; Load second variable.
    int 0x10        ; Call BIOS.

swap_variables:
    ; Swap the values in 'one' and 'two' using XCHG.
    mov al, [one]   ; Move 'a' into AL.
    xchg al, [two]  ; AL='b', two='a'.
    mov [one], al   ; one='b'.

second_print:
    ; Print a space, then the swapped characters.
    ; No need to redo AH and BH. Their values haven't changed.
    mov al, ' '     ; Load a space.
    int 0x10

    mov al, [one]
    int 0x10

    mov al, [two]
    int 0x10
    
    hlt             ; Halt the CPU.
    
; Declare 2 different variables.
one db 'a'
two db 'b'

times 510 - ($ - $$) db 0   ; Padding to 510 bytes with 0s.
dw 0xAA55                   ; Boot signature.
