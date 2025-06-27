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

+ Assembler directives:
    - [`ORG`](../notes/04_assembler_directives/org.md)
    - [`BITS`](../notes/04_assembler_directives/bits.md)
    - [`TIMES`](../notes/04_assembler_directives/times.md)
    - [`DB,DW,DD,DQ`](../notes/04_assembler_directives/db.md)

---

## Data Movement

+ Assembly instructions:
    - [`MOV`](../notes/03_assembly_instructions/mov.md)
    - [`XCHG`](../notes/03_assembly_instructions/xchg.md)
    - [`LEA`](../notes/03_assembly_instructions/lea.md)

+ Assembler directives:
    - [`EQU`](../notes/04_assembler_directives/equ.md)

+ Projects:

---

## Arithmetic and Logic

+ `ADD`, `SUB`, `INC`, `DEC`
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
