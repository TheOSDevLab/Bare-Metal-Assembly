# Array Indexing

> **Random Quote:** Curiosity is the spark behind every breakthrough.

## Key Topics

+ [Objective](#objective)
    - [Code Summary](#code-summary)
+ [Practice Areas](#practice-areas)
+ [Run](#run)
+ [Output and Explanation](#output-and-explanation)

---

## Objective

This project demonstrates how to use the `LEA` instruction to calculate memory addresses and index into an array-like structure. You will declare a small block of data in memory, computer the address of specific elements, and print them to the screen.

### Code Summary

1. Declare 5 bytes in memory (e.g., `'a'`, `'b'`, `'c'`, `'d'`, `'e'`).
2. Use `LEA` to computer the address of the 3rd element.
3. Use `MOV` to load that byte into a register and print it.
4. Use `LEA` again to computer the address of a different element.
5. Load and print that byte as well.
6. Halt.

---

## Practice Areas

This project will help you practice:

+ **Using `LEA`**: Computing effective addresses for data in memory.
+ **Array-like indexing**: Accessing specific elements by offset.
+ **`MOV` instruction**: Loading data from memory into registers.
+ **BIOS TTY output**: Printing characters to the screen via `INT 10h, AH=0Eh`.
+ **Memory layout awareness**: Understanding how sequential `DB` declarations are stored.

---

## Run

To run the bootloader, execute the `run.sh` script.

```sh
./run.sh
```

The script uses `NASM` to assemble `main.asm` into a bootable flat binary (`main.img`) and launches it in QEMU for testing.

---

## Output and Explanation

When you run the program, you'll get this output:

[Program's Output](../../../resources/images/array_indexing_output.png)

### What This Means

This program prints two letters:

+ The first letter, `'i'`, is the third element in the array-like structure named `vowels`. Its address is calculated with:

    ```assembly
    lea si, [vowels + 2]
    ```

    This tells the assembler to take the starting address of `vowels` and add an offset of 2 (since indexing starts at 0), which points to the third character.

+ The second letter, `'u'`, is the fifth and last element in the same structure. Its address is calculated with:

    ```assembly
    lea si, [vowels + 4]
    ```

    Here, an offset of 4 points to the fifth character.

This demonstrates that `LEA` is correctly computing the effective addresses of specific elements within the array, allowing each character to be accessed and printed.
