# `NOT`

> **Random Quote**: Success is neither magical nor mysterious. Sucess is the natural consequence of consistently applying basic fundamentals.

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

`NOT` performs a **bitwise logical NOT** (one’s complement) on its operand, inverting every bit. It exists to provide fast, single-instruction bit inversion without arithmetic overhead. The instruction **does not affect any flags**, making it unique among bitwise instructions. 

### How It Works

The operand (register or memory) is read, each bit is flipped (`0→1`, `1→0`), and the result is written back to the same location. Unlike `XOR` or `AND`, there is no source operand; `NOT` only has a single destination. Because the instruction is non-destructive to the flags, it is useful when bit inversion is needed without disturbing the program’s condition codes. 

---

## Syntax

```asm
NOT destination
```

* `destination`: register or memory operand.
* **restriction**: cannot use an immediate as the operand; only register or memory is valid.

### Instruction Size

* Encoded via **Group 3 instructions** (`F6 /2` for byte, `F7 /2` for word/dword/qword).
* Typical size: **2-3 bytes** depending on addressing mode.
* No short accumulator-only forms.
* `LOCK` prefix is permitted when the operand is in memory, allowing atomic inversion on multiprocessor systems.

---

## Examples

```nasm
; --- Simple register inversion ---
mov al, 0b10101010
not al               ; al = 01010101

; --- Word inversion ---
mov ax, 0x0F0F
not ax               ; ax = 0xF0F0

; --- Memory operand ---
lock not byte [var]       ; inverts the byte stored at memory label "var"

; --- Toggle all bits in EAX ---
mov eax, 0x12345678
not eax              ; eax = 0xEDCBA987
```

---

## Practical Use Cases

* **Bitmask creation**: build inverse masks for selective clearing operations.
* **Data inversion**: useful when working with hardware registers or devices that use active-low logic.
* **Efficient complement**: flipping all bits without affecting flags, unlike arithmetic negation (`NEG`).

---

## Best Practices

* Use `NOT` when you need pure bit inversion **without disturbing flags**.
* Pair with `AND`, `OR`, or `XOR` to perform compound bit manipulations.
* When clearing selected bits, create masks by inverting constants with `NOT` instead of manually writing hex.

---

## Common Pitfalls

* **Confusing with `NEG`**: `NEG` computes two’s complement (arithmetic negation), which includes inversion + adding 1 and **does affect flags**; `NOT` is just one’s complement and leaves flags unchanged.
* **Immediate operands not allowed**: only registers or memory can be inverted.
* **Atomic operations**: if multiple threads use `NOT` on shared memory, forgetting the `LOCK` prefix can cause race conditions.

---
