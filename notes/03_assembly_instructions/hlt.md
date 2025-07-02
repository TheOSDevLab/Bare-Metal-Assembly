# `HLT`

> **Random Quote:** You will never always be motivated, so you must learn to be disciplined.

## Key Topics

+ [Overview](#overview)
    - [Syntax](#syntax)
+ [Examples](#examples)

---

## Overview

The `HLT` instruction is a single-byte x86 instruction that causes the CPU to stop executing instructions until it receives a hardware interrupt.

**How it works**:

+ When `HLT` is executed, the processor suspends instruction execution.
+ The CPU remains in this halted state until a hardware interrupt occurs (e.g., from the timer, keyboard, or another I/O device).
+ Upon receiving an interrupt, the processor resumes normal execution by invoking the corresponding interrupt handler.

**Note:** The CPU must have interrupts enabled for `HLT` to resume on interrupt. If interrupts are disabled and `HLT` is executed, the system may lock up or hang indefinitely.

**When to use `HLT`**:

+ **In idle loops**. This reduces CPU usage while waiting for input or events.
+ **Bootloader termination**. Ends execution after loading or displaying something.
+ **Error states**. Cleanly stops the system if it cannot continue after a critical error.
+ **Bare-metal Testing**. Prevents the CPU from running garbage if control falls through unintended code.

**Instruction size**:

+ `HLT` is only **1 byte** in size. Its machine code is `0xF4` in hex.
+ This makes `HLT` very space-efficient, especially in size-constrained environments like boot sectors.

### Syntax

```asm
hlt
```

+ No operands.
+ No prefixes.
+ Not affected by or affecting the CPU flags.

---

## Examples

### Bootloader Termination

```asm
hang:
    cli         ; Clear interrupts.
    hlt         ; Halt CPU (won't wake unless NMIs).
```

This can serve as the end of a simple test bootloader. It halts the CPU, keeping the processor in an idle state.

### Idle Routine in a Kernel

```asm
idle:
    sti         ; Enable interrupts.
    hlt         ; Halt until next interrupt.
    jmp idle    ; Return to idle loop.
```

This code continuously halts the processor until an interrupt wakes it, then returns to the halt loop.

### Safe Stop After Error

```asm
error_halt:
    cli     ; Disable interrupts.
    hlt     ; Halt the CPU.
    jmp $   ; Infinite loop (fallback).
```

---
