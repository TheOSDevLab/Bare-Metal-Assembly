# `XCHG`

> **Random Quote:** Be yourself; everyone else is already taken.

## Key Topics

+ [Overview](#overview)

---

## Overview

The `XCHG` instruction, short for **exchange**, is used to **swap the values** of two operands. It performs a data exchange without the need for a temporary register or memory location.

This instruction is particularly useful in low-level programming scenarios where register preservation is important, or when implementing efficient in-place algorithms.

**Note:** This instruction does not affect any flags.

**Use Cases:**

+ Swapping registers during context switches or subroutine entry/exit.
+ Temporary data preservation without pushing to the stack.
+ Swapping values in sorting algorithms.
+ Compact register juggling in bootloaders.

### Syntax

```asm
xchg operand1, operand2
```

+ Both operands **must be the same size** (e.g., both 8-bit, 16-bit, or 32-bit).
+ One operand **must be a register**.
+ The other operand can be either a **register** or **memory** location.
+ You **cannot** use two memory operands.

---

### Examples

#### Register to Register

```asm
mov ax, 0x1234
mov bx, 0x5678
xchg ax, bx     ; AX = 0x5678, BX = 0x1234
```

#### Register and Memory

```asm
myvar dw 0xAAAA     ; Note that the value is 2 bytes.

mov ax, 0x5555      ; This is also 2 bytes.
xchg ax, [myvar]    ; AX = 0xAAAA, [myvar] = 0x5555
```

**Quick explanation:** `myvar` is an address in memory. It can be anything (like `0x2344`). The brackets mean, take the value at that memory address, which is `0xAAAA`. This code example swaps the contents of `AX` with the word stored at label `myvar`.

#### Invalid Example

```asm
xchg [var1], [var2]     ; Invalid because both operands are memory.
xchg al, bx             ; Invalid because of size mismatch.
```

#### Special Case: `XCHG` with `AX`

The instruction `xchg ax, reg16` uses a special, optimized encoding that is **1 byte shorter** than other forms. This makes it useful in space-constrained environments such as bootloaders.

```asm
xchg ax, dx     ; More compact encoding than 'xchg bx, dx'.
```

**Instruction Size:**

+ `xchg ax, reg16`: 1 byte.
+ `xchg reg, reg` : 2 bytes.
+ `xchg reg, mem` : 2-3 bytes.

---
