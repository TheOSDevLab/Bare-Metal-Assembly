# `SAR`

> **Random Quote**: It's not about being the best. It's about being better than you were yesterday.

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

The `SAR` instruction performs an **arithmetic right shift** on its operand, preserving the sign bit (most significant bit) while shifting bits to the right. It exists to facilitate efficient signed division by powers of two, where logical right shifts (`SHR`) would disrupt the sign. Key behavior points include sign preservation and flag updates that reflect arithmetic semantics.  

### How It Works

- The operand (register or memory) is shifted right by the specified count.
- The **sign bit is replicated into the vacated MSBs** to maintain the original signed value.
- The **least significant bit (LSB)** that’s shifted out is stored in the **Carry Flag (CF)**.
- Flags updated:
  - **ZF** (Zero Flag): set if the result is zero.
  - **SF** (Sign Flag): reflects the new most significant bit.
  - **PF** (Parity Flag): based on the least significant byte's parity.
  - **OF** (Overflow Flag): cleared (to 0) for single-bit shifts; undefined for multi-bit shifts.
  - **CF**: holds the last bit shifted out.  

---

## Syntax

```asm
SAR destination, count
```

* `destination`: register or memory operand.
* `count`: can be:

  * An **immediate value**, or
  * The **`CL`** register.
* **Restrictions**:

  * No memory-to-memory direct operations.
  * In 32-bit mode, count is masked to 5 bits (0-31); in 64-bit mode, masked to 6 bits (0-63).

### Instruction Size

* **Encoding**: Falls under the x86 shift/rotate group (opcodes `D0`, `D1`, `D2`, `D3`).
* **Typical size**: 2-3 bytes depending on addressing mode and immediate size.
* **LOCK prefix**: Not applicable for shift operations.

---

## Examples

```nasm
; -- Arithmetic shift right preserves sign --
mov al, 0b10000000   ; -128 in two’s complement
sar al, 1            ; al = 11000000b (-64), SF=1, CF=0

; -- Multi-bit shift with sign preservation --
mov ax, -16          ; ax = 0xFFF0
sar ax, 2            ; ax = 0xFFFF (-4)

; -- Flag use: extract dropped bit --
mov bl, 3            ; 00000011b
sar bl, 1            ; bl = 00000001b, CF=1 (the LSB was shifted out)
```

---

## Practical Use Cases

* **Signed division by powers of two**, especially when negative values must remain negative.
* **Arithmetic scaling** for fixed-point or efficient integer calculations.
* **Sign-preserving bitfield manipulations**, such as logical shifts for signed data processing.
* **Flag-based logic flows** when the carry-out bit provides useful data for decisions.

---

## Best Practices

* Use `SAR` for signed integer operations; use `SHR` for unsigned logic.
* Avoid relying on **OF** for multi-bit shifts; it's only reliably defined for single-bit operations.
* Recognize that `SAR` rounds toward negative infinity, which differs from `IDIV` rounding toward zero.

---

## Common Pitfalls

* **Mixing signed vs. unsigned semantics**: `SAR` is correct for signed values but incorrect for unsigned bit extraction.
* **Count overflow**: Only the low 5 (or 6 in 64-bit) bits of the count are used for shifting.
* **Misinterpretation of rounding**: `SAR` produces different results than integer division (`IDIV`) when negative values are involved.

---
