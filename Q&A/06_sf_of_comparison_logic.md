# Why `SF ≠ OF` Indicates "Less Than" in Signed Comparisons

In x86 architecture, the **Sign Flag** (SF) reflects the sign bit of the result of the last arithmetic operation, while the **Overflow Flag** (OF) indicates whether the signed result exceeded the representable range.

When comparing signed integers via a `CMP` instruction (which internally performs a subtraction: `A - B`), the CPU determines the relational outcome by examining these flags.

For **signed comparisons**:

* **Less than**: `SF ≠ OF`
* **Greater than or equal**: `SF = OF`

This logic works because:

* If the result's sign is **correct** (no signed overflow occurred), SF correctly indicates whether the result is negative.
* If a signed overflow **did** occur, SF is inverted relative to the true signed comparison, so the CPU must detect this by comparing SF and OF.

---

### **Truth Table for Signed Result Conditions**

| SF (Sign Flag) | OF (Overflow Flag) | SF ≠ OF? | Meaning in Signed Comparison                                     |
| -------------- | ------------------ | -------- | ---------------------------------------------------------------- |
| 0              | 0                  | 0        | Result ≥ 0 (no overflow) → not less than                         |
| 0              | 1                  | 1        | Overflow made result appear positive → actually less than        |
| 1              | 0                  | 1        | Negative result with no overflow → less than                     |
| 1              | 1                  | 0        | Overflow made result appear negative → actually greater or equal |

---

### Example 1: No Overflow (Straightforward Case)

Compare `-3` and `5` (signed 8-bit):

```
A = -3   (0xFD)
B = 5    (0x05)

CMP A, B  →  (-3) - (5) = -8  (0xF8)
```

* SF = 1 (result negative)
* OF = 0 (no signed overflow)
* SF ≠ OF → **Less than**.

---

### **Example 2: Overflow Changes Sign Bit**

Compare `100` and `-50` (signed 8-bit):

```
A = 100  (0x64)
B = -50  (0xCE)

CMP A, B →  (100) - (-50) = 150 → 0x96 (-106 in signed 8-bit)
```

* SF = 1 (bit 7 set) — appears negative
* OF = 1 (signed overflow occurred)
* SF = OF → **Not less than** (in reality, 100 > -50).

---

### **Example 3: Overflow in Opposite Direction**

Compare `-120` and `50` (signed 8-bit):

```
A = -120 (0x88)
B = 50   (0x32)

CMP A, B →  (-120) - (50) = -170 → 0x56 (86 in signed 8-bit)
```

* SF = 0 (appears positive)
* OF = 1 (signed overflow)
* SF ≠ OF → **Less than** (in reality, -120 < 50).

---

This mechanism allows the CPU to determine "less than" for signed values without additional arithmetic; simply by comparing the states of SF and OF after a subtraction.

---
