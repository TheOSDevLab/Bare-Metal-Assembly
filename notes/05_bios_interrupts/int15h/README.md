# BIOS INT 15h, AH=24h: A20 Gate Control Functions

## Key Topics

+ [Introduction](#introduction)
+ [Function Overview](#function-overview)

---

## Introduction

The BIOS interrupt interface INT 15h with function code AH=24h provides a standardized mechanism for controlling the A20 address line in x86-compatible computer systems. This interface abstracts the hardware-specific details of A20 management, allowing system software to enable, disable, and query the status of the A20 gate through a consistent BIOS-level API rather than direct hardware manipulation. These functions are particularly valuable during system initialization when transitioning from real mode to protected mode, where reliable A20 enablement is essential for accessing memory beyond the first megabyte. The interface offers a cleaner, more maintainable approach to A20 control compared to direct hardware programming methods.

---

## Function Overview

The INT 15h, AH=24h interface comprises four distinct subfunctions, selected via the AL register. Each subfunction serves a specific purpose in A20 gate management.

### Subfunction AL=00h: Disable A20 Gate

This function disables the A20 address line, forcing address wrap-around behavior that mimics the original IBM PC's 20-bit address bus. When invoked, the BIOS ensures that the 21st address line (A20) is held low, causing any memory access above 1MB to wrap around to the first megabyte. This function is primarily used for maintaining compatibility with legacy software that depends on the wrap-around behavior.

### Subfunction AL=01h: Enable A20 Gate

This function enables the A20 address line, allowing the processor to access memory above the 1MB boundary. Successful execution of this function is a prerequisite for entering protected mode and utilizing extended memory. The BIOS implementation handles the hardware-specific details of A20 enablement, whether through keyboard controller manipulation, system control port access, or other platform-specific methods.

### Subfunction AL=02h: Query A20 Gate Status

This query function returns the current operational status of the A20 gate. The BIOS reports whether the A20 line is currently enabled or disabled, allowing system software to determine the current state without direct hardware probing. This is particularly useful for diagnostic purposes and for avoiding redundant enablement attempts.

### Subfunction AL=03h: Query A20 Support

This comprehensive support query returns information about the BIOS's A20 management capabilities. It indicates which A20 control methods are supported by the system hardware and reveals the A20 state at system boot. The function returns a bitmask in register BX specifying available interfaces, including keyboard controller support, system control port A (Fast A20) availability, and BIOS-based A20 management capability. Additionally, it indicates whether the A20 line was initially enabled or disabled at system startup.

---

## Implementation Notes

When using these functions, system programmers should always check the carry flag upon return to determine success or failure. A set carry flag indicates an error condition, with specific error codes available in the AH register. The support query function (AL=03h) should typically be called first to determine the most appropriate A20 control strategy for the specific platform.

These BIOS functions provide a hardware-abstraction layer that simplifies A20 management but may not be available on all systems. Robust implementations should include fallback mechanisms to direct hardware control methods when BIOS support is absent or incomplete.

---
