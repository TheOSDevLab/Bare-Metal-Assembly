org 0x7C00
bits 16

start:
    ; Set video mode and clear the screen.
    mov ax, 0x0003
    int 0x10

    lea si, [first_string]
    call get_string_len
    
    lea di, [second_string]
    mov cx, [string_len]
    repe cmpsb

    cmp cx, 0
    jz equal
    jmp not_equal

equal:
    lea si, [equal_message]
    call print_string
    jmp halt

not_equal:
    lea si, [not_equal_message]
    call print_string
    jmp halt

halt:
    cli
    hlt

; -------------------------------
; Calculate the length of a string.
; Input: SI = String.
; Preserves SI.
; -------------------------------
get_string_len:
    push si     ; Preserve SI.
    xor cx, cx

.get_string_len_loop:
    lodsb
    cmp al, 0
    jz .get_string_len_return

    inc cx
    jmp .get_string_len_loop

.get_string_len_return:
    mov [string_len], cx
    pop si      ; Restore SI.
    ret

; ---------------------------------
; Print a null-terminated string.
; Input: SI = Index of the string.
; Preserves SI.
; ---------------------------------
print_string:
    push si         ; Preserve SI.
    mov ah, 0x0E    ; BIOS function: Teletype output.
    mov bh, 0

.print_string_loop:
    lodsb
    cmp al, 0
    jz .print_string_return

    int 0x10
    jmp .print_string_loop

.print_string_return:
    pop si          ; Restore SI.
    ret

; Make sure that the strings are of equal length.
first_string  db "Sample string.", 0
second_string db "Simple string.", 0

equal_message     db "Match", 0
not_equal_message db "Mismatch", 0

string_len db 0

times 510 - ($ - $$) db 0
dw 0xAA55
