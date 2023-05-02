.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
#   The order of error codes (checked from top to bottom):
#   If the dimensions of m0 do not make sense, 
#   this function exits with exit code 2.
#   If the dimensions of m1 do not make sense, 
#   this function exits with exit code 3.
#   If the dimensions don't match, 
#   this function exits with exit code 4.
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
# =======================================================
# int dot(int *x, int *y, int len, int strideA, int strideB) {
#     auto sum = 0;
#     for (int i = 0; i < len; ++i) {
#         sum += x[i * strideA] * y[i * strideB];
#     }
#     return sum;
# }
# 
# void mul(int *A, int rowsA, int colsA,
#         int *B, int rowsB, int colsB,
#         int *result) {
#     for (int i = 0; i < rowsA; ++i) {
#         for (int j = 0; j < colsB; ++j) {
#             int r = dot(A + i * colsA, B + j, rowsB, 1, colsB);
#             result[i * colsB + j] = r;
#         }
#     }
# }

matmul:

    # Error checks
    bgt a1, zero, check1
    li a1, 2
    call exit
check1:
    bgt a2, zero, check2
    li a1, 2
    call exit
check2:
    bgt a4, zero, check3
    li a1, 3
    call exit
check3:
    bgt a5, zero, check4
    li a1, 3
    call exit
check4:
    beq a2, a4, start
    li a1, 4
    call exit

start:
    # Prologue
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

    mv s0, a0 # A
    mv s1, a1 # rowsA
    mv s2, a2 # colsA
    mv s3, a3 # B
    mv s4, a4 # rowsB
    mv s5, a5 # colsB
    mv s6, a6 # result

    li s7, 0 # i = 0
outer_loop_start:
    bge s7, s1, outer_loop_end # if i >= rowsA
    li s8, 0 # j = 0
inner_loop_start:
    bge s8, s5, inner_loop_end # if j >= colsB

    mul a0, s7, s2 # a0 = i * colsA
    slli a0, a0, 2
    add a0, a0, s0 # a0 = A + i * colsA
    slli a1, s8, 2
    add a1, a1, s3 # a1 = B + j
    mv a2, s4, # a2 = rowsB
    li a3, 1
    mv a4, s5 # a3 = colsB
    call dot

    mul t0, s7, s5 # t0 = i * colsB
    add t0, t0, s8 # t0 = i * colsB + j
    slli t0, t0, 2
    add t0, t0, s6 # t0 = &result[i * colsB + j]
    sw a0, 0(t0) # result[i * colsB + j] = r
    addi s8, s8, 1
    j inner_loop_start
inner_loop_end:
    addi s7, s7, 1
    j outer_loop_start
outer_loop_end:

    # Epilogue
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
    addi sp, sp, 40

    ret