.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#   If any file operation fails or doesn't read the proper number of bytes,
#   exit the program with exit code 1.
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
#
# If you receive an fopen error or eof, 
# this function exits with error code 50.
# If you receive an fread error or eof,
# this function exits with error code 51.
# If you receive an fclose error or eof,
# this function exits with error code 52.
# ==============================================================================
read_matrix:

    # Prologue
    addi sp, sp, -36
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 24(sp)
    sw s7, 28(sp)
    sw ra, 32(sp)

    mv s1, a1 # &rows
    mv s2, a2 # &cols



    mv a1, a0
    mv a2, zero
    call fopen
    blt a0, zero, fopen_failed
    mv s0, a0 # fd

    mv a1, s0
    addi sp, sp, -8
    mv a2, sp
    li a3, 8
    call fread
    li a1, 8
    bne a0, a1, fread_failed

    lw s4, 0(sp) # rows
    lw s5, 4(sp) # cols
    addi sp, sp, 8

    mul s6, s4, s5
    slli s6, s6, 2 # size of matrix data
    mv a0, s6
    call malloc
    beq a0, zero, malloc_failed
    mv s7, a0 # &matrix data

    mv a1, s0
    mv a2, s7
    mv a3, s6
    call fread
    bne a0, s6, fread_failed

    mv a1, s0
    call fclose
    bne a0, zero, fclose_failed

    mv a0, s7
    sw s4, 0(s1)
    sw s5, 0(s2)

    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw s7, 28(sp)
    lw ra, 32(sp)
    addi sp, sp, 36

    ret

malloc_failed:
    li a1, 48
    call exit
fopen_failed:
    li a1, 50
    call exit
fread_failed:
    li a1, 51
    call exit
fclose_failed:
    li a1, 52
    call exit