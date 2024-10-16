.text
.align 2
# car - 0xffff0100

.set steering_wheel, 0xffff0120
.set engine, 0xffff0121
j move_car

move_car:

set_steer:
li a0, steering_wheel
li t2, -100
sb t2, 0(a0)

set_engine:
li a0, engine
li t2, 1
sb t2, 0(a0)

delay:
li t0, 0
li t1, 25000
loop:
addi t0, t0, 1
blt t0, t1, loop

reset_steer:
li a0, steering_wheel
li t2, 0
sb t2, 0(a0)

second_delay:
li t0, 0
li t1, 200000
second_loop:
addi t0, t0, 1
blt t0, t1, second_loop

exit:
li a0, 0
li a7, 93
ecall