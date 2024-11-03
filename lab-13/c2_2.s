.globl middle_value_int 
middle_value_int: # a0 = *array, a1 = size n
srli a1, a1, 1
li t0, 4
mul a1, a1, t0
add a0, a0, a1
lw a0, 0(a0)
ret

.globl middle_value_short
middle_value_short: # a0 = *array, a1 = size n
srli a1, a1, 1
li t0, 2
mul a1, a1, t0
add a0, a0, a1
lh a0, 0(a0)
ret

.globl middle_value_char
middle_value_char: # a0 = *array, a1 = size n
srli a1, a1, 1
add a0, a0, a1
lb a0, 0(a0)
ret

.globl value_matrix
value_matrix: # a0 = matrix[12][42], a1 = r, a2 = c
li t0, 168
mul a1, a1, t0
add a0, a0, a1
slli a2, a2, 2
add a0, a0, a2
lw a0, 0(a0)
ret
