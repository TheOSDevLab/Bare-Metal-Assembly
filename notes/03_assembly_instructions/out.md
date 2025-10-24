# `OUT`

## Key Topics

* [Overview](#overview)
  * [How It Works](#how-it-works)
* [Syntax](#syntax)
  * [Instruction Size](#instruction-size)
* [Examples](#examples)
* [Practical Use Cases](#practical-use-cases)
* [Best Practices](#best-practices)
* [Common Pitfalls](#common-pitfalls)

---

## Overview

The `OUT` instruction in the x86 architecture writes data from a register to an I/O port. It exists because x86 supports a distinct **port-mapped I/O** address space (separate from memory) and physical hardware often expects writes to these ports. Key points:

* It moves the contents of AL, AX or EAX into a specified I/O port using either an immediate port address (0-255) or one stored in DX.
* It is privileged in many environments (kernel/driver code) since arbitrary I/O writes can disrupt hardware or system stability.

### How It Works

* Internally, when `OUT` executes, the CPU places the port address on the I/O port address bus (distinct from normal memory addressing) and issues a write signal to that port.
* Operands accepted: the destination is the port (via immediate or DX) and the source is AL/AX/EAX depending on size. The instruction writes the data from the register into the device/port at that address.
* Flags: The instruction does **not** affect typical arithmetic/logic flags (ZF, SF, etc.).
* Privilege & mode behaviour: In protected mode, if the current privilege level (CPL) is greater than the I/O privilege level (IOPL) or the I/O permission bitmap in the TSS denies access, executing `OUT` triggers a general protection fault (#GP).

---

## Syntax

```asm
OUT port, source
```

* **port**: either `imm8` (immediate 8-bit port number, values 0-255) or `DX` register (full 16-bit port number, values 0-65535)
* **source**: one of the registers AL (8-bit), AX (16-bit) or EAX (32-bit) depending on operand-size
* Forms (Intel syntax) include:

  ```asm
  OUT imm8, AL       ; write byte from AL to port imm8
  OUT imm8, AX       ; write word from AX to port imm8
  OUT imm8, EAX      ; write dword from EAX to port imm8 (in 32-bit mode)
  OUT DX, AL         ; write byte from AL to port whose address is in DX
  OUT DX, AX         ; write word from AX to port in DX
  OUT DX, EAX        ; write dword from EAX to port in DX
  ```
* **Restrictions**:

  * Destination is the port, not memory. You cannot use a memory operand in place of the port operand.
  * Source must be register AL/AX/EAX depending on size.
  * If using immediate port, port number must fit 8 bits (0-255). For larger port addresses, you must use DX.

### Instruction Size

* Typical size: depends on the form. For example the encoding table shows: `E6 ib` (opcode E6 followed by immediate byte) for `OUT imm8, AL`.
* For word or dword versions possibly require operand‐size prefix (0x66) depending on mode (16-bit vs 32-bit) and target register size.
* No `LOCK` prefix applicable (port I/O operations are not subject to the atomic/lock prefix feature).
* Because I/O instructions often serialize the bus or flush store buffers (depending on implementation) they may have different performance characteristics than simple memory writes.

---

## Examples

```asm
; Simple usage: write value in AL to port 0x60 (keyboard data port for example)
MOV AL, 0x1C
OUT 0x60, AL

; Write word from AX to port 0x70
MOV AX, 0x1234
OUT 0x70, AX

; Using DX for larger port address (e.g., port 0x3F8 = COM1)
MOV DX, 0x3F8
MOV AL, 'A'
OUT DX, AL

; Example in OS-dev: acknowledge PIC interrupt (Master PIC command port 0x20)
MOV AL, 0x20
OUT 0x20, AL
```

These examples show progressively more complex forms: immediate port, word sized, DX port register.

---

## Practical Use Cases

* In OS-kernel or driver code you use `OUT` to send commands or data to hardware devices that use port-mapped I/O (for example legacy ISA devices, PIC/PIT, keyboard controller, serial/parallel ports).
* Early boot code (real mode or early protected mode) often uses port I/O because memory-mapped I/O may not yet be configured or supported, so interacting with firmware/chipset via ports is common.
* When initializing hardware: e.g., writing to the programmable interrupt controller (PIC) to remap interrupt vectors via ports 0x20/0x21 and 0xA0/0xA1; sending commands to the PIT (Programmable Interval Timer) port 0x43; writing to VGA ports etc.
* You choose `OUT` over memory writes when the device is only reachable via the I/O port address space (not memory-mapped). On x86 this is the case for many legacy or chipset-specific registers.

---

## Best Practices

* Use `OUT` only when you *know* the hardware requires port-mapped I/O; for many modern devices memory-mapped I/O is preferred and more efficient.
* Ensure your OS kernel sets up the proper I/O permissions (in protected mode, the I/O permission bitmap in the TSS, or run in ring 0) so that `OUT` won’t fault.
* Document clearly which port numbers you are writing to; rather than magic numbers, define constants like `PIC1_COMMAND_PORT = 0x20`. Makes your driver code readable/maintainable.
* Batch port writes when possible (e.g., configuring multiple registers in one routine) rather than scatter `OUT` instructions throughout large code, so you can audit and manage side-effects.
* Understand the device side-effects: many port writes trigger hardware state changes (like clearing an interrupt, setting mode bits, resetting FIFOs) so don’t write blindly.
* If the hardware supports both port-mapped I/O and memory-mapped I/O, prefer memory-mapped for performance and maintainability unless you have a reason to use ports.
* Keep port access as low-level hardware abstraction; build higher-level routines in your OS to wrap these `OUT`s (e.g., `pic_send_command(port, cmd)`) to isolate hardware specifics.

---

## Common Pitfalls

* **Writing to a port that doesn’t exist or isn’t configured**; you may get no effect, garbage output, or hardware misbehaviour.
* **Assuming `OUT` works like a normal memory store**; port I/O uses a separate address space and often has serialization constraints. For instance, speculative memory writes may not apply to port writes.
* **Forgetting privilege checks**; if CPL > IOPL or I/O permission bitmap doesn’t allow the port, you get a #GP fault; in virtual-8086 mode also.
* **Incorrect operand size**; writing a word when the device expects a byte (or vice-versa) may cause incorrect behaviour or partial overwrite. Ensure you use AL vs AX vs EAX correctly.
* **Using the immediate port when the port number exceeds 255**; you must use DX when port > 255; misuse will either truncate or encode incorrectly.
* **Modern hardware may not support port I/O or may behave differently**; many modern peripherals use memory-mapped I/O rather than port-mapped, so relying on `OUT` for all hardware will limit compatibility.
* **Overlooking ordering and side-effects**; some device writes require delays, read-back, or ordering constraints (e.g., acknowledgment, clearing interrupt flags). Using `OUT` without respecting these may lead to race conditions/hangs.

---
