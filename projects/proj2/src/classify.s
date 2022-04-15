.globl classify

.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero,
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    # Exceptions:
    # - If there are an incorrect number of command line args,
    #   this function terminates the program with exit code 89.
    # - If malloc fails, this function terminats the program with exit code 88.
    #
    # Usage:
    #   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>

    # check if argc valid
    li t0, 5
    bne t0, a0, exit89

    # allocate memory
    addi sp, sp, -48
    sw ra,   0(sp)
    sw s0,   4(sp)
    sw s1,   8(sp)
    sw s2,  12(sp) # rc0
    sw s3,  16(sp) # m0
    sw s4,  20(sp) # rc1
    sw s5,  24(sp) # m1
    sw s6,  28(sp) # input_rc
    sw s7,  32(sp) # input_m
    sw s8,  36(sp) # hidden_layer
    sw s9,  40(sp) # scores
    sw s10, 44(sp) # max

    mv s0, a1 # argv
    mv s1, a2 # flag

    # =====================================
    # LOAD MATRICES
    # =====================================

    # Load pretrained m0
    li a0, 8
    jal malloc
    beq a0, x0, exit88
    mv s2, a0 # rc0

    lw a0, 4(s0) # argv[1]
    addi a1, s2, 0 # rc0[0]
    addi a2, s2, 4 # rc0[1]
    jal read_matrix
    mv s3, a0 # m0

    # Load pretrained m1
    li a0, 8
    jal malloc
    beq a0, x0, exit88
    mv s4, a0 # rc1

    lw a0, 8(s0) # argv[2]
    addi a1, s4, 0 # rc1[0]
    addi a2, s4, 4 # rc1[1]
    jal read_matrix
    mv s5, a0 # m1

    # Load input matrix
    li a0, 8
    jal malloc
    beq a0, x0, exit88
    mv s6, a0 # input_rc

    lw a0, 12(s0) # argv[3]
    addi a1, s6, 0 # input_rc[0]
    addi a2, s6, 4 # input_rc[1]
    jal read_matrix
    mv s7, a0 # input_m


    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)

    # m0 * input
    lw t0, 0(s2) # rc0[0]
    lw t1, 4(s6) # input_rc[1]
    mul a0, t0, t1 # rc0[0] * input_rc[1]
    slli a0, a0, 2 # rc0[0] * input_rc[1] * sizeof(int)
    jal malloc
    beq a0, x0, exit88
    mv s8, a0 # hidden_layer

    mv a0, s3 # m0
    lw a1, 0(s2) # rc0[0]
    lw a2, 4(s2) # rc0[1]
    mv a3, s7 # input_m
    lw a4, 0(s6) # input_rc[0]
    lw a5, 4(s6) # input_rc[1]
    mv a6, s8 # hidden_layer
    jal matmul

    # ReLU(hidden_layer)
    mv a0, s8 # hidden_layer
    lw t0, 0(s2) # rc0[0]
    lw t1, 4(s6) # input_rc[1]
    mul a1, t0, t1 # rc0[0] * input_rc[1]
    jal relu
ebreak

    # m1 * ReLU(hidden_layer)
    # lw t0, 0(s4) # rc1[0]
    # #lw t1, 4(s6) # input_rc[1]
    # li t1, 10
    # mul a0, t0, t1 # rc1[0] * input_rc[1]
    li a0, 100
    jal malloc
    beq a0, x0, exit88
    mv s9, a0 # scores

    mv a0, s5 # m1
    lw a1, 0(s4) # rc1[0]
    lw a2, 4(s4) # rc1[1]
    mv a3, s8 # hidden_layer
    lw a4, 0(s2) # rc0[0]
    lw a5, 4(s6) # input_rc[1]
    mv a6, s9 # scores
    jal matmul

    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix
    lw a0, 16(s0) # argv[4]
    mv a1, s9 # scores
    lw a2, 0(s4) # rc1[0]
    lw a3, 4(s6) # input_rc[1]
    jal write_matrix

    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax
    mv a0, s9 # scores
    lw t0, 0(s4) # rc1[0]
    lw t1, 4(s6) # input_rc[1]
    mul a1, t0, t1
    jal argmax
    mv s10, a0 # max

    # Print classification
    bne s1, x0, free_memory
    mv a1, s10
    jal print_int
    # Print newline afterwards for clarity
    li a1, '\n'
    jal print_char

free_memory:
    mv a0, s2
    jal free
    mv a0, s3
    jal free
    mv a0, s4
    jal free
    mv a0, s5
    jal free
    mv a0, s6
    jal free
    mv a0, s7
    jal free
    mv a0, s8
    jal free
    mv a0, s9
    jal free

    mv a0, s10
    lw ra,   0(sp)
    lw s0,   4(sp)
    lw s1,   8(sp)
    lw s2,  12(sp)
    lw s3,  16(sp)
    lw s4,  20(sp)
    lw s5,  24(sp)
    lw s6,  28(sp)
    lw s7,  32(sp)
    lw s8,  36(sp)
    lw s9,  40(sp)
    lw s10, 44(sp)
    addi sp, sp, 48

    ret

exit88:
    li a1, 88
    j exit2

exit89:
    li a1, 89
    j exit2

exit120:
    li a1, 120
    j exit2
