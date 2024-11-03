.globl my_function
my_function: # receives 3 values in a0, a1 and a2
    add t0, a0, a1 # SUM 1

    # store caller-save registers in stack
    addi sp, sp, -16
    sw ra, 0(sp)
    sw a0, 4(sp)
    sw a1, 8(sp)
    sw a2, 12(sp)

    mv a1, a0 # 2nd: a0
    mv a0, t0 # 1st: SUM 1
    jal mystery_function 
    mv t0, a0 # CALL 1

    # restore parameters
    lw ra, 0(sp)
    lw a0, 4(sp)
    lw a1, 8(sp)
    lw a2, 12(sp)
    addi sp, sp, 16

    sub t0, a1, t0 # DIFF 1
    add a3, t0, a2 # SUM 2 -> a3

    # store caller-save registers in stack
    addi sp, sp, -20
    sw ra, 0(sp)
    sw a0, 4(sp)
    sw a1, 8(sp)
    sw a2, 12(sp)
    sw a3, 16(sp)

    mv a0, a3 # 1st: SUM 2, 2nd: a1 (a1)
    jal mystery_function
    mv t0, a0 # CALL 2

    # restore parameters
    lw ra, 0(sp)
    lw a0, 4(sp)
    lw a1, 8(sp)
    lw a2, 12(sp)
    lw a3, 16(sp)
    addi sp, sp, 20

    sub t0, a2, t0 # DIFF 2
    add t0, t0, a3 # SUM 3

    mv a0, t0 # return SUM 3
    ret