org 0x7C00
bits 16

start:
    ; Set video mode and clear the screen.
    mov ah, 0x00    ; BIOS function: Set video mode.
    mov al, 0x03    ; Mode: 80x25 color text mode.
    int 0x10        ; Call BIOS.

print_A:
    mov ah, 0x0E    ; BIOS function: Teletype output.
    mov al, 'A'     ; Character to print.
    mov bh, 0       ; Page number.
    int 0x10        ; Call BIOS.

jmp print_C         ; Skip the segment that prints 'B'.

print_B:
    mov al, 'B'     ; Character to print.
    int 0x10        ; Call BIOS.

print_C:
    mov al, 'C'     ; Character to print.
    int 0x10        ; Call BIOS

done:
    cli
    hlt             ; Halt the CPU.

times 510 - ($ - $$) db 0
dw 0xAA55
