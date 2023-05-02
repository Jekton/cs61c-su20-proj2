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
#
# If the length of the vector is less than 1, 
# this function exits with error code 5.
# If the stride of either vector is less than 1,
# this function exits with error code 6.
# =======================================================
dot:
    ble a2, x0, error5
    ble a3, x0, error6
    ble a4, x0, error6

    mv t0, x0 # sum
    mv t1, x0 # index

loop_start:
    mul t2, t1, a3
    slli t2, t2, 2
    add t2, t2, a0
    lw t2, 0(t2)

    mul t3, t1, a4
    slli t3, t3, 2
    add t3, t3, a1
    lw t3, 0(t3)

    mul t2, t2, t3
    add t0, t0, t2
    addi t1, t1, 1
    blt t1, a2, loop_start

loop_end:
    mv a0, t0
    ret

error5:
    li a0, 10
    li a1, 5
    ecall
error6:
    li a0, 10
    li a1, 6
    ecall