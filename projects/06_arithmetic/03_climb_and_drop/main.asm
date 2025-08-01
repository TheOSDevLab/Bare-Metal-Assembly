org 0x7C00
bits 16

start:
    ; Set video mode.
    mov ah, 0x00        ; BIOS function: Set video mode.
    mov al, 0x03        ; Mode: 80x25 color text mode.
    int 0x10            ; Call BIOS.

    mov al, [num]

    call print_number   ; Print original number.

increment:
    ; Increment to 9.
    inc al

    ; Print the number.
    call print_number

    ; Check if number = 9.
    cmp al, 9
    je print_space
    jmp increment

print_space:
    push ax         ; Preserve AX.
    mov al, ' '     ; Character to print.
    call print      ; Print the space.
    pop ax          ; Recover AX.

decrement:
    ; Decrement to original number.
    dec al

    ; Print the number.
    call print_number

    ; Check if number = original number.
    cmp al, [num]
    je done
    jmp decrement

done:
    cli     ; Clear interrupts.
    hlt     ; Halt the CPU.

print_number:
    ; This function converts the number in AL into
    ; a string and prints it.
    push ax         ; Preserve AX.
    add al, '0'     ; Convert number to string.
    call print      ; Print the number.
    pop ax          ; Recover AX.
    ret             ; Return to caller.

print:
    ; This function expects AL to contain the character to print.
    mov ah, 0x0E    ; BIOS function: Teletype output.
    mov bh, 0       ; Page number.
    int 0x10        ; Call BIOS.
    ret             ; Return to caller.

; Number to increment then decrement.
num db 3    ; Must be less than 9.

times 510 - ($ - $$) db 0
dw 0xAA55
