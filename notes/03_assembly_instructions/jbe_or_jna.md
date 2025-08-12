# JBE / JNA

> **Random Quote**: You may have to fight a battle more than once to win it.

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

`JBE` (“Jump if Below or Equal”) and `JNA` (“Jump if Not Above”) are synonyms that perform the same conditional jump based on unsigned comparison. The instruction tests if the **Carry Flag (CF) = 1** or **Zero Flag (ZF) = 1**; i.e., if the result of a prior comparison was "below or equal". They exist to simplify unsigned boundary checks. Both mnemonics compile to the same opcode.

### How It Works

- After a comparison such as `CMP`, if **CF = 1** (underflow happened in unsigned subtraction) **or** **ZF = 1** (values are equal), then `JBE` / `JNA` causes an immediate jump to the specified label. If neither condition is met, execution continues sequentially.
- Both flags are read but not modified by the instruction itself.

---

## Syntax
```asm
JBE label

; or

JNA label
```

* `label`: A destination label for the jump.
* Only a single operand is allowed; cannot use memory or register as the destination in typical encodings.

### Instruction Size

* **Short near form**: \~2 bytes, using an 8-bit signed displacement.
* **Longer near form**: \~3 bytes (16- or 32-bit displacement) depending on operand-size attribute.
* No `LOCK` or segment override prefixes are applicable.

---

## Examples

```asm
mov ax, 5
cmp ax, 10
jbe less_or_equal   ; jumps because 5 < 10 (CF=1 in unsigned)
```

```asm
mov ax, 10
cmp ax, 10
jna equal_or_less   ; jumps because values are equal (ZF=1)
```

---

## Practical Use Cases

* Used in **unsigned comparisons**; often verifying array bounds, buffer lengths, or counter limits where underflow or equality should continue the flow.
* Common in low-level routines like **bootloader loops** or **string processing**, where comparing unsigned lengths is frequent.

---

## Best Practices

* Favor `JBE` when testing unsigned "≤" conditions; reserve `JNA` when intent reads more naturally as “not above.”
* Always pair with `CMP` (or unsigned logic) immediately prior to avoid flag pollution.
* Use short encodings when possible for locality and size efficiency.

---

## Common Pitfalls

* Misusing for **signed comparisons**; for signed number checks, use `JL`/`JLE` instead.
* Relying on flags set by unintended prior instructions; always ensure flags reflect the intended check.
* Hitting displacement limits: if the label is beyond short jump range (±128 bytes), ensure assembler emits a longer form.

---

## Notes and References

* `JBE` and `JNA` are op-code synonyms: same encoding, two mnemonics.
* [yassinebridi](https://yassinebridi.github.io/asm-docs/asm_tutorial_07.html)

---
