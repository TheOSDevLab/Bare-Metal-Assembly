# BitHunt

> **Random Quote**: Knowing yourself is the beginning of all wisdom.

## Sections

+ [Overview](#overview)
    - [Objectives](#objectives)
+ [How It Works](#how-it-works)
+ [Practice Areas](#practice-areas)
+ [Running the Project](#running-the-project)
+ [Output and Explanation](#output-and-explanation)
+ [Notes](#notes)

---

## Overview

This project demonstrates how to find the highest and lowest set bits in a 16-bit unsigned integer without using the `BSR` (Bit Scan Reverse) or `BSF` (Bit Scan Forward) instructions. Instead, it implements a generic bit scanning routine using shift and loop instructions. The program displays both the index of the highest set bit and the lowest set bit.

### Objectives

+ Write a generic bit scanning routine that can work in both directions.
+ Print the index of the highest set bit in a given number.
+ Print the index of the lowest set bit in the same number.
+ Practice using BIOS interrupts for string and character output.

---

## How It Works

1. The program initializes video mode using BIOS interrupt `INT 10h` to clear the screen.  
2. It prints a message indicating that the highest set bit will be displayed.  
3. The `bit_scan` procedure is called with `DL = 1` to search for the highest set bit.  
4. Inside `bit_scan`:
   + The number (`NUM`) is shifted repeatedly.  
   + If scanning for the highest set bit (`SHL`), the loop terminates when a set bit is shifted into the carry flag.  
   + If scanning for the lowest set bit (`SHR`), the same check is applied but from the other direction.  
   + The correct index is computed depending on the scan direction.  
5. The found index is passed to `print_index`, which converts it into decimal characters and prints it.  
6. The program prints a newline and repeats the same process for the lowest set bit by calling `bit_scan` with `DL = 0`.  
7. The program halts execution.

---

## Practice Areas

+ Implementing a generic procedure (`bit_scan`) with different modes of operation.  
+ Using `SHL` and `SHR` instructions to test individual bits.  
+ Performing arithmetic to calculate bit positions depending on scan direction.  
+ Converting numbers to decimal ASCII characters for display.  
+ Using BIOS interrupts (`INT 10h`) for character and string output.  
+ Writing structured and reusable assembly procedures.  

---

## Running the Project

To run the bootloader, execute the `run.sh` script.

```sh
./run.sh
```

The script uses `NASM` to assemble `main.asm` into a bootable flat binary (`main.img`) and launches it in QEMU for testing.

---

## Output and Explanation

For `NUM equ 1026` (binary `0000 0100 0000 0010`), the program prints:

![Program's Output](../../../resources/image/bit_hunt_output.png)

Explanation:

* The highest set bit is at position 10 (counting from 0, least significant bit).
* The lowest set bit is at position 1.
  This matches the binary representation of the number.

---

## Notes

* This project assumes the number fits within 16 bits (`0 < NUM ≤ 65,535`).
* The bit indices start from 0 at the least significant bit (rightmost).
* The generic `bit_scan` routine can be adapted to larger numbers by changing the counter and shifting logic.
* In real CPUs, the `BSF` and `BSR` instructions perform these tasks directly, but this project demonstrates how to emulate them with simpler instructions.

---
