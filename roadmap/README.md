# Assembly for OS Development

> **Random Quote:** Excuses are lies you sell yourself to avoid doing the work.

Assembly language plays a critical role in low-level programming, particularly in operating system development. This roadmap is designed specifically for absolute beginners seeking to learn x86 Assembly with a focus on building operating systems from the ground up.

Each topic is accompanied by a dedicated project to reinforce practical understanding. Learners are strongly encouraged to complete these projects, as hands-on experience is essential for mastering the material.

> **Guiding Principle:** Learn only what is necessary to progress. Introduce new instructions as they become relevant. There is no need to memorize the entire x86 instruction set in advance.

---

## Set Up Development Environment

This is covered [here](../notes/00_setup_dev_env.md).

**What will be covered:**

+ Determining the best platform.
+ Installing an assembler.
+ Installing QEMU.
+ Installing text editor(s).

---

## Syntax

This is covered in these files: [Intel](../notes/01_syntax/00_intel.md), [AT&T](../notes/01_syntax/01_AT&T.md).

**What will be covered:**

+ Instruction format and operand order.
+ Comment style.
+ Register naming.
+ Constants/literals.
+ Memory access.
+ Instruction suffixes (AT&T only).
+ Size specifiers (Intel only).
+ Label syntax and jump targets.

---

## Boilerplate Code

This is covered in [this file](../notes/02_boilerplate.md).

**What will be covered:**

+ Boot signature.
+ Why `ORG 0x7C00` and `BITS 16`?
+ 512 bytes restriction.

**Learn these first:**

+ Assembly instruction:
    - [`HLT`](../notes/03_assembly_instructions/hlt.md)

+ Assembler directives:
    - [Introduction](../notes/04_assembler_directives/README.md)
    - [`ORG`](../notes/04_assembler_directives/org.md)
    - [`BITS`](../notes/04_assembler_directives/bits.md)
    - [`TIMES`](../notes/04_assembler_directives/times.md)
    - [`DB,DW,DD,DQ`](../notes/04_assembler_directives/db.md)

---

## BIOS Interrupts Introduction

**Learn These:**

+ Assembly instruction:
    - [`INT`](../notes/03_assembly_instructions/int.md)

+ [Introduction to BIOS interrupts](../notes/05_bios_interrupts/README.md)
+ [BIOS INT 10h](../notes/05_bios_interrupts/int10h/README.md)
+ [BIOS INT 10h 00h](../notes/05_bios_interrupts/int10h/00h.md)
+ [BIOS INT 10h 0Eh](../notes/05_bios_interrupts/int10h/0Eh.md)

**Project:**

+ [Print Character](../projects/01_bios_interrupts/01_print_character/README.md)

---

## Data Movement

**Learn These:**

+ Assembly instructions:
    - [Introduction](../notes/03_assembly_instructions/README.md)
    - [`MOV`](../notes/03_assembly_instructions/mov.md)
    - [`XCHG`](../notes/03_assembly_instructions/xchg.md)
    - [`LEA`](../notes/03_assembly_instructions/lea.md)

+ Assembler directives:
    - [`EQU`](../notes/04_assembler_directives/equ.md)

**Projects:**

+ [Swap and Show](../projects/02_data_movement/01_swap_and_show/README.md)
+ [Register Shuffling Puzzle](../projects/02_data_movement/02_register_shuffling_puzzle/README.md)
+ [Array Indexing](../projects/02_data_movement/03_array_indexing/README.md)

---

## Arithmetic

**Learn These:**

+ Assembly Instructions:
    - [`ADD`](../notes/03_assembly_instructions/add.md)
    - [`SUB`](../notes/03_assembly_instructions/sub.md)
    - [`INC`](../notes/03_assembly_instructions/inc.md)
    - [`DEC`](../notes/03_assembly_instructions/dec.md)

**Note:** The `MUL`, `IMUL`, `DIV`, and `IDIV` instructions do exist, but they have been omitted here, as they are seldom required in typical bootloader development.

---

## Bitwise Operations

+ `AND`, `OR`, `XOR`, `NOT`, `SHL`, `SHR`

---

## Conditionals

+ `JC`, `JZ`, `JE`, `JNE`, `JMP`, `JG`, `JL`, etc.
+ `CMP`, `TEST`

---

## Loops

+ `JMP`, `LOOP`
+ `REP`, `REPE`, `REPNE`
+ Assembler directive: `%define`, `times`

---

## String and Memory Instructions

+ `MOVSB`, `STOSB`, `LODSB`, `SCASB`, and their variants.

---

## Stack Operations

+ `PUSH`, `POP`, `PUSHA`, `POPA`
+ `CALL`, `RET`

---

## Interrupts

+ Software interrupts: `INT 0x10`, `INT 0x13`, etc.
+ `IRET`, `CLI`, `STI`, `HLT`

---

> This learning path is incremental. Advanced instructions such as `LGDT`, `LIDT`, and `INVLPG` will be introduced later, as the complexity of OS development increases. These and other instructions will be covered in context throughout this repository.
