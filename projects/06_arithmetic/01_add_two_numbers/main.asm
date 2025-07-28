org 0x7C00
bits 16

num1 equ 7
num2 equ 2

start:
	; Set video mode.
	mov ah, 0x00    ; BIOS function: Set video mode.
	mov al, 0x03    ; Mode: 80x25 color text mode.
	int 0x10        ; Call BIOS.

	; Add the numbers.
	mov ah, num1    ; AH = 7
	mov al, num2    ; AL = 2
	add al, ah      ; AL = 7 + 2 = 9

	; Convert sum to string for printing.
	add al, '0'
	; OR add al, 48

	; Print the sum.
	mov ah, 0x0E    ; BIOS function: Teletype output.
	mov bh, 0       ; Page number.
	int 0x10        ; Call BIOS.

	; Halt.
	hlt

times 510 - ($ - $$) db 0
dw 0xAA55
