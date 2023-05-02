.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
#
# If the length of the vector is less than 1, 
# this function exits with error code 8.
# ==============================================================================
relu:
    ble a1, x0, error
    li t0, 0
loop_start:
    slli t1, t0, 2
    add t1, t1, a0
    lw t2, 0(t1)
    bge t2, x0, loop_continue
    sw x0, 0(t1)
loop_continue:
    addi t0, t0, 1
    blt t0, a1, loop_start
loop_end:
    ret

error:
    li a0, 10
    li a1, 8
    ecall