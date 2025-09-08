# `REPNE` / `REPNZ`

> **Random Quote**: It always seems impossible until it's done.

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

`REPNE` (also known as `REPNZ`) repeats a string operation as long as CX > 0 and the Zero Flag (ZF) remains clear (ZF = 0).  
Its purpose is to scan or compare memory until a match is found or the count expires.  

---

### How It Works

+ The CPU uses CX as a repeat counter. On each pass:
    - It first checks if CX is zero; if so, repetition stops.
    - Otherwise, it executes the following string instruction (typically `SCAS` or `CMPS`).
    - CX is decremented.
    - If ZF becomes set; meaning the comparison yielded equality, repetition stops.
+ Thus, `REPNE` limits execution to when the compared elements are not equal and unprocessed count remains.  
+ This hardware-controlled looping benefits interrupt handling: if an interrupt occurs, the state (including CX, registers, flags, and IP) is preserved for resumption.

---

## Syntax

```asm
REPNE CMPSB
REPNZ SCASW
```

* **REPNE / REPNZ**: Prefix meaning “repeat while not equal / not zero.”
* **String instruction**: Must be one of `CMPSB`, `CMPSW`, `SCASB`, `SCASW`.

  * `CMPS` compares the bytes/words at DS\:SI and ES\:DI.
  * `SCAS` compares AL/AX with ES\:DI memory.

**Restrictions:**

* Only valid when used with string comparison or scan instructions.
* Use with other instructions results in undefined or unpredictable behavior.

### Instruction Size

* `REPNE` / `REPNZ` is a **1-byte prefix**: 0xF2 in 16-bit mode.
* It precedes the string instruction opcode, for example `F2 AE` for `REPNE SCASB`.
* No `LOCK` prefix applicability; strictly for string operations.

---

## Examples

```asm
; Example 1: Search for a byte in memory
cld                   ; clear direction flag
mov cx, 100          ; maximum comparisons
mov al, target_byte
repne scasb           ; scan until AL = [ES:DI] or CX = 0

; Example 2: Compare two buffers for first difference
cld
mov cx, 50           ; number of word comparisons
repne cmpsw           ; repeat while words are unequal and CX > 0

; Example 3: Zero count behavior
mov cx, 0
repne scasb           ; does nothing; ZF remains unchanged
```

---

## Practical Use Cases

* **Bootloader scanning**: quickly find a signature byte (like a file system marker) within a sector.
* **Buffer scanning**: locate the first matching value across memory; such as a delimiter or magic constant.
* `REPNE` allows concise, hardware-accelerated scanning loops in size-limited real-mode code.

---

## Best Practices

* Always **initialize CX** properly and **clear the direction flag** (`CLD`) before usage.
* Choose correct operand size (`SCASB` vs `SCASW`); remember CX counts elements, not bytes.
* After the loop, check CX (e.g., with `JCXZ`) or ZF (`JZ` / `JNZ`) to determine whether match was found or count expired.
* Place the instruction early to allow timely interrupt response and resumption of state.

---

## Common Pitfalls

* Using `REPNE` with non-string instructions leads to **undefined or unreliable behavior**. On early Intel CPUs, this might even flip sign bits unexpectedly.
* ZF assumptions: if CX starts as zero, the instruction is skipped and ZF remains whatever it was before.

---
