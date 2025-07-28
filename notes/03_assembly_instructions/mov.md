# `MOV`

> **Random Quote:** Success doesn't come from what you do occasionally, it comes from what you do consistently.

## Key Topics

- [Overview](#overview)
    - [How It Works](#how-it-works)
- [Syntax](#syntax)
    - [Instruction Size](#instruction-size)
- [Examples](#examples)
- [Practical Use Cases](#practical-use-cases)
- [Best Practices](#best-practices)
- [Common Pitfalls](#common-pitfalls)
- [Notes and Reference](#notes-and-reference)

---

## Overview

The `MOV` instruction copies data from a source operand to a destination operand. It is the most fundamental instruction in x86 assembly, used to transfer data between registers, memory, and immediate values.

`MOV` does not alter the source. It simply copies the value, leaving the original intact.

### How It Works

+ The CPU reads the value from the `source` and writes it into the `destination`.
+ No flags are affected by this instruction.

---

## Syntax

```asm
mov destination, source
````

* `destination`: A register or memory location that will receive the value.
* `source`: A register, memory location, or immediate value (constant).
+ Operands must be of the same size (e.g., 8-bit to 8-bit, 16-bit to 16-bit).
+ **Restriction**: Direct memory-to-memory transfers are not allowed.

```asm
mov [mem1], [mem2]  ; Invalid!
```

### Instruction Size

* 1-6 bytes depending on the operand types:

  * Register-to-register: typically 2 bytes.
  * Immediate-to-register: 3-5 bytes.
  * Memory operands: depends on the addressing mode.
* Does not support the `LOCK` prefix.

---

## Examples

```asm
; Register to register
mov ax, bx

; Immediate to register
mov cx, 0x1234

; Immediate to memory
mov [myvar], 42

; Register to memory
mov [myvar], ax

; Memory to register
mov ax, [myvar]
```

---

## Practical Use Cases

* Loading immediate values into registers before arithmetic operations.
* Storing results into memory after computations.
* Initializing buffers or video memory in bootloaders.
* Moving stack pointer addresses during function calls or setup.
* Setting segment registers (indirectly) during memory setup.

---

## Best Practices

* Use size specifiers (`byte`, `word`, `dword`) when the size is ambiguous.
* Be explicit with memory operands to avoid misinterpretation.
* For segment registers:

  * Load values into a general-purpose register first, then move into the segment register.
  * Only `AX`, `BX`, etc. are valid sources for segment registers.
* Use consistent size operands; mismatches can lead to assembler errors.

---

## Common Pitfalls

* **Memory-to-memory moves are invalid.** Always use a register as an intermediary.
* **Mismatched operand sizes.** For example, `mov eax, bx` is invalid (32-bit to 16-bit).
* **Improper use of segment registers.**

  * `MOV cs, ax` is invalid.
  * You cannot load a segment register directly from memory or another segment register.

* **Missing size specifiers.** When writing to memory with a literal, always clarify the size.

---

## Notes and Reference

* Instruction does **not** affect any flags.
* Reference: [Intel Developer Manual - MOV](https://www.felixcloutier.com/x86/mov)

---
