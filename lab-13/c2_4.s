.globl node_op
node_op: # a0 = *node
    lw a1, 0(a0)
    lb a2, 4(a0)
    lb a3, 5(a0)
    lh a4, 6(a0)
    add a0, a1, a2
    sub a0, a0, a3
    add a0, a0, a4
    ret
