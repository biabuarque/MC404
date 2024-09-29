.bss
.align 2
    input_address: .skip  7 # buffer
    output_address: .skip 5  # buffer

.text
.align 2
read:
    li a0, 0  # file descriptor = 0 (stdin)
    la a1, input_address #  buffer to write the data
    li a2, 7  # size
    li a7, 63 # syscall read (63)
    ecall

    jal a0, convert

to_integer:
    li t0, 0
    li t2, 32
    li t5, 10

    loop:
    lbu t1, 0(a1)
    beq t1, t2, end_loop
    beq t1, t5, end_loop
    mul t0, t0, t5
    addi t1, t1, -48
    add t0, t0, t1
    addi a1, a1, 1
    j loop

    end_loop:
    addi a1, a1, 1
    jalr x0, 0(a0)

convert:
    li t4, 45
    lbu t6, 0(a1)
    bne t6, t4, then
    addi a1, a1, 1
    then:
    jal a0, to_integer
    mv a3, t0 # number to be searched
    bne t6, t4, search
    li t4, -1
    mul a3, a3, t4
    j search

sum:
    lw s0, 0(a1)
    li s4, 0
    addi a1, a1, 4
    lw s1, 0(a1)
    add s2, s0, s1
    beq s2, a3, found
    addi a1, a1, 4
    lw s3, 0(a1)
    beq s3, x0, end
    mv a1, s3
    addi a5, a5, 1
    j sum
    end:
    jalr x0, 0(a0)
    
search:
    li a5, 0
    la a1, head_node
    jal a0, sum
    j not_found

found:
    la a1, output_address
    build:
    li t5, 10
    li t6, 100
    addi a1, a1, 3
    li t4, 3
    check:
    rem t1, a5, t6
    bne t1, a5, build_loop
    addi a1, a1, -1
    addi t4, t4, -1
    rem t1, a5, t5
    bne t1, a5, build_loop
    addi a1, a1, -1
    addi t4, t4, -1
    build_loop:
    rem t0, a5, t5
    addi t0, t0, 48
    sb t0, 0(a1)
    div a5, a5, t5
    beq a5, x0, end_build
    # pointers & counters
    addi a1, a1, -1
    # updates and returns
    j build_loop
    end_build:
    add a1, a1, t4
    li t5, 0xa
    sb t5, 0(a1)
    j write

not_found:
    la a1, output_address
    li t4, 45
    sb t4, 0(a1)
    addi a1, a1, 1
    li a5, 49
    sb a5, 0(a1)
    addi a1, a1, 1
    li s0, 0xa
    sb s0, 0(a1)

write:
    li a0, 1  # file descriptor = 1 (stdout)
    la a1, output_address # buffer to write the data
    li a2, 5  # size
    li a7, 64 # syscall write (64)
    ecall





    

