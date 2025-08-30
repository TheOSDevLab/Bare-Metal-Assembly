org 0x7C00
bits 16

TEMP          equ 2
FREEZING_TEMP equ 0

start:
    ;Set video mode and clear the screen.
    mov ah, 0x00
    mov al, 0x03    ; 80x25 text mode.
    int 0x10

    ; Check the temperature
    mov al, TEMP
    cmp al, FREEZING_TEMP
    jl trigger_alarm
    jmp safe_temp

trigger_alarm:
    lea si, [freezing_message]
    call print_message
    jmp done

safe_temp:
    lea si, [safe_temp_message]
    call print_message
    jmp done

done:
    cli
    hlt

; -------------------------------
; Print a null-terminated string.
; Input: SI = String to print.
; -------------------------------
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

; -------------------------------
; Print a single character
; Input: AL = Character to print.
; -------------------------------
print_char:
    mov ah, 0x0E    ; BIOS Teletype output.
    mov bh, 0
    int 0x10
    ret

freezing_message   db "ALERT: Temperature below freezing! Risk of frost damage.", 0
safe_temp_message  db "Temperature normal. No frost detected.", 0

times 510 - ($ - $$) db 0
dw 0xAA55
