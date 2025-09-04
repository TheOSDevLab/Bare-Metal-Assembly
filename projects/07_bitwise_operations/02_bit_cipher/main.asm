org 0x7C00
bits 16

KEY equ "1"

start:
    ; Set video mode and clear the screen.
    mov ax, 0x0003
    int 0x10

    ; Print original string.
    lea si, [password]
    call get_string_len
    call print_string

encrypt:
    mov al, [si]
    test al, al
    jz print_encrypted

    xor al, KEY
    mov [si], al    ; Overwrite original string.

    inc si
    jmp encrypt

print_encrypted:
    ; Move cursor to a new line.
    mov ah, 0x02    ; BIOS function: Set cursor position.
    mov bh, 0
    mov dh, 1
    mov dl, 0
    int 0x10

    lea si, [password]
    call print_string

done:
    cli
    hlt

; --------------------------------------------------
; Print a string null-terminated string.
; Input: SI = Memory address of the string to print.
; --------------------------------------------------
print_string:
    push si
    mov cx, [string_len]
    mov al, [si]

.print_loop:
    call print_char
    inc si

    mov al, [si]
    loop .print_loop

.return:
    pop si
    ret

; -------------------------------
; Print a single character.
; Input: AL = Character to print.
; -------------------------------
print_char:
    mov ah, 0x0E    ; BIOS Function: Teletype output.
    mov bh, 0
    int 0x10
    ret

; ---------------------------------------------------------------------------
; Count number of characters in a string and store the value in [string_len].
; Input; SI = Memory address of the string.
; ---------------------------------------------------------------------------
get_string_len:
    push si
    xor cx, cx

.count_loop:
    mov al, [si]
    test al, al
    jz .finish

    inc cx
    inc si
    jmp .count_loop

.finish:
    mov [string_len], cx
    pop si
    ret

password   db "Onlyfeet password.", 0
string_len dw 3

times 510 - ($ - $$) db 0
dw 0xAA55
