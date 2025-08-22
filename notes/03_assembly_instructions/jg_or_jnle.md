# `JG / JNLE`

> **Random Quote**: Without hard work, nothing grows but weeds.

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

`JG` ("Jump if Greater") and its alias `JNLE` ("Jump if Not Less or Equal") are conditional jump instructions used for **signed integer comparisons**. They are taken when the **Zero Flag (ZF) = 0** *and* the **Sign Flag (SF) equals the Overflow Flag (OF)**. These mnemonics compile to the same opcode and are functionally identical.  

### How It Works

- `JG` / `JNLE` checks:
  - `ZF` must be 0 (values are not equal), **and**
  - `SF == OF` (the result's sign is reliable, i.e., no signed overflow occurred).
- If both conditions are met, the jump is taken; otherwise, execution continues sequentially.  

---

## Syntax

```asm
JG   label

; or

JNLE label
```

* `label`: The jump destination (usually a near, relative label).
* Only one operand is permitted; it cannot target memory or a register directly.

### Instruction Size

* **Short form**: Typically **2 bytes**, using an 8-bit signed displacement.
* **Near form**: **3 bytes or more** when using 16-bit or 32-bit displacements depending on the operating mode.
* No `LOCK` or other prefixes apply for conditional jumps.

---

## Examples

```asm
mov al, 10
cmp al, 5
jg greater      ; taken, since 10 > 5 (ZF = 0, SF = OF = 0)

jmp done

greater:
    mov bl, 1   ; this is executed
```

```asm
; Example where values are equal
mov ax, 7
cmp ax, 7
jnle skip      ; not taken, since ZF = 1 (not greater)
```

---

## Practical Use Cases

* Employed in **signed comparisons** where behavior depends on one value being strictly greater than another (e.g., sorting, threshold checks).
* Common in high-level flow control in OS kernels, arithmetic routines, or any performance-critical signed logic.

---

## Best Practices

* Use `JG` when your logic centers around the concept of "greater than." Use `JNLE` when your mental model fits "not less or equal"; both are functionally the same but semantically different.
* Always place `CMP` or other flag-setting instructions **immediately before** the jump to avoid tampered flag states.
* Prefer short-reach displacement encodings for compact, efficient branching; let the assembler expand these when necessary.

---

## Common Pitfalls

* **Using `JG` for unsigned comparisons**; that’s incorrect. Instead, use `JA` / `JAE`.
* **Overwriting flags** between `CMP` and `JG` invalidates the branch decision.
* **Jump target too distant**; ensure the assembler selects the correct near format if short-range displacement doesn't fit.

---

## Notes and References

* `JG` and `JNLE` are alias instructions with identical opcodes and behavior.

---
