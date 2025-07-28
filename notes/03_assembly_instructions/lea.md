# `LEA`

> **Random Quote:** Be the change that you wish to see in the world.

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

The `LEA` (Load Effective Address) instruction computes the address defined by a memory expression and stores it in a register. Unlike `MOV`, which retrieves data from a memory address, `LEA` retrieves the address itself.

### How It Works

When `LEA` is executed:

- The CPU evaluates the memory operand (inside the brackets) and computes its effective address.
- This address is stored in the destination register.
- The content at the computed address is **not accessed or read**.
- The `LEA` instruction **does not affect any flags**.

---

## Syntax

```asm
lea destination, source
```

+ `destination`: Must be a general-purpose register (e.g., `AX`, `BX`, `SI`, `EAX`, `RAX`).
+ `source`: Must be a valid memory expression enclosed in square brackets.
+ **Restrictions**: You cannot use `LEA` with two memory operands or with an immediate constant directly (e.g., `lea ax, 0x1234` is invalid).

Valid memory expressions can include combinations of base registers, index registers, scale factors, and displacements.

In 16-bit real mode, addressing is limited to specific combinations like `[bx + si]`, `[bp + 6]`, etc.

### Instruction Size

* Typically 2–7 bytes, depending on the mode (16-bit, 32-bit, or 64-bit) and complexity of the addressing mode.
* Shorter encodings are used for simple effective address forms.
* In 64-bit mode, RIP-relative addressing is also supported.

---

## Examples

### Load Address of a Variable

```asm
myvar dw 0x1234
lea si, [myvar]     ; SI = offset of myvar (not its value).
```

### Simple Pointer Arithmetic

```asm
lea bx, [di + 4]        ; BX = DI + 4
lea ax, [bx + si + 2]   ; AX = BX + SI + 2
```

### Scaled Address Computation (32-bit+)

```asm
lea eax, [ebx + ecx*4 + 8]   ; EAX = EBX + ECX*4 + 8
```

This allows complex address math without modifying flags or using slower arithmetic instructions.

---

## Practical Use Cases

* **String and buffer manipulation**: Quickly compute addresses without loading data.
* **Stack frame access**: Calculate offsets from base pointers without touching memory.
* **Optimized arithmetic**: Use `LEA` to perform additions and scaling without affecting flags.
* **Parameter passing and address loading**: Compute structure field addresses in OS kernels or drivers.

---

## Best Practices

* Use `LEA` when you need the address, not the value.
* Prefer `LEA` over arithmetic instructions (like `ADD` or `MUL`) when computing pointer offsets or scaled indices.
* Use it for side-effect-free arithmetic in performance-critical code.

---

## Common Pitfalls

* Confusing `LEA` with `MOV` and expecting it to load the contents at the address.
* Using invalid memory expressions (e.g., two memory operands, bare constants).
* In real mode (16-bit), using unsupported addressing combinations that are valid only in 32-bit/64-bit modes.
* Assuming `LEA` will trigger memory access; it never does.

---

## Notes and References

* `LEA` is often considered a hidden gem for optimized register arithmetic.
* [felixcloutier.com](https://www.felixcloutier.com/x86/lea)

---