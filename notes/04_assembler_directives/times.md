# `TIMES`

> **Random Quote:** Success is the product of daily habits, not once-in-a-lifetime transformations.

## Key Topics

+ [Overview](#overview)
+ [Usage Scenarios](#usage-scenarios)
    - [Padding the Boot Sector to 512 Bytes](#padding-the-boot-sector-to-512-bytes)
    - [Reserving or Initializing Memory](#reserving-or-initializing-memory)
    - [Instruction Repetition](#instruction-repetition)
+ [Best Practices](#best-practices)

---

## Overview

The `TIMES` directive in NASM is used to **repeat an instruction, data declaration, or value** a specified number of times. It provides a powerful and concise way to generate repeated output in the assembled binary.

This directive is especially important in bare-metal programming, where precise control over memory layout and binary size is critical.

**Important Notes:**

+ `TIMES` affects the assembled output statically; it does not generate loops or repeated runtime behavior.
+ It can only repeat a single token or line. To repeat multiple instructions, you must use macros or a loop in code.
+ The value to be repeated must be something NASM can repeat without ambiguity, like `db` or a simple instruction.

### Syntax

```asm
times count value
```

+ `count`: The number of times the `value` should be repeated. This must be a **constant** or an **expression** that evaluates to a constant at assembly time.
+ `value`: A single instruction, data declaration, or numeric value.

---

## Usage Scenarios

### Padding the Boot Sector to 512 Bytes

In BIOS-based systems, the first sector of a bootable disk must be exactly 512 bytes. After writing the code and data, the rest of the sector is filled with zeroes using `TIMES`.

```asm
times 510 - ($ - $$) db 0
dw 0xAA55
```

+ `times`: The directive.
+ `510 - ($ - $$)`: The `count`.
    - `$` refers to the current offset.
    - `$$` refers to the start of the section.
    - `($ - $$)` is the size of the file from the start to the current point.
    - This expression calculates how many bytes are needed to pad the binary to 510 bytes, leaving space for the 2-byte boot signature.
+ `db 0`: The `value`. This directive fills the remaining space with 0s.

### Reserving or Initializing Memory

`TIMES` can be used to initialize memory with repeated values. For example, clearing 16 bytes:

```asm
times 16 db 0   ; Write 16 zero bytes.
```

Or filling with a specific pattern:

```asm
times 8 db 0xFF ; Fill with 8 bytes of 0xFF.
```

### Instruction Repetition

Although uncommon in practice, `TIMES` can be used to repeat the same instruction multiple times. For example:

```asm
times 4 nop     ; Insert 4 NOP instructions.
```

This may be used to align code or create timing delays in low-level routines.

---

## Best Practices

+ Use `TIMES` when generating fixed-size outputs such as boot sectors, disk sectors, or aligned buffers.
+ Combine with `$` and `$$` for precise padding.
+ Avoid using `TIMES` with complex instructions or macros. Use it only with simple, repeatable items.
+ Comment its purpose, especially when padding, to avoid confusion for future readers.
