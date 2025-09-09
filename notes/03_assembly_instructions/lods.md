# `LODSB` / `LODSW` / `LODSD`

> **Random Quote**: Our greatest glory is not in never falling, but in rising every time we fall.

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

The `LODS` instruction family transfers data from memory at `DS:SI` into the accumulator (`AL`, `AX`, or `EAX`) and automatically updates the pointer.  
It exists to efficiently load sequential data elements for immediate processing, reducing the need for manual pointer and register updates.  
Key behavior: Data size determines how much `SI` is advanced, and pointer direction depends on the Direction Flag (`DF`), while no flags are affected.

---

### How It Works

Each execution:
- Loads data from memory at `DS:SI` into the accumulator (`AL` for byte, `AX` for word, `EAX` for doubleword).  
- After loading, `SI` (or `ESI` for 32-bit) is incremented (if `DF = 0`) or decremented (if `DF = 1`) by the appropriate number of bytes (1, 2, or 4).  
- Only the implicit source register `DS:SI` is involved; this yields tight, automatic data movement.  
- Flags remain untouched.  

---

## Syntax

```asm
LODSB      ; loads a byte into AL
LODSW      ; loads a word into AX
LODSD      ; loads a dword into EAX (requires 80386+)
```

* **Variants**:

  * `LODSB`: byte → `AL`
  * `LODSW`: word → `AX`
  * `LODSD`: doubleword → `EAX`

**Implicit operands**:

* Source: `DS:SI`
* Destination: accumulator (`AL`, `AX`, `EAX`)

**Note**: Must set `DS:SI` correctly beforehand.

### Instruction Size

* Each variant is a **single-byte opcode** in real-mode.
* It is valid to precede `LODS` with `REP` for repeated loads using `CX` as a count, though this is less common in real-mode bootloader logic.

---

## Examples

```asm
; Example 1: Load one byte
cld                     ; direction forward
mov si, source_addr
lodsb                   ; loads byte from DS:SI into AL, SI++

; Example 2: Load multiple words in a loop
cld
mov si, src
mov cx, N              ; number of words
load_loop:
    lodsw               ; AX = [DS:SI], SI +=2
    ; process AX
    loop load_loop

; Example 3: Reverse loading when necessary
std                     ; set direction backward
lea si, [src + len - 1]
lodsb                   ; AL = byte at DS:SI, SI--
```

These illustrate how `LODS` automatically advances the source pointer based on `DF` and variant.

---

## Practical Use Cases

* **Bootloader input processing**: reading bytes or words from disk-loaded data into registers for parsing (e.g., file headers, sector data).
* **String or buffer iteration**: sequentially processing input data element-by-element, often within a loop.
* It's compact and efficient when you need to read and process data immediately rather than bulk-moving it.

---

## Best Practices

* Always initialize:

  * `DS` and `SI` must point to the data source.
  * Set `DF` using `CLD` (forward) or `STD` (backward) as required.
* For processing sequences, using a `LODS` inside a `loop` or manual decrement-propagation structure helps control flow.
* Avoid `REP LODSB` in bootloaders unless you have a clear use-case; it’s uncommon since processing is often per element, not block.

---

## Common Pitfalls

* **Not setting up `DS:SI`**: can load from unexpected, invalid memory; especially risky in bootloader contexts.
* **Direction flag oversight**: if `DF` remains set, pointer moves in the wrong direction, corrupting logic.
* **Wrong variant**: using `LODSW` when data is byte-sized misaligns reads and shifts offsets incorrectly.
* **Expecting flags to change**: `LODS` does not affect flags; any condition logic must be based on data after load.
* **REP misuse**: using `REP LODSB` without processing each element can overwrite accumulator without meaningful handling.

---
