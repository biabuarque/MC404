# first part: calculate parity -> rem sum(inputs) 2
# second part: check encoding -> p xor a xor b xor c
# third part: build outputs

.bss
.align 2
input_address: .skip 0xd  # buffer
output_address: .skip 0xf  # buffer

.text
.align 2
read:
    li a0, 0  # file descriptor = 0 (stdin)
    la a1, input_address #  buffer to write the data
    li a2, 13  # size
    li a7, 63 # syscall read (63)
    ecall

    jal a0, first

get_bit:
    lbu t0, 0(a1)
    add t0, t0, -48
    addi a1, a1, 1
    jalr t6, 0(a0)

get_parity:
    li t5, 2
    add t0, t1, t2
    add t0, t0, t3
    rem t0, t0, t5
    jalr t6, 0(a0)

first: # read first line
    la a1, input_address
    la a2, output_address
    li s0, 0xa # newline

    jal a0, get_bit
    mv s1, t0
    
    jal a0, get_bit
    mv s2, t0

    jal a0, get_bit
    mv s3, t0

    jal a0, get_bit
    mv s4, t0

    addi a1, a1, 1 # skip newline

    /* build parities */

    # p1 -> s5
    mv t1, s1
    mv t2, s2
    mv t3, s4
    jal a0, get_parity
    mv s5, t0

    # p2 -> s6
    mv t1, s1
    mv t2, s3
    mv t3, s4
    jal a0, get_parity
    mv s6, t0

    # p3 -> s7
    mv t1, s2
    mv t2, s3
    mv t3, s4
    jal a0, get_parity
    mv s7, t0

    /* write encoding */
    addi s5, s5, 48
    sb s5, 0(a2)

    addi s6, s6, 48
    sb s6, 1(a2)

    addi s1, s1, 48
    sb s1, 2(a2)

    addi s7, s7, 48
    sb s7, 3(a2)

    addi s2, s2, 48
    sb s2, 4(a2)

    addi s3, s3, 48
    sb s3, 5(a2)

    addi s4, s4, 48
    sb s4, 6(a2)

    sb s0, 7(a2)

    j then

check_parity:
    xor t0, t1, t2
    xor t0, t0, t3
    xor t0, t0, t4

    jalr t6, 0(a0)

then: # read second line
    li s0, 0xa # newline
    la a2, output_address
    
    jal a0, get_bit
    mv s5, t0

    jal a0, get_bit
    mv s6, t0

    jal a0, get_bit
    mv s1, t0

    jal a0, get_bit
    mv s7, t0

    jal a0, get_bit
    mv s2, t0

    jal a0, get_bit
    mv s3, t0

    jal a0, get_bit
    mv s4, t0

    /* write bits */
    addi s1, s1, 48
    sb s1, 8(a2)
    addi s1, s1, -48

    addi s2, s2, 48
    sb s2, 9(a2)
    addi s2, s2, -48

    addi s3, s3, 48
    sb s3, 10(a2)
    addi s3, s3, -48

    addi s4, s4, 48
    sb s4, 11(a2)
    addi s4, s4, -48

    sb s0, 12(a2)

    mv t1, s5
    mv t2, s1
    mv t3, s2
    mv t4, s4
    jal a0, check_parity
    mv s8, t0

    mv t1, s6
    mv t3, s3
    jal a0, check_parity
    mv s9, t0

    mv t1, s7
    mv t2, s2
    jal a0, check_parity
    mv s10, t0

    or s11, s8, s9
    or s11, s11, s10

    /* write checking */
    addi s11, s11, 48
    sb s11, 13(a2)
    sb s0, 14(a2)

write:
    li a0, 1            # file descriptor = 1 (stdout)
    la a1, output_address
    li a2, 15
    li a7, 64           # syscall write (64)
    ecall





