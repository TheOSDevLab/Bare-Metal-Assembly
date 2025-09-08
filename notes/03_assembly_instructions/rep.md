# `REP`

> **Random Quote**: Action is the foundational key to all success.

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

The `REP` prefix repeats a **string operation instruction** until a counter register (CX/ECX/RCX) hits zero.  
It exists to enable fast memory block operations in fewer instructions.  
Key points: It only works with string instructions, and stops when the count reaches zero.

---

### How It Works

Internally, `REP` checks the count register before each iteration; if it's zero, it does nothing. Otherwise, it performs one instance of the following string operation, decrements the count, and may update pointers and flags.  
Flags may be affected by the underlying instruction (e.g., CMPS, SCAS update ZF), but `REP` itself doesn’t modify flags beyond that.  

---

## Syntax

```asm
REP mnemonic
```

* `mnemonic`: a string operation instruction like `MOVSB`, `STOSD`, `LODSW`, `CMPSB`, `SCASD`, `INSW`, `OUTSB`.
* **Restriction**: You cannot use `REP` with non-string instructions; doing so is undefined and may be silently ignored or even produce odd behavior.

### Instruction Size

* `REP` is a 1-byte prefix.
* The actual string instruction may be another byte or more, depending on size (e.g., `MOVSB`, `MOVSW`, etc.).
* No `LOCK` prefix compatibility.

---

## Examples

```asm
; Simple block move: copy CX bytes from DS:SI to ES:DI
cld                 ; clear direction flag (increment SI, DI)
mov cx, 100         ; set counter
rep movsb           ; repeat MOVSB until CX=0

; Word variant (copies CX words)
cld
mov cx, 50
rep movsw
```

---

## Practical Use Cases

* **Memory copying** in OS dev or bootloaders (e.g., copying structures or buffers with minimal code).
* **Initialization or clearing** memory blocks quickly (e.g., `rep stosb` to fill memory).
* **Low-overhead I/O**, like repeating `INS`/`OUTS` instructions; but caution: some ports can’t handle the fast rate of `REP`.

---

## Best Practices

* Always pair `REP` with valid **string instructions**; don’t try putting it on arithmetic or control instructions.
* Set the **direction flag** with `CLD` (forward) or `STD` (backward) as appropriate for memory movement.
* Use the **right operand size** (`MOVSB`, `MOVSW`, `MOVSD`) so the count in CX means the number of elements, not bytes.

---

## Common Pitfalls

* **Using with non-string instructions** is undefined and may break silently.
* **Misinterpreting the count**: With `MOVSW`, `movsw` moves words, so `CX=1` moves 2 bytes.
* **Ignoring direction flag (DF)**: forgetting to `CLD` or `STD` can reverse movement or corrupt memory order.
* **Zero count behavior**: `REP` checks count first; no iterations occur if the counter is already zero.

---
