org 0x7C00
bits 16

; Note: Range is -128 to 127 (signed 8-bit)
ACCOUNT_BALANCE equ 120
WITHDRAW_AMOUNT equ 110

start:
    ; Set video mode and clear the screen.
    mov ah, 0x00
    mov al, 0x03    ; 80x25 text mode.
    int 0x10

    ; Subtract the numbers.
    mov al, ACCOUNT_BALANCE
    sub al, WITHDRAW_AMOUNT
    mov [result], al    ; Save result in memory.
    jge show_account_balance
    jmp show_debt

show_account_balance:
    lea si, [account_balance_message]
    call print_message
    call print_result
    jmp done

show_debt:
    lea si, [debt_message]
    call print_message

    neg byte [result]
    call print_result
    jmp done

done:
    cli
    hlt

; --------------------------------------
; Print a null terminated string.
; Input: SI = Index of string to print.
; --------------------------------------
print_message:
    .loop:
        mov al, [si]    ; Load character.
        cmp al, 0       ; Check for null-terminator.
        jz .return

        call print_char
        inc si
        jmp .loop

    .return:
        ret

; --------------------------------
; Print a single character.
; Input: AL = Character to print.
; --------------------------------
print_char:
    mov ah, 0x0E    ; BIOS Teletype output.
    mov bh, 0
    int 0x10
    ret

; -----------------------------------------------
; Print the result of the subtraction.
; Input: 'result' variable = The result to print.
; The result can be between 0 and 127.
; -----------------------------------------------
print_result:
    ; Convert result to string.
    mov ax, [result]   ; Dividend.
    xor ah, ah
    mov bx, 10         ; Divisor.
    mov cx, 0          ; Counter.
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
        

account_balance_message db "Account Balance: ", 0
debt_message            db "You owe: ", 0

result db 0     ; Reserve space for the result.

times 510 - ($ - $$) db 0
dw 0xAA55

