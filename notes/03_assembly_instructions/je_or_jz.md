# JE / JZ

> **Random Quote**: Fortune favors the brave.

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

`JE` and `JZ` are synonymous conditional jump mnemonics that transfer control when the Zero Flag (ZF) is set. They exist to implement branches that follow equality tests or operations that produce a zero result.

### How It Works

* Execution flow evaluates the state of the Zero Flag set by a prior instruction such as `CMP`, `SUB`, `TEST`, or a string/logic operation. If ZF = 1, the processor updates the instruction pointer to the target address and continues execution there. If ZF = 0, execution falls through to the next instruction.
* Flags are read but not changed by `JE`/`JZ`. The instruction relies on the status of ZF produced by earlier instructions.

---

## Syntax

```asm
JE  label

; or

JZ  label
```

* `label`: A code location to jump to. This can be a near relative label, a register indirect target, or a far pointer in modes that support far jumps. In practice this is usually a near relative label.
* **Restrictions**:
  * The instruction is single operand only.
  * Typical encodings are relative displacements. Far or indirect forms depend on mode and assembler support.

### Instruction Size

* Typical sizes:
  * **Short near**: 2 bytes when encoded as a short relative jump with an 8 bit signed displacement.
  * **Near**: 3 bytes or more when encoded with a 16 or 32 bit displacement, depending on mode and operand size.
  * **Long/far**: Available in modes that support far control transfers, with larger encodings for segment\:offset pointers.
* Encoding notes:
  * Most assemblers encode `JE`/`JZ` as the same opcode; `JE` is often shown in disassembly but `JZ` is accepted as an alias.
* Prefixes:
  * There is no `LOCK` prefix for conditional jumps. Instruction size and form depend on operand-size and address-size prefixes when targeting different modes.

---

## Examples

```assembly
mov ax, 5
cmp ax, 5
je equal_label   ; jump because ZF = 1

mov bx, 1        ; fallen-through path
jmp done

equal_label:
    mov bx, 2    ; taken path when equal

done:
    nop
```

```assembly
; Example showing zero-result test with arithmetic
mov ax, 3
sub ax, 3        ; AX becomes 0, ZF set
jz zero_result   ; taken because result was zero
```

---

## Practical Use Cases

* Implementing branches after `CMP` to handle equality cases in control flow.
* Checking whether arithmetic or logical operations produced zero, for example, checking end of a counter or termination condition.
* Low level state dispatch where different code paths are selected based on earlier comparisons in bootloaders and OS kernels.

---

## Best Practices

* Use `JE` when the logic is about equality after a comparison. Use `JZ` when the logic reads more naturally as a zero test. Both are identical at machine level, so pick the mnemonic that makes intent clearer.
* Ensure the instruction that sets ZF directly precedes the jump or that no intervening instruction clobbers flags. Common flag-setting instructions include `CMP`, `TEST`, `SUB`, and string/logic operations.
* Prefer short relative encodings for local branches to reduce code size and improve branch prediction locality. If the target is out of range, rely on the assembler to emit the longer near form.

---

## Common Pitfalls

* Assuming `JE` reads some computed result other than ZF. It only checks ZF; if ZF has not been set intentionally the behavior depends on prior operations.
* Inserting instructions between the flag-setting operation and `JE` that modify flags. That will change ZF and thus the branch decision.
* Misunderstanding short jump range. A short `JE` uses an 8 bit signed displacement. If the label is too far the assembler must encode a longer form, or the code will not assemble.

---

## Notes and References

* Formal opcode and encoding reference: [Félix Cloutier’s x86 reference.](https://www.felixcloutier.com/x86/jcc)

---
