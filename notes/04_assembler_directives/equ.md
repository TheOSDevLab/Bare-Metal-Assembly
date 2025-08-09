# `EQU`

> **Random Quote:** If you tell the truth, you don't have to remember anything.

## Key Topics

+ [Overview](#overview)
    - [Syntax](#syntax)
    - [Examples](#examples)
+ [Notes and References](#notes_and_references)
---

## Overview

The `EQU` directive in Assembly stands for **equate**. It is used to define **named constants**, allowing you to assign a fixed value to a symbol. Once defined, that symbol can be used throughout the code in place of the literal value it represents.

This improves code readability, maintainability, and portability, especially in low-level development contexts such as bootloaders and operating system kernels, where magic numbers and hardware-specific values are common.

**Characteristics:**

+ `EQU` creates a constant symbol, not a variable or label.
+ It does not allocate memory or produce output in the final binary.
+ The value must be a constant expression, known at assembly time.
+ Once defined, the symbol cannot be redefined later in the same file.

**Best Practices:**

+ Use all-uppercase for constants to distinguish from labels or variables.
+ Group related constants to improve organization and readability.
+ Use descriptive names to clarify the purpose of each constant.

---

### Syntax

```asm
symbol equ value
```

+ `symbol`: The name you wish to assign to the constant.
+ `value`: A constant expression (numeric or character literal). It can be written in decimal, hexadecimal, binary, or character format.

---

### Examples

#### Simple Constants

```asm
SECTOR_SIZE equ 512
SCREEN_WIDTH equ 80

; You can now use `SECTOR_SIZE` and `SCREEN_WIDTH` in place of hard-coded values.
mov cx, SECTOR_SIZE
mov dl, SCREEN_WIDTH
```

#### Character Constants

```asm
NEWLINE_CHAR equ 10     ; ASCII newline character (`\n`).

mov al, NEWLINE_CHAR
```

#### Address Offsets

```asm
BUFFER_BASE equ 0x7E00

mov si, BUFFER_BASE
```

This is especially useful when working with memory-mapped I/O or stack addresses in real-mode Assembly.

#### Invalid Examples

```asm
COUNT equ bx        ; Invalid because BX is not a constant.
value equ [somevar] ; Invalid because you cannot equate to a memory reference.
```

---

## Notes and References

+ Refer to [this document](../../Q&A/05_equ_vs_%25define.md) for a detailed explanation of the difference between `EQU` and `%define`.
