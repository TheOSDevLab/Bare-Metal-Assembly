# Sector Count Limit

The limitation of 127 sectors per INT 13h AH=02h call is due to a combination of factors, with the **64KB segment size** of the x86 real-mode memory model being the primary and most direct reason.

Here’s the breakdown:

## The 64KB Segment Boundary

In x86 real-mode, a memory address is composed of a **Segment:Offset** pair (e.g., `ES:BX`). The physical address is calculated as `(Segment * 16) + Offset`.

- The **Offset** (`BX` in this case) is a 16-bit value, meaning it can range from `0x0000` to `0xFFFF` (0 to 65,535).
- This means that within a single segment, you can only address **64 Kilobytes (65,536 bytes)** without changing the segment register.

Now, let's apply this to disk sectors:
- A standard sector is **512 bytes**.
- The maximum number of sectors you can read into a contiguous buffer within one segment without causing a **segment wrap** is:
  \( 65,536 \div 512 = 128 \)

However, there's a critical detail: if the `Offset` part of your buffer (`BX`) is not `0x0000`, you have *less* than 64KB available before you hit the segment limit.

**The "Pessimistic" BIOS Rule:**
To guarantee that a transfer will not cross the 64KB segment boundary and wrap around (which would corrupt memory), the BIOS implements a simple, conservative rule: a single read request must not result in a transfer that requires crossing a **64KB boundary**.

Because the starting offset (`BX`) can be any 16-bit value, the safest maximum number of sectors the BIOS can allow is **127**. Reading 127 sectors requires \( 127 \times 512 = 65,024 \) bytes. This leaves at least 512 bytes of headroom until the segment limit, no matter what the starting offset is.

> **In practice, many BIOS implementations *do* allow `AL=128`** (which would be 65,536 bytes, exactly filling the segment) if the caller is careful to ensure the buffer starts at an offset of 0. However, the official, safe, and most compatible limit is **127**.

So, while the 8-bit `AL` register can theoretically hold a value up to 255, the underlying memory architecture of the system it's designed to run on imposes a much stricter practical limit. The BIOS service is designed to be safe and reliable within the constraints of the 16-bit real-mode environment.

---
