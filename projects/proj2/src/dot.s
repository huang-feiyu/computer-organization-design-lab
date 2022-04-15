.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 75.
# - If the stride of either vector is less than 1,
#   this function terminates the program with error code 76.
# =======================================================
dot:
    ble a2, x0, exit75 # check if length of vector is less than 1
    # check if stride of either vector is less than 1
    ble a3, x0, exit76
    ble a4, x0, exit76

    # allocate space
    addi sp, sp, -12
    sw s0, 0(sp) # sum
    sw s1, 4(sp) # arr1 temp value
    sw s2, 8(sp) # arr2 temp value

    # init value
    li t2, 0 # i = 0
    li s0, 0 # sum=0
    li t0, 4
    li t1, 4
    mul t0, t0, a3 # arr1 stride
    mul t1, t1, a4 # arr2 stride

loop_start:
    lw s1, 0(a0) # arr1[i]
    lw s2, 0(a1) # arr2[i]

    mul s1, s1, s2 # s1 = s1 * s2
    add s0, s0, s1 # sum += s1

    addi t2, t2, 1 # i++
    add a0, a0, t0 # arr1 += arr1 stride
    add a1, a1, t1 # arr2 += arr2 stride

    beq t2, a2, loop_end # i == length, break
    j loop_start

loop_end:
    mv a0, s0 # a0 = sum

    # pop stack
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    addi sp, sp, 12

    ret

exit75:
    li a1, 75
    j exit2

exit76:
    li a1, 76
    j exit2