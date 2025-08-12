# JA / JNBE

> **Random Quote:** In the absence of orders, go find something and kill it.

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

`JA` (“Jump if Above”) and `JNBE` (“Jump if Not Below or Equal”) are synonyms that perform the same conditional jump based on unsigned comparison outcomes. They test if **Carry Flag (CF) = 0** **and** **Zero Flag (ZF) = 0**, meaning the preceding comparison deemed the first operand strictly greater.

### How It Works

- After an instruction like `CMP` (unsigned comparison), if **CF = 0** **and** **ZF = 0**, indicating a strictly greater result, `JA` or `JNBE` directs control flow to the target label. Otherwise, execution continues sequentially.
- Neither `CF` nor `ZF` is modified by the instruction; it only reads the flags.

---

## Syntax
```asm
JA  label

; or

JNBE  label
```

* `label`: the jump destination; usually a relative near label.
* **Restriction**: Single operand only; cannot accept memory or register sources in typical encodings.

### Instruction Size

* **Short near form**: \~2 bytes using an 8-bit signed displacement.
* **Near form**: \~3 bytes or more when using 16-bit or 32-bit displacement, depending on the mode.
* No `LOCK` or other prefixes are valid for conditional jumps.

---

## Examples

```asm
mov ax, 10
cmp ax, 5
ja greater_label   ; taken because 10 > 5 (CF=0 & ZF=0)

mov bx, 0         ; if not taken
jmp done

greater_label:
    mov bx, 1     ; taken path
```

```asm
mov ax, 5
cmp ax, 5
jnbe equal_or_less   ; not taken because 5 is not above 5 (ZF=1)
```

---

## Practical Use Cases

* Used in **unsigned comparisons**, where checking "greater than" is required; such as indexing, handling unsigned counters, or validating buffer sizes.
* Common in bootloader, embedded, or OS code where unsigned arithmetic logic ensures safety against underflows and overflows.

---

## Best Practices

* Choose mnemonic based on clarity: use `JA` for "above," `JNBE` for "not below or equal" when you want to emphasize the logical intent.
* Ensure a flag-setting instruction like `CMP`, `SUB`, or `TEST` directly precedes the jump; no intervening instructions should modify flags.
* Favor short displacement forms for local branching to keep code compact and friendly to branch prediction.

---

## Common Pitfalls

* **Using for signed comparisons**; for signed logic use `JG` / `JNLE` instead.
* **Flag misuse**; inserting instructions between flag setup and the jump can corrupt logic.
* **Jump range exceeded**; if label is out of ±128 bytes, ensure assembler emits a near form; otherwise, assembly may fail.

---

## Notes and References

* `JA` and `JNBE` are opcode equivalents: identical machine code with different mnemonic aliases.
* [tutorialspoint.com](https://www.tutorialspoint.com/assembly_programming/assembly_conditions.htm)

---
