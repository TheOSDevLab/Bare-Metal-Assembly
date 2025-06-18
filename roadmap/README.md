# Assembly for OS Development

> **Random Quote:** Excuses are lies you sell yourself to avoid doing the work.

Assembly language is essential for writing low-level code, especially in OS\_development. This roadmap is tailored for absolute beginners who want to learn x86 Assembly with a focus on building operating systems.

Every topic comes with a focused project. Don't skip them. Real understanding comes from doing.

> **Key Rule:** Learn the minimum to move forward. Use new instructions only when you need them. Don't waste time memorizing the whole x86 manual.

---

## Set up dev env

+ Install your assembler of choice. Recommended: **NASM**.

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

**Learn these:**
+ `MOV`, `XCHG`, `LEA`
+ Assembler directives: `equ`, `db` and its variants.

**Projects:**
+ [Data Movement 1](../projects/01_data_movement/README.md)

**Project idea:**
    - Move a literal to memory.
    - Move t

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

## Stack operations

+ `PUSH`, `POP`, `PUSHA`, `POPA`
+ `CALL`, `RET`

---

## Interrupts

+ Software interrupts: `INT 0x10`, `INT 0x13`, etc.
+ `IRET`, `CLI`, `STI`, `HLT`

---

> The journey is not over. More instructions like `LGDT`, `LIDT`, `INVLPG` will appear as you go deeper into OS development. Learn them when they are needed, not all at once. They will all be covered in this repository.
