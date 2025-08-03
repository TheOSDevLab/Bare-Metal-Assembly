# How to Control the Register Used by `LOOP` via Address-Size Override

> **Random Quote**: The only limit to our realization of tomorrow is our doubts of today.

## Overview

+ On x86_64 systems without any override, `LOOP` uses `RCX` as the counter.
+ In 32-bit mode, `LOOP` defaults to `ECX`.
+ In 16-bit mode, it uses `CX`.
+ You can override this behavior using the address-size override prefix (opcode `0x67`), enabled in NASM via `a16` or `a32` directives.

---

## How It Works

+ `LOOP` decrements the appropriate counter register (CX/ECX/RCX) and jumps if the result is not zero.
+ Which register is decremented depends on the current address-size.
+ Applying the `0x67` prefix (using `a16` or `a32`) switches the address-size and forces `LOOP` to use a different register.

---

## Examples

```assembly
[bits 32]
mov cx, 5
label:
    a16 loop label  ; Forces `LOOP` to use CX instead of ECX.
```

```assembly
[bits 64]
mov ecx, 5
label:
    a32 loop label  ; Forces `LOOP` to use ECX instead of RCX.
```

These overrides are made using the `a16` or `a32` directive which instructs the assembler to emit the `0x67` prefix.

---

## Caution

In **64-bit mode**, you cannot use the `a16` prefix to make the `LOOP` instruction operate on the 16-bit `CX` register.

+ The smallest supported address size override in 64-bit mode is **32-bits**.
+ Using `a32` forces `LOOP` to use `ECX` instead of the default `RCX`.
+ Attempting to use `a16` has **no effect** or may result in **undefined behavior**, depending on the assembler or CPU.

**Recommendation**: Only use `a32` in 64-bit mode if you need to target `ECX`. Do not attempt to use `a16` for `CX`.

| Mode      | Default Counter | With `a32` | With `a16` |
|-----------|------------------|------------|------------|
| 64-bit    | `RCX`            | `ECX`      | Not supported |
| 32-bit    | `ECX`            | N/A        | `CX`        |
| 16-bit    | `CX`             | N/A        | `CX`       |

---

## Why Use This?

+ Bootloader and OS-dev code may default to 32-bit mode while still benefiting from 16-bit compatibility, such as using `CX` for compact loop counters.
+ In 64-bit environments, you may need to use `ECX` instead of `RCX` for cases where 32-bit counters are sufficient or preferred.
+ It allows you to write smaller loops and maintain compatibility with older code or certain BIOS routines.

---
