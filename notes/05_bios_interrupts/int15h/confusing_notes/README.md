# BIOS INT 15h, AH=24h: A20 Gate Control Functions

## Key Topics

+ [Introduction](#introduction)
+ [Function Overview](#function-overview)
+ [Implementation Notes](#implementation-notes)

---

## Introduction

The BIOS interrupt interface **INT 15h, AH=24h** provides a standardized mechanism for controlling the **A20 address line** on x86-compatible systems. This interface abstracts away hardware-specific details, allowing software to enable, disable, or query the A20 gate through BIOS rather than direct port manipulation.  

The A20 gate historically existed to maintain compatibility with the original **IBM PC’s 20-bit address bus**, where memory addresses wrapped around at 1 MB. On modern processors, A20 must be **enabled** before entering protected mode, as linear addresses above 1 MB must be valid and unique.

While the INT 15h interface simplifies early-stage A20 management (especially in bootloaders or real-mode kernels), many modern BIOSes either **emulate** or **ignore** these calls, reporting success regardless of actual hardware action. Therefore, they serve mainly as a *compatibility interface*, not a guaranteed hardware control.

---

## Function Overview

The INT 15h, AH=24h interface defines several **subfunctions**, selected via register `AL`.  
Each subfunction provides a distinct capability for A20 gate management.

### Subfunction AL=00h: Disable A20 Gate

Disables the A20 address line, forcing address wrap-around behavior to emulate a 20-bit address space. When invoked, the BIOS attempts to hold the 21st address line (A20) low so that addresses above `0xFFFFF` wrap to the start of conventional memory.  

This is used primarily when reverting from protected mode back to real mode, or when executing legacy software that depends on the 8086-style wrap-around behavior.

---

### Subfunction AL=01h: Enable A20 Gate

Enables the A20 line, allowing access to memory beyond the 1 MB boundary.  
This is required for entering protected mode or using the HMA (High Memory Area).

The BIOS internally selects the correct control mechanism; typically either:
- The **8042 keyboard controller** (bit 2 of output port 0xD1/0xD0),
- The **System Control Port A** (I/O port 92h),
- Or chipset-specific logic on newer hardware.

---

### Subfunction AL=02h: Query A20 Gate Status

Returns the current state of the A20 gate (enabled or disabled).  
This lets software check the A20 line status without direct hardware probing.

This function is useful for verifying A20 enablement before transitioning modes or enabling paging.

---

### Subfunction AL=03h: Query A20 Support and Capabilities

Returns a bitmask indicating which A20 control methods and features are supported by the system BIOS.  
This is the recommended first call when attempting A20 control via BIOS, as it prevents invalid or unsupported operations.

**Registers:**
- Input: `AH=24h`, `AL=03h`
- Output:
  - `CF=0` — success  
    - `BL` — support bitmask  
      - Bit 0: A20 always enabled (no control possible)  
      - Bit 1: BIOS supports software A20 control (via INT 15h/24h)  
      - Bit 2: Keyboard controller method available  
      - Bit 3: Port 92h (“Fast A20”) method available  
    - `BH` — initial A20 state at power-on (bit 0 = 1 → enabled)
  - `CF=1` — failure  
  - `AH` — error code

This subfunction enables dynamic selection of the best A20 control path for the given platform.

---

## Implementation Notes

- Always check the **Carry Flag (CF)** after each INT 15h call.  
  If set, the operation failed, and `AH` contains the error code.  
- On many modern BIOSes, A20 control is **virtualized** or **ignored**. These calls may always return success.  
- For reliable OS behavior, especially after protected-mode initialization, implement fallback methods:
  - **Port 92h control**; toggling bit 1 enables/disables A20 quickly.
  - **Keyboard controller method**; using the 8042 command interface.
- Avoid assuming BIOS-preserved registers; only `CF`, `AH`, and documented outputs are defined on return.
- The **A20 line** may already be enabled at boot; querying status before toggling prevents redundant operations.

In modern systems, A20 is almost always *permanently enabled*; but BIOS INT 15h / 24h remains a legacy-safe interface for backward compatibility and clean early-stage initialization.

---
