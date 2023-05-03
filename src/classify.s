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
    # 
    # If there are an incorrect number of command line args,
    # this function returns with exit code 49.
    #
    # Usage:
    #   main.s -m -1 <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
    li t0, 5
    bne a0, t0, wrong_argc

    addi sp, sp, -40
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 24(sp)
    sw s7, 28(sp)
    sw s8, 32(sp)
    sw ra, 36(sp)

    mv s1, a1 # argv
    mv s2, a2 # print_classification

	# =====================================
    # LOAD MATRICES
    # =====================================
    addi sp, sp, -24


    # Load pretrained m0
    lw a0, 4(s1)
    mv a1, sp      # 0(sp) -> rows of m0
    addi a2, sp, 4 # 4(sp) -> cols of m0
    call read_matrix
    mv s3, a0 # m0

    # Load pretrained m1
    lw a0, 8(s1)
    addi a1, sp, 8  # 8(sp) -> rows of m1
    addi a2, sp, 12 # 12(sp) -> cols of m1
    call read_matrix
    mv s4, a0 # m1


    # Load input matrix
    lw a0, 12(s1)
    addi a1, sp, 16 # 16(sp) -> rows of input
    addi a2, sp, 20 # 20(sp) -> cols of input
    call read_matrix
    mv s5, a0 # input

    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    lw t0, 0(sp)  # rows of hidden_layer
    lw t1, 20(sp) # cols of hidden_layer
    mul s6, t0, t1 # size of hidden_layer
    mv a0, s6
    slli a0, a0, 2
    call malloc
    beq a0, zero, malloc_failed
    mv s7, a0 # *hidden_layer

    mv a0, s3
    lw a1, 0(sp)
    lw a2, 4(sp)
    mv a3, s5
    lw a4, 16(sp)
    lw a5, 20(sp)
    mv a6, s7
    call matmul

    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    mv a0, s7
    mv a1, s6
    call relu

    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)
    lw t0, 8(sp)
    lw t1, 20(sp)
    mul a0, t0, t1
    slli a0, a0, 2
    call malloc
    beq a0, zero, malloc_failed
    mv s8, a0 # *output

    mv a0, s4
    lw a1, 8(sp)
    lw a2, 12(sp)
    mv a3, s7
    lw a4, 0(sp)
    lw a5, 20(sp)
    mv a6, s8
    call matmul

    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix
    lw a0, 16(s1)
    mv a1, s8
    lw a2, 8(sp)
    lw a3, 20(sp)
    call write_matrix

    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax
    mv a0, s8
    lw t0, 8(sp)
    lw t1, 20(sp)
    mul a1, t0, t1
    call argmax

    bne s2, zero, out
    # Print classification
    mv a1, a0
    call print_int

    # Print newline afterwards for clarity
    li a1, '\n'
    call print_char

out:
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw s7, 28(sp)
    lw s8, 32(sp)
    lw ra, 36(sp)
    addi sp, sp, -40

    ret


wrong_argc:
    li a1, 49
    call exit
malloc_failed:
    li a1, 48
    call exit