# Assembly for OS Development

> **Random Quote:** Excuses are lies you sell yourself to avoid doing the work.

Assembly language is essential for writing low-level code, especially in OS_development. This roadmap is tailored for absolute beginners who want to learn x86 Assembly with a focus on building operating systems. It skips outdated DOS-era tutorials and instead dives into the instructions and concepts that matter for real system-level programming.

You don't have to strictly follow the roadmap, feel free to jump to where you need.

> **Key Rule:** Learn the minimum to move forward. Use new instructions only when you need them. Don't waste time memorizing the whole x86 manual.

---

## Set up dev env

+ Install your assembler of choice. I recommend NASM.

---

## Assembler Directives Basics

+ `section`, `global`, `org`, `bits`
+ `times`, `equ`, `db/dw/dd`
+ `resb`, `resw`, `resd`
+ `macro`, `%define`, `%if`
+ `rep`

---

## Instruction Format

+ Learn both or choose your poison:
	- Intel's syntax
	- AT&T syntax
+ Operand order: `mov dest, src`
+ Immediate, register, memory operands
+ Label syntax and jump targets

---

## Data Movement Instructions

+ `mov`, `xchg`, `lea`

---

## Arithmetic and Logic

+ Learn the following commands: `ADD`, `SUB`, `INC`, `DEC`, `MUL`, `DIV`. `AND`, `OR`, `XOR`, `NOT`, `SHL`, `SHR`.

+ `ADD`, `SUB`, `INC`, `DEC`
+ `AND`, `OR`, `XOR`, `NOT`

---

## Control flow

+ `JC`, `JZ`, `JE`, `JNE`, `JMP`, `JG`, `JL`
+ `CMP`, `TEST`
+ `CALL`, `RET`
+ `LOOP`, `REP`, `REPE`, `REPNE`

---

## String and Memory Instructions

+ `MOVSB`, `MOVSW`, `MOVSD`
+ `STOSB`, `STOSW`, `STOSD`
+ `LODSB`, `LODSW`, `LODSD`
+ `SCASB`, `SCASW`, `SCASD`
+ `REP`, `REPE`, `REPNE`

---

## Stack operations

+ `PUSH`, `POP`, `PUSHA`, `POPA`
+ `CALL`, `RET`

---

## Interrupts

+ Software interrupts: `INT 0x10`, `INT 0x13`, etc.
+ `IRET`, `CLI`, `STI`, `HLT`

---

> The journey is not over. There are a lot of other commands that you need to know like `LGDT`, etc. You'll learn them as you go deeper into OS dev.