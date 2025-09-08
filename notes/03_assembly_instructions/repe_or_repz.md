# `REPE` / `REPZ`

> **Random Quote**: The mind is everything. What you think you become.

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

`REPE` (also `REPZ`) repeats a string operation while the count register (CX) is nonzero and the zero flag (ZF) remains set.  
It exists to speed up comparison or scanning of memory regions by halting on the first mismatch or when the buffer ends.  

---

### How It Works

+ The CPU uses CX as the iteration counter. On each iteration:
    - It checks if CX is zero; if so, it stops immediately.
    - Otherwise, it performs the next string comparison or scanning instruction (typically `CMPS` or `SCAS`).
    - CX is decremented.
    - Then ZF is examined; if ZF=0 (meaning no match), repetition stops.
+ Thus, it loops only while CX>0 and successive comparisons match.  

---

## Syntax

```asm
REPE CMPSB
REPE SCASW
```

* **REPE / REPZ**: Prefix indicating “repeat while equal / zero.”
* **String instruction**: Must be `CMPSB`, `CMPSW`, `SCASB`, `SCASW`.

  * CMPS compares memory at \[SI] and \[DI].
  * SCAS compares accumulator (AL/AX) with memory at \[DI].

**Restrictions:**

* Only valid with string comparison or scan instructions.
* Applying it to non-string instructions is undefined; and may produce unpredictable or undocumented results.

### Instruction Size

* `REPE` / `REPZ` is encoded as a **1-byte prefix** (0xF3) in 16-bit mode.
* Follows the string instruction, e.g. `F3 AF` for `REPE SCASW`.
* There is **no LOCK prefix** interaction or alternate encoding here; it is strictly a repetition prefix.

---

## Examples

```asm
; Example 1: Compare two memory areas, byte by byte
cld                  ; ensure forward direction
mov cx, 10          ; number of comparisons
repe cmpsb          ; repeat while equal (ZF = 1) and CX > 0

; Example 2: Scan a word value in memory
cld
mov ax, target_word ; value to match
mov cx, 5           ; number of locations to check
repe scasw          ; scan until not equal or CX = 0

; If CX starts at zero
mov cx, 0
repe cmpsb          ; no comparisons executed; flags remain unchanged
```

---

## Practical Use Cases

* **Bootloader string comparison**: e.g., comparing filenames, matching command keywords.
* **Memory scanning**: searching for a magic number or signature in a region.
* It speeds up loops by letting the hardware do the counting and flag testing in one compact instruction; ideal in constrained 16-bit real-mode environments.

---

## Best Practices

* Always **initialize CX** and **clear direction flag** (`CLD`) before using `REPE`/`REPZ`.
* Use correct size variants (`CMPSB` vs `CMPSW`) so CX counts elements not bytes.
* Use right after setting ZF-relevant data; there is no need to preset ZF.
* After a mismatch, check whether CX expired or ZF changed (e.g., via `JZ` / `JNZ` or `JCXZ`) to handle loop exit reasons.

---

## Common Pitfalls

* Using `REPE` with non-string instructions yields **undefined behavior**; behavior varies by CPU and may corrupt results.
* **Misinterpreting CX**: With `CMPSW`, CX decrements per word, not per byte.
* **ZF assumptions**: If CX starts at zero, the instruction is never executed, and ZF remains whatever it was before; handle accordingly.
* **Interrupt handling**: The CPU preserves state on interrupts; understanding this helps when resuming long comparisons reliably.

---
