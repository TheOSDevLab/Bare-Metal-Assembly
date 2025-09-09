# `SCASB` / `SCASW` / `SCASD`

> **Random Quote**: Only those who dare to fail greatly can ever achieve greatly.

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

The `SCAS` family (Scan String) compares the accumulator (`AL`, `AX`, or `EAX`) to the memory value at `ES:DI`, automatically updating the pointer afterwards.  
Its purpose is to locate data within a buffer by scanning sequential elements.  
Key behavior: flags are set based on the subtraction result; pointer updates depend on data size and the Direction Flag (`DF`).

---

### How It Works

On each execution:
- CPU computes `accumulator - [ES:DI]` and sets status flags (`ZF`, `SF`, `CF`, `OF`, `AF`, `PF`).
- `DI` (or `EDI`) is then incremented (if `DF = 0`) or decremented (if `DF = 1`) by:
  - 1 byte for `SCASB`
  - 2 bytes for `SCASW`
  - 4 bytes for `SCASD` (80386+ only)

Flags affected include all arithmetic flags, reflecting the subtraction outcome.  

---

## Syntax

```asm
SCASB      ; Compare AL with byte at ES:DI
SCASW      ; Compare AX with word at ES:DI
SCASD      ; Compare EAX with dword at ES:DI (80386+)
```

* **Variants**:

  * `SCASB`: byte comparison (AL vs ES\:DI)
  * `SCASW`: word comparison (AX vs ES\:DI)
  * `SCASD`: doubleword comparison (EAX vs ES\:DI)

**Implicit operands**:

* Destination memory: `ES:DI`
* Source register: `AL`, `AX`, or `EAX`

**Note**: Must initialize `ES` and `DI` correctly.

### Instruction Size

* Each variant is a **single-byte opcode** in real mode (`AE` for `SCASB`, `AF` for `SCASW/SCASD`).
* It can be used with `REP`, `REPE/REPZ`, or `REPNE/REPNZ` prefixes to repeat until count runs out or flags change.

---

## Examples

```asm
; Example 1: Find a byte value in memory
cld                     ; forward direction
mov al, target_byte
mov di, buf
mov cx, 100             ; max comparisons
repne scasb             ; repeat while not equal and CX > 0

; Example 2: Find first matching word
cld
mov ax, 0xABCD
mov di, buf16
mov cx, 50
repe scasw              ; repeat while equal and CX > 0

; Example 3: Reverse scan
std                     ; backward direction
mov al, target
mov di, buf_end
repeat scanning code...
```

`DI` adjusts by data size automatically.
Flags reflect the result of each comparison.

---

## Practical Use Cases

* **Bootloader sector scanning**: locate magic numbers, filesystem signatures, or structure headers.
* **Pattern detection**: quickly identify delimiters or special bytes/words in loaded data buffers.
* **Efficient loops**: using hardware-driven comparisons avoids manual loops and flag checks.

---

## Best Practices

* Initialize:

  * `ES` and `DI` for memory location.
  * `DF` with `CLD` (forward) or `STD` (backward).
* Use appropriate variant (`SCASB` vs `SCASW`) for data alignment.
* Combine with `REPE/REPNE` to handle large scans efficiently.
* After completion, inspect `ZF` and `CX` to distinguish match found vs count exhausted.

---

## Common Pitfalls

* Incorrect `DF` setting: can reverse scan direction unintentionally.
* Using `SCASD` in pre-80386 real mode; unsupported.
* Overreliance on `REP SCAS` without checking flags between iterations; exits may occur unexpectedly if flag conditions are misinterpreted.

---
