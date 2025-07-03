# Swap and Show

> **Random Quote:** Don't count the days, make the days count.

## Key Topics

+ [Objective](#objective)
    - [Code Summary](#code-summary)
+ [Practice Areas](#practice-areas)
+ [Run](#run)

---

## Objective

Write a program that swaps two variables using the `XCHG` instruction.

### Code Summary

1. Declare two variables using `DB`.
2. Print the variables using `BIOS INT 10h, AH=0Eh`.
3. Swap the variables using `XCHG`.
4. Print the swapped values.
5. Halt.

---

## Practice Areas

This project will help you bild intuition around:

+ **The `MOV` instruction**: Moving data from memory to registers and between registers.
+ **The `XCHG` instruction**: Swapping values without using a temporary register.
+ **Memory declaration using `DB`**: Storing values directly in memory.
+ **Basic character output using BIOS**: Printing characters using `INT 10h, AH=0Eh`.
+ **Program structure and flow**: Building a minimal program from data definition to output.

---

## Run

To run the bootloader, execute the `run.sh` script.

```sh
./run.sh
```

The script uses `NASM` to assemble `main.asm` into a bootable flat binary (`main.img`) and launches it in QEMU for testing.
