# `ADD`

> **Random Quote**: Small disciplines repeated with consistency every day lead to great achievements gained slowly over time.

## Key Topics

+ [Overview](#overview)
+ [Syntax](#syntax)
    - [Examples](#examples)
+ [Behavior](#behavior)
    - [Flags Affected](#flags-affected)
+ [Real-Mode Use Cases](#real-mode-use-cases)
+ [Common Pitfalls](#common-pitfalls)

---

## Overview

The `ADD` instruction performs integer addition of the source operand to the destination operand, with the result **replacing the destination**.

`ADD` has a variable size, generally ranging from **1 to 4 bytes**, depending on the operand types.

---

## Syntax

```assembly
add destination, source
```

+ `destination`: Register or memory location containing an integer.
+ `source`: Register, memory location, or immediate constant.

**Note**: You cannot have memory locations for both operands at the same time.

```assembly
add [mem1], [mem2]  ; Invalid because both operands are memory locations.
```

### Examples

```assembly
; Register to register.
add ax, bx      ; AX = AX + BX

; Immediate to register.
add eax, 10     ; EAX = EAX + 10

; Memory to register.
add ax, [var]   ; AX = AX + word at var

; Register to memory.
add [var], cl   ; byte at var = byte at var + CL
```

---

## Behavior

+ The result is stored in the destination operand.
+ Handles both signed and unsigned integers.
+ When an immediate constant is used, it is **sign-extended** to the destination operand size.
+ In protected mode, `ADD` can raise faults if memory is invalid (e.g. #GP, #SS, #PF).
+ Supports a `LOCK` prefix for atomic usage in multiprocessing environments.

### Flags Affected

This instruction updates the following flags based on the result:

+ **CF (Carry Flag)**: Set if unsigned overflow occurs.
+ **OF (Overflow Flag)**: Set if signed overflow occurs.
+ **ZF (Zero Flag)**: Set if the result is zero.
+ **SF (Sign Flag)**: Reflects the sign bit of the result.
+ **AF (Auxiliary Carry Flag)**: Set if a nibble (4-bit) carry occurs.
+ **PF (Parity Flag)**: Set if the low byte of the result has even parity.

These flags are crucial for conditional branching and multi-word arithmetic.

---

## Real-Mode Use Cases

+ Increment pixel counters or row and column indices in early graphics routines.
+ Update loop counters in BIOS or bootloader code.
+ Adjust the stack pointer after function calls or when preserving or releasing local storage.
+ Increment disk sector offsets or memory pointers.

---

## Common Pitfalls

+ Attempting to use two memory operands in a single `ADD` instruction.
+ Forgetting that the result overwrites the destination operand. If the original value is needed later, store it elsewhere first.
+ Misinterpreting the effect on flags. Remember that `ADD` modifies several status flags, which can unintentionally affect subsequent conditional jumps.
+ Using immediate values without considering sign extensions. Ensure the immediate constant fits the intended operand size toa void unexpected results.
+ Applying `ADD` in protected mode without valid memory access. Invalid segment selectors or page faults can cause exceptions.

---
