# TEST

> **Random Quote**: The only place where success comes before work is in the dictionary.

## Key Topics

- [Overview](#overview)
    - [How It Works](#how-it-works)
- [Syntax](#syntax)
    - [Instruction Size](#instruction-size)
- [Examples](#examples)
- [Practical Use Cases](#practical-use-cases)
- [Best Practices](#best-practices)
- [Common Pitfalls](#common-pitfalls)
- [Notes and References](#notes-and-references)

---

## Overview

The `TEST` instruction performs a **bitwise logical AND** on two operands and sets the CPU status flags **without modifying** the operands themselves. It's used to evaluate register or memory value patterns (zero, sign, parity) to control branches and logic decisions.  
### How It Works

- Computes `SRC1 AND SRC2`, then **discards the result**.
- Flags affected:
  - **ZF**: Set to 1 if the result is zero; otherwise cleared.  
  - **SF**: Reflects the most significant bit of the result.  
  - **PF**: Set based on parity of the least significant byte (1 if even number of bits set).  
  - **CF** and **OF**: Always cleared (set to 0).  
  - **AF**: Undefined.  

---

## Syntax

```asm
TEST operand1, operand2
```

* `operand1`, `operand2`: Can be registers, memory locations, or immediates (depending on the addressing mode).
* The instruction supports various sizes (8-bit, 16-bit, 32-bit, 64-bit) and addressing modes.

### Instruction Size

* Multiple opcodes exist depending on the operand types and sizes (immediate vs register/memory variants).
* No `LOCK` prefix or special modifiers apply.

---

## Examples

```asm
; Example 1; Zero test
test eax, eax
jz is_zero      ; Jump if EAX == 0

; Example 2; Negative test (based on sign bit)
test cl, cl
js is_negative  ; Jump if CL < 0 (signed)

; Example 3; Mask-specific test
test al, 0x0F
jnz not_aligned ; Jump if any of the low 4 bits of AL != 0
```

---

## Practical Use Cases

* **Check if a register or memory value is zero**, without altering its content.
* **Test for specific bits** (flag checks, alignment checks) via `TEST` and conditional jumps.
* Often used in performance-critical or tight loop logic where modifying the register is undesirable.

---

## Best Practices

* Use `TEST` when you want to inspect a value without changing it.
* Choose between `TEST` and `CMP` depending on whether you're doing bit-level checks (`TEST`) or relational comparisons (`CMP`).
* Keep flag-consuming logic (`TEST`, `CMP`) immediately before conditional jumps to avoid interference.

---

## Common Pitfalls

* Confusing `TEST` with `AND`:

  * `AND` updates the destination register with the result.
  * `TEST` leaves operands unchanged.
* Assuming `CF` or `OF` are preserved; both are explicitly cleared to 0.
* Relying on `AF` is risky; its state is undefined.

---

## Notes and References

* `TEST` is effectively a read-only `AND` that only affects CPU flags.

---
