# BIOS INT 13h

## Key Topics

+ [Introduction](#introduction)
+ [Function Overview](#function-overview)

---

## Introduction

BIOS Interrupt 13h is a fundamental software interrupt routine within the Basic Input/Output System (BIOS) of x86-based computer systems. This interrupt provides a suite of low-level disk services that enable communication with storage devices, including floppy disk drives and hard disk drives, at the sector level.

The primary purpose of INT 13h is to facilitate disk operations during the system boot process and in real-mode operating environments, before higher-level operating system drivers are loaded and initialized. It serves as the essential interface between system firmware and storage hardware, allowing for critical operations such as loading boot sectors, operating system kernels, and other system utilities.

---

## Function Overview

The following catalogue details the primary functions available through INT 13h, accessed by setting the appropriate function code in the AH register prior to invoking the interrupt.

- **AH=00h: Reset Disk System** - Reinitializes the disk controller and recalibrates the drive mechanism.
- **AH=01h: Get Status of Last Operation** - Returns the error status from the most recent disk operation.
- **AH=02h: Read Sectors** - Transfers data from specified disk sectors into system memory using CHS addressing.
- **AH=03h: Write Sectors** - Transfers data from system memory to specified disk sectors using CHS addressing.
- **AH=04h: Verify Sectors** - Confirms the readability and integrity of one or more disk sectors without data transfer.
- **AH=05h: Format Track** - Prepares a specified track for data storage by writing sector headers and formatting data.
- **AH=08h: Get Drive Parameters** - Retrieves the physical geometry of the drive (cylinders, heads, sectors per track).
- **AH=15h: Get Drive Type** - Identifies the type and presence of the specified disk drive.
- **AH=42h: Extended Read Sectors** - Reads sectors using Logical Block Addressing (LBA) for access beyond CHS limitations.
- **AH=43h: Extended Write Sectors** - Writes sectors using Logical Block Addressing (LBA).
- **AH=48h: Get Extended Drive Parameters** - Returns detailed drive information, including support for extended features and LBA.

---
