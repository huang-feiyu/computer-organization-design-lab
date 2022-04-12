# Classify

> 更多请参见 [Classify](https://inst.eecs.berkeley.edu/~cs61c/fa20/projects/proj2/)。

此文档记录，遇见的 bugs 与输出。

[TOC]

```tree
.
├── inputs (test inputs)
├── outputs (some test outputs)
├── README.md
├── src
│   ├── argmax.s (partA)
│   ├── classify.s (partB)
│   ├── dot.s (partA)
│   ├── main.s (do not modify)
│   ├── matmul.s (partA)
│   ├── read_matrix.s (partB)
│   ├── relu.s (partA)
│   ├── utils.s (do not modify)
│   └── write_matrix.s (partB)
├── tools
│   ├── convert.py (convert matrix files for partB)
│   └── venus.jar (RISC-V simulator)
└── unittests
    ├── assembly (contains outputs from unittests.py)
    ├── framework.py (do not modify)
    └── unittests.py (partA + partB)
```


## Part A: Mathematical Functions

### Task 0

![task 0](./outputs/img/task0.png)

### Task 1

没有完全覆盖，不知道还有什么。

![task 1](./outputs/img/task1.png)

### Task 2

1. <s>误用不存在的寄存器 `t3`</s>

> 错误无法再现，反正需要用栈。

```assembly
# load next element
lw t3, 0(a0) # temp_next = array[i]
# if temp_next <= max, jump to loop_continue
ble t3, t2, loop_continue
mv t2, t3 # max = temp_next
add t1, a0, x0 # max_index = i
j loop_continue
```

对于寄存器不足的情况，可以使用栈去存储数据，修改为：

```assembly
# allocate memory
addi sp, sp, -8
sw s0, 0(sp)
sw s1, 4(sp)

add t0, x0, x0 # i = 0
#add s0, a0, x0 # max_index = 0
add s0, x0, x0
lw s1, 0(a0) # max = array[0], the first element
```

2. 返回参数错误

```
a0 (int)  is the first index of the largest element
```

应该返回 `index` 而非地址，修改即可。

---

![task 2](./outputs/img/task2.png)

### Task 3.1

![task 3.1](./outputs/img/task31.png)

### Task 3.2

```c
// C语言代码
void matmul(int* m0, int r0, int c0, int* m1, int r1, int c1, int* d) {
    assert(r0 > 0 && c0 > 0 && r1 > 0 && c1 > 0 && c0 == r1);
    int i, j;
    for (i = 0; i < r0; i++) {
        for (j = 0; j < c1; j++) {
            d[i * c1 + j] = dot(m0 + i * c0, m1 + j, r0, 1, c1);
        }
    }
}
```

1. 输出错误

![debug1](./outputs/img/debug1.png)

```assembly
inner_loop_start:
    mv a0, s0 # arr0 pointer
    li t2, 4
    mul t2, t2, t1 # j * 4
    add a1, s2, t2 # arr1 pointer

    mv a2, s1 # arr0 cols
    li a3, 1 # arr0 stride
    mv a4, s5 # arr1 cols, stride

    # code...
```

肉眼排查法：寄存器 typo 错误，`add a1,s2,t2` 改为 `add a1,s3,t2`。

2. 输出错误

![debug2](./outputs/img/debug2.png)

```assembly
inner_loop_start:
    mv a0, s0 # arr0 pointer
    li t2, 4
    mul t2, t2, t1 # j * 4
    add a1, s2, t2 # arr1 pointer

    mv a2, s1 # arr0 cols
    li a3, 1 # arr0 stride
    mv a4, s5 # arr1 cols, stride

    # code...
```

单步调试发现 `mv a2, s1` 存在 typo，改为 `mv a2, s2`

---

![task32](./outputs/img/task32.png)
