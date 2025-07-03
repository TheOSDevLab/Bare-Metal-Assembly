# `INT`

> **Random Quote:** Hard work beats talent when talent doesn't work hard.

## Key Topics

+ [Overview](#overview)
    - [Behavior](#behavior)
    - [Use Cases](#use-cases)
    - [Cautions and Restrictions](#cautions-and-restrictions)
    - [Syntax](#syntax)
    - [Instruction Size](#instruction-size)
+ [Examples](#examples)

---

## Overview

The `INT` instruction, short for **interrupt**, is used to perform a software interrupt, a controlled transfer of execution to a predefined address specified in the **Interrupt Vector Table (IVT)**.

### Behavior

1. When the `INT` instruction is executed, the CPU pushes the current `FLAGS`, `CS`, and `IP` registers onto the stack.
2. It **clears the interrupt flag (IF)** and **trap flag (TF)** to prevent other interrupts during handler execution.
3. It loads `CS` and `IP` from the corresponding entry in the **Interrupt Vector Table**, based on the interrupt number.
4. Execution jumps to the address of the interrupt handler.
5. When the handler completes, it typically ends with an `IRET` instruction, which restores the saved state and returns control to the original caller.

### Use Cases

+ **BIOS services:** Used to access video, disk, keyboard, and other low-level hardware services.
+ **System calls:** Used in software-triggered system calls in OS design.
+ **Exception handling:** Exceptions like division by zero, invalid opcode, and others use `INT` internally.
+ **Debugging:** `INT 3` is used as a breakpoint in debuggers.

### Cautions and Restrictions

+ The interrupt handler must end with `IRET`, not `RET`, to properly restore `FLAGS` and resume execution.
+ If you execute `INT` with an undefined or uninitialized interrupt vector, the behavior is undefined and may crash the system.
+ Be cautious when using `INT` in protected mode; its behavior defers and is typically managed through the **IDT (Interrupt Descriptor Table)** and system gates.
+ `INT` is not a high-performance mechanism. It introduces overhead and should be used judiciously in performance-critical code.

### Syntax

```asm
int interrupt_number
```

+ `interrupt_number`: A one-byte value (0-255) that identifies the interrupt vector to invoke. It is usually written in hexadecimal (e.g., `int 0x10`).

**Note:** The instruction takes a single immediate operand, not a register or memory value.

### Instruction Size

| Operand Type      | Machine Code Example | Size    |
| ----------------- | -------------------- | ------- |
| `INT n`           | `CD nn`              | 2 bytes |
| `INT 3` (special) | `CC`                 | 1 byte  |

+ `INT3` has its own opcode (`0xCC`) for efficient insertion by debuggers.

---

## Examples

### BIOS Teletype Output

```asm
mov ah, 0x0E    ; Function: Teletype output.
mov al, 'A'     ; Character to print.
mov bh, 0       ; Page number.
int 0x10        ; Call BIOS.
```

This prints the character `'A'` to the screen using BIOS video services.

### Trigger Software Exception (for debugging)

```asm
int 0x03    ; Trigger a breakpoint (used by debuggers).
```
