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

```diff
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

When I use others' registers, I found that the first test could pass, but the second test failed. In my opinion, the components are exactly the same. What is wrong with me? So I just use it, but I don't know why.——I found why: it is my computer's or my Logisim's fault that the `register` is wrong literally.

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

### Task 3: The `addi` instruction

`addi` instruction: `imm[11:0]` `rs2[4:0]` `rs1[4:0]` `000` `rd[4:0]` `0010011`

#### Info: circ

1. `mem.circ`: combined RAM
    * word-addressable but **byte** level write enabled
    * `rs#` will **always** return the value in memory at the supplied address
2. `branch_comp.circ`
3. `imm_gen.circ`
    * requires an immediate generator, but in partA we can use hard-wire
4. `cpu.circ`
    * implement single-stage processor first, then modify it to have 2-stage pipeline
    * two-stage pipeline: IF; ID, EX, EME, WB
5. `control_logic.circ`

#### Info: Single Stage CPU

1. IF: Instruction Fetch
    * PC
2. ID: Instruction Decode
    * instruction
3. EX: Execute
    * ALU
4. MEM: Memory
5. WB: Write Back
    * RegFile

After implementing part of `imm_gen.circ`, `cpu.circ`, passed easily.

```bash
Running tests for part_a/addi_single...
        PASSED test: cpu-addi-single test
Passed 1/1 tests
```

#### Info: Pipelining CPU

* Stage 1: IF
* Stage 2: ID, EX, MEM, WB

* Will the IF and EX stages have the same or different PC values?<br/>
    * No, they have different PC values.
* Do you need to store the PC between the pipelining stages?<br/>
    * No, for now the PC is not needed.

A little bug: the `register` in my computer is wrong, so I have to copy from the PC. It's fine besides it.

```bash
Running tests for part_a/addi_pipelined...
        PASSED test: cpu-addi-pipelined test
Passed 1/1 tests
```

## Part B

### Task 4: More Instructions

#### ISA

> The Instruction Set Architecture

* R: `add`, `mul`, `sub`, `sll`, `mulh`, `mulhu`, `slt`, `xor`, `srl`, `sra`, `or`, `and`
* I: `lb`, `lh`, `lw`, `addi`, `slli`, `slti`, `xori`, `srli`, `srai`, `ori`, `andi`
    `jalr`, `csrrw`, `csrrwi`
* S: `sb`, `sh`, `sw`
* SB: `beq`, `bne`, `blt`, `bge`, `bltu`, `bgeu`
* U: `auipc`, `lui`
    * `auipc`: `R[rd] = PC + {imm, 12'b0}`
    * `lui`: `R[rd] = {32b'imm<31>, imm, 12'b0}`
* UJ: `jal`
    * `jal`: `R[rd] = PC + 4; PC += {imm, 1'b0}`
    * `jalr`: `R[rd] = PC + 4; PC = R[rs1] + imm`

Almost everything we should know is in [riscv card](./resources/riscvcard.pdf). It is a lot, isn't it?

Additionally, `mul` and `mulhu` are Extension:
* `mul`:
    * func7 = 0000001
    * func3 = 000
    * opcode = 0110011
* `mulh`:
    * func7 = 0000001
    * func3 = 001
    * opcode = 0110011

#### Info: circ

* `mem.circ`: give to memory a byte address, the bottom 2 bits will be ignored, it returns 4 bytes addressed from the byte address without the bottom 2 bits are 0.
* `branch_comp.circ`: compares two values and outputs control signals
* `imm_gen.circ`: extracts the appropriate immediate from `I`, `S`, `SB`, `U`, `UJ`
    * specially, `csrrwi` is not I-type to a certain extent
