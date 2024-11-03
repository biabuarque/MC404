.globl operation
operation:
    # a = a0, b = a1, c = a2, d = a3, e = a4, f = a5, g = a6, h = a7, i = 0(sp), j = 4(sp), k = 8(sp), l = 12(sp), m = 16(sp), n = 20(sp)
    lw t0, 20(sp)
    lw t1, 16(sp)
    lw t2, 12(sp)
    lw t3, 8(sp)
    lw t4, 4(sp)
    lw t5, 0(sp)
    sw a0, 20(sp)
    sw a1, 16(sp)
    sw a2, 12(sp)
    sw a3, 8(sp)
    sw a4, 4(sp)
    sw a5, 0(sp)
    mv t6, a6
    mv a6, a7
    mv a7, t6
    mv a0, t0
    mv a1, t1
    mv a2, t2
    mv a3, t3
    mv a4, t4
    mv a5, t5
    addi sp, sp, -4
    sw ra, 0(sp)
    addi sp, sp, 4
    jal mystery_function
    addi sp, sp, -4
    lw ra, 0(sp)
    addi sp, sp, 4
    ret