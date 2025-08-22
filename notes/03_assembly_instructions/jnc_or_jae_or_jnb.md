# `JNC / JAE / JNB`

> **Random Quote**: To be prepared for war is one of the most effective means of preserving peace.

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

The conditional jump instructions **`JNC`** (Jump if No Carry), **`JAE`** (Jump if Above or Equal), and **`JNB`** (Jump if Not Below) are synonyms in x86 assembly. They test the **Carry Flag (CF)** and transfer control when **CF = 0**, typically after an unsigned comparison indicates that the first operand is greater than or equal to the second. All compile to the same opcode, differing only in mnemonic semantics.  

### How It Works

- After an unsigned comparison (e.g., via `CMP`), the **Carry Flag** reflects whether an underflow occurred; `CF = 0` means *no underflow*, i.e., `A >= B`.
- If **CF = 0**, the jump is taken; otherwise, execution continues sequentially.
- The instruction reads but **does not modify any flags**.  

---

## Syntax
```asm
JNC  label

; or

JAE  label

; or

JNB  label
````

* `label`: A destination label (typically a near relative address).
* Only a single operand is supported; memory or register targets are not valid in standard usage.

### Instruction Size

* **Short (near) form**: Approximately **2 bytes**, using an 8-bit signed displacement.
* **Longer (near) form**: Approximately **3 bytes** or more when 16-bit or 32-bit displacements are required.
* No `LOCK` prefix or other modifiers apply to conditional jumps.

---

## Examples

```asm
mov ax, 10
cmp ax, 5
jnc no_carry_or_above ; taken because 10 ≥ 5 (CF = 0)

mov bx, 0             ; fallen-through path
jmp done

no_carry_or_above:
    mov bx, 1         ; taken path
```

```asm
cmp ax, bx            ; result unsigned ≥?
jae greater_or_equal  ; jump if CF = 0
```

---

## Practical Use Cases

* **Unsigned comparisons** where you need to branch when the left operand is *greater than or equal to* the right operand.
* Common in buffer indexing, array bounds checking, and low-level logic in OS, embedded, or bootloader code.

---

## Best Practices

* Choose the mnemonic that best suits your intent:

  * `JAE` when thinking in terms of "above or equal" in unsigned comparisons.
  * `JNC` if you’re focusing on the carry flag.
  * `JNB` for readability when describing “not below.”
* Always place the flag-setting instruction (`CMP`, `SUB`, etc.) immediately before the conditional jump to avoid misinterpreting flags.
* Favor short form encodings for efficiency; let the assembler handle longer forms if needed.

---

## Common Pitfalls

* **Confusing signed vs unsigned comparisons**; for signed comparisons, use instructions like `JGE` instead.
* **Flag clobbering**; inserting instructions between the comparison and the jump may alter the carry flag, invalidating the intended logic.
* **Jump range overflow**; if the target label is beyond ±128 bytes, ensure your assembler emits the correct near encoding.

---

## Notes and References

* `JAE`, `JNB`, and `JNC` share the same opcode; differences are purely mnemonic for clarity.

---
