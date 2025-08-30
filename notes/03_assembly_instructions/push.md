# PUSH

> **Random Quote:** In the middle of difficulty lies opportunity. 

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

The `PUSH` instruction places a value onto the system stack, automatically adjusting the stack pointer. It exists to support function calls, parameter passing, and register preservation. Key points: stack grows downward, and `PUSH` is atomic; essential for correct control flow and data integrity.  

### How It Works

- On execution, the stack pointer (`ESP`/`RSP`) is decremented by the operand size (e.g., 2, 4, or 8 bytes depending on mode), and the operand is stored at the new top of the stack.  
- No flags are modified by the `PUSH` instruction.

---

## Syntax

```asm
PUSH operand
```

* `operand` can be:

  * Immediate constant
  * Register (e.g., `EAX`, `AX`, `AL`)
  * Memory location (`[var]`)
* It cannot take two operands or operate on segment registers in 64-bit mode without specific behaviors.

### Instruction Size

* Encodings vary depending on operand type and operand size (8-bit imm, 16/32/64-bit register/memory).
* Typical sizes:

  * Register push: 1 byte (e.g., `PUSH EAX`)
  * Immediate: 2–5 bytes depending on the size of the immediate
* `LOCK` prefix is not applicable.

---

## Examples

```asm
; Push a register
push eax

; Push an immediate value (32-bit)
push 0x1234

; Push a value from memory
push dword [var]

; Push multiple values
push eax
push ebx
```

```asm
; Function call example
call my_function
; Automatically pushes return address onto the stack
```

---

## Practical Use Cases

* **Function Calls**: `CALL` uses `PUSH` internally to store return addresses.
* **Register Preservation**: Save caller’s registers (`push ebx`) before modifier functions and restore them later (`pop ebx`).
* **Stack Frame Creation**: Dynamically manage memory for local variables and function parameters.
* **Immediate Values**: Use `PUSH` for small constants more compactly than `MOV` in shellcode or tight code.

---

## Best Practices

* Use `PUSH` before `CALL` for passing parameters (if implementing cdecl or stack-based calling convention).
* Maintain **stack alignment** (commonly 16-byte aligned in x86-64) after consecutive pushes.
* Avoid pushing large immediates when more efficient patterns exist (e.g., using registers, then pushing the register).

---

## Common Pitfalls

* **Stack Overflow / Underflow**: Excessive pushes without pops or frame unwinding can corrupt memory or cause a crash.
* **Segment Register Behavior in x86-64**: Inconsistent behavior between AMD64 and Intel64 when pushing segment registers, leading to subtle bugs.
* **Memory Operand with Stack Register**: Using stack pointer (`ESP/RSP`) as part of the address in `PUSH` can cause unintended behavior; operand address is calculated before decrementing the pointer.

---
