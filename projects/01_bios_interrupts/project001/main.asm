org 0x7C00
bits 16

start:
    ; Set video mode to 80x25 text mode (`03h`).
    mov ah, 0x00    ; Function: Set video mode.
    mov al, 0x03    ; Mode: 80x25 color text.
    int 0x10        ; Call BIOS.

    ; Print a single character using BIOS INT 10h, function 0Eh (TTY output).
    mov ah, 0x0E    ; Function: Teletype output.
    mov al, 'A'     ; Character to print.
    mov bh, 0       ; Page number.
    int 0x10        ; Call BIOS

    hlt             ; Halt the CPU forever.

times 510 - ($ - $$) db 0	; Pad the boot sector with zeros.
dw 0xAA55			        ; Boot signature.
