.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 78.
# ==============================================================================
relu:
    # check if a1 is less than 1
    li t0, 1
    bge a1, t0, loop_start # if # >= 1, jump to loop_start
    li a1, 78
    j exit2

loop_start:
    # i = 0
    add t0, x0, x0

    # load the first element
    lw t1, 0(a0)
    bge t1, x0, loop_continue # if array[0] >= 0, step into loop
    sw x0, 0(a0) # else set array[0] = 0

loop_continue:
    addi t0, t0, 1 # i++
    addi a0, a0, 4 # array = array + 4

    # check if i == a1
    beq t0, a1, loop_end

    # load the next element
    lw t1, 0(a0)
    bge t1, x0, loop_continue
    sw x0, 0(a0)
    j loop_continue # loop again

loop_end:
    ret
