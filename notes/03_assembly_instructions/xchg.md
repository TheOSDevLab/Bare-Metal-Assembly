# `XCHG`

> **Random Quote:** Be yourself; everyone else is already taken.

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

The `XCHG` instruction swaps the values of two operands. It performs an in-place exchange of data between a register and another register or a memory location, without using a temporary register.

It is a compact and efficient instruction especially useful in low-level routines, register juggling, or implementing swap logic in-place.

### How It Works

+ The CPU reads the values from both operands.
+ It then exchanges (swaps) their contents.
+ One operand must be a register. The other can be a register or a memory location.
+ The operands must be of equal size (8, 16, 32, or 64-bit).
+ No CPU flags are affected by this operation.

---

## Syntax

```asm
xchg destination, source
````

* `destination`: A register.
* `source`: A register or a memory location.
* **Restrictions**:

  * Both operands must be the same size.
  * You cannot use two memory operands.

```asm
xchg [mem1], [mem2]  ; Invalid!
xchg al, bx          ; Invalid size combination!
```

### Instruction Size

* `xchg ax, reg16`: 1 byte (special encoding).
* `xchg reg, reg`: 2 bytes.
* `xchg reg, mem`: 2–3 bytes (depends on addressing mode).

---

## Examples

```asm
; Register to register
mov ax, 0x1234
mov bx, 0x5678
xchg ax, bx      ; AX = 0x5678, BX = 0x1234

; Register and memory
myvar dw 0xAAAA
mov ax, 0x5555
xchg ax, [myvar] ; AX = 0xAAAA, [myvar] = 0x5555

; Special encoding with AX
xchg ax, dx      ; 1-byte encoding
```

---

## Practical Use Cases

* Swapping variables in sorting algorithms.
* Efficient register preservation before subroutine calls or I/O routines.
* Quick value swaps without allocating extra memory or registers.
* Register juggling in bootloader logic to conserve space and avoid stack usage.

---

## Best Practices

* Use `XCHG` with `AX` when possible to take advantage of shorter encoding in size-constrained environments.
* Prefer `XCHG` over manual swap logic when only two values need to be exchanged.
* Be explicit with memory size specifiers (e.g., `byte`, `word`) to avoid ambiguity.
* Avoid using `XCHG` in critical sections of multiprocessor systems without proper locking (see `LOCK` prefix if needed).

---

## Common Pitfalls

* Using two memory operands: not allowed.
* Mismatched operand sizes: causes assembler errors.
* Assuming flags are modified: `XCHG` does not affect any CPU flags.
* Forgetting that one operand **must** be a register.

---

## Notes and Reference

* In 16-bit mode, `xchg ax, reg` has a one-byte encoding (opcode `90h` + register code).
* `XCHG` with `AX` is functionally identical to a `NOP` if the same register is used (e.g., `xchg ax, ax`).
* Reference: [XCHG - Felix Cloutier](https://www.felixcloutier.com/x86/xchg)

---
