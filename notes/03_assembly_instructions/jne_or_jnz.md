# JNZ / JNE

> **Random Quote**: To dare is to lose one's footing momentarily. Not to dare is to lose oneself.

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

`JNZ` and `JNE` are synonymous conditional jump mnemonics that transfer control flow when the **Zero Flag (ZF)** is **cleared** (i.e., equals 0). They enable branching when a previous comparison or test did not indicate equality, making them essential for non-equal or non-zero logic paths.

### How It Works

- After an instruction like `CMP`, `TEST`, `SUB`, or a logical operation sets the flags, `JNZ`/`JNE` checks if **ZF = 0**.
- If true, it jumps to the target **destination label**; if false, execution continues sequentially.
- Compatible with both **arithmetic zero checks** and **equality checks**, enhancing readability in both contexts.

---

## Syntax

```asm
JNZ label

; or

JNE label
```

* `label`: A branch destination. This can be a near relative label, a register indirect target, or a far pointer in modes that support far jumps. In practice this is usually a near relative label.
* Only one operand is permitted; there's no support for memory or register targets in standard usage.
* Both mnemonics compile to identical opcodes and may be used interchangeably depending on semantic preference.

### Instruction Size

* **Short near form**: \~2 bytes, using an 8-bit signed displacement.
* **Near (longer)**: \~3 bytes or more when using 16/32-bit displacement depending on addressing mode.
* No support for `LOCK` or other prefixes; branch encoding relies solely on displacement size and operand-size context.

---

## Examples

```asm
mov ax, 7
cmp ax, 10
jne not_equal   ; taken because AX != 10 (ZF = 0)

mov bx, 0       ; fallen through path
jmp done

not_equal:
  mov bx, 1     ; taken path
```

```nasm
; Zero-check with TEST
test ax, ax     ; sets ZF=1 if AX == 0
jnz not_zero    ; jumps if AX != 0
```

These follow the typical two-step pattern: test/comparison followed by conditional jump.

---

## Practical Use Cases

* Branching when two values aren't equal; useful in loops, conditional logic, or exception handling.
* Checking for non-zero values (e.g., counters, pointers) using instructions like `TEST` or `CMP`.
* In disassembly or reverse engineering, `JNZ` is conventionally used when testing for non-zero flags not set.

---

## Best Practices

* **Use `JNE`** when the logic is explicitly about inequality (often after `CMP`), and **use `JNZ`** when the logic checks for non-zero conditions; choosing based on semantic clarity.
* Always ensure the instruction that sets the flags immediately precedes `JNZ`/`JNE`; avoid stray instructions that clobber flags in between.
* Favor short displacement form for nearby jumps; it’s more compact and efficient. Assemblers auto-expand when needed.

---

## Common Pitfalls

* **Using `JNZ` without setting ZF deliberately**: residual flag state can lead to unpredictable branching.
* **Flag clobbering**: instructions like `ADD`, `SUB`, or even function calls can modify flags; beware of inserting them between comparisons and conditional jumps.
* **Displacement limits**: if a jump target is out of short range (\~±128 bytes), make sure an assembler expands it to a near form; otherwise, code won't assemble.

---

## Notes and References

* `JNZ` and `JNE` are the same. They both rely on ZF, with the difference primarily semantic.
* Formal opcode and encoding reference: [Felix Cloutier's x86 reference](https://www.felixcloutier.com/x86/jcc)

---
