.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
# - If malloc returns an error,
#   this function terminates the program with error code 88.
# - If you receive an fopen error or eof,
#   this function terminates the program with error code 90.
# - If you receive an fread error or eof,
#   this function terminates the program with error code 91.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 92.
# ==============================================================================
read_matrix:

    # allocate memory
    addi sp, sp, -28
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw ra, 24(sp)

    mv s0, a0 # filename
    mv s1, a1 # &row
    mv s2, a2 # &col

    # open file
    mv a1, s0
    li a2, 0
    jal fopen
    li t0, -1
    beq a0, t0, exit90 # file open error
    mv s3, a0 # fp pointer

    # read file: row, col
    li s5, 4  # size
    mv a1, s3 # fp
    mv a2, s1 # &row
    mv a3, s5 # sizeof(int)
    jal fread
    bne a0, s5, exit91 # fread error

    mv a1, s3 # fp
    mv a2, s2 # &col
    mv a3, s5 # sizeof(int)
    jal fread
    bne a0, s5, exit91 # fread error
    lw s1, 0(s1) # row, only one byte
    lw s2, 0(s2) # col

    # allocate memory for matrix
    mul s5, s1, s2 # row*col
    slli s5, s5, 2 # multiply by 4
    mv a0, s5
    jal malloc
    beq a0, x0, exit88 # malloc error
    mv s4, a0 # matrix pointer

    # read file: matrix
    mv a1, s3 # fp
    mv a2, s4 # matrix
    mv a3, s5 # row*col*4
    jal fread
    bne a0, s5, exit91 # fread error

    # close file
    mv a1, s3
    jal fclose
    li t0, -1
    beq a0, t0, exit92 # fclose error

    # return matrix
    mv a0, s4

    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw ra, 24(sp)
    addi sp, sp, 28

    ret

exit88:
    li a1, 88
    j exit2

exit90:
    li a1, 90
    j exit2

exit91:
    li a1, 91
    j exit2

exit92:
    li a1, 92
    j exit2