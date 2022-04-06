.globl factorial

.data
n: .word 7

.text
main:
    la t0, n
    lw a0, 0(t0)
    jal ra, factorial

    addi a1, a0, 0
    addi a0, x0, 1
    ecall # Print Result

    addi a1, x0, '\n'
    addi a0, x0, 11
    ecall # Print newline

    addi a0, x0, 10
    ecall # Exit

# int factorial(int n) {
#     return factorial(n - 1) * n;
# }
factorial:
    li t0, 1 # 1
    beq a0, t0, finish # if n == 1, then return
    addi sp, sp, -8
    sw ra, 4(sp) # push ra, ans
    sw a0, 0(sp) # push a0, n
    addi a0, a0, -1 # n--
    jal ra, factorial
    lw t0, 0(sp) # pop a0, n!
    mul a0, a0, t0 # mul n * n!
    lw ra, 4(sp) # pop ra
    addi sp, sp, 8

finish:
    ret