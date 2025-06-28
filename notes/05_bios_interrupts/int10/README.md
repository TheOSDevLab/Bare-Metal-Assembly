# `INT 10h`

> **Random Quote:** We must all suffer one of two things: the pain of discipline or the pain of regret.

## Key Topics

+ [Introduction](#introduction)
+ [Links](#links)

---

## Introduction

`INT 10h` is a BIOS interrupt dedicated to **video services**. It provides a set of routines that allows real-mode programs to interact with the screen at a low level, without requiring direct hardware programming. This includes tasks such as:

+ Displaying text on the screen.
+ Changing the cursor location and appearance.
+ Switching between text and graphics modes.
+ Drawing pixels.
+ Scrolling text windows.
+ Querying or changing display settings.

These services are especially useful before a custom graphics driver or kernel-level display routine has been implemented.

This interrupt is one of the most commonly used BIOS services in early-stage operating system development and bootloaders due to its simplicity and immediate visual feedback.

In 16-bit bootloaders, `INT 10h` is typically used for:

+ Debugging: displaying messages without relying on serial output or disk access.
+ Displaying boot status.
+ Prompting user input via simple text.

### Categories of Services Provided

| AH Value | Category                      |
| -------- | ----------------------------- |
| `0x00`   | Set video mode                |
| `0x01`   | Set cursor shape              |
| `0x02`   | Set cursor position           |
| `0x03`   | Get cursor position           |
| `0x06`   | Scroll window up              |
| `0x07`   | Scroll window down            |
| `0x08`   | Read character and attribute  |
| `0x09`   | Write character and attribute |
| `0x0A`   | Write character only          |
| `0x0E`   | Teletype output (common use)  |
| `0x13`   | Write string                  |
| `0x1A`   | Query video system info       |

Each of these services will be covered in its own dedicated file within this directory.

---

## Links

> The following links are arranged in ascending order for ease of reference.

+ [`0Eh`](./0E.md)
