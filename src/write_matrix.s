.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
#   If any file operation fails or doesn't write the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
#
# If you receive an fopen error or eof, 
# this function exits with error code 53.
# If you receive an fwrite error or eof,
# this function exits with error code 54.
# If you receive an fclose error or eof,
# this function exits with error code 55.
# ==============================================================================
write_matrix:

    # Prologue
    addi sp, sp, -20
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw ra, 16(sp)


    mv s1, a1 # &data
    mv s2, a2 # rows
    mv s3, a3 # cols

    mv a1, a0
    addi a2, zero, 1
    call fopen
    blt a0, zero, fopen_failed
    mv s0, a0 # fd

    addi sp, sp, -8
    sw s2, 0(sp)
    sw s3, 4(sp)
    mv a1, s0
    mv a2, sp
    li a3, 2
    li a4, 4
    call fwrite
    li a1, 2
    bne a0, a1, fwrite_failed
    addi sp, sp, 8

    mv a1, s0
    mv a2, s1
    mul s3, s2, s3 # size of matrix
    mv a3, s3
    li a4, 4
    call fwrite
    bne a0, s3, fwrite_failed


    mv a1, s0
    call fclose
    bne a0, zero, fclose_failed
    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw ra, 16(sp)
    addi sp, sp, 20
    ret

fopen_failed:
    li a1, 53
    call exit
fwrite_failed:
    li a1, 54
    call exit
fclose_failed:
    li a1, 55
    call exit