org 0x7C00
bits 16

start:
    ; Set video mode.
    mov ah, 0x00    ; BIOS Function: Set Video Mode.
    mov al, 0x03    ; Mode: 80x25 color text mode.
    int 0x10        ; Call BIOS.

    ; Use LEA to calculate the address of the 3rd vowel.
    lea si, [vowels + 2]    ; SI = address of 'i'.
    
    ; Print the vowel in [SI].
    mov ah, 0x0E    ; BIOS Function: Teletype output.
    mov al, [si]    ; AL = 'i'.
    mov bh, 0       ; Page number.
    int 0x10        ; Call BIOS.

    ; Use LEA to calculate the address of the 5th vowel.
    lea si, [vowels + 4]    ; SI = address of 'u'.

    ; Print the vowel in [SI].
    mov al, [si]    ; AL = 'u'.
    int 0x10        ; Call BIOS.

    jmp $       ; Infinite loop to prevent executing data.

vowels db "aeiou"

times 510 - ($ - $$) db 0
dw 0xAA55
