# `0Eh`

> **Random Quote:** Discipline is the soul of an army. It makes small numbers formidable; procures success to the weak, and esteem to all.

## Key Topics

+ [Introduction](#introduction)
+ [Register Breakdown](#register-breakdown)
+ [Examples](#examples)

---

## Introduction

BIOS `INT 10h` function `0Eh`, also known as **Teletype Output**, is a BIOS **video service** used to display a single character on the screen in **text mode**, emulating the behavior of a typewriter (hence the name *Teletype*).

**Behavior:**

+ The given character is written to the screen at the current cursor position.
+ The cursor is automatically advanced to the next column.
+ If the end of a line is reached, the cursor moves to the beginning of the next line.
+ If the cursor is on the last row, the screen scrolls up by one line.
+ Special characters like `\n` and `\r` must be handled manually using their ASCII codes: `0x0A` (line feed) and `0x0D` (carriage return) respectively.

This service is used for basic on-screen text output without requiring custom display routines.

Because this function does not require setting up a video buffer or calculating screen positions, it is ideal for bootloaders and debugging during early development.

---

## Register Breakdown

| Register | Purpose                                                          |
| -------- | ---------------------------------------------------------------- |
| `AH`     | Must be `0x0E`                                                   |
| `AL`     | ASCII character to print                                         |
| `BH`     | Video page number (0 for most cases)                             |
| `BL`     | Text color (only in graphics modes; can be omitted in text mode) |

+ `AH`: This register is the **function selector**. It specifies which BIOS video service to execute. The required value is `0x0E` for teletype output.
+ `AL`: This register contains the **ASCII code** of the character to be displayed. The valid range is `0x00` to `0xFF`, though printable characters are typically in the range `0x20` to `0x7E`.
+ `BH`: This register specifies the **video page number** to write to. The typical value is `0` in most real-mode bootloader setups. The range is `0` to `7` (text mode supports up to 8 video pages). Modern BIOS implementations often ignore this in single-page contexts. Unless you're explicitly managing multiple text pages, set it to zero.
+ `BL`: This sets the **color attribute in graphics mode**. This is not used in text mode.

---

## Examples

### Displaying a Single Character

```asm
mov ah, 0x0E    ; Teletype function.
mov al, 'A'     ; Character to print.
mov bh, 0       ; Page number.
int 0x10        ; Call BIOS.
```

This prints the character `'A'` to the screen.

---

### Displaying a String

```asm
mov si, message     ; String to print.
mov ah, 0x0E        ; Teletype function.
mov bh, 0           ; Page number.

print_loop:
    lodsb           ; Load byte at [SI] into AL, increment SI.

    or al, al       ; Check if AL == 0 (end of string).
    jz done

    int 0x10        ; Call BIOS.
    jmp print_loop  ; Loop.

done:
    ; Continue execution...

message db "Hello World!", 0
```

+ `mov si, message` sets up the string to be printed.
+ `lodsb` loads the current character from `message` into `AL`.
+ `or al, al` checks for null-terminator (`0`) to stop.
+ `int 0x10` prints the character.

---

### Newline

To properly insert a new line, you must emit **carriage return (CR)** followed by **line feed (LF)**:

```asm
mov ah, 0x0E
mov al, 0x0D    ; Carriage return.
int 0x10

mov al, 0x0A    ; Line feed.
int 0x10
```

---
