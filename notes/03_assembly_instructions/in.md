# `IN`

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

The `IN` instruction on the x86 architecture reads data from an I/O port into a register. It exists because x86 (and many PCs) support a separate **port-mapped I/O** address space aside from normal memory. Key points:

* It transfers from an I/O port (addressed via immediate or DX) into AL/AX/EAX.
* It is privileged in many contexts (i.e., user code often cannot execute it unless given permission) since direct hardware manipulation can break the system.

### How It Works

* Internally, when `IN` executes, the CPU places the port address on the I/O port address bus (distinct from memory addresses) and signals a read from that I/O space.
* Operands: the destination must be a register (AL = byte, AX = word, EAX = dword) and the source is either an 8-bit immediate port number (0-255) or the DX register (allowing up to 65,535) specifying the port address.
* Flags: The `IN` instruction does **not** affect the typical arithmetic/logic flags (ZF, SF, etc.).
* Privilege & mode behaviour: In protected mode, if the current privilege level (CPL) is greater than the I/O privilege level (IOPL) or the TSS I/O bitmap denies access, a general protection fault (#GP) is raised.

---

## Syntax

```asm
IN destination, source
```

* **destination**: must be one of AL/AX/EAX (depending on operand size)
* **source**: either `imm8` (immediate 8-bit port number) or `DX` (register holds port address)
* Examples of forms:

  ```asm
  IN AL, imm8
  IN AX, imm8          ; word sized
  IN EAX, imm8         ; dword sized
  IN AL, DX
  IN AX, DX
  IN EAX, DX
  ```
* Restrictions:

  * Cannot have memory operand as destination (only register).
  * Cannot have two memory operands (not even relevant since destination cannot be memory).
  * Port address via immediate is limited (0-255), via DX is full 16-bit (0-65535).

### Instruction Size

* Typical size: depends on whether the immediate is used or DX, and operand-size prefix if needed. For example, `E4 ib` for `IN AL,imm8` (one-byte opcode plus immediate byte).
* For word or dword operands, operand-size prefix (0x66) may be required on 32-bit mode for AX or EAX etc.
* No `LOCK` prefix applicable (since port I/O is inherently device-specific and generally serialized by hardware).
* Because access to I/O ports is special (vs memory loads/stores), the processing might be slower and may have serialized side-effects (especially regarding CPU store buffers) though exact latency varies by CPU.

---

## Examples

```asm
; Read a byte from I/O port 0x60 (keyboard data port) into AL
IN AL, 0x60

; Read a word (16 bits) from I/O port 0x70 into AX
IN AX, 0x70

; Read a dword (32 bits) from the I/O port whose address is in DX (say DX = 0x3F8)
MOV DX, 0x3F8
IN EAX, DX

; In 16-bit mode: read a byte from port in DX into AL
MOV DX, 0x3F8
IN AL, DX
```

In an OS-dev context, you might check the status of a hardware device via a port and then read data when ready. For example (pseudocode):

```asm
.wait_loop:
  IN AL, 0x64          ; read status register of keyboard controller
  TEST AL, 1           ; bit 0 = output buffer full?
  JZ .wait_loop        ; wait if no data
  IN AL, 0x60          ; read the actual key code
```

---

## Practical Use Cases

* When building an OS , particularly in low-level hardware/driver code, the `IN` instruction is essential for interacting with legacy devices or chipsets that support **port-mapped I/O** (for example, older PC keyboard controller ports, legacy PCI devices on some buses, or chipset south-bridge registers).
* It is often used in early boot code (real mode / 16-bit) where memory-mapped I/O may not yet be configured, so port I/O is used to probe hardware.
* For example: reading from the VGA port register, reading from an ISA device at port 0x378 (parallel port), or reading from chipset registers that are port-mapped.
* You’d choose `IN` instead of memory loads when the device is only accessible via I/O port space (not memory-mapped). On x86 this is a distinct address space and sometimes the only supported method for certain legacy devices.

---

## Best Practices

* Use `IN` only when the hardware device you target is documented as using port-mapped I/O. For newer hardware, memory-mapped I/O is more common and often more efficient.
* Make sure you perform the necessary privilege setup: in your OS kernel you must set up the I/O permission bitmap in the TSS (if using protected mode) or run in ring 0 so that `IN` won’t fault.
* Consolidate I/O port reads: if reading multiple ports, consider looping or batching rather than scattering `IN` everywhere, so it's easier to audit which hardware ports you’re using.
* Document the port numbers and bit meanings clearly; when someone (or future you) reads your OS driver code, having e.g. `#define KEYBOARD_DATA_PORT 0x60` is much clearer than “IN AL, 0x60”.
* When possible, abstract port I/O into functions/macros, so your higher-level driver code uses named operations (e.g., `read_keyboard_data()`) rather than raw `IN`.
* Consider side-effects of I/O port reads (some reads clear a status bit, or acknowledge an interrupt, etc). Be sure to understand the device protocol.

---

## Common Pitfalls

* **Using `IN` on a port that doesn’t exist or isn’t set up**; you’ll read garbage or device may misbehave. Some hardware may hang waiting for a response.
* **Assuming I/O and memory operations behave the same**; port I/O is separate address space; memory-mapped I/O uses normal loads/stores. Mistaking one for the other leads to bugs.
* **Forgetting privilege checks**; in protected mode, if CPL > IOPL or I/O permission bitmap denies a given port, `IN` causes #GP(0). You might debug for hours wondering why your code faulted.
* **Incorrect register size**; e.g., using `IN AX, imm8` when you meant to read a byte into AL; or using an immediate port >255 when only immediate form allows 0-255. Using DX form if >255 is mandatory.
* **Overlooking device behaviour or serialization issues**; I/O port operations may force ordering/serialization unlike some memory loads (especially with caching). Speculative memory loads might be allowed, but port I/O often bypasses caching and must be done carefully in OS code.
* **Using `IN` in 64-bit mode expecting 64-bit transfers**; x86 port I/O instructions don’t support 64-bit operand size. Many devices now prefer memory-mapped I/O, so relying on port I/O on modern hardware may be obsolete.

---
