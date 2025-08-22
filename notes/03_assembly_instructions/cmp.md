# `CMP`

> **Random Quote**: The harder the conflict, the greater the triumph.

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

The `CMP` (compare) instruction performs a **non-destructive subtraction** of the source operand from the destination operand, setting the processor's **status flags** accordingly without altering either operand. It exists to facilitate condition-based branching and logical decisions by preparing flags for subsequent conditional instructions.

### How It Works

- Internally, `CMP` computes: **`destination - source`**, then adjusts the **CF, OF, SF, ZF, AF, PF** flags just like a `SUB` instruction; **with zero change to the operands themselves**.  
- This prepares the CPU for condition checks such as equality, greater-than, or below relations.

---

## Syntax
```asm
CMP destination, source
````

* `destination`: Register or memory operand.
* `source`: Can be register, memory, or an immediate constant.
* The instruction supports various addressing modes and data sizes (8-bit, 16-bit, 32-bit, etc.).

### Instruction Size

`CMP` has multiple encodings depending on operand types and sizes:

* Immediate to accumulator: e.g., `CMP AL, imm8` (opcode `3C ib`), `CMP AX, imm16` (`3D iw`), `CMP EAX, imm32` (`3D id`).
* Register/memory to register: e.g., `CMP r/m8, r8` (`38 /r`), `CMP r/m16, r16` (`39 /r`), etc.
* Source-to-reg and memory comparators are also supported.
* No `LOCK` prefix or modifications apply.

---

## Examples

```asm
; 16-bit real mode, NASM syntax
CMP AX, BX       ; compares AX - BX, setting flags, AX and BX unchanged

CMP AL, 0x5      ; compares AL to immediate 5
```

```asm
; Example with conditional jump
cmp ax, bx
je equal_label   ; jumps if ZF = 1 (operands equal)

; If `AX = 5`, `BX = 5` → `CMP AX, BX` sets **ZF = 1**, enabling `JE` to jump.
```

---

## Practical Use Cases

* `CMP` is essential before **conditional branching** (e.g., loops, if-then logic).
* It works in tandem with `Jcc` (jump if condition), `SETcc`, and `CMOVcc` instructions to control program flow.

---

## Best Practices

* **Always follow `CMP` with conditional jump or set instruction**; flags are meaningless otherwise.
* Use appropriate operand sizes (8/16/32/64-bit) to match your data types for correct flag outcomes.
* Favor **short jumps** (`JE short label`) when target is near to minimize code size and improve locality.

---

## Common Pitfalls

* **Clobbering flags** between `CMP` and the conditional instruction can invalidate logic.
* Misunderstanding operand ordering (`destination - source`) can reverse your logic.
* **Using signed vs unsigned logic incorrectly**: `CMP` itself is neutral; interpreting flags requires selecting the correct `Jcc` mnemonic (e.g., `JL` vs `JB`).

---

## Notes and References

* `CMP` is the canonical way to conduct comparisons in assembly, widely used in performance-critical and low-level code.

---
