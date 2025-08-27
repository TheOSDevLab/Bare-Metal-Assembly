org 0x7C00
bits 16

SPEED equ 45

start:
    ;Set video mode and clear the screen.
    mov ah, 0x00
    mov al, 0x03    ; 80x25 text mode.
    int 0x10

    ; Check the speed.
    mov al, SPEED
    cmp al, 80      ; Max speed = 80 km/h.
    jbe safe_speed
    jmp slow_down

safe_speed:
    lea si, [safe_speed_message]
    call print_message
    jmp done

slow_down:
    lea si, [slow_down_message]
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

safe_speed_message db "Speed within safe limit.", 0
slow_down_message  db "Overspeed detected. Slow down.", 0

times 510 - ($ - $$) db 0
dw 0xAA55
