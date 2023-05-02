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
#
# If the length of the vector is less than 1, 
# this function exits with error code 7.
# =================================================================
argmax:
    ble a1, x0, error
    li t0, 1 # iteration index
    li t1, 0 # largest index
    lw t2, 0(a0) # largest value

loop_start:
    bge t0, a1, loop_end
    slli t3, t0, 2
    add t3, t3, a0
    lw t3, 0(t3)
    blt t3, t2, loop_continue
    mv t1, t0
    mv t2, t3
loop_continue:
    addi t0, t0, 1
    j loop_start
loop_end:
    mv a0, t1
    ret

error:
    li a0, 10
    li a1, 7
    ecall