# `DEC`

> **Random Quote**: Obsessed is just a word the lazy use to describe the dedicated.

## Sections

+ [Overview](#overview)
    - [How It Works](#how-it-works)
+ [Syntax](#syntax)
    - [Instruction Size](#instruction-size)
+ [Examples](#examples)
+ [Practical Use Cases](#practical-use-cases)
+ [Best Practices](#best-practices)
+ [Common Pitfalls](#common-pitfalls)
+ [Notes and References](#notes-and-references)

---

## Overview

The `DEC` instruction performs **integer decrement**. It subtracts **1** from the destination operand and stores the result in place.

### How It Works

+ Reads the operand.
+ Computes `destination := destination - 1`.
+ Stores the result back in the destination operand.
+ Just like `INC`, `DEC` does not affect the **Carry Flag (CF)**.
+ All the other arithmetic flags are updated based on the result.
    - **OF (Overflow Flag)**: Set if signed overflow occurs.
    - **ZF (Zero Flag)**: Set if the result is zero.
    - **SF (Sign Flag)**: Reflects the sign bit of the result.
    - **AF (Auxiliary Flag)**: Set if there was a borrow from the lower nibble.
    - **PF (Parity Flag)**: Set if the low byte of the result has even parity.

---

## Syntax

```asm
dec destination
```

+ `destination`: A register or memory operand.
+ **Restrictions**: Only one operand is allowed.

### Instruction Size

+ Register form (`DEC AX`, `DEC EAX`) is encoded in **1 byte** (`FE/FF` family or `48+`).
+ Memory forms use ModR/M encoding and vary in length.
+ Supports the `LOCK` prefix for atomic usage in multiprocessor environments.

---

## Examples

```asm
; Decrement 8-bit register
dec al        ; AL := AL - 1

; Decrement 16-bit register
dec ax        ; AX := AX - 1

; Decrement 32-bit register
dec eax       ; EAX := EAX - 1

; Decrement memory location
dec [count]   ; BYTE or WORD at 'count' is decremented by 1
```

---

## Practical Use Cases

+ Decrementing loop counters and timers in BIOS or bootloader contexts.
+ Reducing stack pointer offsets or index registers.
+ Adjusting lengths, remaining sectors, or other counters in low-level system routines.
+ Efficient single-step operations on memory or register values.

---

## Best Practices

+ Use `DEC reg` when you want compact encoding and to preserve the Carry Flag.
+ For scenarios where borrow and carry must be observed, prefer `SUB destination, 1`.
+ Use `LOCK DEC [mem]` in SMP environments to ensure atomic decrement on shared memory.
+ Combine `DEC` with branching logic that depends on updated flags.

---

## Common Pitfalls

+ **CF is preserved**: Don't rely on the Carry Flag for detecting underflow when using `DEC`; use `SUB` if needed.
+ **Memory versus register variants have different performance**: `DEC [mem]` is slower than `DEC reg`.
+ **Immediate encoding differences**: Register form is shorter; memory requires ModR/M and possibly more bytes.
+ **Protected-mode exceptions**: Applying `DEC` to invalid or non-writable memory may trigger faults (#GP, #SS, #PF).

---

## Notes and References

+ [**Intel/AMD Manual**: `DEC r/m8` and `DEC r/m16,r/m32` descriptions](https://www.felixcloutier.com/x86/dec)
+ Related files: [`INC`](./inc.md), [`SUB`](./sub.md)

---
