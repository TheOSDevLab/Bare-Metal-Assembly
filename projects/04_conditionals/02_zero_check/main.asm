org 0x7C00
bits 16

NUM equ 7

start:
    ; Set video mode and clear the screen.
    mov ah, 0x00
    mov al, 0x03    ; 80x25 text mode.
    int 0x10

    ; Check if NUM == 0.
    mov al, NUM
    cmp al, 0
    jnz not_zero
    jmp zero

not_zero:
    lea si, [not_zero_message]
    call print_message
    jmp done

zero:
    lea si, [zero_message]
    call print_message
    jmp done

done:
    cli
    hlt

; ---------------------------------
; Prints a null-terminated string.
; Input: SI = String to print.
; ---------------------------------
print_message:
    .loop:
        mov al, [si]
        cmp al, 0
        jz .return

        call print_char
        inc si
        jmp .loop

    .return:
        ret

; --------------------------------
; Prints a single character.
; Input: AL = Character to print.
; --------------------------------
print_char:
    mov ah, 0x0E
    mov bh, 0
    int 0x10
    ret

zero_message     db "Zero", 0
not_zero_message db "Not Zero", 0

times 510 - ($ - $$) db 0
dw 0xAA55
