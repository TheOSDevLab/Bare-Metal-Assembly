# Assembler Directives

> **Random Quote:** Discipline equals freedom.

## Key Topics

+ [What Is an Assembler Directive?](#what-is-an-assembler-directive)
+ [About This Directory](#about-this-directory)
+ [Links](#links)

---

## What Is an Assembler Directive?

An **assembler directive** (also known as a *pseudo-instruction*) is a command that gives instructions to the assembler, not the CPU. These directives **do not generate machine code** and are not executed at runtime. Instead, they control how the assembler processes the source file and how it outputs binary or object code.

Assembler directives are typically used to:

+ Define memory layout (`ORG`, `ALIGN`).
+ Set the instruction mode (`BITS 16`, `BITS 32`).
+ Declare or reserve data (`DB`, `DW`, `RESB`).
+ Control file size and padding (`TIMES`).
+ Create symbolic constants (`EQU`, `%DEFINE`).
+ Control conditional assembly or macros (`%if`, `%macro`, etc.).

These directives are essential for tasks like writing bootloaders, configuring memory regions, or preparing flat binaries, where precise control over the output file structure is required.

---

## About This Directory

This directory contains focused explanations of **assembler directives** used in x86 Assembly programming (Intel syntax). Each file covers a specific directive (such as `ORG`, `BITS`, `TIMES`, and others), explaining its purpose, usage, and relevance in low-level development.

The links listed below are organized in **alphabetical order** for ease of reference. However, you are strongly advised not to study these directives in alphabetical order, as doing so may disrupt the natural learning progression.

Instead, follow the recommended sequence provided in the project's learning [roadmap](../../roadmap/README.md), which outlines when and where each directive is introduced in context.

---

## Links

+ [`BITS`](./bits.md)
+ [`DB,DW,DD,DQ`](./db.md)
+ [`ORG`](./org.md)
+ [`TIMES`](./times.md)
