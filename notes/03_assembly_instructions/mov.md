# `MOV`

> **Random Quote:** Success doesn't come from what you do occasionally, it comes from what you do consistently.

## Key Topics

+ [Overview](#overview)
    - [Syntax](#syntax)
    - [Examples](#examples)
+ [Things To Note](#things-to-note)
    - [Operand Size](#operand-size)
    - [Addressing Modes](#addressing-modes)
    - [Segment Registers](#segment-registers)
    - [Instruction Encoding and Size](#instruction-encoding-and-size)

---

## Overview

The `MOV` instruction is used to **copy data from a source operand to a destination operand**. This instruction is one of the most fundamental and frequently used instructions in x86 Assembly.

**Note:** `MOV` copies data. It does not move or remove it from the source. The original value in the source remains unchanged.

### Syntax

```asm
mov destination, source
```

+ `destination`: Where the data will be stored. This can be a register or a memory address.
+ `source`: Where the data is taken from. This can be a register, memory address, or a literal/constant.

**Valid Operand Combinations:**

| Destination | Source    | Description                                     |
| ----------- | --------- | ----------------------------------------------- |
| Register    | Register  | Copy data from one register to another          |
| Register    | Literal   | Load a constant value into a register           |
| Register    | Memory    | Load data from a memory address into a register |
| Memory      | Register  | Store data from a register into memory          |
| Memory      | Literal   | Store a constant directly into memory           |

**Invalid Operand Combinations:**

+ **Memory to memory** transfers are not allowed. You cannot use `MOV` to transfer directly between two memory locations.

---

### Examples

**Register to Register:**

```asm
mov ax, bx      ; Copy the contents of BX into AX
```

**Literal to Register:**

```asm
mov cx, 0x1234  ; Load the contant `0x1234` into `CX`
```

**Immediate to Memory:**

```asm
mov [myvar], 42 ; Store value 42 at the memory location labeled 'myvar'
```

**Register to Memory:**

```asm
mov [myvar], ax ; Store the value in AX at 'myvar'
```

**Memory to Register:**

```asm
mov ax, [myvar] ; Load the value stored at 'myvar' into AX
```

---

## Things To Note

### Operand Size

The destination and source operands **must match in size**. For example:

```asm
mov ax, bx  ; Valid: both are 16-bit registers
mov eax, bx ; Invalid: EAX is a 32-bit register and BX is a 16-bit register
```

For operands involving memory addresses and literals (where the size is ambiguous), use **size specifiers**. For example:

```asm
mov byte [ax], 0xFF     ; Specify to write only one byte to memory.
mov word [0x7C00], 0x1234   ; Store 2 bytes at 0x7C00.
```

---

### Addressing Modes

The `MOV` instruction supports various addressing modes when working with memory operands:

**Direct Addressing:**

```asm
mov ax, [0x1234]    ; Load value from memory address 0x1234
```

**Register Indirect Addressing:**

```asm
mov al, [bx]    ; Load byte from address pointed to by BX
```

**Based and Indexed Addressing:**

```asm
mov al, [bx + si]           ; Load byte at BX + SI
mov ax, [bp + 6]            ; Load word at BP + 6
mov eax, [ebx + ecx*4 + 8]  ; Load dword at EBX + ECX*4 + 8
```

---

### Segment Registers

Below are some rules when using the `MOV` instruction with segment registers.

#### 1. You Can't Use Immediate Values Directly

You cannot load a literal/constant value directly into a segment register.

```asm
mov ds, 0x1234  ; Not allowed.
```

Instead, use a general-purpose register like this:

```asm
mov ax, 0x1234  ; Move the literal into the general-purpose register.
mov ds, ax      ; Allowed.
```

#### 2. Only Certain Registers Are Allowed as Sources

Segment registers can only be loaded from **general-purpose 16-bit registers**, like `AX`, `BX`, etc. You cannot move a segment register into another segment register or from memory.

```asm
mov ds, bx      ; Allowed. BX is a general-purpose register.
mov ds, [si]    ; Not allowed. You cannot use a memory address as a source.
mov ds, es      ; Not allowed. You cannot use a segment register (ES) as a source.
```

#### 3. You Can't Use `MOV` on Some Segment Registers

`CS` is a special segment register. It cannot be modified using the `MOV` instruction; it can only be changed through a far jump, far call, or an interrupt.

```asm
mov cs, ax  ; Not allowed.
```

---

### Instruction Encoding and Size

The number of bytes the `MOV` instruction occupies in the output binary depends on the operands:

+ Register to register is typically 2 bytes.
+ Immediate to register is 3-5 bytes.
+ Memory access varies depending on the addressing mode.

This becomes important when writing 512-byte boot sectors, where every byte counts.

---
