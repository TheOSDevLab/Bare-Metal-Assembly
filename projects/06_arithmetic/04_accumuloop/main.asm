org 0x7C00
bits 16

start:
    ; Set video mode and clear the screen.
    mov ah, 0x00    ; BIOS function: Set video mode.
    mov al, 0x03    ; Mode: 80x25 color text mode.
    int 0x10        ; Call BIOS.

calc_arithmetic_series:
    xor ax, ax
    xor bx, bx

    .calc_loop:
        inc bx                  ; Increment BX.
        add ax, bx              ; AX = AX + BX.
        cmp bx, [num]           ; Check if upper limit is reached.
        je print_triangular_sum
        jmp .calc_loop

print_triangular_sum:
    ; Convert value in AX to ASCII decimal string and print it.
    mov bx, 10  ; Divisor.
    xor cx, cx  ; Counter.

    .convert_to_string:
        xor dx, dx              ; Zero out upper part of the dividend.
        div bx                  ; AX = quotient, DX = remainder.
        
        add dx, '0'             ; Convert to string.
        push dx                 ; Push to stack.
        inc cx                  ; Increment counter.

        cmp ax, 0               ; Check if AX = 0.
        je .print_num
        jmp .convert_to_string

    .print_num:
        pop ax          ; AL = Character to print.
        call print      ; Print the character.
        loop .print_num ; Loop until CX = 0.

done:
    cli     ; Clear interrupts.
    hlt     ; Halt the CPU.
    
print:
    ; This function expects AL to contain the character to print.
    push ax         ; Preserve AX.
    
    mov ah, 0x0E    ; BIOS function: Teletype output.
    mov bh, 0       ; Page number.
    int 0x10        ; Call BIOS.

    pop ax          ; Recover AX.
    ret             ; Return to caller.

; Upper limit of the arithmetic series.
num db 5

times 510 - ($ - $$) db 0
dw 0xAA55
