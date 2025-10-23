# Investigating BIOS A20 Line Control (INT 15h AH=24h AL=03h)

## Background

I’ve been learning how to enable the A20 line, which is required to access memory beyond the 1 MB boundary.
While studying the BIOS A20 control functions (INT 15h), I came across subfunction `03h`; that is, `INT 15h AH=24h AL=03h`.

However, I found conflicting documentation from different sources. Both agreed on the **input**, but not on the **output**.
Here are the two main versions I encountered:

---

### Version 1 (Simplified Status Check)

**Output:**

* **CF**; Carry Flag

  * `0`: BIOS supports A20 gate control functions
  * `1`: BIOS does *not* support A20 gate control functions
* **BL**; Bit 0 reflects current A20 state if `CF=0` (`0` = disabled, `1` = enabled)
* **AH**; `86h` if `CF=1`; undefined if `CF=0`
* All other registers undefined

---

### Version 2 (Capability Bitmap)

**Output:**

* **BX**; Capability bitmap

  * Bit 0: Keyboard controller method supported
  * Bit 1: System Control Port A (“Fast A20”) supported
  * Bit 2: BIOS A20 gate control functions supported
* **BH**; Initial A20 state at boot (`00h` = always disabled, `01h` = may be enabled)
* **CF**; `1` if function not supported, `0` on success
* **AH**; Error code if `CF=1` (typically `86h`)

---

These two versions are fundamentally different, so I decided to test both and determine which one aligns with reality.

---

## Experiment

### Test 1; Determining Which Version Matches Reality

I called the subfunction while the A20 line was disabled, then read the `BX` register.

**Logic:**

* If `BX == 0` and `CF == 0`, Version 1 would be correct (since `BL` reflects A20 state).
* If `BX != 0` and `CF == 0`, Version 2 would be correct (since `BX` acts as a capability bitmap).

**Code:**

```asm
org 0x7C00
bits 16

mov ah, 0x24
mov al, 0x03
int 0x15
jc not_supported

cmp bl, 0
jz zero
jmp not_zero

not_supported:
    mov ah, 0x0E
    mov al, 'E'
    mov bh, 0
    int 0x10
    jmp done

zero:
    mov ah, 0x0E
    mov al, '0'
    mov bh, 0
    int 0x10
    jmp done

not_zero:
    mov ax, bx
    call print_int

    jmp done

done:
    cli
    hlt

; ---------------------------------------
; Print a multidigit integer.
; Input: AX = The integer.
; ---------------------------------------
print_int:
    ; Convert int to string.
    mov bx, 10          ; Divisor.
    mov cx, 0           ; Counter.
    .convert_loop:
        xor dx, dx
        div bx

        add dx, '0'       ; Convert remainder to string.
        push dx
        inc cx

        test ax, ax
        jz .print_loop
        jmp .convert_loop

    .print_loop:
        pop ax
        call print_char
        loop .print_loop

    .return:
        ret

; -------------------------------
; Print a single ascii character.
; Input: AL = Character to print.
; -------------------------------
print_char:
    mov ah, 0x0E    ; BIOS function: Teletype output.
    mov bh, 0
    int 0x10
    ret

times 510 - ($ - $$) db 0
dw 0xAA55
```

**Result:**

* `CF == 0`
* `BX == 3` (`0b00000011`)

**Conclusion:**

* Version 1 was eliminated; `BL` did *not* reflect the current A20 state.
* Version 2 also appeared suspicious. If `CF` was clear, that implies BIOS support for subfunction `03h` (and likely `00h-02h` as well).
  According to Version 2, bit 2 of `BL` should then be set (indicating BIOS A20 control support), but it wasn’t. Why?

---

### Test 2; Verifying Subfunction Support

This test checks whether subfunctions `00h-02h` are indeed supported, as assumed in Test 1.

**Method:**
Call each subfunction (`00h-02h`) and check the Carry Flag.
If the Carry Flag is clear for all, they are supported.

**Code:**

```asm
org 0x7C00
bits 16

; Subfunction 02h: Query A20 Gate Status
mov ah, 0x24
mov al, 0x02
int 0x15
jc fail

; Subfunction 01h: Enable A20 Gate
mov ah, 0x24
mov al, 0x01
int 0x15
jc fail

; Subfunction 00h: Disable A20 Gate
mov ah, 0x24
mov al, 0x00
int 0x15
jc fail
jmp success

fail:
    mov ah, 0x0E
    mov al, 'E'
    mov bh, 0
    int 0x10
    jmp done

success:
    mov ah, 0x0E
    mov al, 'A'
    mov bh, 0
    int 0x10
    jmp done

done:
    cli
    hlt

times 510 - ($ - $$) db 0
dw 0xAA55
```

**Result:**

* The Carry Flag was clear for all subfunction calls.

**Conclusion:**

* All subfunctions are supported.
* Therefore, Version 2 is also invalid, since bit 2 (BIOS A20 control support) was not set even though all related subfunctions worked correctly.

---

## Final Decision

I no longer trust either version.
Instead, I’ll rely solely on the **Carry Flag** to determine A20 gate control support:

* If `CF == 1`: BIOS A20 control functions **not supported**.
* If `CF == 0`: BIOS A20 control functions **supported**.

---
