# Assembly Syntax

> **Random Quote:** Trust in the Lord with all your heart, and do not lean on your own understanding.

This section contains notes on the two main syntax styles used in x86 Assembly: **Intel** and **AT&T**. Understanding these syntaxes is essential for reading, writing, and translating low-level code across different tools and environments.

Most assemblers and compilers (such as NASM, GAS, and GCC) support one or both of these styles. Choosing the right syntax depends on the assembler in use and personal or project-specific preferences.

The majority of examples in this repository use **Intel syntax** for the following reasons:

+ It is more readable and beginner-friendly.
+ It is supported by the **NASM** assembler, which will be used throughout this repository.

**AT&T syntax** will be used later when writing inline Assembly within C code in the operating system's kernel.

### Links

+ [**Intel**](./00_intel.md)
+ [**AT&T**](./01_AT&T.md)

> **Note:** You do not need to study both syntax styles immediately. If you are following along with NASM and Intel syntax, you may skip AT&T syntax for now and return to it later when it becomes relevant (when writing inline Assembly in C using GCC).
