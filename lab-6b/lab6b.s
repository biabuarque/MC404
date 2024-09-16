/* YB = s1 XC = s2 TA = s3 TB = s4 TC = s5 TR = s6
 DA = (TR - TA)* (3/10).
 DB = (TR - TB)* (3/10).
DC = (TR - TC)* (3/10).
 DA = a3, DB = a4, DC = a5, X = a6, Y = a7
*/

.data
input_address: .skip 0x100  # buffer
output_address: .skip 0x60  # buffer

.text
read:
    li a0, 0  # file descriptor = 0 (stdin)
    la a1, input_address #  buffer to write the data
    li a2, 32  # size
    li a7, 63 # syscall read (63)
    ecall

    jal a0, first

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

first: # read coordinates and convert them to integers
    li t5, 10

    # yB
    lb s0, 0(a1)
    addi a1, a1, 1
    jal a0, to_integer
    mv s1, t0
    # check negative
    addi s0, s0, -44
    blt s0, x0, jump
    # get 2's complement
    xori s1, s1, -1
    addi s1, s1, 1
    jump:

    # xC
    lb s0, 0(a1)
    addi a1, a1, 1
    jal a0, to_integer
    mv s2, t0
    # check negative
    addi s0, s0, -44
    blt s0, x0, jump2
    # get 2's complement
    xori s2, s2, -1
    addi s2, s2, 1
    jump2:

    # tA
    jal a0, to_integer
    mv s3, t0

    # tB
    jal a0, to_integer
    mv s4, t0

    # tC
    jal a0, to_integer
    mv s5, t0

    # tR
    jal a0, to_integer
    mv s6, t0

second: # a3 = dA, a4 = dB
    li t4, 3
    li t5, 10

    # dA
    mv a3, s6
    sub a3, a3, s3
    mul a3, a3, t4
    div a3, a3, t5
    # dA²
    mul a3, a3, a3

    # dB
    mv a4, s6
    sub a4, a4, s4
    mul a4, a4, t4
    div a4, a4, t5
    # dB²
    mul a4, a4, a4

    # dC
    mv a5, s6
    sub a5, a5, s5
    mul a5, a5, t4
    div a5, a5, t5
    # dC²
    mul a5, a5, a5

then:
    # calculate X (a6)
    mv a6, s2 # xC
    mul a6, a6, a6 # xC²
    add a6, a6, a3 # xC² + dA²
    sub a6, a6, a5 # xC² + dA² - dC²

    li t5, 2
    mul t5, t5, s2 # 2 * xC
    div a6, a6, t5 # (xC² + dA² - dC²) / 2 * xC

    # maybe change that ...
    addi a6, a6, 2

    # calculate Y (a7) 
    mv a7, s1 # yB
    mul a7, a7, a7 # yB²
    add a7, a7, a3 # yB² + dA²
    sub a7, a7, a4 # yB² + dA² - dB²

    li t5, 2
    mul t5, t5, s1 # 2 * yB
    div a7, a7, t5 # (yB² + dA² - dB²) / 2 * yB

    # maybe change that ...
    addi a7, a7, 4

build_output:
    li s0, 32
    li t5, 10
    li t2, 43
    li t3, 45
    la a0, output_address

    bge a6, x0, if_xpos
    j else_x
    if_xpos:
    sb t2, 0(a0)
    j build_x
    else_x:
    sb t3, 0(a0)
    # get 2's complement
    xori a6, a6, -1
    addi a6, a6, 1
    j build_x

    build_x:
    rem t0, a6, t5
    addi t0, t0, 48
    sb t0, 4(a0)
    div a6, a6, t5
    
    rem t0, a6, t5
    addi t0, t0, 48
    sb t0, 3(a0)
    div a6, a6, t5

    rem t0, a6, t5
    addi t0, t0, 48
    sb t0, 2(a0)
    div a6, a6, t5

    rem t0, a6, t5
    addi t0, t0, 48
    sb t0, 1(a0)
    div a6, a6, t5

    sb s0, 5(a0)

    bge a7, x0, if_ypos
    j else_y
    if_ypos:
    sb t2, 6(a0)
    j build_y
    else_y:
    sb t3, 6(a0)
    # get 2's complement
    xori a7, a7, -1
    addi a7, a7, 1
    j build_y

    build_y:
    rem t0, a7, t5
    addi t0, t0, 48
    sb t0, 10(a0)
    div a7, a7, t5
    
    rem t0, a7, t5
    addi t0, t0, 48
    sb t0, 9(a0)
    div a7, a7, t5

    rem t0, a7, t5
    addi t0, t0, 48
    sb t0, 8(a0)
    div a7, a7, t5

    rem t0, a7, t5
    addi t0, t0, 48
    sb t0, 7(a0)
    div a7, a7, t5

    li s0, 0xa
    sb s0, 11(a0)

write:
    li a0, 1            # file descriptor = 1 (stdout)
    la a1, output_address       # buffer
    li a2, 12          # size
    li a7, 64           # syscall write (64)
    ecall
