# `STOSB` / `STOSW` / `STOSD`

> **Random Quote**: It's not whether you get knocked down, it's whether you get up.

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

The `STOS` instruction family writes the contents of the accumulator (AL, AX, or EAX) to memory at the address `ES:DI` (or `ES:EDI`), then automatically adjusts the destination pointer.  
It exists to simplify and optimize initialization or block-store operations.  
Key behavior: pointer movement respects the data size and the Direction Flag (`DF`).

---

### How It Works

Internally, the CPU:
- Stores the accumulator value into memory at `ES:DI`.
  - `STOSB`: byte from `AL`
  - `STOSW`: word from `AX`
  - `STOSD`: doubleword from `EAX` (available on 80386+ CPUs)
- After each store, `DI` (or `EDI` in 32-bit mode) is incremented or decremented depending on `DF`:
  - `DF = 0` → increment (`CLD`)
  - `DF = 1` → decrement (`STD`)
- The adjustment amount is 1, 2, or 4 bytes for byte, word, or doubleword operations respectively.

---

## Syntax

```asm
STOSB
STOSW
STOSD
```

* **STOSB**: store the byte in `AL` to `ES:DI`.
* **STOSW**: store the 16-bit word in `AX` to `ES:DI`.
* **STOSD**: store the 32-bit doubleword in `EAX` to `ES:DI` (80386+ only).

**Implicit operands**:

* Destination: `ES:DI` (or `ES:EDI` if applicable).
* Source: `AL`, `AX`, or `EAX` depending on instruction size.

**Restriction**: Must properly set up `ES` segment and `DI` pointer before execution.

### Instruction Size

* Each variant is encoded as a **single-byte opcode** (e.g., `AA` for `STOSB`, `AB` for `STOSW`; exact opcode depends on mode).
* When combined with `REP` prefix (e.g., `REP STOSW`), it repeats the store `CX` times, enabling block initialization or memory fills.
* There is no `LOCK` prefix interaction; it's strictly meant for string-store operations.

---

## Examples

```asm
; Example 1: Store a byte
cld                     ; direction forward
mov al, 0xFF            ; value to store
mov di, buffer          ; destination pointer
stosb                   ; writes AL to ES:DI, increments DI by 1

; Example 2: Block store of words
cld
mov ax, 0x1234          ; word pattern
mov di, dst
mov cx, 128             ; number of words
rep stosw               ; store AX into ES:DI, CX times

; Example 3: Backward byte store (for overlapping regions)
std                     ; set direction flag
mov al, 0
lea di, [dst + len - 1]
mov cx, len
rep stosb               ; stores backwards, byte by byte
```

---

## Practical Use Cases

* **Bootloader memory initialization**: filling buffers, sectors, or data structures (e.g., zeroing memory) in real-mode.
* **Memset-like behavior**: quickly set memory regions to a specific pattern using `REP STOSB` or `REP STOSW`.
* Efficiently writing repeated data with minimal code footprint; ideal for constrained 16-bit real-mode environments.

---

## Best Practices

* Always initialize:

  * `ES` for correct segment.
  * `DI` to target offset.
  * `CX` when using `REP`.
  * `DF` (`CLD` for forward, `STD` for backward).
* Prefer `STOSW` over `STOSB` when aligned for speed; use `STOSD` only if running on an 80386 or newer CPU.
* Use `REP` for bulk operations to minimize instruction count.
* Validate memory alignment when using word/doubleword variants to avoid penalties or faults.

---

## Common Pitfalls

* Failing to set the direction flag correctly leads to unintended pointer movement.
* Using `STOSD` in pure 16-bit real-mode before 80386 CPUs; unsupported and will produce invalid opcodes.
* Not checking overlap; copying data into overlapping regions without adjusting direction can corrupt the output.
* Forgetting to load `ES`; default segment might not point to the intended memory in bootloader context, causing silent corruption.

---
