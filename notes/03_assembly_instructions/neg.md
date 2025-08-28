# `NEG`

> **Random Quote**: Don't wish it were easier; wish you were better.

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

`NEG` computes the two's complement negation of its operand; effectively performing `0 - operand`, and storing it back in place. It exists to provide a concise, single-instruction way to invert the sign of a value.

### How It Works

- The CPU retrieves the operand (register or memory), calculates its two’s complement (i.e., flips all bits and adds one), and stores the result back into the operand.  
- Internally equivalent to:  
  ```asm
  NOT dest
  ADD dest, 1
  ```

* Flags updated:

  * **CF (Carry Flag)**: set to `0` if the original operand was zero; otherwise set to `1`.
  * **OF, SF, ZF, AF, PF**: updated based on the result.

---

## Syntax

```asm
NEG operand
```

* `operand`: A register or memory location.
* It does **not** take an immediate operand or allow two memory operands.

### Instruction Size

* Encoded via opcode `/3`:

  * `F6 /3` for 8-bit (`r/m8`)
  * `F7 /3` for 16-bit / 32-bit / 64-bit (`r/m16`, `r/m32`, `r/m64`)
* In 64-bit mode, the default size is 32 bits; use `REX.W` for 64-bit operation.
* A `LOCK` prefix *is* allowed if operating on a memory operand to ensure atomicity.

---

## Examples

```asm
; Simple register negation
mov ax, 5
neg ax        ; AX becomes -5

; Negate zero
mov bx, 0
neg bx        ; BX remains 0, CF cleared

; Negating a memory operand
mov [var], byte 0x10
neg byte [var]  ; value becomes -0x10

; Larger scale (signed subtraction)
mov eax, X
neg eax         ; result is 0 - X
```

---

## Practical Use Cases

* **Implementing signed arithmetic**: Useful in expressions like `R = -X` or `R = Y - X`, without needing multiple instructions.
* **Bootloaders or OS-dev routines**: Efficient when negating pointers, offsets, or signed flags.

---

## Best Practices

* Use `NEG` when intending to reverse the sign of a value directly; it's more concise than separate `NOT` and `INC`.
* Be aware of its side-effects on flags (especially CF) so place it where flag state matters predictably.
* In performance-critical code, using `NEG` can save instructions and maintain readability.

---

## Common Pitfalls

* **CF Behavior at Zero**: `NEG 0` clears CF instead of setting it.
* **Memory operand complexity**: Negating memory causes a read-modify-write; ensure you're not clobbering data unintentionally.
* **Instruction length and mode awareness**: In 64-bit code, proper use of `REX.W` is necessary to avoid inadvertent 32-bit behavior.
* **Flag confusion**: If relying on OF/SF/ZF after negation, ensure no intervening instructions modify flags first.

---
