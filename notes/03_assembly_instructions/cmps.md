# `CMPSB` / `CMPSW` / `CMPSD`

> **Random Quote**: A stumble may prevent a fall.

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

The `CMPS` instruction family compares the data at `DS:SI` with that at `ES:DI`, using a subtraction operation without storing the result; only flags are affected.  
It exists to perform fast, hardware-controlled element-by-element comparison of memory blocks.  
Key behavior: both SI and DI advance (or retreat) based on data size and direction flag (`DF`), and processor flags such as ZF, CF, SF, etc. are updated.

### How It Works

- CPU performs `DS:SI - ES:DI` (byte for `CMPSB`, word for `CMPSW`, doubleword for `CMPSD`).
- The result is not saved; only status flags (`ZF`, `SF`, `CF`, `OF`, `AF`, `PF`) are set accordingly.  
- Both SI and DI are adjusted by 1, 2, or 4 bytes depending on the variant and whether the Direction Flag (`DF`) is clear (`CLD`) or set (`STD`).  

---

## Syntax

```asm
CMPSB      ; byte compare
CMPSW      ; word compare
CMPSD      ; doubleword compare (80386+)
```

* **Variants**:

  * `CMPSB`: compares one byte from `DS:SI` to `ES:DI`.
  * `CMPSW`: compares one word from `DS:SI` to `ES:DI`.
  * `CMPSD`: compares one doubleword from `DS:SI` to `ES:DI`.

**Implicit operands**:

* Source: `DS:SI` (optionally with segment override).
* Destination: `ES:DI` (cannot be overridden).

### Instruction Size

* Single-byte opcode:

  * `CMPSB` → opcode `A6`
  * `CMPSW` → opcode `A7`
  * (`CMPSD` and others are mode-dependent and beyond pure 16-bit real mode.)
* Can be prefixed by `REPE/REPZ` or `REPNE/REPNZ` to repeat based on `CX` and `ZF`.

---

## Examples

```asm
; Compare two buffers byte-by-byte
cld                     ; ensure forward direction
mov si, buf1
mov di, buf2
mov cx, 100             ; number of bytes to compare
repe cmpsb              ; repeat while equal and CX > 0

; Compare words until mismatch
cld
mov si, buf1w
mov di, buf2w
mov cx, 50              ; number of words
repne cmpsw             ; repeat while not equal and CX > 0

; Single compare
cld
mov si, src
mov di, dst
cmpsb                   ; sets flags, SI++, DI++
```

These operations update SI and DI, affect flags based on subtraction, and allow concise string handling.

---

## Practical Use Cases

* **Bootloader buffer comparison**: check for identical blocks (e.g., validate MBR contents, compare directory entries).
* **String searching or validation**: locate specific sequences or confirm buffer equivalence efficiently.
* **Compact logic**: avoids manual loop and pointer arithmetic in tight 16-bit real-mode environments.

---

## Best Practices

* Initialize `DS`/`ES`, `SI`/`DI`, and `CX` before using with `REPE/REPNE`.
* Clear or set `DF` with `CLD` or `STD` depending on copy direction.
* Choose the variant (`CMPSB` vs `CMPSW`) matching data alignment to avoid logic errors.
* After repetition, inspect `ZF` and `CX` to determine whether the loop ended due to mismatch or count exhaustion.

---

## Common Pitfalls

* Using explicit operand syntax (`CMPS [label], [label2]`) is misleading; the instruction always uses `DS:SI` and `ES:DI`.
* Forgetting to set `DF` may cause backward pointer movement and unpredictable behavior.
* Using the wrong variant can skew offset calculations and logic (e.g., mixing `CMPSW` for byte comparisons).
* Assumptions about flags: only flags are updated; no data is stored, so logic must be based on flag conditions.
* Using doubleword variant (`CMPSD`) in pure 16-bit real mode is invalid on pre-80386 CPUs.

---
