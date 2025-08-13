# JC / JB / JNAE

> **Random Quote:** I am not afraid of an army of lions led by a sheep; I am afraid of an army of sheep led by a lion.

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

The conditional jump instructions **`JC`**, **`JB`**, and **`JNAE`** are synonymous in x86 assembly. They all test whether the **Carry Flag (CF)** is set (CF = 1), effectively performing an unsigned "below" comparison. `JC` means "Jump on Carry", `JB` stands for "Jump if Below", and `JNAE` for "Jump if Not Above or Equal". All compile to the same machine opcode.  

### How It Works

- The CPU examines the **Carry Flag (CF)**, typically set by instructions like `CMP` or `SUB` when an unsigned underflow occurs.
- If CF = 1, the jump is taken; otherwise, execution continues.
- Flags are only **read**, not modified, by the instruction.

---

## Syntax
```asm
JC   label

; or

JB   label

; or

JNAE label
```

* `label`: Destination to jump to if `CF = 1`.
* Only one operand is allowed; other formats (memory, register) aren’t valid in standard conditional jumps.

### Instruction Size

* **Short form**: Typically **2 bytes**, using an 8-bit signed relative displacement.
* **Near form**: Can expand to **3 bytes or more**, depending on mode and displacement size (e.g. 16-bit, 32-bit).
* No lock prefix or segment overrides apply to this conditional jump.

---

## Examples

```asm
mov ax, 3
cmp ax, 5
jc below_label   ; taken because 3 < 5 (unsigned, so CF = 1)

mov bx, 0        ; else path
jmp done

below_label:
    mov bx, 1    ; branch taken

done:
    nop
```

```asm
; Using JNAE for readability
cmp ax, bx
jnae below_or_equal ; branch if CF = 1 (unsigned)
```

---

## Practical Use Cases

* Performing **unsigned comparisons** where you need to branch when the left operand is **less than** the right.
* Common in ranged logic, buffer manipulation, array indexing, or low-level parsing routines in OS, embedded, or bootloader contexts.

---

## Best Practices

* Use mnemonic based on clarity:

  * `JC` when you're focusing on the carry logic,
  * `JB` when expressing "below" semantics,
  * `JNAE` when the logic fits “not above or equal”.
* Always follow directly after a flag-setting instruction (`CMP`, `SUB`, etc.) to avoid flag contamination.
* Prefer short jump encodings when the target is nearby to maintain compact and efficient code.

---

## Common Pitfalls

* **Using for signed comparisons**; this instruction is for **unsigned logic only**. For signed comparisons, use `JL`, `JG`, etc.
* **Flags may be clobbered** by intervening instructions; always ensure the flag-setting instruction is immediately before the jump.
* **Jump distance overflow**; if the target label is beyond ±128 bytes, ensure the assembler emits the correct near form; otherwise, the code may not assemble or work properly.

---

## Notes and References

* All three mnemonics (`JC`, `JB`, `JNAE`) refer to the same opcode; only semantic differences exist for readability.
* The instruction table from x86 reference manuals confirms the flag-based condition (CF = 1).

---
