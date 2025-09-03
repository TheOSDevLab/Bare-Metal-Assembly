org 0x7C00
bits 16

start:
    ; Set video mode and clear the screen.
    mov ax, 0x0003 
    int 0x10

    ; Initialize and preserve AL.
    mov al, 'a'
    push ax

    ; Change AL and print the new value.
    mov al, 'b'
    call print

    ; Restore AL and print the original value.
    pop ax
    call print

done:
    cli
    hlt

; -------------------------------
; Print one character.
; Input: AL = Character to print.
; -------------------------------
print:
    mov ah, 0x0E
    mov bh, 0
    int 0x10
    ret

times 510 - ($ - $$) db 0
dw 0xAA55
