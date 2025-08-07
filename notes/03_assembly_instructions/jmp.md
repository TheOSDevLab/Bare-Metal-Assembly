# `JMP`

> **Random Quote**: If you're going through hell, keep going.

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

The **`JMP`** instruction performs an unconditional jump by changing the instruction pointer to the specified target. It exists to redirect program flow without preserving a return address and is fundamental for implementing loops, branches, and manual control flow.

### How It Works

- CPU loads a new address into the instruction pointer (`IP`/`EIP`/`RIP`), effectively redirecting execution.
- No flags or registers (other than the instruction pointer) are affected.
- The next instruction executed is the one at the new location.

---

## Syntax

```asm
JMP destination
````

* `destination` can be:

  * A label (relative jump),
  * An immediate far pointer (`segment:offset`),
  * A register (`EAX`, etc.),
  * Or a memory location containing the target address.

### Instruction Size

* **Short Jump**: `rel8`; 8-bit signed displacement (±128 bytes).
* **Near Jump**: `rel16` or `rel32`; within current segment.
* **Far Jump**:

  * Real-mode/intersegment: includes both segment and offset (`ptr16:16` or `ptr16:32`).
  * Protected mode: may refer to segment selectors or use call gates and can effect task switching.

---

## Examples

```asm
; Short relative jump (16-bit real mode)
jmp short label

; Near jump with label
jmp continue_here

; Far jump (intersegment real mode)
jmp 0x1234:0x5678

; Register-indirect jump
jmp eax
```

---

## Practical Use Cases

* Creating **loops**: jump back to a loop header.
* Implementing **state machines** or **branch logic** in pure assembly.
* **Intersegment jumps** in real mode or switching code segments in protected mode.
* **Task switching** via far jumps in protected mode.

---

## Best Practices

* Always use **relative jumps** for maintainable, position-independent code.
* Use **short jumps** when possible; they’re more compact and faster.
* Avoid far jumps unless you’re managing segments or privilege levels.
* Ensure jump targets are valid; assembler should catch undefined labels.

---

## Common Pitfalls

* Jumping too far with a short jump causes assembler errors or runtime faults.
* Far jumps in protected mode without correct privilege or descriptor context can cause **General Protection Faults**.
* Not realizing **JMP** doesn’t save a return address; use **`CALL`** when you need to return.
* Miscalculating offsets for relative jumps (especially when inserting/removing code).

---

## Notes and References

+ [felixcloutier.com](https://www.felixcloutier.com/x86/jmp)

---
