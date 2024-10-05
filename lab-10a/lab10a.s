/*
linked_list_search:
parameters: Node *head_node, int val
returns: index (if node (index) sum of values = val, -1 if none)
*/
linked_list_search:
# a0 = head_node, a1 = val 
    li a2, 0
    search:
    lw s0, 0(a0)
    addi a0, a0, 4
    lw s1, 0(a0)
    add s2, s0, s1
    beq s2, a1, end
    addi a0, a0, 4
    lw s3, 0(a0)
    bne s3, x0, continue
    li a2, -1
    j end
    continue:
    mv a0, s3
    addi a2, a2, 1
    j search
    end:
    mv a0, a2
    ret

/*
puts: write string to stdout
parameters: const char *str (string terminated by \0)
returns: - (ecall)
*/
puts:
# a0 = str
    li s0, 0
    mv s2, a0
    len:
    lb s1, 0(s2)
    beq s1, x0, write
    addi s0, s0, 1
    addi s2, s2, 1
    j len
    write:
    mv a1, a0
    li a0, 1
    li a2, s0
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
gets:
mv a1, a0
li s1, 0xa
loop:
li a0, 0
li a2, 1
li a7, 63
ecall
lb s0, 0(a1)
beq s0, x0, gets_end
beq s0, s1, gets_end
addi a1, a1, 1
j loop
gets_end:
mv a0, a1
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
atoi:
# a0 = str adress
li s0, 0
mv s1, a0
li s2, 0x20
li s4, 1
# The function first discards as many whitespace characters (as in isspace) as necessary until the first non-whitespace character is found.
discard_whitespace:
lb s3, 0(s1)
beq s3, x0, end_atoi # returns s0 (0)
bne s3, s2, check_sign
j discard_whitespace
# Then, starting from this character, takes an optional initial plus or minus sign
check_sign:
addi s3, s3, -45
beq s3, x0, negative
blt s3, x0, positive
negative:
li s4, -1
positive:
addi s1, s1, 1
j get_digit
get_digit:
lb s3, 0(s1)
addi s3, s3, -48
# gets digit and checks if it stands between 0 and 9. in case it does not, jumps to end
blt s3, x0, end_atoi
li s2, 0xa
bge s2, 0xa, end_atoi
# conversion loop
mul s0, s0, s2
add s0, s0, s3
addi s1, s1, 1
j get_digit
end_atoi:
addi s1, s1, 1
mv a1, s1 # new buffer pointer
mv a0, s0 # value encountered

/*
itoa: converts a value to its representation in decimal/hexadecimal base
parameters: int value, char *str (buffer to be filled), int base
returns: char *str (representation)
*/
itoa:
# a0 = value, a1 = buffer, a2 = base
li s0, 16
beq a2, s0, hexadecimal
decimal: 
hexadecimal:

/*
exit: calls exit syscall to finish execution
parameters: int code (return/error code)
returns: -
*/
exit:
# a0 -> int code
li a7, 93
ecall