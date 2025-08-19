org 0x7C00
bits 16

CHAR equ "w"
MAX equ 15
%define MAX_INDEX (MAX - 1)

start:
    ; Set video mode and clear the screen.
    mov ah, 0x00        ; BIOS function: Set video mode.
    mov al, 0x03        ; Mode: 80x25 color text mode.
    int 0x10            ; Call BIOS.

    ; Loop setup.
    mov cx, MAX         ; Loop counter.
    mov bh, CHAR        ; Character to find.
    lea si, [string]    ; SI = index of the string's first character.

find_char:
    mov bl, [si]        ; Load next character into BL.
    inc si              ; Move pointer to the next character.

    cmp bh, bl          ; Check if BH == BL.
    loopne find_char    ; Loop if BH != BL.

print_index:
   ; Index = 14 - CX.
   mov al, MAX_INDEX
   sub al, cl           ; AL = (MAX - 1) - CX.
   add al, '0'          ; Convert AL to string.

   ; Print the index.
   mov ah, 0x0E         ; BIOS function: Teletype output.
   mov bh, 0            ; page number.
   int 0x10             ; Call BIOS.

done:
    cli
    hlt

string db "Hello world!", 0

times 510 - ($ - $$) db 0
dw 0xAA55
