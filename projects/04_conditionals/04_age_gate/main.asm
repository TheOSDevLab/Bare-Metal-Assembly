org 0x7C00
bits 16

AGE equ 7

start:
    ; Set video mode and clear the screen.
    mov ah, 0x00
    mov al, 0x03    ; 80x25 color text mode.
    int 0x10

    ; Check age.
    mov al, AGE
    cmp al, 18
    jae grant_access
    jmp deny_access

grant_access:
    lea si, [access_granted_message]
    call print_message
    jmp done

deny_access:
    lea si, [access_denied_message]
    call print_message
    jmp done

done:
    cli
    hlt

; --------------------------------
; Print a null-terminated string.
; Input: SI = String to print.
; --------------------------------
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
; Print a single character.
; Input: AL = Character to print.
; --------------------------------
print_char:
    mov ah, 0x0E    ; BIOS Teletype output.
    mov bh, 0
    int 0x10
    ret


access_granted_message db "Access granted.", 0
access_denied_message  db "Access denied.", 0

times 510 - ($ - $$) db 0
dw 0xAA55
