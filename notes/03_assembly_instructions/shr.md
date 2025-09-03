# `SHR`

> **Random Quote**: Consistency is harder when no one is clapping for you. You must clap for yourself.

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

`SHR` (Shift Logical Right) shifts the bits of a register or memory operand to the **right** by a specified count. The vacated most significant bits (MSBs) are filled with **zeros**, making it a logical (not arithmetic) shift. This instruction is commonly used for **unsigned division by powers of two** and for bit manipulation. 

### How It Works

- Each shift moves all bits right by one position.  
- The **least significant bit (LSB)** shifted out goes into the **Carry Flag (CF)**.  
- The MSB is filled with zero, regardless of the sign.  
- Flags affected:
  + **CF**: set to the last bit shifted out.  
  + **ZF, SF, PF**: updated based on the result.  
  + **OF**: defined only for a 1-bit shift; set if the original MSB differs from the new MSB.  

---

## Syntax

```asm
SHR destination, count
```

* `destination`: register or memory operand.
* `count`:

  * Immediate value.
  * The contents of `CL`.
* **restrictions**:

  * Cannot shift directly from memory to memory.
  * Count is masked (5 bits in 32-bit mode, 6 bits in 64-bit mode).

### Instruction Size

* Typical size: **2-3 bytes**, depending on addressing mode.
* Encoded in the **Group 2 shift/rotate instruction set** (`D0`, `D1`, `D2`, `D3` opcodes).
* No `LOCK` prefix is supported.

---

## Examples

```asm
; --- Simple right shift ---
mov al, 0b11110000
shr al, 1            ; al = 01111000, CF = 0

; --- Multi-bit shift ---
mov bx, 64
shr bx, 3            ; bx = 8  (64 / 8)

; --- Shift with CL ---
mov ecx, 2
mov eax, 0b10010000
shr eax, cl          ; eax = 0b00100100

; --- Flag demo ---
mov al, 1
shr al, 1            ; al = 0, CF = 1, ZF = 1
```

---

## Practical Use Cases

* **Unsigned division by powers of two** (`x >> n = x / 2^n`).
* **Extracting individual bits** by observing CF after shifts.
* **Bitfield processing** (e.g., parsing protocol headers).
* **Normalizing values** in fixed-point arithmetic.

---

## Best Practices

* Use `SHR` for **unsigned values**. For signed division, use `SAR`.
* Be careful with **multi-bit shifts**: OF is undefined, so avoid relying on it.
* Prefer `SHR` for efficient division when divisors are powers of two.
* Use shifts instead of masking when bits need to be "peeled off" serially.

---

## Common Pitfalls

* **Mixing with signed values**: `SHR` always inserts zeros in MSBs; use `SAR` for sign-preserving shifts.
* **Forgetting the masked count**: only the low 5 (or 6 in 64-bit) bits of the count matter.
* **Lost precision**: once bits are shifted out, they are gone except for the last one in CF.
* **OF misuse**: programmers sometimes expect OF to work for multi-bit shifts; it is **only defined for single-bit shifts**.

---
