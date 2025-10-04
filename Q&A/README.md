# Q&A

> **Random Quote:** Dreams don't work unless you do.

This directory collects all the small but important questions that come up while working on low‑level programming and bootloader development; questions that are not directly covered in the main notes but are worth exploring in detail. Each file in this directory documents one such question along with a clear explanation, examples, and sometimes experiments to try out. Over time, this serves as a growing reference of practical insights, edge cases, and hard‑won answers that fill the gaps left by formal tutorials or textbooks.

---

## Links

1. [Why are variables in assembly programs typically defined toward the end of the source file, near the boot signature?](01_why_variables_are_at_the_bottom.md)
2. [Which registers can be used as base or index registers in 16-bit addressing modes?](02_which_registers_are_valid_for_memory_addressing.md)
3. [How do I convert an integer into a string for printing?](03_convert_integer_to_string.md)
4. [How can I change the counter register used by `LOOP` using address size override?](04_how_to_override_address_size.md)
5. [What's the difference between `EQU` and `%define` assembler directives?](05_equ_vs_%25define.md)
6. [When comparing signed numbers in x86 assembly, why does `SF` not being equal to `OF` mean that one number is less than the other?](06_sf_of_comparison_logic.md)
7. [How do I know whether to use a macro or a function in assembly?](07_macro_vs_function.md)
8. [How can I determine whether I am working with signed or unsigned numbers in assembly?](08_signed_and_unsigned_numbers.md)
9. [What is an atomic instruction?](09_atomic_instructions.md)
10. [How do I perform multiplication using left shifts and addition?](10_shift_and_addition_multiplication.md)
11. [Why is the sector count for INT 13h AH=02h limited to 128 when an 8-bit register can hold 255?](11_sector_count_limit.md)

---
