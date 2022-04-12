.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 77.
# =================================================================
argmax:
    # check if a1 is less than 1
    li t0, 1
    bge a1, t0, loop_start # if # >= 1, jump to loop_start
    li a1, 77
    j exit2

loop_start:
    # allocate memory
    addi sp, sp, -8
    sw s0, 0(sp)
    sw s1, 4(sp)

    add t0, x0, x0 # i = 0
    add s0, x0, x0 # max_index = 0
    lw s1, 0(a0) # max = array[0], the first element

loop_continue:
    addi t0, t0, 1 # i++
    addi a0, a0, 4 # array++

    # check if i is less than a1
    beq t0, a1, loop_end # if i >= a1, jump to loop_end

    # load next element
    lw t1, 0(a0) # temp_next = array[i]
    ble t1, s1, loop_continue # if temp_next <= max, jump to loop_continue
    mv s1, s1 # max = temp_next
    add s0, t0, x0 # max_index = i
    j loop_continue

loop_end:
    # return max_index
    mv a0, s0

    # pop stack
    lw s0, 0(sp)
    lw s1, 0(sp)
    addi sp, sp, 8

    ret
