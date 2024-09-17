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

    j first

# to_integer -> converts 4-byte inputs to its respective integer value
to_integer:
    li t0, 0
    li t2, 0
    li t3, 3
    li t5, 10

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
    la a1, input_address
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

    j output

build:
    li t1, 0
    li t2, 4
    li t5, 10
    addi a1, a1, 4
    build_loop:
    rem t0, s1, t5
    addi t0, t0, 48
    sb t0, 0(a1)
    div s1, s1, t5
    # pointers & counters
    addi a1, a1, -1
    addi t1, t1, 1
    blt t1, t2, build_loop
    # updates and returns
    addi a1, a1, 5
    jalr s11, 0(a0)
    
output: # converts the integer values to string (for the future: optimize!)
    li s0, 32
    la a1, output_address
    addi a1, a1, -1

    mv s1, a3
    jal a0, build
    sb s0, 0(a1)

    mv s1, a4
    jal a0, build
    sb s0, 0(a1)

    mv s1, a5
    jal a0, build
    sb s0, 0(a1)

    mv s1, a6
    jal a0, build

    li s0, 0xa
    sb s0, 0(a1)


write:
    li a0, 1            # file descriptor = 1 (stdout)
    la a1, output_address       # buffer
    li a2, 20           # size
    li a7, 64           # syscall write (64)
    ecall

