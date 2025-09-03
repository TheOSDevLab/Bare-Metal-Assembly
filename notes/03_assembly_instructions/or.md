# `OR`

> **Random Quote**: Consistency is the true foundation of trust. Either keep your promises or do not make them.

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

The `OR` instruction performs a **bitwise inclusive OR** between the destination and source operands, storing the result in the destination. It exists to allow selective bit setting and flag preparation for subsequent control flow instructions. Like other logical operations, it modifies certain status flags to reflect the outcome.  

### How It Works

- Computes: `DEST = DEST OR SRC`, combining bits: a bit in the result is 1 if that bit is 1 in either operand.  
- Flags affected:
  - **CF (Carry Flag)**: cleared to 0.
  - **OF (Overflow Flag)**: cleared to 0.
  - **SF (Sign Flag)**: set according to the sign bit of the result.
  - **ZF (Zero Flag)**: set if the result is zero; otherwise cleared.
  - **PF (Parity Flag)**: set based on parity of the least-significant byte.
  - **AF (Auxiliary Carry)**: undefined.

---

## Syntax

```asm
OR destination, source
```

* `destination`: Register or memory operand.
* `source`: Register, memory, or immediate.
* Cannot use two memory operands.

### Instruction Size

* Varies by operand types and sizes:

  * Register-to-register or memory-to-register forms exist with compact encodings.
  * Immediates introduce larger encodings, depending on bit-width (8/16/32/64-bit).
* Supports `LOCK` prefix if used with memory operand for atomic update.

---

## Examples

```asm
; Simple bitwise OR on register
mov eax, 0xF0F0
or eax,  0x0F0F    ; Result: 0xFFFF

; Masking with a memory operand
mov al, [flags]
or al, 0b00000010 ; Set bit 1

; Clearing masking with immediate
or bl, 0xFF       ; Sets all bits in BL
```

---

## Practical Use Cases

* **Feature enabling**: Combine flags or modes (e.g., setting bits in control registers).
* **Bitmask composition**: Construct or adjust masks that involve multiple criteria.
* **Flag-based logic flow**: Immediately follow an `OR` with conditional jumps like `JZ` or `JS`, since the flags reflect the result.

---

## Best Practices

* Use `OR` when you need to **set bits selectively** within a register or memory without altering other bits.
* For testing bit conditions without altering data, prefer `TEST` instead; it performs an AND-like test without storing the result.
* Remember that `OR` clears both `CF` and `OF`, so don’t rely on carry or overflow after using it.

---

## Common Pitfalls

* Assuming `CF` or `OF` might reflect meaningful data; both are always cleared by `OR`.
* Accidentally modifying key flags that subsequent conditional logic depends on.
* Misusing `OR` for testing bits (use `TEST`) or vice versa.

---
