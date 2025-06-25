# `ORG` (NASM)

> **Random Quote:** The only way to do great work is to love what you do.

The `ORG` directive (short for **origin**) is used in Assembly language to tell the assembler the **starting memory address** at which the program or section of code will be loaded and executed. It **does not insert any machine instruction** into the final output, nor does it affect the actual binary, it only influences how the assembler calculates memory addresses.

`ORG` is primarily used when writing **flat binaries**, such as bootloaders where the code is not loaded by an operating system but directly by the firmware (e.g., BIOS).

### Why `ORG` is Important

By default, assemblers assume your code starts at address `0x0000`. But in bare-metal programming, where code is directly executed by the hardware, this assumption is often wrong.

For example, when the BIOS loads the bootloader, it places it into memory at address `0x7C00`. If the assembler is not made aware of this, it will calculate incorrect offsets for jumps, labels, memory references, and stack addresses. The following directive corrects this:

```asm
org 0x7C00
```

---

## Syntax

```asm
org address
```

+ `address`: Must be a constant value. It can be written in hexadecimal (e.g., `0x7C00`), decimal (`31744`), or binary.

### Practical Example:

```asm
org 0x7C00
bits 16

start:
	mov si, message		; Correct address of 'message' is (0x7C00 + offset).

message db "Hello World!", 0

...
```

In the above example, `message` is a memory label. Its address will be calculated relative to `0x7C00`, which is exactly where the BIOS loads the code.

If `org` were omitted, NASM would assume the base address is `0x0000`, and the `mov si, message` instruction would load the wrong address into `SI`, causing garbage or crashes when accessed.

Missing or misaligned `ORG` may not crash immediately, but it will almost certainly cause unexpected behavior, especially when calling BIOS interrupts, accessing strings, or jumping to labels.

---

## What `ORG` Does Internally

`ORG` changes the value of the special symbol `$$`, which NASM uses to calculate relative addresses.

+ `$$`: Origin (e.g., `0x7C00`).
+ `$`: Current offset from the start of the section.
+ `($ - $$)`: The current offset from the origin.

This is why padding expressions often look like:

```asm
times 510 - ($ - $$) db 0
```

This calculates how many bytes remain before reaching 510 bytes from the `ORG` origin (used to fill out the boot sector before inserting the 2-byte boot signature).