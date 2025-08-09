# `EQU` vs `%define`

### `EQU`

+ Defines a symbolic constant at assembly time, meaning the expression on the right is evaluated immediately and the symbol is permanently bound to that value.
+ It's not a text substitution; rather, it sets a constant that cannot be redefined later.
+ Commonly used for compile-time constants like `msglen equ $-message`.

### `%define`

+ A preprocessor directive that performs textual substitution similar to C's `#define`.
+ Evaluations happen upon use, not definition, and can be redefined later in the code.
+ Allows parameterized macros and defered expansion; very flexible for code generation.

---
