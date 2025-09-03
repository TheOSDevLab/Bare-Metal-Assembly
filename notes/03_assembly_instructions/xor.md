# `XOR`

> **Random Quote**: Motivation gets you going, but discipline keeps you growing.

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

`XOR` performs a **bitwise exclusive OR** between two operands and stores the result in the destination. It exists for fine-grained bit manipulation; masking, toggling, and constructing logic without arithmetic side effects. The operation deterministically updates condition flags (e.g., clears `CF`/`OF`, sets `ZF`/`SF`/`PF` based on the result).

### How It Works

+ Conceptually, each result bit is `1` iff the corresponding bits of the operands differ; otherwise it is `0`.
+ The CPU writes the result back to the destination operand and updates flags:
    - **`CF=0`**
    - **`OF=0`**
    - **`ZF`** set if result is zero
    - **`SF`** mirrors the sign bit
    - **`PF`** reflects even parity of the low byte
    - **`AF`** is undefined.

---

## Syntax
```asm
XOR destination, source
```

* `destination`: register or memory.
* `source`: register, memory, or immediate (various encodings).
* **Restriction**: you cannot use **two memory operands** in the same `XOR`.

### Instruction Size

* **Register-register / register-memory** encodings are typically **2–3 bytes** (plus any address-size/index bytes).
* **Immediate forms** vary with width; special encodings exist for `XOR AL, imm8` (`34 ib`) and `XOR rAX, imm` (`35 iw/id`). Group-1 encodings handle `XOR r/m, imm` (`80/6`, `81/6`, `83/6`).
* **LOCK** prefix is **allowed** when the destination is memory, making the read-modify-write atomic.

---

## Examples

```asm
; --- Masking & zeroing ---
xor ax, ax           ; zero AX (ZF=1, SF=0). Clobbers flags.
and al, 0x0F         ; keep low nibble after zeroing example

; --- Toggle specific bits: flip bit 5 to switch ASCII case (a<->A) ---
mov al, 'a'          ; 0x61
xor al, 0x20         ; 0x41 ('A')

; --- Preserve/clear selected bits: turn on bits via OR, toggle via XOR ---
mov bl, 0b10101010
xor bl, 0b00000111   ; toggles low 3 bits

; --- Memory destination (read-modify-write); lockable on x86 ---
; xor byte [flags], 1         ; toggle LSB in memory
; LOCK xor byte [shared], 1   ; atomic toggle on shared memory (SMP)

; --- Equality trick (destructive): sets ZF if operands equal, but changes DEST ---
mov cx, 0x1234
xor cx, 0x1234       ; CX becomes 0; ZF=1. (Prefer CMP/TEST for non-destructive check.)
```

---

## Practical Use Cases

* **Zeroing idiom**: `xor reg, reg` is the canonical way to set a register to zero; CPUs recognize it as dependency-breaking, often faster/shorter than `mov reg, 0`; useful on hot paths. *(Beware: it clobbers flags.)*
* **Bit toggling and feature flags**: flip configuration bits in device/status bytes without altering others.
* **Atomic bit manipulation**: with a memory destination and `LOCK`, safely toggle shared flags in multiprocessor code.

---

## Best Practices

* Use **`xor reg, reg`** for fast zeroing when you **do not** need to preserve flags; otherwise prefer **`mov reg, 0`** (MOV doesn’t affect flags).
* For **tests** that should not modify the operand, use **`TEST`** (non-destructive AND that sets flags) rather than `XOR` with zero.
* If multiple threads may write the same memory, use **`LOCK`** with a memory destination to ensure atomicity (and consider wider synchronization strategy).

---

## Common Pitfalls

* **Relying on carry/overflow**: `XOR` **always clears** `CF` and `OF`; do not read them after `XOR`.
* **Accidental data destruction**: `XOR` writes the destination. If you only need flags, use `TEST`; if you need equality comparison, use `CMP`.
* **Aliasing with XOR-swap**: the classic three-step `XOR` swap is fragile (breaks if operands alias) and slower than `XCHG`/`MOV`; avoid it in modern code.

---
