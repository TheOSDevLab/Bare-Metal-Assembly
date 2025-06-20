# Assembly for OS Development

> **Random Quote:** Excuses are lies you sell yourself to avoid doing the work.

Assembly language plays a critical role in low-level programming, particularly in operating system development. This roadmap is designed specifically for absolute beginners seeking to learn x86 Assembly with a focus on building operating systems from the ground up.

Each topic is accompanied by a dedicated project to reinforce practical understanding. Learners are strongly encouraged to complete these projects, as hands-on experience is essential for mastering the material.

> **Guiding Principle:** Learn only what is necessary to progress. Introduce new instructions as they become relevant. There is no need to memorize the entire x86 instruction set in advance.

---

## Set Up Development Environment

This is covered [here](../notes/00_setup_dev_env.md)

+ Install a favourable Linux distribution.
+ Install your assembler of choice.
+ Install your text editor(s).

---

## Syntax

+ Choose your syntax (Intel or AT&T). Both will be covered.
+ Instruction format and operand order.
+ Register naming.
+ Constants/literals.
+ Memory access.
+ Instruction suffixes (AT&T only).
+ Size specifiers (Intel only).
+ Comment style.
+ Label syntax and jump targets.

---

## Boilerplate Code

+ Boot signature.
+ Why `ORG 0x7C00`, `BITS 16`.
+ 512 bytes restriction.

---

## Data Movement

+ `MOV`, `XCHG`, `LEA`
+ Assembler directives: `equ`, `db` and its variants.

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
