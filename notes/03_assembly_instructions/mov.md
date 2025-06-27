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
mov cx, 0x1234  ; Load the contant 0x1234 into CX
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

### Segment Registers

You can use `MOV` with segment registers, but only in certain ways:

```asm
mov ax, ds  ; Valid: You can load segment registers into general-purpose registers
mov ds, ax  ; Valid: You can load general-purpose registers into segment registers
