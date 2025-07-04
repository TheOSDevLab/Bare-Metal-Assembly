# Bugs

This file contains wierd behavior encountered and their fixes.

> This file is incomplete.

## 1. Integer vs String

```asm
one db 1
two db 2
```

If you try to print these two, you get smily faces on QEMU. It only works if you use strings like so.

```asm
one db '1'
two db '2'
```

This happens because, when you use decimal numbers, they are mapped to ascii characters. In this case `1` and `2` mapped to the smilly faces.


