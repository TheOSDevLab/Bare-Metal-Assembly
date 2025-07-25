# `LEA`

> **Random Quote:** Be the change that you wish to see in the world.

## Key Topics

+ [Overview](#overview)
    - [Syntax](#syntax)
    - [Examples](#examples)

---

## Overview

`LEA`, short for **Load Effective Address**, is a special-purpose instruction used to load the address (not the contents) of a memory operand into a register. Unlike `MOV`, which loads data from memory, `LEA` loads the address of the memory operand.

This instruction is particularly useful for:

+ Getting the address of a variable.
+ Loading offsets for string printing routines.
+ Efficient pointer arithmetic.
+ Address calculations (e.g., array elements).
+ Efficiently computing values without affecting flags.

---

### Syntax

```asm
lea destination, source
```

+ `destination` **must be a register**.
+ `source` **must be a memory operand** (i.e., an expression in square brackets).

**Note:** `LEA` can only operate on memory expressions written in square brackets. It does not support bare constants or immediate values without brackets.

```asm
lea ax, 0x1234      ; Invalid because there are no brackets.
lea ax, [0x1234]    ; Valid because it's a memory address expression.
```

---

### Examples

#### Load the Address of a Variable

```asm
myvar dw 0x1234

lea si, [myvar]     ; SI contains the offset (address) of `myvar`, not the value stored at that address (0x1234).
```

#### Pointer Arithmetic

```asm
lea bx, [di + 4]        ; BX = DI + 4
lea ax, [bx + si + 2]   ; AX = BX + SI + 2
```

This is one of the key advantages of `LEA`: you can use it to **add or scale registers** without using `ADD`, `MUL`, or `SHL`.

#### Computing Scaled Addresses

```asm
lea eax, [ebx + ecx*4 + 8]
```

This avoids using slower multiplication or addition instructions. This is common in 32-bit and 64-bit mode. In 16-bit real mode, `LEA` is limited to valid memory addressing modes such as `[bx + si]` or `[bp + 6]`.

---
