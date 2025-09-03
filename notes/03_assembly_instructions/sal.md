# `SAL`

> **Random Quote**: Daily ripples of excellence over time becomes a tsunami of success.

In the x86 instruction set, the `SAL` (Shift Arithmetic Left) and `SHL` (Shift Logical Left) instructions are functionally identical. Both perform a leftward shift of the destination operand by a specified count, inserting zeros into the vacated least significant bits and discarding the bits shifted out of the most significant position.

The distinction in naming exists primarily for historical and semantic clarity:

+ `SAL` emphasizes the use of the instruction in arithmetic contexts.
+ `SHL` emphasizes the logical interpretation.

However, at the encoding level and in actual execution, there is no difference between the two. For a complete explanation of the behavior, flag effects, and usage considerations, refer to [this file](./shl.md)

---
