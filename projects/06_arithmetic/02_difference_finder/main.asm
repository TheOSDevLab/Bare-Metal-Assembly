org 0x7C00
bits 16

; Numbers to subtract.
num1 equ 123
num2 equ 89

start:
    ; Set video mode and clear the screen.
    mov ah, 0x00    ; BIOS function: Set video mode.
    mov al, 0x03    ; Mode: 80x25 text mode.
    int 0x10        ; Call BIOS.

    ; Find the difference.
    mov ax, num1    ; AX = 123
    sub ax, num2    ; AX = 123 - 89 = 34

; Convert difference to string.
mov cx, 0   ; Loop counter.
mov bx, 10  ; Divisor.

convert_to_string:
    xor dx, dx  ; Zero out dividend's upper half.
    div bx      ; AX = Quotient, DX = Remainder.

    add dl, '0' ; Convert remainder to string.
    push dx     ; Push remainder character to stack.
    inc cx      ; Increment loop counter.

    ; Check if quotient is 0.
    cmp ax, 0
    je print_digits
    jmp convert_to_string

; Print the difference.
print_digits:
    pop ax              ; AL = character to print.
    mov ah, 0x0E        ; BIOS function: Teletype output.
    mov bh, 0           ; Page number.
    int 0x10            ; Call BIOS.
    loop print_digits   ; Loop until CX = 0.

done:
    jmp $

times 510 - ($ - $$) db 0
dw 0xAA55
