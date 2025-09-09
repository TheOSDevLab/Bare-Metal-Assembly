org 0x7C00
bits 16

start:
    ; Set video mode and clear the screen.
    mov ax, 0x0003
    int 0x10
    
    ; Print the string correctly.
    lea si, [message]
    cld
    call print_message

    ; Print new line.
    mov ah, 0x0E
    mov al, 0x0D    ; Carriage return.
    int 0x10

    mov al, 0x0A    ; Line feed.
    int 0x10

    ; Print the string in reverse.
    call get_string_len

    add si, [string_len]    ; SI = Index of the null-terminator.
    dec si                  ; SI = Index of the last character in `message`.
    std
    call print_message

halt:
    cli
    hlt

; ---------------------------------
; Print a null-terminated string.
; Input: SI = Index of the string.
; ---------------------------------
print_message:
    push si         ; Preserve SI.
    mov ah, 0x0E    ; BIOS function: Teletype output.
    mov bh, 0

.print_message_loop:
    lodsb
    cmp al, 0
    jz .print_message_return

    int 0x10
    jmp .print_message_loop

.print_message_return:
    pop si          ; Restore SI.
    ret

; -------------------------------
; Calculate the length of string.
; Input: SI = String.
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

reverse_null_terminator db 0    ; Null terminator for the `message` string in reverse.
message                 db "You can change this to anything you want.", 0
string_len              db 0    ; Reserve space for the string length.

times 510 - ($ - $$) db 0
dw 0xAA55
