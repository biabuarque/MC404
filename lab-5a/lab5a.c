int read(int __fd, const void *__buf, int __n){
    int ret_val;
  __asm__ __volatile__(
    "mv a0, %1           # file descriptor\n"
    "mv a1, %2           # buffer \n"
    "mv a2, %3           # size \n"
    "li a7, 63           # syscall write code (63) \n"
    "ecall               # invoke syscall \n"
    "mv %0, a0           # move return value to ret_val\n"
    : "=r"(ret_val)  // Output list
    : "r"(__fd), "r"(__buf), "r"(__n)    // Input list
    : "a0", "a1", "a2", "a7"
  );
  return ret_val;
}

void write(int __fd, const void *__buf, int __n)
{
  __asm__ __volatile__(
    "mv a0, %0           # file descriptor\n"
    "mv a1, %1           # buffer \n"
    "mv a2, %2           # size \n"
    "li a7, 64           # syscall write (64) \n"
    "ecall"
    :   // Output list
    :"r"(__fd), "r"(__buf), "r"(__n)    // Input list
    : "a0", "a1", "a2", "a7"
  );
}

void exit(int code)
{
  __asm__ __volatile__(
    "mv a0, %0           # return code\n"
    "li a7, 93           # syscall exit (64) \n"
    "ecall"
    :   // Output list
    :"r"(code)    // Input list
    : "a0", "a7"
  );
}

void _start()
{
  int ret_code = main();
  exit(ret_code);
}

#define STDIN_FD  0
#define STDOUT_FD 1

int readDecimal(char str[], int start){
    int number = 0, negative = 0;

    if (str[start] == '-'){
        negative = 1;
    }

    start++;

    for (int i = start; str[i] != ' ' && str[i] != '\n'; i++){
        number = number * 10 + str[i] - '0';
    }

    if (negative){
        number = -number;
    }

    return number;
}

void hex_code(int val){
    char hex[11];
    unsigned int uval = (unsigned int) val, aux;
    
    hex[0] = '0';
    hex[1] = 'x';
    hex[10] = '\n';

    for (int i = 9; i > 1; i--){
        aux = uval % 16;
        if (aux >= 10)
            hex[i] = aux - 10 + 'A';
        else
            hex[i] = aux + '0';
        uval = uval / 16;
    }
    write(1, hex, 11);
}


int main()
{
    char input[30];
    int n = read(STDIN_FD, input, 30);
    int n1 = readDecimal(input, 0), n2 = readDecimal(input, 6), n3 = readDecimal(input, 12), n4 = readDecimal(input, 18), n5 = readDecimal(input, 24);
    int result = (n1 & 7) | ((n2 & 255) << 3) | ((n3 & 31) << 11) | ((n4 & 31) << 16) | ((n5 & 2047) << 21);
    hex_code(result);
    return 0;
}

