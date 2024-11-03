.globl operation
operation:
    # a = a0, b = a1, c = a2, d = a3, e = a4, f = a5, g = a6, h = a7, i = 0(sp), j = 4(sp), k = 8(sp), l = 12(sp), m = 16(sp), n = 20(sp)
    mv t0, a1
    mv t1, a2
    add t0, t0, t1 # t0 = b + c
    mv t1, a5
    sub t0, t0, t1 # t0 = b + c - f
    mv t1, a7
    add t0, t0, t1 # t0 = b + c - f + h
    lh t1, 8(sp)
    add t0, t0, t1 # t0 = b + c - f + h + k
    lw t1, 16(sp)
    sub t0, t0, t1 # t0 = b + c - f + h + k - m
    mv a0, t0
    ret