.bss
.align 2

buffer: .skip 1

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
/*
write:
la a1, buffer
sb a0, 0(a1)
li t0, 0xa
sb t0, 1(a1)
li a0, 1
li a2, 1
li a7, 64
ecall
ret

read:
li a0, 0
la a1, buffer
li a2, 1
li a7, 63
ecall
ret
*/

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
        jal write
        jal exit

reversed:
    li t2, 0xa
    mv t3, sp
    rev_loop:
        jal read
        beq a0, t2, print
        addi sp, sp, -1
        sb a0, 0(sp)
        j rev_loop
    print:
        beq sp, t3, end_rev
        lb a0, 0(sp)
        addi sp, sp, 1
        jal write
        j print
    end_rev:
        mv a0, t2
        jal write
        jal exit

atoi:
    addi sp, sp, -4
    sw ra, 0(sp)
    li t1, 0
    jal read
    li a2, 10
    li t2, 0xa
    li t3, '-'
    li t4, ' '
    bne a0, t3, positive
    li t3, -1
    jal read
    j looptoi
    positive:
    li t3, 1
    j looptoi
    looptoi:
    beq a0, t2, end_atoi
    beq a0, t4, end_atoi
    addi a0, a0, -48
    mul t1, t1, t2
    add t1, t1, a0
    jal read
    j looptoi
    end_atoi:
    mul t1, t1, t3
    mv a0, t1
    lw ra, 0(sp)
    addi sp, sp, 4
    ret

conversion: # conversion loop, stores digits in stack
addi sp, sp, -4
sw ra, 0(sp)
mv t5, sp
start_conversion:
remu t1, a0, a2
li t2, 10
blt t1, t2, continue_conversion # in case the base is hexadecimal, and the digit is greater than 9, it must be converted to a letter
addi t1, t1, 7
continue_conversion:
addi t1, t1, 48
addi sp, sp, -1
sb t1, 0(sp)
divu a0, a0, a2
beq a0, x0, build
j start_conversion
build:
lb a0, 0(sp)
addi sp, sp, 1
jal write
beq sp, t5, end_conversion
j build
end_conversion:
li t2, 0xa
mv a0, t2
jal write
lw ra, 0(sp)
addi sp, sp, 4
ret

hex:
jal atoi
li a2, 16
jal conversion
jal exit

algebra:
li a2, 10
jal atoi
mv a3, a0
jal read
mv a4, a0
jal read
jal atoi
mv a5, a0
li t1, '*'
bne a4, t1, addit
mul a0, a3, a5
j answer
addit:
li t1, '+'
bne a4, t1, subt
add a0, a3, a5
j answer
subt:
li t1, '-'
bne a4, t1, divi
sub a0, a3, a5
j answer
divi:
li t1, '/'
bne a4, t1, exit
div a0, a3, a5
j answer
answer:
bge a0, x0, positive_ans
addi sp, sp, -4
sw a0, 0(sp)
li a0, '-'
jal write
lw a0, 0(sp)
addi sp, sp, 4
li a1, -1
mul a0, a0, a1
positive_ans:
jal conversion
jal exit

exit:
li a0, 0
li a7, 93
ecall