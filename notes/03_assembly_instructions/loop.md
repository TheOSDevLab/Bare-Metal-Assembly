# `LOOP`

> **Random Quote**: Whether you think you can or you think you can't, you're right.

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

`LOOP` decrements the loop counter register (CX, ECX, or RCX depending on address size) and jumps to a label if the result is not zero. It exists to provide compact, counter-based iteration without manual decrement and branch logic.

### How It Works

+ The CPU decrements the count register (CX/ECX/RCX).
+ If the new value is non-zero, it performs a near jump to the specified label.
+ If zero, execution continues with the next instruction.
+ CPU flags are **not affected** by `LOOP`; it does not modify ZF, CF, or others.

---

## Syntax

```asm
loop label
```

+ `label`: A relative target label within `+-128` bytes.
+ No explicit operands; the instruction implicitly uses CX, ECX, or RCX.
+ Only valid when paired with the correct address-size register.

### Instruction Size

* Opcode size: `1 byte` plus a signed 8-bit displacement for the jump.
* No support for `LOCK` prefix or operand-size modifiers.
* Encodes as a short jump-efficient within limited memory loops.

---

## Examples

```asm
; 16-bit loop example
mov cx, 5
loop_start:
    ; loop body
    loop loop_start     ; decrements CX and jumps if CX ≠ 0

; 32-bit mode example
mov ecx, 10
loop top             ; uses ECX in 32-bit mode

; 64-bit mode with address override
addr32:
    mov ecx, 3
    a32 loop addr32       ; The 'a32' prefix forces LOOP to use EAX.
```

---

## Practical Use Cases

* **Fixed iteration loops** in bootloader routines, such as printing characters or initializing memory.
* Compact loop for **count-controlled operations** (e.g., scanning bytes or performing repeated BIOS calls).
* Preferred in size-constrained early-stage OS code (like boot sectors) when CX-based looping is enough.
* When you want minimal code footprint for simple loops without flag interference.

---

## Best Practices

* Make sure to initialize CX/ECX/RCX before entering the loop.
* Prefer `LOOP` when loops are simple and size matters; it packs decrement and branch into one instruction.
* For more flexibility or condition-based loops, consider `DEC reg` + `JNZ` instead.
* Confirm your assembler uses the correct `CX/ECX/RCX` based on code segment mode.

---

## Common Pitfalls

* **Counter zero wrap:** If CX/ECX/RCX starts at zero, decrementing wraps around (e.g., 0→0xFFFF), causing a huge loop.
* **Flag misuse:** `LOOP` does not update flags; don’t rely on ZF or others for its behavior.
* **Size mismatch:** Using 16-bit `CX` in 32-bit code will not work unless you explicitly override the address size.
* **Displacement limited:** Jump displacement must fit in signed 8‑bit range (±128 bytes); long loops may not assemble.

---

## Notes and References

+ Additional insight: `loop` is effectively `dec cx` / `jnz label` wrapped into one instruction.
+ See [this file](../../Q&A/04_how_to_override_address_size.md) to learn how to override the address size; for example, how to force the use of `CX` in 32-bit mode or `ECX` in 64-bit mode.
+ [felixcloutier.com](https://www.felixcloutier.com/x86/loop:loopcc)

---
