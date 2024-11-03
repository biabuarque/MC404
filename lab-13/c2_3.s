.text
.align 2
.globl fill_array_int
fill_array_int:
addi sp, sp, -404
mv a0, sp
li a1, 0
li a2, 100
mv t0, a0
for_int:
bge a1, a2, end_int
sw a1, 0(t0)
addi t0, t0, 4
addi a1, a1, 1
j for_int
end_int:
sw ra, 400(sp)
jal mystery_function_int
lw ra, 400(sp)
addi sp, sp, 404
ret

.globl fill_array_short
fill_array_short:
addi sp, sp, -204
mv a0, sp
li a1, 0
li a2, 100
mv t0, a0
for_short:
bge a1, a2, end_short
sw a1, 0(t0)
addi t0, t0, 2
addi a1, a1, 1
j for_short
end_short:
sw ra, 200(sp)
jal mystery_function_short
lw ra, 200(sp)
addi sp, sp, 204
ret


.globl fill_array_char
fill_array_char:
addi sp, sp, -104
mv a0, sp
li a1, 0
li a2, 100
mv t0, a0
for_char:
bge a1, a2, end_char
sw a1, 0(t0)
addi t0, t0, 1
addi a1, a1, 1
j for_char
end_char:
sw ra, 100(sp)
jal mystery_function_char
lw ra, 100(sp)
addi sp, sp, 104
ret