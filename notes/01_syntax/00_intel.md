# Intel Syntax

> **Random Quote:** Whoever guards his mouth preserves his life; he who opens wide his lips comes to ruin.

The Intel syntax is one of the most widely used assembly language formats, especially in educational materials, tutorials, and operating system development. It is the default syntax used by the **NASM** and **MASM** assemblers.

Intel syntax will be used throughout this repository in all standalone Assembly code and projects written using NASM. Its clarity and straightforwardness make it ideal for beginners learning to write low-level code for the x86 architecture.

---

## Key Topics

+ [Instruction Format and Operand Order](#instruction-format-and-operand-order)
+ [Comment Style](#comment-style)
+ [Register Naming](#register-naming)
+ [Constants and literals](#constants-and-literals)
+ [Memory Access](#memory-access)
+ [Size Specifiers](#size-specifiers)
+ [Label Syntax](#label-syntax)

---

## Instruction Format and Operand Order

In Intel syntax, the general instruction format follows this pattern:

```asm
mnemonic destination, source
```

+ `mnemonic`: The name of the instruction like `MOV`.
+ `destination`: This is where the result of the operation is stored. It can be a register, variable, or memory address.
+ `source`: The data to be used. It can be a register, constant/literal, a variable, or a memory address.

This is the opposite of AT&T syntax, where the source comes first.

**Example:**

```asm
mov ax, bx      ; Copy the contents of the BX register into the ax register.
add al, 1       ; Increment the value in the AL register.
```

---

## Comment Style

Comments are written using a semicolon (`;`). Everything after the semicolon on the line is treated as a comment. Assembly supports only single-line comments.

**Example:**

```asm
; This whole line is a comment.
mov ah, 0x0E    ; This is a comment.
mov al, 'X'     ; Writing the character X to the AL register.
```

> Use comments generously to explain logic, especially in non-obvious instructions or structures.

---

## Register Naming

In Intel syntax, there are no prefixes (like `%` in AT&T). Register names are used directly.

Remember that registers are named based on their size. That is:

+ 8-bit: `AL`, `BL`, etc
+ 16-bit: `AX`, `BX`, etc
+ 32-bit: `EAX`, `EBX`, etc
+ 64-bit: `RAX`, `RBX`, etc

**Example:**

```asm
mov dx, 0x03F8  ; DX is a register. Just write the name as is.
mov al, 65      ; AL is a register.
```

In case you are unfamiliar with registers or need a refresher, check out [this file](https://github.com/brogrammer232/Crafting-an-OS-Notes-and-Insights/blob/main/notes/01_computer_architecture/02_registers.md) in another repository.

---

## Constants and Literals

Constants (or literals) are straightforward and do not require special prefixes. Numeric values can be written in several bases: decimal, hexadecimal, binary and character.

+ Decimal: `42`
+ Hexadecimal: `0x2A`
+ Binary: `0b1010`
+ Character: `'A'`

**Example:**

```asm
mov ah, 0x0E
mov al, 'H'
mov bl, 12
```

These bases are discussed in [this file](https://github.com/brogrammer232/Crafting-an-OS-Notes-and-Insights/blob/main/notes/01_computer_architecture/08_number_systems.md) in another repository.

---

## Memory Access

Memory is accessed using square brackets `[]`. The expression inside `[]` represents an effective address.

**Examples:**

+ Basic forms:
    
    ```asm
    mov ax, [var]   ; Load value at address 'var' into AX.
    mov [bx], al    ; Store AL into the memory location pointed to by bx.
    ```

+ Indexed and scaled access:

    ```asm
    mov al, [si + 1]            ; Load byte at SI + 1.
    mov eax, [ebx + ecx*4 + 8]  ; Complex addressing: base + index * scale + offset
    ```

---

## Size Specifiers

When the assembler cannot infer the size of a memory operand, you must explicitly specify it using size keywords:

+ `byte` for 8-bit
+ `word` for 16-bit
+ `dword` for 32-bit
+ `qword` for 64-bit

The size specifier is written immediately after the mnemonic.

**Example:**

```asm
mov byte [bx], 0xFF     ; Store 0xFF at the byte pointed to by bx.
mov word [0x7C00], ax   ; Store the value in AX at address 0x7C00.
mov dword [esi], eax    ; Store the value in EAX at the address in ESI.
```

Without a size specifier, the assembler may raise an error or make an incorrect assumption.

---

## Label Syntax

Labels are used to mark positions in code that can be jumped to using control flow instructions such as `jmp`, `je`, `jne`, etc.

Labels must be followed by a colon (`:`) and placed on their own line or before an instruction. They are **case-sensitive** in NASM.

Labels can be global (accessible across files/modules) or local (used only within a defined scope). NASM supports local labels using a `.` prefix when structured under a parent label.

**Example:**

+ Defining a label:

    ```asm
    start:              ; This is a label.
        mov ah, 0x0E
    ```

+ Jumping to a label:

    ```asm
    loop:
        mov ah, 0x0E
        jmp loop        ; This will jump back to the "loop" label.`
    ```

+ A local label:

    ```asm
    label1:     ; This is a global label.

    .label2:    ; This is a local label.
    ```

---

## Final Remarks

You may have found some parts of this file difficult to understand. Don't worry, they will make sense soon. Keep pushing.
