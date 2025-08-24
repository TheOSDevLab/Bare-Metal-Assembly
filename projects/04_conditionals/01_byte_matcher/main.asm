org 0x7C00
bits 16

first_byte  equ 'a'
second_byte equ 'b'

start:
    ; Set video mode and clear the screen.
    mov ah, 0x00
    mov al, 0x03    ; 80x25 text mode.
    int 0x10

    ; Check if the two bytes are equal.
    mov al, first_byte
    cmp al, second_byte
    je equal
    jmp not_equal

equal:
    lea si, [equal_message]
    call print_string
    jmp done

not_equal:
    lea si, [not_equal_message]
    call print_string
    jmp done

done:
    cli
    hlt

; ---------------------------------
; Prints a null-terminated string.
; Input: SI = address of string.
; ---------------------------------
print_string:
    .loop:
        mov al, [si]    ; Load next char.
        cmp al, 0       ; Check for terminator.
        jz .finished

        call print
        inc si
        jmp .loop

    .finished:
        ret

; ---------------------------------
; Prints a single character in AL.
; ---------------------------------
print:
    mov ah, 0x0E
    mov bh, 0
    int 0x10
    ret

equal_message     db "Bytes match.", 0
not_equal_message db "Bytes don't match.", 0

times 510 - ($ - $$) db 0
dw 0xAA55
