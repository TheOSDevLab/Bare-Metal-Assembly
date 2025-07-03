# Print Character

> **Random Quote:** Success is nothing more than a few simple disciplines, practiced every day.

## Key Topics

+ [Objective](#objective)
+ [Code Summary](#code-summary)
+ [Practice Areas](#practice-areas)
+ [Run](#run)

---

### Objective

Write a program that does the following:

1. **Sets the video mode** using `BIOS INT 10h, AH=00h` to 80x25 text mode (`03h`).
2. **Prints a single character** (e.g., `A`) on the screen using `BIOS INT 10h, AH=0Eh` (TTY output).

> **Note:** This project is intentionally kept simple to help you get started with real mode assembly programming.

### Code Summary

+ Begin execution at `org 0x7C00`.
+ Set video mode `03h` using `INT 10h, AH=00h`.
+ Load the ASCII character into the `AL` register.
+ Set `AH` to `0Eh` and call `INT 10h` to print the character.
+ Halt the CPU with `hlt`.

### Practice Areas

This program will make you practice using the following:

+ BIOS video interrupts: `INT 10h` function `00h` and `0Eh`.
+ Registers: `AH`, `AL`, `BX`, etc.
+ Basic instructions: `MOV`, `INT`, `HLT`.

### Run

To run the bootloader, execute the `run.sh` script.

```sh
./run.sh
```

This script uses `NASM` to assemble `main.asm` into a bootable flat binary (`main.img`) and launches it in QEMU for testing.

---
