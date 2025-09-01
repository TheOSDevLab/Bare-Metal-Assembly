# `CALL`

> **Random Quote**: Turn your wounds into wisdom.

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

The `CALL` instruction initiates a subroutine invocation by pushing the return address onto the stack and then transferring control to the specified procedure. It exists to implement structured control flow and support function calls, including proper return sequencing. It preserves the return point by saving the instruction pointer before branching.  

### How It Works

- The processor **pushes the address of the instruction following the `CALL`** (i.e., the return address) onto the stack, effectively saving the return point.  
- Control is then transferred to the **target address**, which may be specified in different ways:
  - **Near call** (within the same code segment): uses absolute or PC-relative offsets.  
  - **Far call** (switching segments): pushes both code segment (`CS`) and instruction pointer (`IP`/`EIP`/`RIP`) for later return.  
- **Flags** are unaffected by the `CALL` instruction.

---

## Syntax

```asm
CALL target
```

* `target` can be:

  * A label for **PC-relative near call**,
  * A register or memory operand for an **indirect near call**,
  * A pointer to a far code segment and offset for **far call**.
* Only **one operand** is allowed.
* Operand size (16-bit, 32-bit, 64-bit) determines the type of call executed. In 64-bit mode, near calls use a 32-bit signed displacement sign-extended to 64 bits.

### Instruction Size

* Encoding depends on the call type:

  * **Near, relative**:

    * `E8 cw`: relative 16-bit displacement
    * `E8 cd`: relative 32-bit displacement
  * **Indirect near**: `FF /2`, via ModR/M
  * **Far, absolute**: `9A cd/cp` or via memory operands (`FF /3`)
* No `LOCK` prefix applies to `CALL`.

---

## Examples

```asm
; Near relative call
call subroutine_label

; Indirect near call
call eax             ; transfers control to address in EAX

; Far absolute call (e.g., real mode or protected mode)
call far ptr 0x08:0x1234 
```

```asm
; Basic function invocation with return
call print_hello
; … code resumes here after subroutine returns
```

---

## Practical Use Cases

* Implements **function or procedure calls**, facilitating structured and reusable code.
* Essential in **calling conventions** (e.g., CDECL), supporting:

  * Argument passing (typically via stack),
  * Return address handling,
  * Register preservation,
  * Compatible interface with high-level languages.

---

## Best Practices

* Use near relative calls (`call label`) when invoking local functions; efficient and easier to assemble.
* Adhere to calling conventions:

  * **Push arguments in reverse order**,
  * Save caller-saved registers (`EAX`, `ECX`, `EDX`) if needed,
  * Clean up stack after return when required (caller-clean or callee-clean conventions).
* In x86-64, leverage **register-based argument passing** (`RDI`, `RSI`, etc.) and only push extra arguments when needed.

---

## Common Pitfalls

* **Incorrect stack cleanup**; failing to balance `CALL` with proper cleanup (e.g., using `RET` vs `RETN`) leads to stack corruption.
* **Far calls across privilege levels** require careful setup (e.g., using call gates for protected mode transitions), with risks of faults if misused.
* **Incorrect argument ordering**; pushing arguments in the wrong order yields incorrect parameter passing.
* Neglecting **64-bit return value conventions** (e.g., using `RAX`) can cause data miscommunication.

---
