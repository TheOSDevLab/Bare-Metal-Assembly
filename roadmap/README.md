# Assembly for OS Development

> **Random Quote:** Excuses are lies you sell yourself to avoid doing the work.

Assembly language is essential for writing low-level code, especially in OS_development. This roadmap is tailored for absolute beginners who want to learn x86 Assembly with a focus on building operating systems. It skips outdated DOS-era tutorials and instead dives into the instructions and concepts that matter for real system-level programming.

You don't have to strictly follow the roadmap, feel free to jump to where you need. You don’t need to master every instruction up front. Start writing code, hit walls, then come back and learn what you need.

> **Key Rule:** Learn the minimum to move forward. Use new instructions only when you need them. Don't waste time memorizing the whole x86 manual.

---

## Set up dev env

+ Install your assembler of choice. Recommended: **NASM**.

---

## Instruction Format

+ Choose your syntax (Intel or AT&T). Both will be covered here.
+ Operand order: `mov dest, src`
+ Immediate, register, memory operands
+ Label syntax and jump targets
+ Assembler directives: `section`, `org`, `bits`, `global`

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

## Stack operations

+ `PUSH`, `POP`, `PUSHA`, `POPA`
+ `CALL`, `RET`

---

## Interrupts

+ Software interrupts: `INT 0x10`, `INT 0x13`, etc.
+ `IRET`, `CLI`, `STI`, `HLT`

---

> The journey is not over. More instructions like `LGDT`, `LIDT`, `INVLPG` will appear as you go deeper into OS development. Learn them when they are needed, not all at once. They will all be covered in this repository.