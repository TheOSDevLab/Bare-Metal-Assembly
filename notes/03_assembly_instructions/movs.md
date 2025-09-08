# `MOVSB` / `MOVSW` / `MOVSD`

> **Random Quote**: Success usually comes to those who are too busy to be looking for it.

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

The `MOVS` instruction family transfers data from the memory location pointed to by `DS:SI` into the memory pointed to by `ES:DI`, then updates those pointers automatically.  
It exists to streamline block memory copying using implicit addressing and minimal code.  
Key behavior: pointer increment or decrement is controlled by the Direction Flag (`DF`), and element size is determined by the variant used.

### How It Works

Internally, the CPU:
- Reads data from `DS:SI` and writes to `ES:DI`.
- Depending on the variant (`MOVSB`, `MOVSW`, `MOVSD`), moves 1, 2, or 4 bytes.
- After the move, `SI` and `DI` are incremented (if `DF = 0`) or decremented (if `DF = 1`) by 1, 2, or 4 respectively.  
- It requires that `DS:SI` and `ES:DI` point to valid, accessible memory.  
- When used with the `REP` prefix, this becomes a block move using `CX` as the element count.  

---

## Syntax

```asm
MOVSB      ; move byte at DS:SI to ES:DI
MOVSW      ; move word (2 bytes) at DS:SI to ES:DI
MOVSD      ; move doubleword (4 bytes) at DS:SI to ES:DI (80386+ only)
```

* **Variants**:

  * `MOVSB`: moves a single byte.
  * `MOVSW`: moves a 16-bit word.
  * `MOVSD`: moves a 32-bit doubleword (80386 and later CPUs).

**Implicit operands**:

* Source: `DS:SI`
* Destination: `ES:DI`
* No explicit operands allowed.

**Restriction**: You must set `DS`, `ES`, `SI`, and `DI` appropriately before execution.

### Instruction Size

* These are single-byte instructions:

  * `MOVSB`: opcode `A4`
  * `MOVSW`: opcode `A5` (same for `MOVSD` in 16-bit legacy mode)
* No `LOCK` prefix applicability.
* With a `REP` prefix, `REP MOVSB`, `REP MOVSW`, or `REP MOVSD` perform block moves of `CX` elements.

---

## Examples

```asm
; Example 1: Move a single byte
cld                    ; clear direction flag (forward)
mov si, source_addr
mov di, dest_addr
movsb                  ; copy one byte

; Example 2: Move 256 words forward
cld
mov si, src
mov di, dst
mov cx, 256
rep movsw              ; move 256 words (512 bytes)

; Example 3: Move backward when overlapping
std                    ; set direction flag (backward)
lea si, [src + len - 1]
lea di, [dst + len - 1]
mov cx, len
rep movsb              ; reverse-copy bytes
```

These show how `SI`/`DI` adjust by the data size, influenced by `DF` and repeat prefix.

---

## Practical Use Cases

* **Bootloader buffer copy**: transfer sectors or load initial data structures (e.g., read from disk buffer into place).
* **Overlapping memory handling**: correct forward or backward copy depending on buffer overlap.
* **Optimized block moves**: `REP MOVSW` significantly reduces instruction count for copying larger words.

---

## Best Practices

* Always initialize:

  * `DS` and `ES` to appropriate segments.
  * `SI` and `DI` to source and destination offsets.
  * `CX` when using `REP`.
  * `DF` correctly (`CLD` or `STD`).
* Use word (`MOVSW`) or doubleword (`MOVSD`) when possible for speed and alignment.
* Ensure pointer and length alignment to reduce cycles.
* Check for overlapping regions and choose direction accordingly.

---

## Common Pitfalls

* **Using the generic `MOVS` form**: it suggests explicit operands but is misleading; always use `MOVSB`, `MOVSW`, or `MOVSD`.
* **Forgetting to set `DF`**: can result in backwards moves with corrupt data.
* **Misaligned pointer increments**: choosing wrong variant leads to wrong offset adjustments (e.g., using `MOVSW` but expecting byte increments).
* **Overlapping copy without direction awareness**: copies may overwrite and propagate corrupted data; use backward copy with `STD`.
* **Using `MOVSD` in pure 16-bit real mode on pre-80386 CPUs**: `MOVSD` is not available.

---
