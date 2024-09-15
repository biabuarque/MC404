.data
input_address: .skip 0xa0  # buffer
output_address: .skip 0xa0  # buffer
string:  .asciz "Hello! It works!!!\n"

.text
read:
    li a0, 0  # file descriptor = 0 (stdin)
    la a1, input_address #  buffer to write the data
    li a2, 20  # size
    li a7, 63 # syscall read (63)
    ecall


    li t5, 10
    jal a0, first_number

to_integer:
    li t0, 0
    li t2, 0
    li t3, 3
loop:
    lbu t1, (a1)
    add t1, t1, -48
    add t0, t0, t1
    mul t0, t0, t5
    addi a1, a1, 1
    addi t2, t2, 1
    blt t2, t3, loop

    addi a1, a1, 2
    jalr t6, 0(a0)

first_number:
    jal a0, to_integer
    mv a3, t0

second_number:
    jal a0, to_integer
    mv a4, t0

third_number:
    jal a0, to_integer
    mv a5, t0

fourth_number:
    jal a0, to_integer
    mv a6, t0

square_root:
    li t6, 0
    mv t0, a3
    srli t0, t0, 1
    slti t1, t0, 1
    add t0, t0, t1

    for_1:
    mv t4, a3
    div t4, t4, t0
    add t0, t0, t4
    srli t0, t0, 1
    slti t1, t0, 1
    add t0, t0, t1


    addi t6, t6, 1
    blt t6, t5, for_1
    
    mv a3, t0

    li t6, 0
    mv t0, a4
    srli t0, t0, 1
    slti t1, t0, 1
    add t0, t0, t1
    
    for_2:
    mv t4, a4
    div t4, t4, t0
    add t0, t0, t4
    srli t0, t0, 1
    slti t1, t0, 1
    add t0, t0, t1

    addi t6, t6, 1
    blt t6, t5, for_2

    mv a4, t0

    li t6, 0
    mv t0, a5
    srli t0, t0, 1
    slti t1, t0, 1
    add t0, t0, t1

    for_3:
    mv t4, a5
    div t4, t4, t0
    add t0, t0, t4
    srli t0, t0, 1
    slti t1, t0, 1
    add t0, t0, t1

    addi t6, t6, 1
    blt t6, t5, for_3

    mv a5, t0

    li t6, 0
    mv t0, a6
    srli t0, t0, 1
    slti t1, t0, 1
    add t0, t0, t1

    for_4:
    mv t4, a6
    div t4, t4, t0
    add t0, t0, t4
    srli t0, t0, 1
    slti t1, t0, 1
    add t0, t0, t1

    addi t6, t6, 1
    blt t6, t5, for_4

    mv a6, t0
    
build_output:
    li s0, 32
    la a1, output_address

    sb a3, 3(a1)
    lb t0, 3(a1)
    rem t0, t0, t5
    addi t0, t0, 48
    sb t0, 3(a1)

    div a3, a3, t5
    sb a3, 2(a1)
    lb t0, 2(a1)
    addi t0, t0, 48
    sb t0, 2(a1)

    div a3, a3, t5
    sb a3, 1(a1)
    lb t0, 1(a1)
    addi t0, t0, 48
    sb t0, 1(a1)
    
    div a3, a3, t5
    sb a3, 0(a1)
    lb t0, 0(a1)
    addi t0, t0, 48
    sb t0, 0(a1)

    sb s0, 4(a1)

    sb a4, 8(a1)
    lb t0, 8(a1)
    rem t0, t0, t5
    addi t0, t0, 48
    sb t0, 8(a1)

    div a4, a4, t5
    sb a4, 7(a1)
    lb t0, 7(a1)
    addi t0, t0, 48
    sb t0, 7(a1)

    div a4, a4, t5
    sb a4, 6(a1)
    lb t0, 6(a1)
    addi t0, t0, 48
    sb t0, 6(a1)
    
    div a4, a4, t5
    sb a4, 5(a1)
    lb t0, 5(a1)
    addi t0, t0, 48
    sb t0, 5(a1)

    sb s0, 9(a1)

    sb a5, 13(a1)
    lb t0, 13(a1)
    rem t0, t0, t5
    addi t0, t0, 48
    sb t0, 13(a1)

    div a5, a5, t5
    sb a5, 12(a1)
    lb t0, 12(a1)
    addi t0, t0, 48
    sb t0, 12(a1)

    div a5, a5, t5
    sb a5, 11(a1)
    lb t0, 11(a1)
    addi t0, t0, 48
    sb t0, 11(a1)
    
    div a5, a5, t5
    sb a5, 10(a1)
    lb t0, 10(a1)
    addi t0, t0, 48
    sb t0, 10(a1)

    sb s0, 14(a1)

    sb a6, 18(a1)
    lb t0, 18(a1)
    rem t0, t0, t5
    addi t0, t0, 48
    sb t0, 18(a1)

    div a6, a6, t5
    sb a6, 17(a1)
    lb t0, 17(a1)
    addi t0, t0, 48
    sb t0, 17(a1)

    div a6, a6, t5
    sb a6, 16(a1)
    lb t0, 16(a1)
    addi t0, t0, 48
    sb t0, 16(a1)
    
    div a6, a6, t5
    sb a6, 15(a1)
    lb t0, 15(a1)
    addi t0, t0, 48
    sb t0, 15(a1)

    li s0, 0xa
    sb s0, 19(a1)


write:
    li a0, 1            # file descriptor = 1 (stdout)
    la a1, output_address       # buffer
    li a2, 20           # size
    li a7, 64           # syscall write (64)
    ecall

