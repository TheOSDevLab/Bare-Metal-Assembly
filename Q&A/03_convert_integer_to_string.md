# How to Convert an Integer Into a String For Printing

> **Random Quote**: When you feel like quitting, think about why you started.

## Key Topics

+ [Introduction](#introduction)
+ [Single Digit Integers (`0-9`)](#single-digit-integers-0-9)
+ [Multi-Digit Integer](#multi-digit-integer)

---

## Introduction

In 16-bit x86 Assembly (real mode), BIOS interrupts like `INT 10h` only print characters. To display an integer on the screen, you must first convert the numeric value into its ASCII string representation. For example, the integer `123` must be converted to the string `"123"` before printing.

In this file, you will learn how to convert single digit integers and multi-digit integers to strings for display purposes.

---

## Single Digit Integers (`0-9`)

This is the easiest to do.

### Step-by-Step Explanation

**Note**: This only works on single decimal digits, i.e. `0-9`.

Let's say you want to print the result of `7 + 2`.

**1. Perform the Arithmetic**:

```assembly
mov ah, 7   ; AH = 7
mov al, 2   ; AL = 2
add al, ah  ; AL = 9
```

Now, `AL` holds the binary value `00001001` (which is 9 in decimal).

**2. Convert the Number to ASCII**:

The ASCII codes for the digits `'0'` through `'9'` are stored in memory as:

| Character | ASCII Code | Hex | Binary     |
| --------- | ---------- | --- | ---------- |
| `'0'`     | 48         | 30h | `00110000` |
| `'1'`     | 49         | 31h | `00110001` |
| `'2'`     | 50         | 32h | `00110010` |
| ...       | ...        | ... | ...        |
| `'9'`     | 57         | 39h | `00111001` |

Therefore, to convert the numeric value `9` to the character `'9'`, you **add the ASCII value of `'0'` (48) to it**.

```assembly
add al, '0'

; OR

add al, 48
```

Now `AL` contains `57`, which is the ASCII code for `'9'`.

This works because the digits `'0'` through `'9'` are laid out sequentially in the ASCII table. If a register holds the number `n` where `0 <= n <= 9`, then `n + '0'` yields the correct ASCII code for the digit character.

You are not converting the number itself, but preparing it to be interpreted as a printable character by BIOS.

**3. Print the Character**:

With the ASCII character now in `AL`, we can print it using BIOS.

```assembly
mov ah, 0x0E    ; Teletype output.
; AL = 57
mov bh, 0       ; Page number.
int 0x10        ; Call BIOS.
```

This outputs the character in `AL` (now `'9'`) to the screen.

---

## Multi-Digit Integer

To convert a multi-digit integer into a string, you need to push each digit onto the stack, and later pop the digits off in reverse order for printing.

### How It Works

1. Start with the integer value in a register (e.g. `AX`)
2. Use `DIV` to repeatedly divide the value by 10:
    - The remainder gives you the current digit (0-9).
    - The quotient is used in the next iteration.
3. Add `'0'`/`48`/`0x30` to the remainder to convert it to ASCII.
4. Push each digit onto the stack as it's created.
5. When the value reaches 0, pop each digit from the stack and print using BIOS `INT 10h`.

### Example Code

```assembly
org 0x7C00
bits 16

mov ax, 12345   ; Number to print.
mov cx, 0       ; Loop counter.

; Handle AX = 0.
cmp ax, 0
jne extract_digits

add al, '0'
call print_character
jmp done


extract_digits:
    ; Divide by 10.
    xor dx, dx      ; Clear DX.
    mov bx, 10      ; Divisor.
    div bx          ; AX = quotient, DX = remainder.

    ; Convert to string.
    add dl, '0'
    push dx         ; Push string to the stack.
    inc cx          ; Increment loop counter.

    ; Check if quotient is 0.
    cmp ax, 0
    je print_number
    jmp extract_digits

print_number:
    pop ax                  ; Pop the next character.
    call print_character    ; Print the number's character.
    loop print_number       ; Loop until CX = 0.

done:
    jmp $

print_character:
    mov ah, 0x0E    ; BIOS function: Teletype output.
    ; AL contain the character to print.
    mov bh, 0       ; Page number.
    int 0x10        ; Call BIOS.
    ret             ; Return to caller.

times 510 - ($ - $$) db 0
dw 0xAA55
```

### This Example Uses Recursion

```assembly
org 0x7C00
bits 16

start:
    ; Set video mode and clear screen.
    mov ah, 0x00        ; BIOS function: Set video mode.
    mov al, 0x03        ; Mode: 80x25 color text mode.
    int 0x10            ; Call BIOS.

    mov ax, 1234        ; Number to print.
    call print_decimal  ; Converts AX to string and prints

hang:
    jmp $

; print_decimal: displays AX via BIOS INT 10h
print_decimal:
    push ax
    push dx

    mov bx, 10
    xor dx, dx
    div bx              ; AX=quotient, DX=remainder

    cmp ax, 0
    je .print_units

    ; Recursively print higher digits
    push ax
    call print_decimal
    pop ax

.print_units:
    add dl, '0'
    mov ah, 0x0E
    mov al, dl
    mov bh, 0
    int 0x10

    pop dx
    pop ax
    ret

times 510-($-$$) db 0
dw 0xAA55

```

### Advantages

+ No need to manage a separate buffer.
+ Prints the digits in correct order without extra memory.
+ Scales at any integer size that fits in a register.

### Drawbacks

+ Depends on stack space; not ideal in environments with limited stack capacity.
+ Cannot directly access digits later (they're discarded after printing).

> There is another method for converting integers to strings that uses a memory buffer instead of the stack. I chose not to document it here as I was uncertain whether it adds enough value in the context of simple bootloader development. If you believe it's worth including, I'd appreciate your thoughts; feel free to suggest it.

---
