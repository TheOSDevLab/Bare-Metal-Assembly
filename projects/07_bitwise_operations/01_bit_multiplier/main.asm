org 0x7C00
bits 16

; Make sure that (MULTIPLICAND x MULTIPLIER ≤ 65,535)
MULTIPLICAND equ 63
MULTIPLIER equ 10

start:
    ; Set video mode and clear the screen.
    mov ax, 0x0003
    int 0x10

    ; Setup
    mov cx, MULTIPLICAND
    mov bx, MULTIPLIER
    xor ax, ax

multiplication_loop:
    test bx, 1
    jz .shift
    add ax, cx

    .shift:
        shl cx, 1
        shr bx, 1
        jnz multiplication_loop

done:
    call print_result
    cli
    hlt

; ---------------------------------------
; Print the result of the multiplication.
; Input: AX = The result.
; ---------------------------------------
print_result:
    ; Convert result to string.
    mov bx, 10          ; Divisor.
    mov cx, 0           ; Counter.
    .convert_loop:
        xor dx, dx
        div bx

        add dx, '0'       ; Convert remainder to string.
        push dx
        inc cx

        test ax, ax
        jz .print_loop
        jmp .convert_loop

    .print_loop:
        pop ax
        call print_char
        loop .print_loop

    .return:
        ret

; -------------------------------
; Print a single ascii character.
; Input: AL = Character to print.
; -------------------------------
print_char:
    mov ah, 0x0E    ; BIOS function: Teletype output.
    mov bh, 0
    int 0x10
    ret

times 510 - ($ - $$) db 0
dw 0xAA55
