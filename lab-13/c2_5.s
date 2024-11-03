.bss
.align 2
node: .skip 8

.text
.align 2
.globl node_creation
node_creation:
    addi sp, sp, -12
    mv a0, sp
    li a1, 30
    sw a1, 0(a0)
    li a1, 25
    sb a1, 4(a0)
    li a1, 64
    sb a1, 5(a0)
    li a1, -12
    sh a1, 6(a0)
    sw ra, 8(sp)
    jal mystery_function
    lw ra, 8(sp)
    addi sp, sp, 12
    ret

