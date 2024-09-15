.data
input_address: .skip 0xa0  # buffer
output_address: .skip 0xa0  # buffer

.text
read:
    li a0, 0  # file descriptor = 0 (stdin)
    la a1, input_address #  buffer to write the data
    li a2, 20  # size
    li a7, 63 # syscall read (63)
    ecall


    
    jal a0, first

# to_integer -> converts 4-byte inputs to its respective integer value
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

first: # converts each input to integer
    jal a0, to_integer
    mv a3, t0

    jal a0, to_integer
    mv a4, t0

    jal a0, to_integer
    mv a5, t0

    jal a0, to_integer
    mv a6, t0

    jal s11, then

# square_root -> calculates the square root of a number
square_root: 
    li t5, 10
    li t6, 0
    mv t0, s1
    srli t0, t0, 1
    slti t1, t0, 1
    add t0, t0, t1

    for:
    mv t4, s1
    div t4, t4, t0
    add t0, t0, t4
    srli t0, t0, 1
    slti t1, t0, 1
    add t0, t0, t1 

    addi t6, t6, 1
    blt t6, t5, for

    mv s1, t0
    jalr s11, 0(a0)

then: # calculates the square root of each input
    mv s1, a3;
    jal a0, square_root
    mv a3, s1

    mv s1, a4;
    jal a0, square_root
    mv a4, s1

    mv s1, a5;
    jal a0, square_root
    mv a5, s1

    mv s1, a6;
    jal a0, square_root
    mv a6, s1

    
build_output: # converts the integer values to string (for the future: optimize!)
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

