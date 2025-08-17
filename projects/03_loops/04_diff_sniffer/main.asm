org 0x7C00
bits 16

start:
    ; Set video mode and clear the screen.
    mov ah, 0x00        ; BIOS function: Set video mode.
    mov al, 0x03        ; Mode: 80x25 color text mode.
    int 0x10            ; Call BIOS.

    ; Loop setup.
    lea si, [string1]   ; SI = first character in string1.
    lea di, [string2]   ; DI = first character in string2.
    mov cx, 10          ; Loop counter.

find_mismatch:
    mov byte bh, [si]   ; Load 1 byte from string1 to BH.
    mov byte bl, [di]   ; Load 1 byte from string2 to BL.
    
    ; Move pointer to the next character.
    inc si
    inc di

    cmp bh, bl          ; Check if BH == BL.
    loope find_mismatch ; Loop if BH == BL.

print_mismatch_index:
    ; Calculate index: index = 9 - CX.
    mov al, 9
    sub al, cl
    add al, '0'         ; Convert index to string.

    ; Print index.
    mov ah, 0x0E        ; BIOS function: Teletype output.
    mov bh, 0           ; Page number.
    int 0x10            ; Call BIOS.

done:
    cli
    hlt

string1 db "example", 0
string2 db "examp1e", 0

times 510 - ($ - $$) db 0
dw 0xAA55
