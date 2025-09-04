# Using Left Shift and Addition To Perform Multiplication

## Key Topics

+ [Fundamental Principle](#fundamental-principle)
+ [Examples in Assembly](#examples-in-assembly)
+ [General Algorithm: Binary Decomposition](#general-algorithm-binary-decomposition)
+ [Hardware-Level Perspective](#hardware-level-perspective)

---

## Fundamental Principle

### Shifts as Multiplication by Powers of Two

In binary arithmetic, a **left shift** is equivalent to multiplying by a power of two:

```
x << n  →  x × (2ⁿ)
```

For example, shifting by 1 yields ×2; by 2 yields ×4; by 3 yields ×8, and so on.

### Decomposing arbitrary multiplication via shifts and adds

Any integer multiplier can be represented in binary; that is, as a sum of powers of two. Example:

```
y = 13 → binary 1101 = 8 + 4 + 1 = 2³ + 2² + 2⁰
```

Then:

```
x × 13 = (x << 3) + (x << 2) + (x << 0)
```

This transforms a general multiplication into a small sequence of shifts and additions.

---

## Examples in Assembly

Let’s illustrate a step-by-step example: multiply a 16-bit number in `AX` by a constant multiplier using only `SHL` (shift left) and arithmetic.

### Example: Multiply `AX` by 10

We know:

```
10 = 8 + 2 = 2³ + 2¹
```

Assembly:

```asm
; AX holds the original value
mov bx, ax        ; copy AX
shl ax, 3         ; AX = AX × 8
mov cx, bx        ; restore original value into CX
shl cx, 1         ; CX = BX × 2
add ax, cx        ; AX = 8×orig + 2×orig = 10×orig
```

Alternatively, a more compact sequence (from Art of Assembly):

```asm
shl ax, 1         ; AX = 2×orig
mov bx, ax        ; BX = 2×orig
shl ax, 1         ; AX = 4×orig
shl ax, 1         ; AX = 8×orig
add ax, bx        ; AX = 8×orig + 2×orig = 10×orig
```

This method leverages shift/add instead of the slower `MUL` instruction on older x86 processors.

### Example: Multiply `AX` by 7

Since:

```
7 = 8 − 1 = 2³ − 2⁰
```

Assembly:

```asm
mov bx, ax        ; BX = orig
shl ax, 1         ; AX = 2×orig
shl ax, 1         ; AX = 4×orig
shl ax, 1         ; AX = 8×orig
sub ax, bx        ; AX = 8×orig − orig = 7×orig
```

Again, a clever use of subtraction with shifts.

---

## General Algorithm: Binary Decomposition

For a more systematic approach:

1. Express the multiplier `m` in binary.
2. For each bit set to 1 at position `k`, compute `(x << k)` and accumulate the result.
3. Sum all these shifted versions to get `x × m`.

#### Assembly-like Pseudocode

```asm
; Inputs: AX = multiplicand, BX = multiplier (constant)
; Output: DX:AX = product (if overflow possible), or AX if known safe.

xor cx, cx         ; CX = 0, accumulator

mov dx, bx
mov si, ax         ; SI = original multiplicand

bit_loop:
  test dx, 1
  jz skip_add
  add cx, si       ; add shifted multiplicand
skip_add:
  shl si, 1        ; shift multiplicand ×2
  shr dx, 1        ; move next multiplier bit into carry
  jnz bit_loop     ; repeat until all bits processed

mov ax, cx         ; final product in AX
```

This loop adds a shifted copy of the multiplicand for each '1' bit in the multiplier; a textbook shift-and-add routine.

---

## Hardware-Level Perspective

Shift-and-add mirrors how early computer multipliers worked; mimicking paper-and-pencil long multiplication in binary. Process:

1. Initialize product register to zero.
2. Inspect LSB of multiplier: if 1, add multiplicand.
3. Shift multiplicand left, multiplier right.
4. Repeat for each bit of multiplier.
5. Final product spans twice the bit width.

Modern processors often implement fast hardware multipliers (sometimes using Booth’s algorithm), but the shift-and-add principle remains fundamental.

---
