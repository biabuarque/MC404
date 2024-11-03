.data
.align 2
.globl my_var
my_var: .word 10

.text
.align 2
.globl increment_my_var
increment_my_var:
la a0, my_var # gets var adress
lw a1, 0(a0) # loads var value
addi a1, a1, 1 # increments var value
sw a1, 0(a0) # stores var value
mv a0, a1 # "returns" var value
ret
