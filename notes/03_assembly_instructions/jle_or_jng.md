# JLE / JNG

> **Random Quote:** Cowards die many times before their deaths; the valiant never taste of death but once.

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

`JLE` (“Jump if Less or Equal”) and its alias `JNG` (“Jump if Not Greater”) are equivalent conditional jumps used after signed comparisons. They transfer control when **Zero Flag (ZF) = 1** *or* **Sign Flag (SF) ≠ Overflow Flag (OF)**, indicating the first operand is less than or equal to the second.

### How It Works

- After a signed `CMP` or arithmetic instruction:
  - If **ZF = 1** (operands are equal) *or*
  - **SF ≠ OF** (signed less-than condition),
then `JLE`/`JNG` jumps to the target label; otherwise, it proceeds sequentially.
- The instruction reads flags, but it does **not** modify them.
- It typically targets a near relative label; support for far or indirect forms depends on assembler and CPU mode.

---

## Syntax

```asm
JLE  label

; or

JNG  label
```

* `label`: A named code location, generally a near relative jump target.
* Only one operand is permitted; memory or register operands are not valid in standard conditional jumps.

### Instruction Size

* **Short form**: \~2 bytes (8-bit signed displacement).
* **Near (longer)**: \~3 bytes or more (16/32-bit displacement), depending on address-size.
* No `LOCK` or segment override prefixes are applicable to conditional jumps.

---

## Examples

```asm
mov ax, 3
cmp ax, 5
jle less_or_equal  ; ZF=0, SF ≠ OF → jump (3 < 5)

mov bx, 0
jmp done

less_or_equal:
    mov bx, 1      ; taken when ax ≤ 5

done:
    hlt
```

```asm
mov ax, 5
cmp ax, 5
jng equal         ; ZF=1 → jump (equal)

; continues sequentially if not taken
```

---

## Practical Use Cases

* Implementing signed comparison branches; especially when handling negative or boundary values.
* Useful in control flow structures that require branching when a signed value is not greater than another.
* Common in arithmetic error checks, bounds checks, loops, or decision-making logic in OS or low-level code.

---

## Best Practices

* Choose the mnemonic that best expresses your logic: use `JLE` for “less or equal” and `JNG` for “not greater” depending on which reads clearer.
* Ensure the instruction that establishes flags (`CMP`, `SUB`, etc.) directly precedes `JLE`/`JNG` to avoid interference.
* Use short-form jumps where possible to keep code compact and increase branch prediction efficiency.

---

## Common Pitfalls

* **Mixing signed and unsigned logic**: `JLE` is for signed comparisons. For unsigned checks, use instructions like `JBE`.
* **Flag tampering**: Be careful not to overwrite flags between the comparison and the jump, as that invalidates the branch condition.
* **Displacement overflow**: If the target label is too distant for a short jump (\~±128 bytes), ensure the assembler uses the longer form to avoid assembly errors or undefined behavior.

---

## Notes and References

* `JLE` and `JNG` are aliases with the same opcode and behavior.

---
