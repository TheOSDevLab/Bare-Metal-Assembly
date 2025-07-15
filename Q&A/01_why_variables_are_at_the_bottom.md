# Why Variables Are Placed at the End in a Bootloader

> **Random Quote:** Focus is the art of knowing what to ignore.

This file contains the answer to this question:

> "Why are variables in assembly programs typically defined toward the end of the source file, near the boot signature?"

---

## Short Answer

NASM lays out code and data in the order they appear. In a bootloader, if you put variables at the top, the CPU will try to execute those data bytes as instructions unless you add a jump to skip over them. Placing variables at the end ensures execution starts with valid code and keeps the layout simple.

---

## Long Answer

Assemblers such as NASM arrange code and data sequentially in the final binary, in the exact order they appear in the source file. In a bootloader, execution begins immediately at memory address `0x7C00`, where the BIOS transfers control after loading the first 512 bytes. If variables are defined at the top of the file, those data bytes become the very first bytes in the binary. Instead of proper instructions, the CPU would begin executing raw data, which often leads to undefined behavior or a crash.

To avoid this, one would need to add an explicit jump instruction to skip over the data section and reach the actual code. However, this introduces unnecessary complexity and consumes additional bytes in the very limited 512‑byte space of a boot sector. By placing variables after the code, near the end of the file, the CPU begins execution directly with valid instructions at `0x7C00`, ensuring predictable behavior and a simpler, cleaner layout.

---

## Try It Yourself

A great way to understand this behavior is to experiment. Take a simple, working bootloader and move your variable definitions (the `DB` lines) to the very top of the file, before any instructions. Assemble and run it in an emulator like QEMU. You will likely see unexpected behavior, random symbols, or even a crash, because the CPU will begin executing those raw data bytes as if they were instructions. This hands‑on test makes the concept clear and shows exactly why variables are typically placed after the code.
