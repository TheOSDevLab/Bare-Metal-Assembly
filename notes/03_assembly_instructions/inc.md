# `INC`

> **Random Quote:** Excellence is not an act, but a habit.

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

The `INC` instruction performs **integer increment**, adding **1** to the operand in-place.

### How It Works

+ Reads the operand value.
+ Computes `destination := destination + 1`.
+ The result replaces the original operand.
+ Unlike `ADD` and `SUB`, `INC` does not modify the **Carry Flag (CF)**.
+ All the other arithmetic flags are updated based on the new result:
    - **OF (Overflow Flag)**: Set if signed overflow occurs.
    - **ZF (Zero Flag)**: Set if the result is zero.
    - **SF (Sign Flag)**: Reflects the sign bit of the result.
    - **AF (Auxiliary Carry Flag)**: Set if a nibble (4-bit) carry occurs.
    - **PF (Parity Flag)**: Set if the low byte of the result has even parity.

---

## Syntax

```asm
inc destination
```

+ `destination`: A register or memory operand containing the integer to be incremented.
+ **Restrictions**: Only one operand is allowed. Memory-to-memory or multiple operands are invalid.

### Instruction Size

+ Register form (`INC AX`, `INC EAX`) is encoded in **1 byte** (opcodes `40h-47h`).
+ Memory forms use ModR/M encoding and vary in length.
+ Supports `LOCK` prefix for atomic increments (required in SMP contexts).

---

## Examples

```asm
; 8-bit register
inc al        ; AL := AL + 1

; 16-bit register
inc ax        ; AX := AX + 1

; 32-bit register
inc eax       ; EAX := EAX + 1

; Memory operand (byte or word)
inc [count]   ; Increment the byte or word at label 'count'
```

---

## Practical Use Cases

+ Incrementing loop counters in BIOS or bootloader routines.
+ Advancing pointers or indexes in data processing loops.
+ Updating string or buffer lengths.
+ Efficiently incrementing memory-resident counters.

---

## Best Practices

+ Use `INC` when you want to avoid changing the **Carry Flag**.
+ If carry propagation matters, use `ADD destination, 1`.
+ For multi-word increments (e.g. 16-bit overflow in a chain), combine `INC` with conditional `ADC`.
+ Prefer `INC reg` over `ADD reg, 1` for compact encoding when CF preservation isn't needed.

---

## Common Pitfalls

+ **Carry flag preservation**: If you expect CF to reflect overflow, `INC` is inappropriate.
+ **Memory operand latency**: `INC [mem]` is slower than `INC reg`.
+ **Instruction length inconsistency**: Register vs memory encoding length may affect tightly packed boot sector code.
+ **Unsupported in older real-mode environments**: Some very old 16-bit BIOS fetters may not fully support memory forms with LOCK prefix.

---

## Notes and References

+ As the CF flag isn't modified, this instruction is especially valuable in contexts where incremental logic must preserve carry.

+ [**Felix Cloutier's x86 Reference**: Detailed encoding and operational behavior of `INC`](https://www.felixcloutier.com/x86/inc)
+ [tutorialspoint.com](https://www.tutorialspoint.com/assembly_programming/assembly_arithmetic_instructions.htm)
+ [cs.virginia.edu](https://www.cs.virginia.edu/~evans/cs216/guides/x86.html)

---