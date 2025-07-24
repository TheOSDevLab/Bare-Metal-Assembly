# `SUB`

> **Random Quote**: Knowledge is of no value unless you put it into practice.

## Sections

+ [Overview](#overview)
    - [How It Works](#how-it-works)
+ [Syntax](#syntax)
    - [Instruction Size](#instruction-size)
+ [Examples](#examples)
+ [Practical Use Cases](#practical-use-cases)
+ [Best Practices](#best-practices)
+ [Common Pitfalls](#common-pitfalls)
+ [Notes and References](#notes-and-references)

---

## Overview

The `SUB` instruction performs **integer subtraction**. It subtracts the source operand from the destination operand and stores the result in the destination operand.

### How It Works

+ The CPU reads both operands.
+ It performs `destination := destination - source`.
+ The result replaces the value in the destination operand.
+ Operands can be 8-bit, 16-bit, 32-bit, or 64-bit depending on mode.
+ All relevant status flags in the FLAGS register are updated:

    - **CF (Carry Flag)**: Set if a borrow was needed.
    - **OF (Overflow Flag)**: Set if signed overflow occurred.
    - **ZF (Zero Flag)**: Set if the result is zero.
    - **SF (Sign Flag)**: Reflects the sign bit of the result.
    - **AF (Auxiliary Flag)**: Set if there was a borrow from the lower nibble.
    - **PF (Parity Flag)**: Set if the low byte of the result has even parity.

---

## Syntax

```assembly
sub destination, source
```

+ `destination`: Register or memory operand that will be updated.
+ `source`: Register, memory operand, or immediate value to subtract.
+ **Restrictions**: Both operands cannot be memory. One must be a register or an immediate.

```assembly
sub [mem1], [mem2]  ; Invalid: Both operands cannot be memory.
```

### Instruction Size

+ Typical size ranges from **1 to 6 bytes**, depending on the operands and addressing mode.
+ Immediate values may use shorter encodings if they fit in a smaller size.
+ Lock prefixes (`LOCK SUB`) are allowed for atomic memory operations on multiprocessor systems.

---

## Examples

```asm
; Register to Register
sub ax, bx        ; AX = AX - BX

; Immediate to Register
sub eax, 10       ; EAX = EAX - 10

; Memory to Register
sub dx, [value]   ; DX = DX - WORD at [value]

; Register to Memory
sub [count], cl   ; BYTE at count = BYTE at count - CL
```

---

## Practical Use Cases

+ Decrementing counters in loops or timers.
+ Adjusting stack pointers, indexes, or offsets.
+ Subtracting memory sizes, buffer lengths, or sector counts in bootloaders.
+ Performing arithmetic on low-level hardware values in real mode.

---

## Best Practices

+ Use `SUB reg, reg` or `SUB reg, imm` for speed; memory access is slower.
+ Prefer `CMP` when you only need to set flags for comparisons without modifying operands.
+ Combine `SUB` with `SBB` for multi-word or multi-precision subtraction.
+ Keep operand sizes consistent to avoid sign-extension issues.

---

## Common Pitfalls

+ **Memory-to-memory is invalid**: Always involve a register or immediate.
+ **Flag side effects**: Remember `SUB` changes many status flags, which may affect subsequent conditional jumps.
+ **Immediate size mismatches**: Ensure your immediate values fit the operand size to avoid assembler warnings or unexpected results.
+ **Using SUB instead of CMP**: If you just need to compare without changing the operand, use `CMP`.

---

## Notes and References

+ [c9x.me x86 reference](https://c9x.me/x86/html/file_module_x86_id_308.html)
+ Related instructions: [`CMP`](./cmp.md), [`ADD`](./add.md)

---
