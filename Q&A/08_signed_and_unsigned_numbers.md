# Signed and Unsigned Numbers

> **Random Quote**: Work hard in silence, let success make the noise.

> "How can I determine whether I am working with signed or unsigned numbers in assembly?"

In x86 assembly, the processor does not inherently distinguish between signed and unsigned numbers; it processes all numeric values as raw bit patterns. The interpretation of these values as signed or unsigned is determined by the programmer's intent and the specific instructions used. Understanding this distinction is crucial for correct arithmetic operations and conditional branching.

---

### Determining Signed vs. Unsigned Numbers

To ascertain whether a number should be treated as signed or unsigned in assembly:

1. **Signed Numbers**: Typically represented in two's complement notation, where the most significant bit (MSB) indicates the sign. A `1` in the MSB denotes a negative number, and a `0` denotes a positive number. For instance, in an 8-bit system:

   * Positive `+5`: `00000101`
   * Negative `-5`: `11111011` (two's complement representation)

2. **Unsigned Numbers**: Represented as simple binary values without a sign bit. All bits contribute to the magnitude of the number. For example:

   * `5`: `00000101`
   * `250`: `11111010`

The distinction lies in how the most significant bit is interpreted.

---

### Processor Flags and Their Interpretations

The x86 processor utilizes several flags to indicate the outcome of arithmetic operations:

* **Carry Flag (CF)**: Indicates an unsigned overflow or borrow.
* **Overflow Flag (OF)**: Indicates a signed overflow.
* **Sign Flag (SF)**: Reflects the sign of the result in signed operations.
* **Zero Flag (ZF)**: Indicates whether the result is zero.

These flags are set based on the operation performed and are interpreted differently depending on whether the numbers are considered signed or unsigned.

---

### Conditional Jumps Based on Signed or Unsigned Comparisons

The interpretation of the flags determines the behavior of conditional jumps:

* **Signed Comparisons**: Use instructions like `JG` (jump if greater), `JL` (jump if less), `JGE` (jump if greater or equal), and `JLE` (jump if less or equal). These instructions interpret the flags assuming signed numbers.

* **Unsigned Comparisons**: Use instructions like `JA` (jump if above), `JB` (jump if below), `JAE` (jump if above or equal), and `JBE` (jump if below or equal). These instructions interpret the flags assuming unsigned numbers.

For example, after a subtraction:

```asm
cmp al, bl
ja unsigned_above
jg signed_above
```

Here, `ja` checks for unsigned greater, while `jg` checks for signed greater.

---

### Arithmetic Operations and Their Signed/Unsigned Variants

Certain arithmetic operations have signed and unsigned variants:

* **Addition and Subtraction**: The same instructions (`ADD`, `SUB`) are used for both signed and unsigned numbers. The interpretation of the result depends on the flags and the subsequent conditional jumps.

* **Multiplication**:

  * `MUL`: Unsigned multiplication.
  * `IMUL`: Signed multiplication.

* **Division**:

  * `DIV`: Unsigned division.
  * `IDIV`: Signed division.

These operations set the flags accordingly, and the programmer must choose the appropriate operation based on the signedness of the numbers involved.

---

### Conclusion

In x86 assembly, numbers are treated as raw bit patterns, and their interpretation as signed or unsigned is determined by the programmer's intent and the specific instructions used. By understanding how the processor sets and interprets flags, and by selecting the appropriate arithmetic and conditional jump instructions, a programmer can correctly handle signed and unsigned numbers in assembly language.

---
