# `ADD`

> **Random Quote**: Small disciplines repeated with consistency every day lead to great achievements gained slowly over time.

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

The `ADD` instruction performs an integer addition of two operands and stores the result in the destination.

### How It Works

When `ADD` is executed:

- The CPU reads the values of the source and destination operands.
- It adds them and stores the result in the destination operand.
- It sets or clears CPU flags based on the outcome.
- The instruction supports signed and unsigned values and can be used with 8-bit, 16-bit, 32-bit, and 64-bit operands.
- If the source is an immediate value, it is **sign-extended** to match the size of the destination.

**Note**: `ADD` does not preserve the original destination value. Use a copy if needed later.

---

## Syntax

```asm
add destination, source
```

+ `destination`: A register or memory location that will hold the result.
+ `source`: A register, memory location, or immediate constant.
+ **Restrictions**: You cannot use two memory operands in a single instruction.

```asm
add [mem1], [mem2]  ; Invalid!
```

### Instruction Size

+ Typically 1-4 bytes, depending on operand size and addressing mode.
+ Encodings vary: register-to-register is shortest, memory-to-memory is invalid, and memory-to-register incurs additional bytes for addressing.
+ Supports the `LOCK` prefix for atomic operations on shared memory in multiprocessor environments.

---

## Examples

```asm
; Register to register
add ax, bx      ; AX = AX + BX

; Immediate to register
add eax, 10     ; EAX = EAX + 10

; Memory to register
add ax, [var]   ; AX = AX + word at var

; Register to memory
add [var], cl   ; byte at var = byte at var + CL
```

---

## Practical Use Cases

+ Updating **loop counters** in iteration logic.
+ Adjusting **pointers or offsets** in memory for buffer traversal.
+ Performing **basic arithmetic** in bootloaders or BIOS routines.
+ Managing **stack pointer (SP/BP)** during procedure prologue/epilogue.
+ Incrementing **disk sectors or segment offsets** for I/O operations.

---

## Best Practices

+ **Preserve the destination** if you need its original value after the operation.
+ Use `ADD` to adjust pointers instead of `MOV` + `ADD` if offsets are small and immediate.
+ Pair with `ADC` for multi-word arithmetic (carry-aware addition).
+ Use with care inside critical sections or shared memory regions; prefix with `LOCK` if atomicity is required.

---

## Common Pitfalls

+ **Invalid memory-memory operand**: Both operands cannot reference memory.
+ **Silent flag changes**: `ADD` modifies multiple flags, which may affect jumps and conditional logic.
+ **Unexpected sign extension**: Immediate values are sign-extended; be mindful of operand sizes.
+ **Overwriting the destination**: The original destination value is lost unless stored first.
+ **Faults in protected mode**: If memory is not mapped or accessible, `ADD` can raise a general protection fault or page fault.

---

## Notes and Reference

* [felixcloutier.com](https://www.felixcloutier.com/x86/add)

---