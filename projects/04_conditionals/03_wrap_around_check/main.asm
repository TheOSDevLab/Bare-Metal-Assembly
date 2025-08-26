org 0x7C00
bits 16

; Note: The subtraction order is NUM1 - NUM2.
NUM1 equ 5
NUM2 equ 1

start:
    ; Set video mode and clear the screen.
    mov ah, 0x00
    mov al, 0x03    ; 80x25 text mode.
    int 0x10

    ; Subtract the numbers.
    mov dl, NUM1
    sub dl, NUM2
    mov [result], dl    ; Save result in memory.
    jc underflow
    jmp no_underflow

underflow:
    lea si, [underflow_message]
    jmp common_print

no_underflow:
    lea si, [no_underflow_message]
    jmp common_print

common_print:
    call print_message
    call print_result

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
; The result can be between 0 and 255.
; -----------------------------------------------
print_result:
    ; Convert result to string.
    mov ax, [result]    ; Dividend.
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
        

underflow_message    db "Wrap around occurred: ", 0
no_underflow_message db "No wrap around: ", 0

result db 0     ; Reserve space for the result.

times 510 - ($ - $$) db 0
dw 0xAA55
