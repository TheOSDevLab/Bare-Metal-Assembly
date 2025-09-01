# PUSHA

> **Random Quote**: Do what you can, with what you have, where you are.

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

The `PUSHA` instruction pushes the full set of 16-bit general-purpose registers onto the stack (in 16-bit mode), capturing the CPU state in one atomic operation. It exists to facilitate rapid context-saving for interrupts, subroutine entry, or debugging, minimizing instruction footprint and preserving register order.

### How It Works

- The CPU computes the original value of `SP` (stack pointer) before pushing starts.
- It then pushes, in order: `AX`, `CX`, `DX`, `BX`, original `SP`, `BP`, `SI`, and `DI`.
- Flags are unaffected by this operation.  
- `PUSHAD` performs the analogous operation in 32-bit mode, pushing `EAX`, `ECX`, `EDX`, `EBX`, original `ESP`, `EBP`, `ESI`, and `EDI`.  

---

## Syntax

```asm
PUSHA
```

* **No operands**; it is a standalone mnemonic.
* Semantic variants:

  * `PUSHA`; used in 16-bit operand-size mode.
  * `PUSHAD`; used in 32-bit operand-size mode.
* Some assemblers treat them as synonyms and rely on current operand-size setting.

### Instruction Size

* Encoded using single-byte opcode `60h`.
* No `LOCK` prefix or other modifiers apply.
* In **real-address mode**, using `PUSHA` when `SP` equals 1, 3, or 5 may cause processor shutdown without generating an exception. In protected mode, such stack conditions may generate a `#SS` shutdown or associated fault.

---

## Examples

```asm
pusha  ; pushes AX, CX, DX, BX, SP (before push), BP, SI, DI
; ... do something ...
popa   ; restores them in reverse order
```

```asm
; 32-bit mode equivalent
bits 32

pushad ; pushes EAX, ECX, EDX, EBX, ESP (before push), EBP, ESI, EDI
popad  ; restores them
```

---

## Practical Use Cases

* **Interrupt service routines** in real-mode or OS kernel code; save all registers quickly without listing each one.
* **Function prologues** when you must preserve entire register state.
* **Debugging or context snapshots**, where a complete register dump is needed for diagnostics.

---

## Best Practices

* Use `PUSHA` / `PUSHAD` when you need to save all general-purpose register state within constrained code (e.g., bootloader or ISR).
* Match with `POPA` / `POPAD` in reverse to correctly restore the order and preserve `SP` integrity (note `SP`/`ESP` is restored to its prior state, not the pushed copy).
* Avoid mixing manual push sequences and `PUSHA` in the same routine to keep stack layout predictable.

---

## Common Pitfalls

* **Mode limitation**: `PUSHA` is *not supported* in 64-bit mode (`RIP`-relative addressing); attempting to use it leads to invalid-opcode exceptions.
* **Stack pointer side-effects**: Since `SP` (or `ESP`) is pushed as its pre-instruction value, misalignment or miscalculation can arise if you manually push/pop registers alongside `PUSHA`.
* **Real-mode hazards**: Executing `PUSHA` when `SP` is low (values like 1, 3, 5) may cause processor shutdown without warnings.

---
