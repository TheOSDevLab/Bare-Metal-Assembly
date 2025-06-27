# Boilerplate

> **Random Quote:** Amateurs sit and wait for inspiration. The rest of us just get up and go to work.

This file contains the foundational boilerplate code commonly found in a 16-bit x86 bootloader. It represents the minimum structure required for the BIOS to recognize and execute the boot sector during the system startup process. Each directive and instruction included serves a specific and critical role in ensuring that the bootloader functions correctly within the constraints of real mode and BIOS expectations.

**Prerequisite Knowledge:** Before proceeding, you should be familiar with the following assembler directives:

+ [`ORG`](./04_assembler_directives/org.md)
+ [`BITS`](./04_assembler_directives/bits.md)
+ [`TIMES`](./04_assembler_directives/times.md)
+ [`DB,DW,DD,DQ`](./04_assembler_directives/db.md)

---

## What You Need To Know First

A **bootloader** is a small program responsible for preparing the system to load and run an operating system. It is the first software that executes after the computer is powered on and the system firmware (typically the BIOS or UEFI) has completed its initial hardware checks.

The bootloader is considered small because it is limited to a maximum size of **512 bytes** (the size of a single sector). This limitation exists because the bootloader must fit entirely within the **boot sector (sector 0)** of a bootable storage device, commonly referred to as the **Master Boot Record (MBR)**.

When the computer is powered on, the BIOS (in BIOS-based systems) executes first. It performs a basic hardware check, and if successful, it locates the boot device, loads the bootloader into memory at address `0x7C00`, and transfers control to it.

The BIOS identifies a valid bootloader by checking for a **boot signature (`0xAA55`)** located at the end of the 512-byte sector. If this signature is missing, the BIOS will not recognize the sector as bootable, even if it resides in the Master Boot Record.

It is also important to note that during this entire process, the CPU operates in **real mode (16-bit)**, which is the default mode after reset.

In case you are unfamiliar with these concepts or need a refresher, the boot sequence and CPU modes are discussed in [this file](https://github.com/brogrammer232/Crafting-an-OS-Notes-and-Insights/blob/main/notes/01_computer_architecture/01_cpu.md) in another repository.

---

## Boilerplate Code

This is the boilerplate code:

```asm
org 0x7C00
bits 16

start:

    ; Other instructions.

times 510 - ($ - $$) db 0
dw 0xAA55
```

+ `org 0x7C00`: Informs NASM that the code is intended to run from memory address `0x7C00`, which is where the BIOS loads the boot sector. This directive is essential for correct address calculation.
+ `bits 16`: Instructs the assembler to generate 16-bit instructions, as the CPU operates in real mode immediately after power-on.
+ `times 510 - ($ - $$) db 0`: Pads the binary with zeros so that its total size is exactly 510 bytes before the boot signature. This ensures the boot sector is the correct size.
+ `dw 0xAA55`: Defines the boot signature required by the BIOS. It must appear at the last two bytes (offsets 511-512) of the sector. If this signature is missing, the BIOS will not treat the sector as bootable.
