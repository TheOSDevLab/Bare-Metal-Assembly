org 0x7C00
bits 16

start:
    ; Setting video mode to 80x25 text mode (`03h`).
    mov ah, 0x00    ; Set video mode function.
    mov al, 0x03    ; 80x25 color text mode.
    int 0x10        ; Call BIOS.

    ; Printing a single character using `BIOS INT 10h`, `0Eh` function.
    mov ah, 0x0E    ; Teletype function.
    mov al, 'A'     ; Character to print.
    mov bh, 0       ; Page number.
    int 0x10        ; Call BIOS

    hlt             ; Halt the CPU forever.

times 510 - ($ - $$) db 0	; Padding with 0s.
dw 0xAA55			        ; Boot signature.
