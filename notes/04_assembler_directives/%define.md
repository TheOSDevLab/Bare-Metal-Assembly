# `%define`

> **Random Quote**: It is not death that a man should fear, but he should fear never beginning to live.

## Key Topics

- [Overview](#overview)
    - [How It Works](#how-it-works)
- [Syntax](#syntax)
    - [Directive Behavior](#directive-behavior)
- [Examples](#examples)
- [Practical Use Cases](#practical-use-cases)
- [Best Practices](#best-practices)
- [Common Pitfalls](#common-pitfalls)

---

## Overview

`%define` is a **preprocessor directive** in NASM that creates **single-line macros**, enabling textual substitution; much like C’s `#define`. It helps make assembly code more readable and flexible by replacing tokens or expressions before assembly time. Key point: it is evaluated at preprocessing, not at runtime.

### How It Works

- The preprocessor replaces each occurrence of a defined token or macro with its expansion before parsing assembly code.
- Supports parameterized definitions (macros with arguments), e.g., `%define f(x) ...`.
- Expansion is deferred until use; nested macros can reference newer definitions too.  

---

## Syntax

```assembly
%define name replacement
%define name(arg1, arg2, ...) expansion
````

- `name`: macro identifier.
- `replacement` or `expansion`: the text or expression to substitute.
- Parameterized form allows dynamic substitution based on arguments.  

---

## Examples

```assembly
%define REG rdi
%define SIZE(n) (n * 4)

mov eax, REG    ; becomes: mov eax, rdi

mov ebx, SIZE(4) ; becomes: mov ebx, (4 * 4)
```

```assembly
%define ctrl 0x1F &
%define param(a,b) ((a)+(a)*(b))

mov byte [param(2,ebx)], ctrl 'D'
; Expands to: mov byte [(2)+(2)*(ebx)], 0x1F & 'D'
```

---

## Practical Use Cases

* **Descriptive aliases** for registers or constants, improving readability.
* **Parameterized macros** to generate expressions or repeated patterns.
* **Conditional assembly** code paths via macros and `%ifdef` logic.
* Easily override values via assembler command line (`-dFOO=100` equals `%define FOO 100`).

---

## Best Practices

* Use `%define` for **simple, single-line substitutions**.
* For complex or multi-line logic, prefer `%macro` or `%rep`.
* Prefer `%define` over `%assign` when you need deferred expansion logic at invocation.
* Use command-line defines (`-d`) for configuration flags instead of hard-coding.

---

## Common Pitfalls

* **Self-dependency / recursive macros**: be cautious of expansions that recursively reference themselves.
* **Timing of expansion**: `%define` expands at invocation; nested definitions that happen later are respected correctly due to deferred expansion behavior.
* **Overuse may reduce clarity**: anonymous or cryptic names can make code harder to read and debug.

---

## Notes and References

* `%define` is the default single-line macro directive in NASM's preprocessor.
* It contrasts with `%assign`, which evaluates immediately at definition time.
* `-dFOO=100` command-line option is an alternative to placing `%define FOO 100` in code.

---
