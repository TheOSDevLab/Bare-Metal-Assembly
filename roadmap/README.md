# Assembly for OS Development

> **Random Quote:** Excuses are lies you sell yourself to avoid doing the work.

Assembly language plays a critical role in low-level programming, particularly in operating system development. This roadmap is designed specifically for absolute beginners seeking to learn x86 Assembly with a focus on building operating systems from the ground up.

Each topic is accompanied by a dedicated project to reinforce practical understanding. Learners are strongly encouraged to complete these projects, as hands-on experience is essential for mastering the material.

> **Guiding Principle:** Learn only what is necessary to progress. Introduce new instructions as they become relevant. There is no need to memorize the entire x86 instruction set in advance.

---

## Set Up Development Environment

This is covered [here](../notes/00_setup_dev_env.md).

### What Will be Covered

+ Determining the best platform.
+ Installing an assembler.
+ Installing QEMU.
+ Installing text editor(s).

---

## Syntax

This is covered in these files: [Intel](../notes/01_syntax/00_intel.md), [AT&T](../notes/01_syntax/01_AT&T.md).

### What Will be Covered

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

### What Will be Covered

+ Boot signature.
+ Why `ORG 0x7C00` and `BITS 16`?
+ 512 bytes restriction.

### Learn These

+ **Assembly instruction**:
    - [`HLT`](../notes/03_assembly_instructions/hlt.md)

+ **Assembler directives**:
    - [Introduction](../notes/04_assembler_directives/README.md)
    - [`ORG`](../notes/04_assembler_directives/org.md)
    - [`BITS`](../notes/04_assembler_directives/bits.md)
    - [`TIMES`](../notes/04_assembler_directives/times.md)
    - [`DB,DW,DD,DQ`](../notes/04_assembler_directives/db.md)

---

## BIOS Interrupts Introduction

### Learn These

+ **Assembly instruction**:
    - [`INT`](../notes/03_assembly_instructions/int.md)

+ [Introduction to BIOS interrupts](../notes/05_bios_interrupts/README.md)
+ [BIOS INT 10h](../notes/05_bios_interrupts/int10h/README.md)
+ [BIOS INT 10h 00h](../notes/05_bios_interrupts/int10h/00h.md)
+ [BIOS INT 10h 0Eh](../notes/05_bios_interrupts/int10h/0Eh.md)

### Project

+ [Print Character](../projects/01_bios_interrupts/01_print_character/README.md)

---

## Data Movement

### Learn These

+ **Assembly instructions**:
    - [Introduction](../notes/03_assembly_instructions/README.md)
    - [`MOV`](../notes/03_assembly_instructions/mov.md)
    - [`XCHG`](../notes/03_assembly_instructions/xchg.md)
    - [`LEA`](../notes/03_assembly_instructions/lea.md)

+ **Assembler directives**:
    - [`EQU`](../notes/04_assembler_directives/equ.md)

### Projects

+ [Swap and Show](../projects/02_data_movement/01_swap_and_show/README.md)
+ [Register Shuffling Puzzle](../projects/02_data_movement/02_register_shuffling_puzzle/README.md)
+ [Array Indexing](../projects/02_data_movement/03_array_indexing/README.md)

---

## Loops

### Learn These

+ **Assembly Instructions**:
    + [`LOOP`](../notes/03_assembly_instructions/loop.md)
    + [`LOOPE` / `LOOPZ`](../notes/03_assembly_instructions/loope_or_loopz.md)
    + [`LOOPNE` / `LOOPNZ`](../notes/03_assembly_instructions/loopne_or_loopnz.md)
    + [`JMP`](../notes/03_assembly_instructions/jmp.md)

+ **Assembler directive**:
    + [`%define`](../notes/04_assembler_directives/%define.md)

### Projects

1. [Operation Skip B](../projects/03_loops/01_operation_skip_b/README.md)
2. [Blastoff Countdown](../projects/03_loops/02_blastoff_countdown/README.md)
3. [Repeat Radar](../projects/03_loops/03_repeat_radar/README.md)
4. [Diff Sniffer](../projects/03_loops/04_diff_sniffer/README.md)
5. [Char Hunt](../projects/03_loops/05_char_hunt/README.md)

---

## Conditionals

### Learn These

#### Assembly Instructions

+ [`JE` / `JZ`](../notes/03_assembly_instructions/je_or_jz.md)
+ [`JNE` / `JNZ`](../notes/03_assembly_instructions/jne_or_jnz.md)
+ [`JBE` / `JNA`](../notes/03_assembly_instructions/jbe_or_jna.md)
+ [`JA` / `JNBE`](../notes/03_assembly_instructions/ja_or_jnbe.md)
+ [`JLE` / `JNG`](../notes/03_assembly_instructions/jle_or_jng.md)
+ [`JC` / `JB` / `JNAE`](../notes/03_assembly_instructions/jc_or_jb_or_jnae.md)
+ `JNC` / `JAE` / `JNB`
+ `JG` / `JNLE`
+ `CMP`, `TEST`

> I intend to address these instructions at a later stage in my study plan:
> + `JGE` / `JNL`
> + `JL` / `JNGE`
> + `JO`
> + `JNO`
> + `JS`
> + `JNS`
> + `JP` / `JPE`
> + `JNP` / `JPO`
> + `JCXZ`
> + `JECXZ`

#### Assembler Directives

+ `%macro`

----

## Stack Operations

+ `PUSH`, `POP`, `PUSHA`, `POPA`
+ `CALL`, `RET`

---

## Arithmetic

### Learn These

+ **Assembly Instructions**:
    - [`ADD`](../notes/03_assembly_instructions/add.md)
    - [`SUB`](../notes/03_assembly_instructions/sub.md)
    - [`INC`](../notes/03_assembly_instructions/inc.md)
    - [`DEC`](../notes/03_assembly_instructions/dec.md)
    - [`DIV`](../notes/03_assembly_instructions/div.md)

**Note:** The `MUL`, `IMUL`, and `IDIV` instructions do exist, but they have been omitted here, as they are seldom required in typical bootloader development. You can still learn them on your own if you feel the need.

### Projects

+ [Add Two Numbers](../projects/06_arithmetic/01_add_two_numbers/README.md)
+ [Difference Finder](../projects/06_arithmetic/02_difference_finder/README.md)
+ [Climb and Drop](../projects/06_arithmetic/03_climb_and_drop/README.md)
+ [Accumuloop](../projects/06_arithmetic/04_accumuloop/README.md)

---

## Bitwise Operations

+ `AND`, `OR`, `XOR`, `NOT`, `SHL`, `SHR`

---

## String and Memory Instructions

+ **Assembly Instructions**:
    + [`REP`](../notes/03_assembly_instructions/rep.md)
    + [`REPE` / `REPZ`](../notes/03_assembly_instructions/repe_or_repz.md)
    + [`REPNE` / `REPNZ`](../notes/03_assembly_instructions/repne_or_repnz.md)


+ `MOVSB`, `STOSB`, `LODSB`, `SCASB`, and their variants.

---

## Interrupts

+ Software interrupts: `INT 0x10`, `INT 0x13`, etc.
+ `IRET`, `CLI`, `STI`, `HLT`

---

> This learning path is incremental. Advanced instructions such as `LGDT`, `LIDT`, and `INVLPG` will be introduced later, as the complexity of OS development increases. These and other instructions will be covered in context throughout this repository.
