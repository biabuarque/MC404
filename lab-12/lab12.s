.text
.align 2

.set serial_write, 0xffff0100
.set serial_read, 0xffff0102

j main

write: # receives char in a0
    li a1, serial_write
    sb a0, 1(a1)
    li t0, 1
    sb t0, 0(a1)
    write_loop:
    lb t0, 0(a1)
    bne t0, x0, write_loop
    ret

read: # returns char in a0
    li a1, serial_read
    li t0, 1
    sb t0, 0(a1)
    read_loop:
    lb t0, 0(a1)
    bne t0, x0, read_loop
    lb a0, 1(a1)
    ret

main:
jal read
mv t1, a0
beqz t1, main
addi t1, t1, -48
jal read
li t2, 1
beq t1, t2, string
addi t2, t2, 1
beq t1, t2, reversed
addi t2, t2, 1
beq t1, t2, hex
addi t2, t2, 1
beq t1, t2, algebra
jal exit

string:
jal read
li t2, 0xa
beq a0, t2, end
jal write
j string
end:
jal exit

reversed:
jal read
li t2, 0xa
mv t3, sp
beq a0, t2, print
addi sp, sp, -1
sb a0, 0(sp)
j reversed
print:
beq sp, t3, end_rev
lb a0, 0(sp)
addi sp, sp, 1
jal write
j print
end_rev:
jal exit

hex:
jal exit

algebra:
jal exit

exit:
li a0, 0
li a7, 93
ecall