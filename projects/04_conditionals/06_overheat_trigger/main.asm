org 0x7C00
bits 16

CPU_TEMP equ 80
MAX_TEMP equ 100

start:
    ;Set video mode and clear the screen.
    mov ah, 0x00
    mov al, 0x03    ; 80x25 text mode.
    int 0x10

    ; Check the temperature
    mov al, CPU_TEMP
    cmp al, MAX_TEMP
    ja overheat
    jmp safe_temp

overheat:
    lea si, [overheat_message]
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

overheat_message   db "WARNING: CPU Overheating! System throttle required.", 0
safe_temp_message  db "CPU temperature normal. System stable.", 0

times 510 - ($ - $$) db 0
dw 0xAA55
