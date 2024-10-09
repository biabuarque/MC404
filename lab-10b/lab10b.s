.global recursive_tree_search
recursive_tree_search:
/*
height = 0
if (a0 == null):
return 0
else if (a0 == val):
return 1
else:
height1 = recursive_tree_search(a0->left, val)
if height1 > 0:
return height1 + 1
height2 = recursive_tree_search(a0->right, val)
if height2 > 0:
return height2 + 1
else:
return 0
*/
# a0 = root_node, a1 = val

addi sp, sp, -12
sw ra, 0(sp)
sw s3, 4(sp)
sw s4, 8(sp)


lw a2, 0(a0)
bne a2, x0, not_zero
is_zero:
lw ra, 0(sp)
lw s3, 4(sp)
lw s4, 8(sp)
addi sp, sp, 12
li a0, 0
ret

not_zero:
bne a2, a1, not_equal # if value, add 1 to height
lw ra, 0(sp)
lw s3, 4(sp)
lw s4, 8(sp)
addi sp, sp, 12
li a0, 1
ret

not_equal:
lw s3, 4(a0)
lw s4, 8(a0)

left_child:
mv a0, s3
jal recursive_tree_search
mv s3, a0

beq s3, x0, right_child
mv s5, s3
addi s5, s5, 1
lw ra, 0(sp)
lw s3, 4(sp)
lw s4, 8(sp)
addi sp, sp, 12
mv a0, s5
ret

right_child:
mv a0, s4
jal recursive_tree_search
mv s4, a0

beq s4, x0, is_zero
mv s5, s4
addi s5, s5, 1
lw ra, 0(sp)
lw s3, 4(sp)
lw s4, 8(sp)
addi sp, sp, 12
mv a0, s5
ret
/*
puts: write string to stdout
parameters: const char *str (string terminated by \0)
returns: - (ecall)
*/
.global puts
puts:
# a0 = str
    li t4, 1
    mv t2, a0
    li t3, 0xa
    len:
    lb t1, 0(t2)
    beq t1, x0, write
    beq t1, t3, write
    addi t4, t4, 1
    addi t2, t2, 1
    j len
    write:
    sb t3, 0(t2)
    mv a1, a0
    li a0, 1
    mv a2, t4
    li a7, 64
    ecall
    ret

/*
gets: reads characters from the standard input (stdin) and stores them as a C string into str until a newline character or the end-of-file is reached.
parameters: char *str (buffer to be filled, stdin)
returns: char *str (buffer filled)
The newline character, if found, is not copied into str.
A terminating null character is automatically appended after the characters copied to str.
*/
.global gets
gets:
mv a1, a0
mv t2, a0
li t1, 0xa
loop:
li a0, 0
li a2, 1
li a7, 63
ecall
lbu t3, 0(a1)
beq t3, x0, gets_end
beq t3, t1, gets_end
sb t3, 0(a1)
addi a1, a1, 1
j loop
gets_end:
sb x0, 0(a1)
mv a0, t2
ret

/*
atoi: parses the C-string str interpreting its content as an integral number, which is returned as a value of type int.
parameters: char *str
returns: int value

" The function first discards as many whitespace
characters (as in isspace) as necessary until the
first non-whitespace character is found. Then,
starting from this character, takes an optional
initial plus or minus sign followed by as many
base-10 digits as possible, and interprets them as
a numerical value.

The string can contain additional characters after
those that form the integral number, which are ignored
and have no effect on the behavior of this function.

If the first sequence of non-whitespace characters in str
is not a valid integral number, or if no such sequence
exists because either str is empty or it contains only
whitespace characters, no conversion is performed and
zero is returned. "
*/
.global atoi
atoi:
# a0 = str adress
li t5, 0
mv t1, a0
li t2, 0x20
li t4, 1
# The function first discards as many whitespace characters (as in isspace) as necessary until the first non-whitespace character is found.
discard_whitespace:
lbu t3, 0(t1)
beq t3, x0, end_atoi # returns s0 (0)
bne t3, t2, check_sign
j discard_whitespace
# Then, starting from this character, takes an optional initial plus or minus sign
check_sign:
addi t3, t3, -45
beq t3, x0, negative
blt t3, x0, positive
j get_digit
negative:
li t4, -1
positive:
addi t1, t1, 1
j get_digit
get_digit:
lbu t3, 0(t1)
addi t3, t3, -48
# gets digit and checks if it stands between 0 and 9. in case it does not, jumps to end
blt t3, x0, end_atoi
li t2, 0xa
bge t3, t2, end_atoi
# conversion loop
mul t5, t5, t2
add t5, t5, t3
addi t1, t1, 1
j get_digit
end_atoi:
addi t1, t1, 1
mul t5, t5, t4
mv a0, t5 # value encountered
ret

/*
itoa: converts a value to its representation in decimal/hexadecimal base
parameters: int value, char *str (buffer to be filled), int base
returns: char *str (representation)
*/
.global itoa 
itoa:
# a0 = value, a1 = buffer, a2 = base
li t0, 0
mv t3, a1
li t2, 11
bge a2, t2, conversion
bge a0, x0, conversion
li t2, 45
sb t2, 0(t3)
li t2, -1
mul a0, a0, t2
addi t3, t3, 1
conversion: # conversion loop, stores digits in stack
rem t1, a0, a2
li t2, 10
blt t1, t2, continue_conversion # in case the base is hexadecimal, and the digit is greater than 9, it must be converted to a letter
addi t1, t1, 7
continue_conversion:
addi t1, t1, 48
addi sp, sp, -1
sb t1, 0(sp)
div a0, a0, a2
beq a0, x0, build
addi t0, t0, 1
j conversion
build: # build output based on whats in the stack
lb t1, 0(sp)
addi sp, sp, 1
sb t1, 0(t3)
addi t3, t3, 1
addi t0, t0, -1
bge t0, x0, build
end_itoa:
li t2, 0xa
sb t2, 0(t3)
mv a0, a1
ret

/*
exit: calls exit syscall to finish execution
parameters: int code (return/error code)
returns: -
*/
.global exit
exit:
# a0 -> int code
li a7, 93
ecall