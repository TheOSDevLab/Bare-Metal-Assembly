org 0x7C00
bits 16

start:
    ; Set video mode.
    mov ah, 0x00    ; BIOS Function: Set video mode.
    mov al, 0x03    ; Mode: 80x25 color text mode.
    int 0x10        ; Call BIOS.

    ; Initialize BL, CL and DL with values.
    mov bl, 'b'     ; BL = 'b'
    mov cl, 'c'     ; CL = 'c'
    mov dl, 'd'     ; DL = 'd'

first_print:    ; Print the initial registers' values.
    ; BL
    mov ah, 0x0E    ; BIOS Function: Teletype output.
    mov al, bl      ; Print the value in BL.
    mov bh, 0       ; Page number.
    int 0x10        ; Call BIOS.
    
    ; CL
    mov al, cl      ; Print the value in CL.
    int 0x10        ; Call BIOS.

    ; DL
    mov al, dl      ; Print the value in DL.
    int 0x10        ; Call BIOS.

shuffle:   ; Shuffle the values of the registers.
    xchg bl, cl     ; BL -> CL. CL = 'b', BL = 'c'.
    xchg dl, bl     ; DL -> BL. DL = 'c', BL = 'd'.

second_print:   ; Print the shuffled values.
    mov bh, 0   ; Reintialize page number.

    ; Print a space.
    mov al, ' '
    int 0x10

    ; BL
    mov al, bl
    int 0x10

    ; CL
    mov al, cl
    int 0x10

    ; DL
    mov al, dl
    int 0x10

halt:
    hlt     ; Halt.
    jmp $   ; Infinite loop fallback.

times 510 - ($ - $$) db 0
dw 0xAA55
