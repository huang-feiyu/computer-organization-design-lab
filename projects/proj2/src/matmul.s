.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 72.
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 73.
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 74.
# =======================================================
matmul:
    ## argument check
    # m0 check
    ble a1, x0, exit72
    ble a2, x0, exit72
    # m1 check
    ble a4, x0, exit73
    ble a5, x0, exit73
    # m0, m1 match check
    bne a2, a4, exit74

    # allocate space to save the arguments
    addi sp, sp, -32
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 24(sp)
    sw ra, 28(sp) # PC counter

    # save the arguments
    mv s0, a0
    mv s1, a1
    mv s2, a2
    mv s3, a3
    mv s4, a4
    mv s5, a5
    mv s6, a6

    # init
    li t0, 0 # i = 0

outer_loop_start:
    li t1, 0 # j = 0

inner_loop_start:
    mv a0, s0 # arr0 pointer
    li t2, 4
    mul t2, t2, t1 # j * 4
    add a1, s3, t2 # arr1 pointer

    mv a2, s2 # arr0 cols
    li a3, 1 # arr0 stride
    mv a4, s5 # arr1 cols, stride

    # save i, j
    addi sp, sp, -8
    sw t0, 0(sp)
    sw t1, 4(sp)

    jal dot # call dot product

    sw a0, 0(s6) # d[i][j] = dot(m0[i], m1[j])
    addi s6, s6, 4 # d pointer move forward

    lw t0, 0(sp) # i
    lw t1, 4(sp) # j
    addi sp, sp, 8 # restore i, j

    addi t1, t1, 1 # j++
    beq t1, s5, inner_loop_end # j == c1
    j inner_loop_start # j != c1

inner_loop_end:

    li t2, 4
    mul t2, t2, s2 # cols * 4
    add s0, s0, t2 # arr0 pointer move forward
    addi t0, t0, 1 # i++

    beq t0, s1, outer_loop_end # i == r0
    j outer_loop_start # i != r0

outer_loop_end:
    # pop stack
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw ra, 28(sp) # PC counter
    addi sp, sp, 32

    ret

exit72:
    li a1, 72
    j exit2

exit73:
    li a1, 73
    j exit2

exit74:
    li a1, 74
    j exit2