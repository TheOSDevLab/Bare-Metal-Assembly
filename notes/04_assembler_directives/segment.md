# `segment`

## Introduction to Sections and Segments in NASM

In NASM, the **`segment` directive** is used to define logical blocks within your program, organizing code, data, and uninitialized data into distinct sections that the linker and loader will handle appropriately. This directive is functionally equivalent to the more commonly used `section` directive in NASM. The primary purpose of these directives is to control the memory layout of your program by grouping similar types of content together; executable code in one segment, initialized data in another, and uninitialized variables in a third.

Understanding segments is crucial for effective assembly programming because it directly affects how your program interacts with memory architecture. Different output formats (such as `bin`, `obj`, `elf`, etc.) handle segments differently, and NASM provides flexibility in defining segment properties to meet various requirements.

---

## Basic Syntax and Usage

### Defining Segments

The basic syntax for defining a segment is straightforward:

```nasm
segment .data
    ; Initialized data declarations
segment .bss
    ; Uninitialized data reservations  
segment .text
    ; Executable code
```

You can use either `segment` or `section` - both directives are functionally identical in NASM. The segment name determines its purpose and, in some output formats, its memory properties.

### Common Standard Segments

NASM recognizes several standard segment names that have conventional meanings:

| **Segment Name** | **Primary Purpose** | **Content Type** |
| :--- | :--- | :--- |
| **`.text`** | Executable code | Instructions, code |
| **`.data`** | Initialized data | Variables with initial values |
| **`.bss`** | Uninitialized data | Reservations for future data |
| **`.stack`** | Program stack | Stack space |

Example of using standard segments:
```nasm
segment .data
    hello db 'Hello, World!', 0xA
    length equ $-hello

segment .bss
    buffer resb 64

segment .text
    global _start
_start:
    ; Your code here
```

---

## Segment Directives in Different Output Formats

### Binary Output Format (`-f bin`)

The binary output format provides the most flexibility for segment handling, as it's designed for environments without complex executable file structures.

**Key features for segments in binary format:**
- Multiple sections with arbitrary names are supported
- Sections can be aligned using `align=` parameter
- Virtual start addresses can be specified with `vstart=`
- Sections can be ordered using `follows=` or `vfollows=`

**Example of binary format with segments:**
```nasm
segment code
    org 0x100
    ; Code here

segment data align=16
    ; Data here, aligned to 16-byte boundary

segment stack start=0x8000
    ; Stack segment starting at specific address
```

### OMF Object Format (`-f obj`)

The OMF format is commonly used for 16-bit DOS development and provides extensive segment customization through qualifiers.

**Available segment qualifiers in OMF format:**

| **Qualifier** | **Purpose** | **Example** |
| :--- | :--- | :--- |
| **`PRIVATE`** | Prevents segment combination | `segment code PRIVATE` |
| **`PUBLIC`** | Allows segment concatenation | `segment data PUBLIC` |
| **`STACK`** | Defines stack segment | `segment stack STACK` |
| **`ALIGN=`** | Specifies alignment | `segment data ALIGN=16` |
| **`CLASS=`** | Sets segment class | `segment code CLASS=CODE` |

**Example of OMF segment definitions:**
```nasm
segment code private align=16
    ; Private code segment, 16-byte aligned

segment data public class=DATA
    ; Public data segment in DATA class

segment stack stack
    ; Stack segment with STACK combination
```

---

## Advanced Segment Features

### Segment Addressing and Grouping

In OMF format, you can group segments together so a single segment register can refer to multiple segments:

```nasm
segment data
    ; Data declarations

segment bss  
    ; Uninitialized data

group dgroup data bss
```

This allows you to access variables across segments using the same segment register. NASM automatically defines the segment name as a symbol, enabling you to retrieve segment addresses:

```nasm
segment data
dvar: dw 1234

segment code
    mov ax, data        ; Get segment address of data
    mov ds, ax          ; Load into DS
    inc word [dvar]     ; Now this reference works
```

### Segment Alignment and Positioning

You can control segment alignment and positioning using various attributes:

```nasm
segment .data align=16
    ; Aligned to 16-byte boundary

segment .code start=0x1000
    ; Starts at specific address

segment .bss follows=.data
    ; Placed immediately after data segment
```

---

## Practical Examples

### DOS EXE Program with Multiple Segments

```nasm
segment code
..start:
    mov ax, data
    mov ds, ax
    mov dx, hello
    mov ah, 9
    int 0x21
    mov ax, 0x4C00
    int 0x21

segment data
    hello db 'Hello, DOS!', '$'

segment stack stack
    resb 100h  ; Reserve 256 bytes for stack
```

### Using Custom Segment Names

```nasm
segment extra_data
    custom_msg db 'Custom segment', 0

segment main_code
    global _start
_start:
    ; Accessing data in different segment
    mov ax, extra_data
    mov ds, ax
    mov dx, custom_msg
    ; ... rest of code
```

---

## Common Issues and Best Practices

### Linker Segment Merging

One common issue is that linkers may merge segments with similar names and attributes. If you need to keep segments separate, use appropriate qualifiers:

```nasm
segment my_code private
    ; This won't be merged with other segments

segment my_data public
    ; This may be concatenated with other public data segments
```

### Default Segment Behavior

If your code contains instructions before any explicit `segment` directive, NASM places them in a default segment called `.text`. It's good practice to explicitly define segments at the beginning of your source files.

### Segment Ordering

The order of segments in your source file doesn't necessarily dictate their final memory layout—the linker determines this based on segment attributes and linker scripts. Use alignment and positioning attributes for precise control.

---

## Conclusion

The `segment` directive in NASM is a powerful tool for organizing your assembly programs and controlling their memory layout. By understanding how to define segments with appropriate attributes and qualifiers, you can create programs that work effectively with different output formats and memory models.

Remember that segment behavior can vary significantly between different output formats, so it's important to consult the NASM documentation for format-specific details when working with specialized environments.

---
