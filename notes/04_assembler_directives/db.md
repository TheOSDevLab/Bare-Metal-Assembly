# `DB,DW,DD,DQ`

> **Random Quote:** Discipline is the bridge between goals and accomplishment.

## Key Topics

+ [Overview](#overview)
    - [Syntax](#syntax)
+ [Size Differences](#size-differences)
    - [Define Byte (`DB`)](#define-byte-db)
    - [Define Word (`DW`)](#define-word-dw)
    - [Define Double (`DD`)](#define-double-dd)
    - [Define Quad (`DQ`)](#define-quad-dq)
    - [Define Ten (`DT`)](#define-ten-dt)
+ [Using With Labels](#using-with-labels)
+ [Using With `dup`](#using-with-dup)
+ [Practical Examples](#practical-examples)

---

## Overview

`DB` is short for **Define Byte**. This directive, along with its variants, allow you to embed bytes, words, and other sized values directly into your program's binary output.

These directives are used to:

+ Store static data such as characters, strings, numbers, or binary sequences.
+ Define data structures, buffers, or constants.
+ Embed machine instructions, if necessary.
+ Lay out precise memory layouts for low-level hardware interfacing.

Like all assembler directives, these do not generate executable instructions, but rather allocate specific values into the output binary.

### Syntax

```asm
mnemonic value [, value, ...]
```

+ `mnemonic`: The assembler directive (e.g., `db`, `dw`, ...).
+ `value`: The data. You can use decimal, hexadecimal, binary, or character literals. The size of the value depends on the `mnemonic` (more on this later).
+ `[, value, ...]`: This means that you can have multiple values separated by a comma.

---

## Size Differences

### Define Byte (`DB`)

This directive is used to emit one or more individual bytes (8-bits). That is `0-255` or a character.

**Example:**

```asm
db 0x41         ; One byte in hexadecimal.
db 'H', 'i'     ; Multiple one-byte characters.
db 10, 20, 30   ; Multiple one-byte decimals.
```

This directive allows strings. Strings are interpreted as a **sequence of characters**, with each character treated as a separate byte. This makes it easier and faster to type strings.

**Example:**

```asm
; These two lines do the same thing.
db "Hello", 0
db 'H', 'e', 'l', 'l', 'o', 0
```

**Note:** This won't work with the other multi-byte directives defined below.


### Define Word (`DW`)

A word is **2 bytes (16-bits)**. Each value must fit within 16 bits (i.e., `0-65535`). If a value is longer than 2 characters, only the first two are used.

**Note:** These bytes are stored in **little-endian** order on x86 CPUs (low byte first, high byte second). This applies to all the other multi-byte directives below. If needed, read about endianness [here](https://github.com/brogrammer232/Crafting-an-OS-Notes-and-Insights/blob/main/notes/01_computer_architecture/14_endianness.md).

**Example:**

```asm
dw 0x1234   ; Stored as 0x34 0x12.
dw 'AB'     ; Stored as `'B'` followed by `'A'`.
```

### Define Double (`DD`)

A **double word** is **4 bytes (32-bits)**. Each value must fit within 32 bits. This is often used for defining 32-bit pointers, addresses, or constants.

**Example:**

```asm
dd 0x12345678   ; Stored as 0x78 0x56 0x34 0x12.
```

### Define Quad (`DQ`)

A **quad word** is **8 bytes (64-bits)**. Each value must fit within 64-bits. It is used for defining 64 bit constants or addresses.

**Example:**

```asm
dq 0x1122334455667788 ; Stored as '88 77 66 55 44 33 22 11'.
```

### Define Ten (`DT`)

Each value must fit within **10 bytes (80-bits)**. This directive is rarely used. It's used for defining **80-bit floating point values** (used with `fldt`, `fstpt`, etc. in x87 FPU operations).

---

## Using With Labels

You can label any data definition for reference in code:

**Syntax:**

```asm
label: mnemonic value [, value, ...]
```

**Example:**

```asm
message: db "Hello World!", 0
```

This allows you to load the address of `message` into a register for printing or processing.

---

## Using With `dup`

`dup` stands for **duplicate**. NASM allows you to use `dup` to define repeated values. This is extremely useful when you need to fill memory with repeating patterns, such as zeros, constants, or placeholders.

**Syntax:**

```asm
count dup(value)
```

+ `count`: How many times the value should be repeated.
+ `value`: What to repeat (can be a byte, word, string, or expression, depending on context).

**Examples: Using the discussed directives.**

```asm
db 5 dup(0)         ; Expands to: `db 0, 0, 0, 0, 0`.
db 2 dup("AB")      ; Expands to: `db "AB", "AB"`.
dw 3 dup(0x1234)    ; Expands to: `dw 0x1234, 0x1234, 0x1234`.
```

### Nesting `dup`

```asm
db 2 dup(3 dup(1))  ; Expands to: `db 1, 1, 1, 1, 1, 1`.
```

+ Inner `3 dup(1)` >> `1, 1, 1`.
+ Outer `2 dup(1, 1, 1)` >> `1, 1, 1,  1, 1, 1`.

---

## Practical Examples

In a bootloader, these directives are commonly used to:

+ Define messages for BIOS text output:

    ```asm
    msg: db "Booting...", 0
    ```

+ Fill the sector up to 510 bytes:

    ```asm
    times 510 - ($ - $$) db 0
    ```

+ Insert the boot signature:

    ```asm
    dw 0xAA55
    ```

---
