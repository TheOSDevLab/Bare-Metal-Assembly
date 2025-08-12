org 0x7C00
bits 16

LOOP_COUNT equ 5    ; Number of times to loop.

start:
    ; Set video mode and clear the screen.
    mov ah, 0x00    ; BIOS function: Set video mode.
    mov al, 0x03    ; Mode: 80x25 color text mode.
    int 0x10        ; Call BIOS.

    ; Loop setup.
    mov ah, 0x0E    ; BIOS function: Teletype output.
    mov bh, 0       ; Page number.
    mov cx, LOOP_COUNT

loop_start:
    ; Print number in CX (more specifically, CL).
    mov al, cl
    add al, '0'     ; Convert integer to string.
    int 0x10        ; Call BIOS.
    
    loop loop_start

done:
    cli     ; Clear interrupts.
    hlt     ; Halt the CPU.

times 510 - ($ - $$) db 0
dw 0xAA55
