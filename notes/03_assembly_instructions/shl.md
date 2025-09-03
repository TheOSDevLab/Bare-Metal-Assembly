# `SHL`

> **Random Quote**: Through discipline comes freedom.

## Key Topics

- [Overview](#overview)
    - [How It Works](#how-it-works)
- [Syntax](#syntax)
    - [Instruction Size](#instruction-size)
- [Examples](#examples)
- [Practical Use Cases](#practical-use-cases)
- [Best Practices](#best-practices)
- [Common Pitfalls](#common-pitfalls)

---

## Overview

`SHL` (Shift Logical Left) shifts the bits of an operand to the left by a specified count, inserting zeros into the vacated least significant bits. Its purpose is to support **bit manipulation, arithmetic by powers of two, and efficient flag setting**. It affects multiple status flags, making it a key instruction in both arithmetic and logic. 

### How It Works

- Each shift moves all bits to the left; the most significant bit (MSB) is moved into the **Carry Flag (CF)**.  
- The least significant bit (LSB) is always filled with zero.  
- Operand can be a register or memory location.  
- The **Overflow Flag (OF)** is updated only for single-bit shifts: it is set if the MSB changes as a result of the shift.  
- The Zero Flag (ZF), Sign Flag (SF), and Parity Flag (PF) are updated based on the final result. 

---

## Syntax

```asm
SHL destination, count
```

* `destination`: register or memory operand.
* `count`: number of bit positions to shift. Can be:

  * An immediate value.
  * The contents of `CL`.
* **restrictions**:

  * No immediate memory-to-memory operations.
  * In 64-bit mode, count is masked to 6 bits (0-63).

### Instruction Size

* Typical size: **2-3 bytes** (depending on addressing mode).
* Encoded under the **Group 2 shift/rotate instructions** (`D0`, `D1`, `D2`, `D3` opcodes).
* No `LOCK` prefix support.

---

## Examples

```asm
; --- Simple left shift ---
mov al, 0b00001111
shl al, 1            ; al = 00011110, CF = 0

; --- Multi-bit shift ---
mov ax, 3
shl ax, 4            ; ax = 48 (3 * 16)

; --- Shift with CL ---
mov cl, 2
mov bx, 0b10110000
shl bx, cl           ; bx = 0b11000000

; --- Flag demonstration ---
mov al, 0x81         ; 10000001b
shl al, 1            ; Result = 00000010b, CF = 1, OF = 1
```

---

## Practical Use Cases

* **Efficient multiplication**: multiply by powers of two (`x << n = x * 2^n`).
* **Bit masking**: move bits into desired positions before applying `AND` or `OR`.
* **Flag extraction**: use the Carry Flag to serialize bits.
* **Optimized loops**: bit shifts are often faster than full multiplications.

---

## Best Practices

* Use `SHL` instead of `MUL` when multiplying by powers of two; it is more efficient.
* Be aware of **flag side effects** when chaining shifts in conditional code.
* For portability, explicitly mask the count if working across architectures (e.g., in 64-bit mode).
* When only one-bit shifts are required, prefer `SHL` over arithmetic to simplify logic.

---

## Common Pitfalls

* **Confusing `SHL` with `SAL`**: they are identical in operation; the difference is naming convention (logical vs arithmetic).
* **Losing bits**: shifted-out bits are lost except for the MSB in CF.
* **Unexpected flag states**: OF is undefined for multi-bit shifts and must not be relied on.
* **Shift count restrictions**: in 32-bit mode, only the lower 5 bits of count are used (0-31); in 64-bit mode, the lower 6 bits (0-63).

---
