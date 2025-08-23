# `JL / JNGE`

> **Random Quote**: Satisfaction lies in the effort, not in the attainment. Full effort is full victory.

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

`JL` ("Jump if Less") and its alias `JNGE` ("Jump if Not Greater or Equal") are conditional jump instructions for **signed integer comparisons**. They are taken whenever the **Sign Flag (SF) ≠ Overflow Flag (OF)**. Both mnemonics map to the same opcode.

### How It Works

- After a signed comparison (`CMP`), the CPU evaluates:
  - If **SF ≠ OF**, then the first operand is less than the second.
- If this condition is true, `JL` / `JNGE` transfers control to the target; otherwise, execution continues sequentially.
- This instruction reads flags without modifying any of them.  

---

## Syntax

```asm
JL   label

; or

JNGE label
```

* `label`: The destination code location for the jump.
* Only a single operand (label) is allowed; memory or register targets are not supported.

### Instruction Size

* **Short form**: \~2 bytes with an 8-bit signed displacement.
* **Near form**: \~3 bytes or more when using 16/32-bit displacement, depending on addressing mode.
* No prefixes like `LOCK` are permitted on conditional jumps.

---

## Examples

```asm
mov ax, -2
cmp ax, 5
jl is_less    ; Taken, since -2 < 5 (SF ≠ OF)

jmp done

is_less:
    mov bx, 1  ; Branch when AX is less
```

```asm
mov ax, 7
cmp ax, 7
jnge not_less_or_equal  ; Not taken, since SF = OF (equal, not less)

; Continues here if not taken
```

---

## Practical Use Cases

* Implement control flow for **signed integer logic**, such as branching when a value is negative or below another in signed representation.
* Typical in algorithms that deal with negative ranges or need to support full signed arithmetic.

---

## Best Practices

* Choose the mnemonic that best conveys intent:

  * `JL`; use when thinking “less than.”
  * `JNGE`; use when thinking “not greater or equal.”
* Always place the comparison (`CMP`) immediately before the jump to preserve flag integrity.
* Prefer short jumps for efficiency; let assembler handle expansion if needed.

---

## Common Pitfalls

* **Using for unsigned comparisons**; `JL` is valid only for signed logic. Use `JB`, `JNAE`, or others for unsigned.
* **Flag clobbering**; any intervening instruction that changes SF or OF will break the intended behavior.
* **Displacement overflow**; if the jump target is beyond the ±128-byte range, the assembler must use a longer encoding to avoid misassembly.

---

## Notes and References

* [felixcloutier.com](https://www.felixcloutier.com/x86/jcc)

---
