# Assembly Instructions

> **Random Quote:** The only thing standing between you and your goal is the story you keep telling yourself as to why you can't achieve it.

## Key Topics

+ [What Is an Assembly Instruction?](#what-is-an-assembly-instruction)
+ [About This Directory](#about-this-directory)
+ [Links](#links)

---

## What Is an Assembly Instruction?

An **assembly instruction** is a single, low-level command written in assembly language that directly corresponds to a machine-level operation executed by the CPU. Each instruction tells the processor to perform a specific task, such as moving data, performing arithmetic, manipulating bits, or controlling program flow.

Assembly instructions are part of the **Instruction Set Architecture (ISA)** of a processor, which defines the operations the processor can perform.

### Characteristics of Assembly Instructions

+ **Architecture-specific:** Instructions vary between CPU architectures (e.g., x86, ARM, RISC-V).
+ **One-to-one mapping:** Most assembly instructions translate directly to a single machine code instruction.
+ **Efficient but low-level:** Provides precise control over hardware, but requires managing memory and registers manually.
+ **Non-portable:** Code written in assembly is typically not portable across different CPU families.

---

## About This Directory

This directory contains focused explanations of **assembly instructions** used in x86 Assembly programming (Intel syntax). Each file covers a specific instruction (such as `MOV`, `ADD`, and others), explaining its purpose, usage, and relevance in low-level development.

The links listed below are organized in **alphabetical order** for ease of reference. However, you are strongly advised not to study these instructions in alphabetical order, as doing so may disrupt the natural learning progression.

Instead, follow the recommended sequence provided in the project's learning [roadmap](../../roadmap/README.md), which outlines when and where each instruction is introduced in context.

---

## Links

+ [`HLT`](hlt.md)
+ [`LEA`](lea.md)
+ [`MOV`](mov.md)
+ [`XCHG`](xchg.md)
