# `AND`

> **Random Quote**: Do not wait till the iron is hot to strike, make it hot by striking.

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

The `AND` instruction performs a **bitwise logical AND** operation between two operands and stores the result in the destination operand. It exists to enable logic operations, masking, and bit-level data manipulation. Crucially, it alters the flags register to support subsequent conditional or logical instructions.

### How It Works

- The CPU computes the result: `destination = destination & source`.
- Operands may be registers, memory, or immediate values (with restrictions).
- Flags are affected as follows:
  - **CF** (Carry Flag): cleared to `0`.  
  - **OF** (Overflow Flag): cleared to `0`.  
  - **ZF** (Zero Flag): set if the result is zero; otherwise cleared.  
  - **SF** (Sign Flag): reflects the most significant bit of the result.  
  - **PF** (Parity Flag): set if the least significant byte has even parity; otherwise cleared.  
  - **AF** (Auxiliary Flag): undefined.  

---

## Syntax

```asm
AND destination, source
```

* `destination`: Register or memory operand.
* `source`: Can be register, memory, or immediate constant.
* Not permitted: two memory operands (both cannot be memory).

### Instruction Size

* Variant sizes depend on operand size and type:

  * Immediate to register/memory: variable length (e.g., 8/16/32/64-bit).
  * Register/memory to register: compact encoding, often 2 bytes.
* No `LOCK` prefix is applicable.

---

## Examples

```asm
; Simple register AND
mov eax, 0xF0F0
and eax, 0x0F0F       ; eax = 0x0000 → affects flags (ZF=1)

; Immediate operand with register
and al, 0x0F          ; keep only lower nibble of AL

; Memory operand
and byte [var], 1     ; mask var to its least-significant bit
```

---

## Practical Use Cases

* **Bit masking**; e.g., isolating specific bits (`and al, 0x0F` retains only the low nibble).
* **Flag setting**; often used in combination with conditional jumps (`jz`, `jnz`, `js`, etc.).
* **Logical checks in OS and real-mode code**; testing hardware status flags or alignment bits without affecting data.

---

## Best Practices

* Use `AND` when you need to preserve selected bits and clear others, rather than using branching or arithmetic logic.
* Take care when combining with conditional jumps to ensure flag behavior is expected.
* For flag-only tests, consider using the `TEST` instruction; it performs an AND operation without modifying the destination, while similarly affecting flags.

---

## Common Pitfalls

* Assuming `AND` preserves carry or overflow; both `CF` and `OF` are always cleared.
* Overwriting important data; remember that `AND` is destructive to the destination operand.
* Mixing signed vs. unsigned logic; `AND` is purely bitwise, so signed interpretations must be handled separately.

---
