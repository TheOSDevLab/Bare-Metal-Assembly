# LOOPE / LOOPZ

> **Random Quote:** Success is not final, failure is not fatal: It is the courage to continue that counts.

## Key Topics

- [Overview](#overview)
    - [How It Works](#how-it-works)
- [Syntax](#syntax)
    - [Instruction Size](#instruction-size)
- [Examples](#examples)
- [Practical Use Cases](#practical-use-cases)
- [Best Practices](#best‑practices)
- [Common Pitfalls](#common‑pitfalls)

---

## Overview

LOOPE (also named LOOPZ) decrements the **CX** register and jumps if the result is **not zero** *and* **Zero Flag (ZF) = 1**. It exists to support counted loops that depend on a flag condition. It's ideal when you want to repeat while equality (ZF) holds.

### How It Works

- CPU decrements CX by 1.
- Checks if CX != 0 **and** ZF = 1.
- If both true, jump to the target label; else, fall through.
- Flags are not modified by the instruction itself.
- Uses CX in 16‑bit real mode.

---

## Syntax

```asm
LOOPE label

; or

LOOPZ label
```

* `label`: the destination if the loop continues.
* No source operand; always targets CX for counter and uses existing ZF.

### Instruction Size

* **Size**: 2 bytes; opcode + signed 8-bit displacement (label).
* No LOCK prefix or operand-size variants in real mode.
* Same opcode for both mnemonics (`LOOPE` and `LOOPZ`).

---

## Examples

```asm
mov cx, 5
start:
    cmp [some_var], ax   ; maybe sets ZF
    LOOPE start
```

```asm
; Compare up to MAXLEN bytes of strings at DS:SI and ES:DI
; Stop early if a mismatch is found.

mov     cx, MAXLEN     ; number of characters to compare
mov     si, str1
mov     di, str2

compare_loop:
    mov     al, [si]   ; load byte from string1
    cmp     al, [di]   ; compare to byte from string2 --> sets ZF
    loope   compare_loop  ; same as LOOPZ: loop while equal (ZF=1) AND CX != 0
    ; Fallthrough here on mismatch or after CX expires
```

---

## Practical Use Cases

* **String processing in real mode**: repeat operations while ZF indicates match (e.g., copying similar bytes).
* **Equality‑based loops**: repeatedly process until a condition fails.
* Useful in BIOS or simple bootloader code written in 16-bit NASM.

---

## Best Practices

* Use only when both a count and equality condition apply.
* Avoid modifying CX or flags inside the loop in ways that invalidate the logic.
* Combine with `CMP` or string instructions (`LODS`, `SCAS`, etc.) to update ZF properly before looping.
* Prefer explicit `DEC` + `JNZ` if flag-checking logic is more complex than just ZF.

---

## Common Pitfalls

* Assuming it checks ZF before decrementing CX; it doesn’t. Decrement happens first.
* If CX initial value is zero, decrement wraps around (to 0xFFFF), so loop runs 65,535 times!
* Using in 16-bit mode but expecting 32-bit behavior; register size matters.
* Forgetting that flags inside the loop must be maintained correctly between iterations.

---

## Notes and References

* Intel's ASM86 manual defines LOOPE (LOOPZ) behavior for 8086/8088. ([community.intel.com download link][https://community.intel.com/cipcp26785/attachments/cipcp26785/c-compiler/31103/1/121703-003_ASM86_Language_Reference_Manual_Nov83.pdf])

