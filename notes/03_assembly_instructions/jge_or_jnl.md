# `JGE / JNL`

> **Random Quote**: Do not pray for an easy life, pray for the strength to endure a difficult one.

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

`JGE` (“Jump if Greater or Equal”) and its alias `JNL` (“Jump if Not Less”) are conditional jump instructions used after **signed integer comparisons**. They succeed when the **Sign Flag (SF)** equals the **Overflow Flag (OF)**, indicating no signed underflow, and thus the first operand is greater than or equal to the second. Both mnemonics compile to the same opcode and are functionally identical.  
### How It Works

- `JGE` / `JNL` examines:
  - If **SF = OF** (meaning the sign is trustworthy for signed interpretation), **then jump**; otherwise, continue.
- No flags are modified by the jump instruction itself; it only reads SF and OF.  

---

## Syntax

```asm
JGE   label

; or

JNL   label
```

* `label`: The target code position to jump to if the condition is true.
* Only one operand is allowed; memory or register operands are not valid for this instruction.

### Instruction Size

* **Short form**: Typically **2 bytes**, using an 8-bit signed displacement.
* **Near form**: Around **3 bytes** or more when full 16- or 32-bit displacement is required depending on the CPU mode.
* No `LOCK`, segment override, or other prefixes are allowed with conditional jumps.

---

## Examples

```asm
mov ax, 5
cmp ax, 5
jge still_equal     ; taken, because equal => SF = OF

mov bx, 0
jmp done

still_equal:
    mov bx, 1       ; path taken when AX ≥ 5
```

```asm
mov ax, -2
cmp ax, 2
jge not_less       ; not taken, because -2 < 2 (SF ≠ OF)
```

---

## Practical Use Cases

* Useful in implementing **signed logic**, such as loops and conditional branches where variables might be negative or positive.
* Ideal for high-level constructs like `if (x >= y)` in lower-level or OS-level code.

---

## Best Practices

* Use `JGE` when your intention is “greater or equal,” and `JNL` when you think in terms of “not less”; choose whichever mnemonic enhances clarity.
* Always immediately precede `JGE` / `JNL` with a flag-setting instruction like `CMP` to maintain correctness.
* Prefer short-form jumps for localized branches; the assembler will switch to near-form if necessary.

---

## Common Pitfalls

* **Incorrect context**: `JGE` is **strictly for signed comparisons**. Using it in unsigned scenarios leads to wrong behavior.
* **Flag clobbering**: Any instruction between the `CMP` and `JGE` that affects flags (e.g. arithmetic/logical instruction) may invalidate the jump condition.
* **Displacement limits**: If you jump too far, make sure your assembler creates the correct near-form encoding to avoid assembly errors.

---

## Notes and References

* `JGE` and `JNL` are aliases with the same opcode (SF = OF).

---
