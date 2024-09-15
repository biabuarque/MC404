/* YB = s1 XC = s2 TA = s3 TB = s4 TC = s5 TR = s6
 DA = (TR - TA)* (3/10).
 DB = (TR - TB)* (3/10).
DC = (TR - TC)* (3/10).
*/

.data
input_address: .skip 0x100  # buffer
output_address: .skip 0x50  # buffer
string:  .asciz "Hello! It works!!!\n"

.text
read:
    li a0, 0  # file descriptor = 0 (stdin)
    la a1, input_address #  buffer to write the data
    li a2, 20  # size
    li a7, 63 # syscall read (63)
    ecall


    li t5, 10
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

first:
    jal a0, to_integer
    mv a3, t0

    jal a0, to_integer
    mv a4, t0

    jal a0, to_integer
    mv a5, t0

    jal a0, to_integer
    mv a6, t0
    
    jal s11, then