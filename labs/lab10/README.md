# lab 10

> A file records bugs and hints.

[TOC]

## Part 1: Using OpenMP

### Exercise 2: Vector Addition

1. **Slicing**

<s>I don't even know how to do this. So, I ask for StackOverflow...</s>

I should take a look at [Discussion 13](https://inst.eecs.berkeley.edu/~cs61c/su20/pdfs/discussions/disc13_sol.pdf), it's a good resource.

It works.

2. **Chunking**

<s>Weird Situation: The more threads, the slower it runs.</s>

Everything is alright.

### Exercise 3: Dot Product

1. **Manual**

Everything is alright.

2. **Reduction**

Everything is alright.

## Part 2: Multi-Processing

### Info: Thread vs. Process

Mutil-Thread: threads have lower overhead, they shared same address space => We should be careful about concurrency issue.

![process](./assets/process.png)

![threads](./assets/threads.png)

### Info: Http Web Server

* `fork`: syscall, create a new process by duplicating the calling process

```c
#include <stdio.h>
#include <sys/types.h>
#include <unistd.h>

int main() {
    pid_t child_pid;
    printf("Main process id = %d (parent PID = %d)\n",
            (int)getpid(), (int)getppid());
    child_pid = fork();
    if (child_pid != 0) { // the parent process
        printf("Parent: child's process id = %d\n", child_pid);
    } else { // child_pid == 0 => a new process
        printf("Child:  my process id = %d\n", (int)getpid());
    }
    return 0;
}
```

### Exercise: Implement `fork`

Everything is alright.
