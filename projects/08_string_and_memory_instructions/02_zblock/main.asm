org 0x7C00
bits 16

start:
    mov ax, 0x0003
    int 0x10

    ; Print the original string.
    lea si, [string]
    call print_string

    ; Fill memory block with 'z's.
    call get_string_len
    mov cx, [string_len]    ; Counter.
    mov al, "z"             ; Character to write to memory.
    lea di, [zblock]        ; Destination.
    rep stosb

    call print_zblock

    ; Move data from `string` to `zblock`.
    mov cx, [string_len]
    lea si, [string]
    lea di, [zblock]
    rep movsb

    call print_zblock

halt:
    cli
    hlt

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
    call print_new_line
    pop si          ; Restore SI.
    ret

; ----------------------------
; Print a new line character.
; ----------------------------
print_new_line:
    mov ah, 0x0E
    mov al, 0x0D    ; Carriage return.
    int 0x10

    mov al, 0x0A    ; Line feed.
    int 0x10
    ret

; ----------------------------
; Print the data in `zblock`.
; ----------------------------
print_zblock:
    lea si, [zblock]
    call print_string
    ret

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

string     db "This string can be anything! 123455lkjdfa", 0
string_len db 0
zblock     db 0

times 510 - ($ - $$) db 0
dw 0xAA55
