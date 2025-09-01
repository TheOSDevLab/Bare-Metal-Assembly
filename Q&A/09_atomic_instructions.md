# Atomic Instructions

**Atomic instructions** are processor-level operations that execute as indivisible units of work. From the perspective of other threads or processors, an atomic instruction appears to occur instantaneously: it cannot be interrupted or partially completed. This property makes atomic instructions essential in concurrent programming, as they ensure consistency when multiple execution contexts access or modify shared data.

---

## Example: The `INC` Instruction

The `INC` instruction increments the value of a register or a memory operand by one. While this may seem like a simple, single-step operation, it is internally composed of multiple micro-operations: reading the operand, performing the addition, and writing the result back to the destination.

In a multiprocessor environment, if two threads simultaneously execute `INC` on the same shared memory location **without atomicity**, a **lost update** problem can occur. For example:

1. Thread A reads the current value.
2. Thread B reads the same current value before A completes its write.
3. Both increment their local copies.
4. The last thread to write overwrites the other’s result.

The outcome is that the shared variable is incremented only once instead of twice, leading to data inconsistency.

To prevent this, the instruction can be prefixed with `LOCK`, as in:

```asm
lock inc [mem]
```

The `LOCK` prefix ensures the entire read-modify-write sequence is executed atomically, blocking other processors from accessing the memory location until the operation completes.

---
