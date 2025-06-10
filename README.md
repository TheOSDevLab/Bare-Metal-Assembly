# Bare-Metal-Assembly

> *No OS. No abstractions. Just you, your CPU, and a handful of opcodes.*

This repository contains notes, explanations, and examples of Assembly programming with a focus on operating system development. It is part of a broader series of repositories dedicated to low-level systems programming and crafting an operating system from scratch.

---

## 📘 What You'll Find Here

### 🧠 Introduction to Assembly
- What is Assembly?
- Why it matters in OS Development
- Real mode vs Protected mode vs Long mode

### 🛠️ Syntax & Structure
- NASM syntax (used throughout)
- Registers, memory, and addressing
- Labels, sections, and directives

### 🧩 Core Instructions
- Data movement (`mov`, `xchg`, `lea`, etc.)
- Arithmetic and logic (`add`, `sub`, `cmp`, `and`, `or`, etc.)
- Control flow (`jmp`, `call`, `ret`, `loop`, etc.)
- Stack operations (`push`, `pop`, `call`, `ret`)

### 🧨 OS Dev-Specific Topics
- Writing bootloaders (MBR / BIOS)
- Switching to 32-bit Protected Mode
- BIOS interrupts (like `int 0x10`)
- Inline assembly in C (brief)
- Assembly in kernel development

---

## 🧵 Related Repositories

- 🧠 [Crafting-an-OS-Notes-and-Insights](https://github.com/brogrammer232/Crafting-an-OS-Notes-and-Insights)
- ⛓️ (Coming Soon) [C-Systems-Programming-Notes](#)
- 🦀 (Coming Soon) [Rust-for-Systems-Dev](#)

---

## 🧰 Requirements

- Basic knowledge of computer architecture
- NASM or any x86 assembler
- QEMU or VirtualBox for testing
- A terminal and a willingness to break stuff

---

## 🤝 Contributions

Pull requests, suggestions, and nitpicks are welcome.  
File an issue if anything’s unclear, incorrect, or you just want to yell about segmentation faults.

---

## 📜 License

MIT – *Do what thou wilt shall be the whole of the license.*

---

