#!/bin/bash

# This bash script compiles `main.asm` into a flat binary image `main.img` and boots off it with QEMU.

# Compiling
nasm -f bin main.asm -o main.img

# Booting
qemu-system-i386 -fda main.img
