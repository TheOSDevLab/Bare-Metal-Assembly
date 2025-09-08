org 0x7C00
bits 16

; Make sure that (0 < NUM ≤ 65,535) (unsigned 16-bit)
NUM equ 1026

start:
    ; Set video mode and clear the screen.
    mov ax, 0x0003
    int 0x10

    ; Find highest set bit.
    lea si, [highest_bit_message]
    call print_string

    mov dl, 1
    call bit_scan
    call print_index

    ; Print new line.
    mov ah, 0x0E
    mov al, 0x0D    ; Carriage return.
    int 0x10

    mov al, 0x0A    ; Line feed.
    int 0x10

    ; Find lowest set bit.
    lea si, [lowest_bit_message]
    call print_string

    mov dl, 0
    call bit_scan
    call print_index

halt:
    cli
    hlt

; ----------------------------------------------
; Generic bit scan
; Input:
;   DL = mode (0 = lowest bit, 1 = highest bit)
; Output:
;   AL = index of found bit
; Note: Works well only on 16-bit numbers.
; ----------------------------------------------
bit_scan:
.scan_loop:
    mov ax, NUM
    mov cx, 16      ; Counter.

    cmp dl, 0
    je .scan_lowest

.scan_highest:
    shl ax, 1
    jc .found_highest
    loop .scan_highest
    jmp .done

.scan_lowest:
    shr ax, 1
    jc .found_lowest
    loop .scan_lowest
    jmp .done

.found_highest:
    dec cl
    mov al, cl        ; index = CL - 1
    jmp .done

.found_lowest:
    mov al, 16
    sub al, cl        ; index = 16 - CL
    jmp .done

.done:
    ret

; -----------------------------
; Print a number.
; Input; AL = Number to print.
; -----------------------------
print_index:
    xor ah, ah
    mov bx, 10          ; Divisor.
    mov cx, 0           ; Counter.

.convert_loop:
    xor dx, dx
    div bx

    add dx, '0'       ; Convert remainder to string.
    push dx
    inc cx

    test ax, ax
    jz .print_loop
    jmp .convert_loop

.print_loop:
    pop ax
    call print_char
    loop .print_loop

    ret

; -----------------------------------------
; Print a null terminated string.
; Input: SI = Index of the string to print.
; -----------------------------------------
print_string:
.loop:
    mov al, [si]    ; Load character.
    cmp al, 0       ; Check for null-terminator.
    jz .print_string_return

    call print_char
    inc si
    jmp .loop

.print_string_return:
    ret

; --------------------------------
; Print a single character.
; Input: AL = Character to print.
; --------------------------------
print_char:
    mov ah, 0x0E    ; BIOS function: Teletype output.
    mov bh, 0
    int 0x10
    ret

highest_bit_message db "Highest set bit: ", 0
lowest_bit_message  db "Lowest set bit: ", 0

times 510 - ($ - $$) db 0
dw 0xAA55
