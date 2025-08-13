org 0x7C00
bits 16

REP_CHAR equ "a"
MAX_REP equ 10

start:
    ; Set video mode and clear the screen.
    mov ah, 0x00    ; BIOS function: Set video mode.
    mov al, 0x03    ; Mode: 80x25 color text mode.
    int 0x10        ; Call BIOS.

    mov cx, MAX_REP     ; Counter.
    lea si, [string]    ; SI = address of the first character.

count_repetitions:
    ; Confirm the first character is the expected repeated character.
    mov al, [si]            ; Get the first character.
    cmp al, REP_CHAR
    je .loop                ; Start loop count if first character is REP_CHAR.
    jmp print_count

    .loop:
        add si, 1           ; Move pointer to the next character.
        mov al, [si]        ; Load the next character into AL.
        cmp al, REP_CHAR
        loope .loop         ; Loop if character = REP_CHAR.

print_count:
    ; Count how many times REP_CHAR was repeated.
    mov ax, MAX_REP
    sub ax, cx
    add al, '0'     ; Convert to string.

    ; Print.
    mov ah, 0x0E    ; BIOS function: Teletype output.
    mov bh, 0       ; Page number.
    int 0x10        ; Call BIOS.

done:
    cli
    hlt

string db "aaaaab", 0

times 510 - ($ - $$) db 0
dw 0xAA55
