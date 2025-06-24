# AT&T Syntax

> **Random Quote:** As water reflects the face, so one's life reflects the heart.

AT&T syntax is the default assembly language format used by the **GNU Assembler (GAS)** and many Unix-based toolchains, including **GCC**.

Although this syntax can appear more complex for beginners, it remains important, especially when writing **inline Assembly** in C programs compiled with GCC, such as in operating system kernels.

---

## Key Topics

+ [Instruction Format and Operand Order](#instruction-format-and-operand-order)
+ [Comment Style](#comment-style)
+ [Register Naming](#register-naming)
+ [Constants and Literals](#constants-and-literals)
+ [Memory Access](#memory-access)
+ [Instruction Suffixes](#instruction-suffixes)
+ [Label Syntax and Jump Targets](#label-syntax-and-jump-targets)

---

## Instruction Format and Operand Order

The general instruction format in AT&T syntax is:

```asm
mnemonic source, destination
```

+ `mnemonic`: The name of the instruction like `MOV`.
+ `source`: The data to be used. It can be a register, constant/literal, a variable, or a memory address.
+ `destination`: This is where the result of the operation is stored. It can be a register, variable, or memory address.

This is the opposite of Intel syntax.

**Example:**

```asm
addl $5, %eax   # Add 5 to the value in EAX.
```

The `l`, `$`, and `%` may seem confusing at first; they are explained in the sections below.

---

## Comment Style

Comments begin with a hash symbol (`#`). Everything after the `#` on the same line is treated as a comment. Assembly supports only single-line comments.

**Example:**

```asm
# This whole line is a comment.
movl $10, %eax   # This is another comment.
```

---

## Register Naming

Registers must be **prefixed with a percent sign (`%`)**. If you don't write the percent sign, GAS will interpret the name as a label or variable.

**Example:**

```asm
movb $'A', %al      # Load the character 'A' into AL.
movw $0x7C00, %sp   # Set the stack pointer to address 0x7C00.
```

---

## Constants and Literals

Constants (or literals) must be **prefixed with a dollar sign (`$`)**. Without the `$` prefix, the assembler assumes you're referencing a memory address or label.

+ Decimal: `$42`
+ Hexadecimal: `$0x2A`
+ Binary: *Not commonly used in GAS*
+ Character: `$'A'` or `$65` (ASCII value)

**Example:**

```asm
movl $0x1234, %eax  # Load immediate hex value into EAX.
movb $'Z', %bl      # Load ASCII 'Z' into BL.
```

---

## Memory Access

Memory operands are written using **parentheses (`()`)**, not square brackets like in Intel syntax. They often involve registers.

**Example:**

```asm
movl (%eax), %ebx   # Load the value from memory at address in EAX into EBX.
movl %ebx, (%eax)   # Store the value in EBX into the memory location pointed to by EAX.
```

**Example:** Indexed and scaled addressing.

```asm
movl 8(%ebx, %ecx, 4), %eax
```

This accesses memory at: `EAX = [EBX + ECX*4 + 8]`

+ `displacement(base, index, scale)` is equivalent to `disp + base + index * scale`.

**Example:** With labels.

```asm
movw var(%bp), %ax  # Load word from offset of 'var' relative to BP.
```

---

## Instruction Suffixes

In AT&T syntax, instruction mnemonics include a **size suffix** to specify operand width. This differs from Intel syntax, which uses keywords like `byte`, `word`, and `dword` to indicate size.

+ `b`: Byte (8-bit).
+ `w`: Word (16-bit).
+ `l`: Long (double word) (32-bit).
+ `q`: Quad (quad word) (64-bit).

**Example:**

```asm
movb $1, %al        # Move 8-bit value.
movw $0xFFFF, %bx   # Move 16-bit value.
movl %eax, %ebx     # Move 32-bit value.
movq %rax, %rbx     # Move 64-bit value.
```

These suffixes are required because GAS does not infer operand size from the registers alone in all cases.

---

## Label Syntax and Jump Targets

Labels in AT&T syntax follow the same structure as in Intel syntax. They are defined using a name followed by a colon (`:`) and must appear on their own line or before an instruction. Labels are also case-sensitive.

**Example:** Defining a label.

```asm
start:  # This is a label.
    movl $0, %eax
```

**Example:** Jumping to a label.

```asm
jmp start   # Jump to 'start'.
```

The main difference between AT&T and Intel syntax regarding labels lies in the handling of local labels.

+ **Global** labels are defined without a prefix (e.g., `main:`).
+ **Local** labels use numeric labels and suffixes (`1f`, `1b`) for forward and backward jumps.

**Example:**

```asm
global_label:
    jmp 1f      # Jump forward to label '1:'.

1:
    # Other instructions.
```

+ `1f`: Forward to the next label named `1:`.
+ `1b`: Backward to the previous label named `1:`.

This is common in GAS-style Assembly for temporary or inline jumps.
