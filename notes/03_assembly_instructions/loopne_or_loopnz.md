# `LOOPNE / LOOPNZ`

> **Random Quote:** Your time is limited, so don't waste it living someone else's life.

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

`LOOPNE` (also known as `LOOPNZ`) decrements the **CX** register and jumps to the target label **only if** CX != 0 **and** the **Zero Flag (ZF) == 0**. It's used to repeat a block of code while some comparison remains unequal. This instruction supports counted loops that break on equality.

### How It Works

- CPU **decrements CX** by 1 (CX := CX − 1).
- It then checks two conditions:
  + Is **CX != 0**?
  + Is **ZF == 0** (i.e., last comparison was *not equal*)?
- If **both** conditions are true; jump to label.
- If either condition fails; fall through to the next instruction.
- Instruction itself **does not change flags**.

---

## Syntax
```asm
LOOPNE label

; or

LOOPNZ label
````

* `label`: The jump destination if loop continues.
* Implicitly uses **CX** as the counter and **ZF** from a prior instruction (like `CMP` or `SCASB`).
* No operands besides the label; not valid with memory/immediate.

### Instruction Size

* **2 bytes**: 1 for opcode, 1 for signed 8-bit offset (label).
* Short jump only (±127 bytes).
* Same binary encoding for both names: `LOOPNE` and `LOOPNZ` are aliases.
* No `LOCK` prefix or segment override allowed.

---

## Examples

```asm
mov cx, 5
start:
    cmp al, bl          ; set ZF
    LOOPNE start        ; loop while CX ≠ 0 AND ZF = 0 (i.e. AL != BL)
```

```asm
mov cx, length
mov si, buffer
mov al, 0
scan_loop:
    lodsb
    cmp al, 0xFF
    LOOPNZ scan_loop    ; loop while 0xFF not found and count not exhausted
```

```asm
mov cx, 3
check_bytes:
    scasb               ; compare AL to [DI], update ZF
    LOOPNE check_bytes  ; continue until match or CX runs out
```

---

## Practical Use Cases

* Scanning for the **first matching** byte in a string or memory block.
* Implementing a retry mechanism where you stop on a successful match.
* Real-mode bootloader loops that check flags after port I/O or memory read.
* When you want to stop looping as soon as equality is detected.

---

## Best Practices

* Always set **ZF** intentionally before using this instruction; typically via `CMP`, `SCAS`, or logical tests.
* Avoid altering `CX` or modifying flags mid-loop unless you're sure it’s safe.
* Use `LOOPNE` when you care about **inequality** staying true.
* When scanning for matches, `LOOPNE` pairs well with `SCASB`, `CMP`, or `TEST`.

---

## Common Pitfalls

* **Forgetting to set ZF**: `LOOPNE` checks it, but doesn’t affect it. Without a flag-setting instruction (like `CMP`) before it, behavior is unreliable.
* **Thinking CX=0 still loops**: It doesn’t; `CX` must be non-zero after decrement, or it exits.
* **Confusing with `LOOPE`**: `LOOPNE` loops on *inequality* (`ZF = 0`), `LOOPE` on *equality* (`ZF = 1`).

---