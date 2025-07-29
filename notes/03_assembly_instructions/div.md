# `DIV`

> **Random Quote:** You don't have to be extreme, just consistent.

## Key Topics

- [Overview](#overview)
    - [How It Works](#how-it-works)
- [Syntax](#syntax)
    - [Instruction Size](#instruction-size)
- [Examples](#examples)
- [Practical Use Cases](#practical-use-cases)
- [Best Practices](#best-practices)
- [Common Pitfalls](#common-pitfalls)
- [Notes and Reference](#notes-and-reference)

---

## Overview

The `DIV` instruction performs an **unsigned integer division**. It divides a fixed-size dividend held in accumulator registers by a specified operand, yielding a quotient and a remainder.

It enables division without requiring explicit multi-step arithmetic routines, streamlining low-level OS‑dev calculations.



### How It Works

+ On execution:
  + The CPU divides the dividend by the divisor.
  + The **quotient** is stored in the accumulator register (`AL`, `AX`, `EAX`, or `RAX`).
  + The **remainder** is stored in the high half register (`AH`, `DX`, `EDX`, or `RDX`).
+ If the divisor is zero or the quotient exceeds the destination register size, a **divide error exception** (`#DE`) occurs.
+ `DIV` does not affect any CPU flags.

---

## Syntax

```asm
div source
```

* `source`: Unsigned divisor operand (register or memory), matching the operation size.

Only one operand is provided because the destination and remainder storage are implicit.

+ **Divisor**: The **number you divide by**. This is the operand passed to the `DIV` instruction. It must be the same size as the lower half of the dividend.

+ **Quotient**: The **result of the division** (how many times the divisor fits into the dividend). Stored in:

    - 8-bit: `AL`
    - 16-bit: `AX`
    - 32-bit: `EAX`
    - 64-bit: `RAX`

+ **Remainder**: The **leftover part** after the division. Stored in the upper half register:

    - 8-bit: `AH`
    - 16-bit: `DX`
    - 32-bit: `EDX`
    - 64-bit: `RDX`

+ **Dividend**: This is the **number you want to divide**. In `DIV`, it's stored implicitly in the accumulator register(s):
    
    - 8-bit: `AX`
    - 16-bit: `DX:AX`
    - 32-bit: `EDX:EAX`
    - 64-bit: `RDX:RAX`

`DX:AX` means the dividend is 32-bits, with `DX` as the **high 16 bits** and `AX` as the **low 16 bits**. `EDX:EAX` means the dividend is 64-bits, with `EDX` as the high 32-bits and `EAX` as the low 32-bits. This is the same for `RDX:RAX` where the dividend is 128-bits.

**Why is it like this? Why not just use `EAX` for 32-bit dividends?**: Because the `DIV` instruction is designed to divide larger numbers (the dividend) by a smaller one (the divisor). It always assumes that the dividend is twice the size of the divisor.

When you write:

```assembly
div ebx     ; EBX = 32-bit divisor
```

The CPU expects a 64-bit dividend in `EDX:EAX`, not just `EAX`.
+ `EDX` holds the upper 32 bits.
+ `EAX` holds the lower 32 bits.
+ Together they form a 64-bit value to be divided by the 32-bit `EBX`.

This is true even if your actual value fits in 32 bits. You still have to explicitly zero out `EDX` if the upper half is not needed.

```assembly
xor edx, edx   ; Make sure upper 32 bits of dividend are 0
mov eax, 12345 ; Dividend
mov ebx, 10    ; Divisor
div ebx        ; EAX = quotient, EDX = remainder
```

**Why did Intel design it like this?**: To allow for division of large numbers, without needing special instructions. For example:

+ 8-bit divisor, 16-bit dividend (`AX`).
+ 32-bit divisor, 64-bit dividend (`EDX:EAX`)
+ 64-bit divisor, 128-bit dividend (`RDX:RAX`)

This makes it consistent across operand sizes and flexible for large-number math.

### Instruction Size

* Varies depending on operand and addressing mode (typically 1–3 bytes).
* No `LOCK` prefix support.
* Operand-size extensions in 64-bit mode may increase size.

---

## Examples

```asm
; Divide 16-bit values:
mov ax, 0x8003
xor dx, dx         ; Clear DX for high half
mov bx, 0x0100     ; Divisor
div bx             ; AX = 0x80, DX = 0x03

; Divide byte values:
mov al, [num1]
xor ah, ah
div bl             ; AL = quotient, AH = remainder

; Divide 32-bit values:
xor edx, edx
mov eax, 100000
mov ebx, 250
div ebx            ; EAX = quotient, EDX = remainder
```

---

## Practical Use Cases

* Computing **quotients and remainders** in early OS‑dev code (e.g., sector calculations, checksum logic).
* Dividing counters or offsets when other arithmetic is insufficient.
* Implementing integer division routines before OS runtime libraries are available.

---

## Best Practices

* Always **initialize the high‑half register** (e.g., `DX`, `EDX`, or `RDX`) before executing `DIV`.
* Use `CDQ` (for signed) or `XOR reg, reg` (for unsigned) to set the high half appropriately.
* Validate that the divisor is **non-zero** to avoid exceptions.
* Use `IDIV` for signed division where negative operands are possible.
* Handle exceptions (`#DE`) gracefully if division may exceed the quotient limit.

---

## Common Pitfalls

* Failing to zero or sign-extend the high‑half register leads to incorrect results or exceptions.
* Dividing by zero triggers an exception.
* Assuming flags are set: `DIV` leaves flags undefined.
* Mismatched operand sizes: divisor and dividend halves must align.
* Using memory operands outside valid segments or without proper alignment can cause protection faults.

---

## Notes and Reference

* `DIV` performs truncating integer division; the remainder is always less than the divisor in magnitude.
* **Signed counterpart**: `IDIV` handles two’s-complement signed division.
* Modern processors implement slower throughput for 64-bit `DIV`; prefer alternative algorithms if performance is critical.
* Reference: [Intel 64 and IA‑32 Architectures Software Developer’s Manual, Vol. 2 - DIV](https://www.felixcloutier.com/x86/div)

---
