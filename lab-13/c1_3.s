.data
.align 2
a: .word 1
b: .word -2
c: .half 3
d: .half -4
e: .byte 5
f: .byte -6
g: .word 7
h: .word -8
i: .byte 9
jo: .byte -10
k: .half 11
l: .half -12
m: .word 13
n: .word -14

.globl operation
operation:
    la a0, b
    lw a1, 0(a0)
    la a0, c
    lh a2, 0(a0)
    la a0, d
    lh a3, 0(a0)
    la a0, e
    lb a4, 0(a0)
    la a0, f
    lb a5, 0(a0)
    la a0, g
    lw a6, 0(a0)
    la a0, h
    lw a7, 0(a0)
    addi sp, sp, -28
    la a0, i
    lb t0, 0(a0)
    sw t0, 0(sp)
    la a0, jo
    lb t0, 0(a0)
    sw t0, 4(sp)
    la a0, k
    lh t0, 0(a0)
    sw t0, 8(sp)
    la a0, l
    lh t0, 0(a0)
    sw t0, 12(sp)
    la a0, m
    lw t0, 0(a0)
    sw t0, 16(sp)
    la a0, n
    lw t0, 0(a0)
    sw t0, 20(sp)
    sw ra, 24(sp)
    la a0, a
    lw a0, 0(a0)
    jal mystery_function
    lw ra, 24(sp)
    addi sp, sp, 28
    ret
    
    
