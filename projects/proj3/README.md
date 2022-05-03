# CS61CPU

> Record bugs and some hints.

[TOC]

## Part A

### Task 1: ALU

> Arithmetic Logic Unit

* ALU: `Input + ${functions} + Mux => Output`
    * Input: `A[31:0]`, `B[31:0]`, `ALUSel[3:0]`
    * Output: `Result[31:0]`

#### Debug

```bash
=====alu-add=====
=====alu-comprehensive=====
16,17c16,17
< 0e    7       ffffabcd        00000005        00000001
< 0f    7       00000005        ffffabcd        00000000
---
> 0e    7       ffffabcd        00000005        fff579a0
> 0f    7       00000005        ffffabcd        0000a000
=====alu-logic=====
=====alu-mulh=====
=====alu-mult=====
=====alu-shift=====
=====alu-slt-sub-bsel=====
```

It seems that `diff` cannot find the difference in `alu-slt-sub-bsel`. I will check it first.

`slt`: `Result = (A < B (signed)) ? 1 : 0`

I recoginize that `slt` is a `sll` operation.

Fix it by `Comparator`, it passed.

#### Output

```bash
Running tests for part_a/alu...
        PASSED test: alu-add test
        PASSED test: alu-comprehensive test
        PASSED test: alu-logic test
        PASSED test: alu-mulh test
        PASSED test: alu-mult test
        PASSED test: alu-shift test
        PASSED test: alu-slt-sub-bsel test
Passed 7/7 tests
```

### Task 2: RegFile

> Register File

* RegFile:
    * Input: `Clock`, `RegWEn`, `rs1[4:0]`, `rs2[4:0]`, `rd[4:0]`, `wb[31:0]`
    * Output(32bits): `rs1`, `rs2`, `ra`, `sp`, `t0`, `t1`, `t2`, `s0`, `s1`, `a0`

1. whether to write and write to where

Use `DMUX` to get `WE#`, connect the later one to every register.

2. every single register

* `x0` => always 0
* Other => input: `clk`, `WE#`, `wb`; output: `x#`/alias

3. read rs1 & rs2

Use `MUX` to get `rs1` and `rs2`.

#### Debug

The last 2 output is `xxxxxxxx` sometimes. It means that the register is not used.

<s>I guess: something wrong with the wire-connecting.</s> Doesn't matter.

<s>I cannot figure it out, so take a look at others' circuit. It seems that it is blame to the `clk`: I should use `clock` input directly?</s> Also failed.

<s>Test in local GUI environment, when I use the check `rs1` and `rs2`, I found that it is `UUUUUUUU`.(Write is Okay) So it is wrong with the `MUX`?</s> I cannot find.

When I use others' registers, I found that the first test could pass, but the second test failed. In my opinion, the components are exactly the same. What is wrong with me? So I just use it, but I don't know why.

The wrong message is obviously, `x0` output is wrong. I fixed it and passed the test.

#### Output

```bash
Running tests for part_a/regfile...
        PASSED test: regfile-allregs test
        PASSED test: regfile-insert test
        PASSED test: regfile-x0 test
        PASSED test: regfile-zero test
Passed 4/4 tests
```