* `control_logic.circ`: to identify each instruction correctly
* `csr.circ`: Control Status Register
    * [csr in *riscv-spec*](https://riscv.org/wp-content/uploads/2017/05/riscv-spec-v2.2.pdf) (use `Ctrl+F` to find it)
* `cpu.circ`: connects all the components
    * use `addi x0, x0, 0` as nop (`0x13`)
    * what you need to think about Pipeline

#### Control Logic

* `PCSel`: `PC = PCSel == 0 ? PC + 4 : ALUout`
    * Regular: always 0
    * Branches: 1 if true (with `branch_comp.circ`)
        * Opcode => 0x63
    * Jumps: always 1
        * `jalr` Opcode => 0x67
        * `jal` Opcode => 0x6F
* `ImmSel`: `imm_gen` input
    * Assume(From 0 to 5, defined in `imm_gen`): `I`, `S`, `SB`, `U`, `UJ`, `CSRI`
    * `S`: Opcode => 0x23 (Use 1)
    * `SB`: Opcode => 0x63 (Use 2)
    * `U`: Opcode => 0x17/0x37 (Use 3)
    * `UJ`: Opcode => 0x6F (Use 4)
    * `CSRI`: Opcode => 0x73 & func3 => 0x5 (Use 5)
    * `I`: Multiple opcode (Use 0)
    * `R`: not used, assume it is 0
* `RegWEn`: Write to `R[rd]` Enable
    * `R`: Always 1
        * Opcode => 0x33
    * `I`: Always 1
        * Load: Opcode => 0x3
        * Arithmetic: Opcode => 0x13
        * `jalr`: Opcode => 0x67
    * `U`: Always 1
        * `auipc`: Opcode => 0x17
        * `lui`: Opcode => 0x37
    * `UJ`: Always 1
        * Opcode => 0x6F
* `BrUn`: Branch flag (unsigned value comparison)
    * `SB`: Opcode => 0x63
    * `bltu`, `bgeu`: func3 => 0x6/0x7
* `ASel`: `OperatorA = ASel == 0 ? rs1 : PC`
    * `SB`: Opcode => 0x63
    * `jal`: Opcode => 0x6F
    * `auipc`: Opcode => 0x17
* `BSel`: `OperatorB = BSel == 0 ? rs2 : imm`
    * very similar to `ImmSel`
* `ALUSel`: perform which operation
    * `R` & `I` Instruction
* `MemRW`: Memory operator flag
    * Read & Write: 1
        * a new flag import: `LSSel` (Load0/Store1 Select)
    * Other: 0
* `WBSel`: which value do we want to write back to `R[rd]`
    * load: `rs2` => 0
        * Opcode => 0x3
    * `R`, `I` Arithmetic & `auipc`: `ALU_output` => 1
    * `jal`, `jalr`: `PC + 4` => 2
    * `lui`: `32b'imm<31>, imm, 12'b0` => 3
* `CSRSel`: CSR Select which operator
    * `csrrw`: `rs1` => func3 0x0
    * `csrrwi`: `imm` => func3 0x1
* `CSRWen`: CSR Write Enable
    * Opcode => 0x73

#### Control Status Register

* `csrw tohost, t2` => `csrrw x0, csr, rs1` (`csr = 0x51E`)
* `csrwi tohost, 1` => `csrrwi x0, csr, uimm` (`csr = 0x51E`)

Use a register, then done.

#### CPU

* to handle control hazards: Instruction kills MUST be accomplished by MUXing a `nop` into the instruction stream and sending the `nop` into the Execute stage instead of using the fetched instruction
    * `nop`: `0x13`
* IF: `PCSel`
* ID: `ImmSel`, `RegWEn`
* EX:
    * ALU: `ASel`, `BSel`, `ALUSel`
    * branch comp: `BrUn`
    * csr: `CSRSel`, `CSRWen`
* MEM & WB: (MEM is implemented before)
    * Store: `MemRW`, `LSSel`
    * Load: `MemRW`, `LSSel`
    * WB: `WBSel`

#### Debug

1. 3 tests failed

```output
Running tests for part_b/pipelined...
        FAILED test: cpu-add-lui-sll test (Did not match expected output)
        PASSED test: cpu-addi test
        PASSED test: cpu-branch-jump test
        FAILED test: cpu-branch test (Did not match expected output)
        PASSED test: cpu-csrw test
        PASSED test: cpu-csrwi test
        PASSED test: cpu-jump test
        FAILED test: cpu-mem test (Did not match expected output)
Passed 5/8 tests
```

Typo: `READ_DATA` => `READ_DATA2`

The first check: I haven't even decode the instruction yet. (`rs2` & `funct7`)

2. 1 test failed

```output
FAILED test: cpu-mem test (Did not match expected output)
```

```diff
=====cpu-mem=====
3,6c3,6
< ra:  00000000 sp:  00000000 t0:  00000000 t1:  00000000 t2:  00000000 s0:  12345000 s1:  00000000 a0:  00000000 PC:  00000008 inst:  02802423 Time_Step:  0002
< ra:  00000000 sp:  00000000 t0:  00000000 t1:  00000000 t2:  00000000 s0:  12345678 s1:  00000000 a0:  00000000 PC:  0000000c inst:  02802083 Time_Step:  0003
< ra:  00000000 sp:  00000000 t0:  00000000 t1:  00000000 t2:  00000000 s0:  12345678 s1:  00000000 a0:  00000000 PC:  00000010 inst:  00000000 Time_Step:  0004
< ra:  12345678 sp:  00000000 t0:  00000000 t1:  00000000 t2:  00000000 s0:  12345678 s1:  00000000 a0:  00000000 PC:  00000014 inst:  00000000 Time_Step:  0005
---
> ra:  00000000 sp:  00000000 t0:  00000000 t1:  00000000 t2:  00000000 s0:  00000008 s1:  00000000 a0:  00000000 PC:  00000008 inst:  02802423 Time_Step:  0002
> ra:  00000000 sp:  00000000 t0:  00000000 t1:  00000000 t2:  00000000 s0:  00000680 s1:  00000000 a0:  00000000 PC:  0000000c inst:  02802083 Time_Step:  0003
> ra:  00000000 sp:  00000000 t0:  00000000 t1:  00000000 t2:  00000000 s0:  00000680 s1:  00000000 a0:  00000000 PC:  00000010 inst:  00000000 Time_Step:  0004
> ra:  00000000 sp:  00000000 t0:  00000000 t1:  00000000 t2:  00000000 s0:  00000680 s1:  00000000 a0:  00000000 PC:  00000014 inst:  00000000 Time_Step:  0005
```

Okay, I forgot to assign inputs to `DMEM`, still wrong.

I <font color=red>failed</font> to find this bug.

