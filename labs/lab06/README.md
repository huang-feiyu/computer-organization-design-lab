---
author: Huang
date: 2022-04-25
---

## Exercise 1 - Inefficiencies Everywhere

```c
45 + 60 + 5 + 10 = 120ns
=> 8333KHz
```

## Exercise 2 - Pipe that Line

> 本实现延后一时钟周期。

```c
max(45 + 5 + 10, 60) = 60ns
=> 16667KHz
```

`60==60` 表明不需要 bubbles。
