# `INT`

> **Random Quote:** Hard work beats talent when talent doesn't work hard.

## Key Topics

- [Overview](#overview)
    - [How It Works](#how-it-works)
- [Syntax](#syntax)
    - [Instruction Size](#instruction-size)
- [Examples](#examples)
- [Practical Use Cases](#practical-use-cases)
- [Best Practices](#best-practices)
- [Common Pitfalls](#common-pitfalls)
- [Notes and Reference](#notes-and-reference)

---

## Overview

The `INT` instruction triggers a **software interrupt**, transferring control to an interrupt handler defined in the **Interrupt Vector Table (IVT)**. It provides a mechanism to invoke system-level functionality from user code, especially useful in real-mode environments like BIOS calls.

### How It Works

+ The CPU pushes `FLAGS`, `CS`, and `IP` onto the stack to save the current execution state.
+ It disables further maskable interrupts by clearing the **IF** (Interrupt Flag) and **TF** (Trap Flag).
+ It fetches the interrupt handler's address from the IVT using the given interrupt number.
+ Control is transferred to the handler at the fetched address.
+ The handler typically ends with `IRET`, restoring the previous state and resuming execution.

---

## Syntax

```asm
int interrupt_number
````

* `interrupt_number`: An immediate value (0-255) specifying the index into the IVT.
* Only immediate values are allowed; you cannot use a register or memory as the operand.

### Instruction Size

* `INT n` => `CD nn`: 2 bytes
* `INT 3` => `CC` (special one-byte encoding for breakpoints)

---

## Examples

```asm
; Teletype output using BIOS
mov ah, 0x0E
mov al, 'A'
mov bh, 0
int 0x10

; Software breakpoint
int 0x03
```

---

## Practical Use Cases

* **BIOS service calls** in real mode (e.g., printing text, reading sectors, checking hardware).
* **Debugging**: inserting `INT 3` to create software breakpoints.
* **Exception simulation** for testing interrupt handlers or system fault responses.
* **System calls** in simple operating systems via `INT` instructions.

---

## Best Practices

* Use only **immediate operands** and verify that the interrupt number is correctly mapped in the IVT.
* Always ensure that the interrupt handler ends with `IRET`, not `RET`.
* Document which registers the handler modifies or preserves, especially in custom OS development.
* Use `INT` judiciously in performance-critical paths due to its relatively high overhead.

---

## Common Pitfalls

* **Using RET instead of IRET** in handlers, leading to stack corruption.
* **Calling undefined or uninitialized vectors**, resulting in crashes or erratic behavior.
* Misunderstanding **INT vs hardware interrupts** (e.g., `INT` is software-driven; hardware IRQs are external events).
* Relying on `INT` in protected mode without proper IDT setup, which causes general protection faults.
* Forgetting that `INT` disables further interrupts until re-enabled manually or by IRET.

---

## Notes and Reference

* `INT` behavior differs significantly between **real mode** (BIOS/IVT) and **protected mode** (IDT and privilege levels).
* Special case: `INT 3` (`0xCC`) is optimized for debuggers and occupies only one byte.
* Reference: [Intel® Software Developer’s Manual, Vol. 2: Instruction Set Reference - INT](https://www.felixcloutier.com/x86/int)

---
