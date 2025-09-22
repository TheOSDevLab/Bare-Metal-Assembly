# BIOS Interrupts

> **Random Quote:** At first, they'll ask you why you're doing it. Later, they'll ask you how you did it.

## Key Topics

+ [Introduction](#introduction)
+ [How BIOS Interrupts Work](#how-bios-interrupts-work)
+ [About This Directory](#about-this-directory)

---

## Introduction

**BIOS interrupts** are software-based mechanisms provided by the **BIOS (Basic Input/Output System)** to expose a set of low-level services to programs running in **real mode** (16-bit mode). These interrupts provide standardized, pre-implemented routines that allow software to interact directly with hardware devices such as the screen, keyboard, disk drives, and other peripherals. This is especially useful in environments such as bootloaders and early-stage operating system kernels, where:

+ There is **no standard library** (like in C or higher-level languages).
+ There is **no operating system** yet to abstract hardware.
+ Hardware access needs to be performed in a safe and consistent manner.

### Advantages of BIOS Interrupts

+ **Hardware abstraction:** BIOS handles the hardware specifics.
+ **No drivers required:** Programs do not need to implement their own drivers.
+ **Consistency across platforms:** Interrupt behavior remains consistent and predictable across different systems, provided the BIOS is compliant.
+ **Essential in bootloaders:** Bootloaders rely on BIOS services to load further stages.

**Note:** BIOS interrupts are only available in real mode. They are not accessible in protected mode (32-bit) or long mode (64-bit) without special workarounds.

---

## How BIOS Interrupts Work

BIOS interrupts are invoked using the `INT` instruction, followed by an interrupt number. Each interrupt number corresponds to a particular category of services. For example:

+ `int 0x10`: Video services (e.g., printing characters to the screen).
+ `int 0x13`: Disk services (e.g., reading/writing sectors).
+ `int 0x16`: Keyboard input services.

When an `INT` instruction is executed:

1. The processor temporarily saves the current state (via the stack).
2. It looks up the **Interrupt Vector Table (IVT)** to find the address of the corresponding interrupt handler.
3. It jumps to that address and begins executing the BIOS routine.
4. Upon completion, the `IRET` instruction is used to return control to the calling code.

The IVT is located at **memory address** `0x0000:0000` and contains 256 entries (one for each interrupt number, `0x00` to `0xFF`).

---

## About This Directory

This directory contains focused explanations of **BIOS interrupts** as used in x86 Assembly programming with Intel syntax. Each subdirectory covers a specific category of BIOS interrupt services (such as `int10h` for video services, `int13h` for disk services, and others), explaining their purpose, usage, and relevance in low-level development.

The links listed below are arranged in **ascending order** for ease of reference. However, you are strongly advised not to study these interrupts in ascending order, as doing so may disrupt the natural learning progression.

Instead, follow the recommended sequence provided in the project's learning [roadmap](../../roadmap/README.md), which outlines when and where each interrupt is introduced in context.

---

## Links

+ [`INT 10h`](./int10/README.md)
+ [`INT 13h`](./int13/README.md)

---
