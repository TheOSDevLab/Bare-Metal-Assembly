## 1. Definitions & Mechanisms

* **Macros**:
  Macros are **compile-time text substitutions**; blocks of code that are expanded inline wherever called. They allow parameterization, enabling a single macro to generate varying code expansions based on arguments.

* **Subroutines (Functions)**:
  Subroutines are blocks of code that exist once in memory. You transfer control to them using `CALL`, and return via `RET`. They exist **once**, regardless of how many times they are called.

---

## 2. Pros & Cons Overview

### Macros (e.g., `%define`, `%macro`)

#### Pros

+ **No call overhead**: Faster execution, no `CALL / RET` penalty.
+ **Flexible code generation**: Can produce different instruction sequences based on parameters.
+ **Useful for tiny repeated patterns**, like single instructions or sequences too short to justify `CALL` overhead.

#### Cons

+ **Code bloat**: Every use expands separately, increasing binary size.
+ **Harder to debug**, due to inlining and less structure.
+ **No type checking or context awareness**: Potential for substitution errors.


### Functions / Subroutines

#### Pros

+ **Code reuse**: One copy, many calls. Saves space in repetitive use.
+ **Clear structure**: Easier to read, maintain, and debug.
+ **Centralized updates**: Fix/unify logic in one place, no duplication.

#### Cons

+ **Execution overhead**: Incurs `CALL` and `RET`, slight performance cost.
+ Minor stack/register management complexity.
+ Not ideal for very small code, where call overhead outweighs benefits.

---

## 3. Use Cases

### In Normal Assembly Programs

* Use **functions** for large or frequently re-used logic; e.g., string formatting, math routines. Helps readability and maintainability.
* Use **macros** for small repeated code blocks or tasks where call overhead is significant relative to the work done, or when parameterized inline code is cleaner.

### In a 512-byte Bootloader

* Every byte counts.

  * If a routine is **used only once**, macros may be acceptable; they eliminate call overhead and hide complexity but at the cost of inline bloat.
  * If used **multiple times**, a subroutine is almost always preferable; since code size increases linearly with each macro expansion, while a subroutine incurs only a small fixed call/return cost.
* In practice, a hybrid approach often works:

  * Use macros **sparingly** for one-off or very small tasks.
  * Use subroutines for any multi-use logic; even adding the overhead of one `CALL`/`RET` is worthwhile if you avoid duplicating the body multiple times.

---

### 4. Final Words

* **Macros** shine for compact, single-use or parameterized inlining where performance is critical; and you don’t mind a bigger binary.
* **Subroutines** are ideal for reusability, maintainability, and space efficiency when you’re repeating logic.
* Especially in **bootloader development**, lean heavily on functions for any recurring tasks, and reserve macros for tiny or unique, performance-sensitive cases.

---
