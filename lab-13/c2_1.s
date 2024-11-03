.globl swap_int
swap_int: # a0 = *a, a1 = *b
    lw t0, 0(a0)
    lw t1, 0(a1)
    sw t1, 0(a0)
    sw t0, 0(a1)

    li a0, 0
    ret

.globl swap_short
swap_short: # a0 = *a, a1 = *b
    lh t0, 0(a0)
    lh t1, 0(a1)
    sh t1, 0(a0)
    sh t0, 0(a1)

    li a0, 0
    ret

.globl swap_char
swap_char: # a0 = *a, a1 = *b
    lb t0, 0(a0)
    lb t1, 0(a1)
    sb t1, 0(a0)
    sb t0, 0(a1)
    
    li a0, 0
    ret