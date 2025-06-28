# Setup Development Environment

> **Random Quote:** Commit your work to the Lord, and your plans will be established.

## Key Topics

+ [Platform](#platform)
+ [Assembler](#assembler)
+ [Installing NASM on Linux](#installing-nasm-on-linux)
+ [Installing QEMU](#installing-qemu)
+ [Text Editors](#text-editors)

---

## Platform

Use **Linux**. Here's why:

Operating System development and low-level programming require direct hardware access, fine-grained control over the development environment, and customizable toolchains - conditions where Linux significantly outperforms Windows in terms of flexibility, transparency, and developer support.

### Disadvantages of Using Windows

+ **Closed source:** Windows internals are not accessible for study or modification.
+ **Limited low-level access:** Windows restricts direct hardware access. Accessing hardware-level features often requires driver development and complex APIs.
+ **Proprietary toolchains:** Most of the powerful tools on Windows are proprietary, heavyweight, and tied to Windows-specific formats and standards.
+ **Poor raw binary support:** Generating raw binary formats like `.bin` (needed for bootloaders) is not straightforward. Most assemblers default to PE (Portable Executable) format.
+ **Hyper-V interface:** Windows' built-in virtualization can conflict with other VM software, complicating testing.
+ **Dependency hell for tooling:** Setting up tools like `NASM`, `QEMU` and custom linkers on Windows requires extra configuration or WSL (Windows Subsystem for Linux) or extensive configuration. Just use Linux.
+ **Unpredictable file I/O behavior:** Filesystems like NTFS can introduce quirks (e.g., metadata pollution) that interfere clean raw binary output.

### Advantages of Using Linux

+ **Open source:** The kernel, toolchains, and supporting utilities are all open source and transparent. Perfect for learning how OSes work.
+ **Native tool support:** Assemblers like `nasm`, emulators like `qemu`, and utilities like `dd` and `mkisofs` are either built-in or installable via package managers.
+ **Powerful terminal and shell tools:** Linux's CLI (Command-Line Interface) tools are lighweight, scriptable, and designed for developers.
+ **Virtualization friendly:** Tools like `qemu` and Bochs run seamlessly.
+ **Scriptability and automation:** Shell scripting enables you to build full toolchains and automated testing environments.
+ **Filesystem control:** Linux filesystems (e.g., ext4) allow raw binary operations without automatic metadata pollution.
+ **Better community and learning resources:** Nearly all OS dev tutorials and examples are written for Linux or Unix-like systems.

Using Linux is not just a matter of preference, it's a practical necessity for serious Assembly and OS development.

---

## Assembler

An **assembler** is a tool that converts assembly language code (a human-readable representation of machine instructions), into binary machine code that a processor can execute. Assembly language provides a low-level abstraction of a system's hardware and is specific to a computer achitecture (e.g., x86, x86\_64, ARM).

### Key Characteristics of an Assembler:

+ **Low-level translation:** It maps mnemonic instructions (e.g, `MOV`, `ADD`) directly to opcodes.
+ **Architecture-specific:** Each assembler targets a specific instruction set (e.g., x86).
+ **Performance-critical:** Used where precise control over hardware is required (e.g., OS kernels, bootloaders, embedded systems).

### Common Assemblers:

+ **NASM (Netwide Assembler):** Popular, open-source assembler for x86 and x86\_64 architectures. It is known for clean syntax.
+ **YASM:** NASM-compatible assembler with additional features and better modularity.
+ **GAS (GNU Assembler):** Part of the GNU Binutils. It uses AT&T syntax by default, which can be less readable for beginners.
+ **FASM (Flat Assembler):** Lightweight assembler known for speed and compactness.

For OS development, especially x86 platforms, **NASM (Netwide Assembler)** is highly recommended due to:

+ Readable and beginner-friendly Intel syntax.
+ Excellent support for flat binaries (required for bootloaders and OS kernels).
+ Active community and extensive documentation.

---

## Installing NASM on Linux

### Void Linux

Void Linux uses the `xbps` package manager.

```bash
sudo xbps-install -Sy nasm

# Verify installation
nasm -v
```

+ `-S`: Synchronize the package index.
+ `-y`: Assume "yes" for all prompts.

### Debian-based Distributions (e.g., Ubuntu, Kali Linux, Linux Mint)

These use the `apt` package manager:

```bash
sudo apt update
sudo apt install nasm

# Verify installation
nasm -v
```

### Arch-Based Distributions (e.g., Arch Linux, Manjaro)

These use the `pacman` package manager:

```bash
sudo pacman -S nasm

# Verify installation
nasm -v
```

+ `-S`: Install the package from official repositories.

### Example Usage

Compiling an assembly file (`bootloader.asm`) into a raw binary file (`bootloader.bin`).

```bash
nasm -f bin bootloader.asm -o bootloader.bin
```

---

## Installing QEMU

**QEMU (Quick EMUlator)** is a **hardware emulator and virtualizer**. It allows you to run operating systems and programs designed for one hardware platform on another, making it an essential tool for low-level software development.

In operating system development, QEMU is particularly useful because:

+ It emulates a full machine (including CPU, memory, I/O devices, and peripherals) without needing actual hardware.
+ It boot raw binaries and ISO images, perfect for testing custom bootloaders and kernels.
+ It supports debugging features like GDB integration and instruction tracing.
+ It provides fast iteration: no need to reboot real hardware.
+ It's scriptable and consistent, perfect for CI setups or automated builds.

### Installing on Void Linux

```bash
sudo xbps-install -S qemu qemu-system-x86_64 qemu-img
```

### Installing on Debian Distributions

```bash
sudo apt install qemu-system-x86

# Optional tools
sudo apt install qemu-utils
```

### Installing on Arch Linux

```bash
sudo pacman -Syu qemu
```

This installs the full QEMU suite, including support for x86 systems.

---

## Text Editors

Assembly programming demands precision, every character matters. Your editor should minimize errors, support syntax awareness, and integrate smoothly into the toolchain. Below are some of the best options:

### Vim / Neovim

**Vim** is a modular, highly configurable, and terminal-based text editor. **Neovim** is a modern refactor of Vim, offering better plugin support, asynchronous I/O, and cleaner configuration.

**Advantages:**

+ Lightweight and fast.
+ Keyboard-driven workflow.
+ Extensive plugin ecosystem.
+ Can be easily integrated into automated build systems and run inside TTYs, terminals, or even QEMU serial consoles.

**Ideal for:**

+ Hardcore terminal users.
+ Anyone building a minimalist, distraction-free dev setup.

---

### Sublime Text

**Sublime Text** is a lightweight yet powerful GUI text editor with great responsiveness and a focus on developer ergonomics.

**Advantages:**

+ Intelligent autocomplete.
+ Syntax highlighting.
+ GUI + mutli-tab layout for managing multiple ASM files.
+ Rich plugin ecosystem via **Package Control**.

**Disadvantages:**

+ Not open source (but it's free to use).
+ Requires some setup for custom build systems and integration with tools like `nasm`, `qemu`, or `make`.

**Ideal for:**

+ Developers who prefer graphical interfaces but want speed and flexibility.
+ Editing and reviewing larger files, multi-window workflows.

---

### Visual Studio Code

**VS Code** is a free, open-source, Electron-based code editor developed by Microsoft.

**Advantages:**

+ Rich IntelliSense support (via extensions).
+ Integrated terminal and Git support.
+ Debuggers and build tasks can be customized.

**Disadvantages:**

+ Heavier than Sublime or Vim.
+ Requires more configuration for raw OS development workflows.

**Ideal for:**

+ Developers who prefer full IDE-like features without a full IDE.
+ Projects involving mixed-language development (e.g, C and Assembly).

---

### Other Mentionable Editors

+ **Kate:** KDE's feature-rich GUI editor. Fast, supports sessions, terminal and syntax highlighting.
+ **Geany:** Lightweight GUI IDE with minimal dependencies. Great for older systems.
+ **Emacs:** A powerhouse, terminal-based editor.
+ **Micro:** Modern terminal-based editor with mouse support. Great alternative for Vim-haters who still want TUI editing.

---

### Recommendation

For OS development:

+ **Primary editor:** `Neovim`. Ideal for fast, efficient workflows, especially if paired with terminal tooling.
+ **Secondary editor:** `Sublime Text`. Useful for multi-file navigation, code review, or when you need a visual layout.
+ I don't know about you, but I won't use `VS Code`.

---

## Next Step

Learn about Assembly syntax [here](./01_syntax/README.md)
