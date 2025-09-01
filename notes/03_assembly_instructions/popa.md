# `POPA`

> **Random Quote**: Happiness depends upon ourselves.

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

`POPA` (16-bit) and `POPAD` (32-bit) restore the state of all general-purpose registers by popping values from the stack in a specific sequence. They reverse the operation of `PUSHA`/`PUSHAD`, facilitating rapid register state restoration following bulk pushes.

### How It Works

- The processor sequentially pops values from the stack into the registers in the following order:
  - **POPA (16-bit):** `DI`, `SI`, `BP`, (ignored `SP`), `BX`, `DX`, `CX`, `AX`  
  - **POPAD (32-bit):** `EDI`, `ESI`, `EBP`, (ignored `ESP`), `EBX`, `EDX`, `ECX`, `EAX`  
- The value corresponding to `SP` or `ESP` is discarded and not reloaded. Instead, the stack pointer is adjusted naturally after each pop.  
- No CPU flags are modified by the instruction.  

---

## Syntax

```asm
POPA
POPAD
```

* These instructions take **no operands**.
* `POPA` is used under 16-bit operand-size mode, while `POPAD` is used in 32-bit mode. Certain assemblers may treat them as synonymous and rely on the current operand-size attribute.

### Instruction Size

* Both instructions are encoded with a **single opcode byte** (`0x61`).
* They are invalid in **64-bit mode** and will raise an undefined instruction exception (`#UD`).

---

## Examples

```asm
; 16-bit real mode
bits 16

pusha
; ... operations that modify registers ...
popa  ; Restores registers: DI, SI, BP, BX, DX, CX, AX
```

```asm
; 32-bit protected mode
bits 32

pushad
; ... operations that modify registers ...
popad  ; Restores registers: EDI, ESI, EBP, EBX, EDX, ECX, EAX
```

---

## Practical Use Cases

* **Context restoration** in interrupt service routines or function epilogues, allowing rapid recovery of register state.
* **Debugging or checkpointing**, where one captures and later restores the CPU state in bulk.
* **Legacy code patterns**, especially in real-mode or early-protected-mode assembler programming.

---

## Best Practices

* Always pair `POPAD` with its counterpart `PUSHAD` (and `POPA` with `PUSHA`) to maintain stack integrity.
* Reserve usage for scenarios where saving and restoring all general-purpose registers is justified, aiming for clarity over performance.
* Be explicit about operand-size mode to prevent assembler misinterpretation (`POPA` vs. `POPAD`).

---

## Common Pitfalls

* **Unsupported in 64-bit mode**; attempting to execute these in x86-64 will generate a fault.
* **Ignored stack slot**; the value corresponding to `SP`/`ESP` is discarded. If manual pushes were interleaved, stack alignment may be disrupted.
* **Performance inefficiency**; on modern CPUs, these instructions are microcoded and slow; manual register pushes/pops are often faster and more flexible.

---
