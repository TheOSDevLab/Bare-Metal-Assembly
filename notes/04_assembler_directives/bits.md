# `BITS`

> **Random Quote:** The difference between ordinary and extraordinary is that little extra.

## Key Topics

+ [Overview](#overview)
+ [Practical Examples](#practical-examples)
+ [Best Practices](#best-practices)

---

## Overview

The `BITS` directive in NASM tells the assembler the **instruction mode** to use when encoding machine code. It specifies whether the code should be assembled as **16-bit, 32-bit or 64-bit** instructions. NASM defaults to 16-bit code generation.

The CPU's mode (real, protected, or long mode) determines how instructions are executed at runtime. For instance, in real mode, the CPU expects 16-bit instructions. Therefore, use the following setting for code that will be executed while the CPU is in real mode:

```asm
bits 16     ; Assemble in 16-bit mode.
```

The following settings apply to protected mode and long mode.

```asm
bits 32     ; Assemble in 32-bit mode for "protected mode".
bits 64     ; Assemble in 64-bit mode for "long mode".
```

**Note:** Using the wrong `BITS` setting will cause instructions to be encoded incorrectly, leading to:

+ Invalid instructions.
+ Unexpected behavior.
+ Crashes or corrupted memory access.

Correct use of `BITS` ensures that:

+ Instruction encoding matches the CPU's execution mode.
+ Registers are interpreted correctly (e.g., `EAX` in 32-bit, `RAX` in 64-bit).
+ The assembler emits correct opcodes for jumps, calls, and addressing.

**Note:** This directive **does not** switch CPU modes. To do that, you must manually change the CPU state using special instructions and registers. `BITS` just ensures that your code matches the environment you're coding for.

---

## Practical Examples

### Real Mode

```asm
org 0x7C00
bits 16

start:
    mov ax, 0x13       ; Valid: AX is a 16-bit register
    int 0x10           ; BIOS video interrupt
    jmp $

times 510 - ($ - $$) db 0
dw 0xAA55
```

In real mode, `bits 16` ensures NASM encodes 16-bit instructions compatible with BIOS services and hardware expectations.

### Protected Mode

```asm
bits 32

start32:
    mov eax, 0xCAFEBABE  ; Valid 32-bit instruction
```

In protected mode, `bits 32` ensures that NASM generates 32-bit opcodes and register encodings suitable for 32-bit kernels.

### Long Mode

```asm
bits 64

start64:
    mov rax, 0xDEADBEEFCAFEBABE
    mov rbx, rax
    ret
```

In long mode, `bits 64` is required to emit proper 64-bit instruction encodings.

---

## Best Practices

+ Place `BITS` at the top of every Assembly file to avoid confusion.
+ If you split code into multiple files, set the appropriate `BITS` in each.
+ Use `BITS` only once per file. Changing it mid-file is discouraged unless you are writing hybride code using advanced macro techniques (which is uncommon and complex).
+ Combine `BITS` with `ORG` when writing flat binaries like bootloaders:

```asm
org 0x7C00
bits 16

...
```

---
