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

int readDecimal(char str[]){
    int number = 0, start = 0;

    if (str[start] == '-'){
        start++;
    }

    for (int i = start; str[i] != '\n'; i++){
        number = number * 10 + str[i] - '0';
    }

    if (start == 1){
        number = -number;
    }

    return number;
}

char* writeNumber(int number, int type){
    char res[20];
    int i = 0;

    if (number < 0){
        res[i++] = '-';
        number = -number;
    }

    while (number > 0){
        res[i++] = number % 10 + '0';
        number /= 10;
    }

    res[i++] = '\n';

    res[i] = '\0';

    return res;
}


int main()
{
  char str[20];
  /* Read up to 20 bytes from the standard input into the str buffer */
  int n = read(STDIN_FD, str, 20);
  int number = readDecimal(str), negative = (number < 0);
  char res[20], inv[20];
  int i = 0, j;

    if (negative){
        number = -number;
    }

    while (number > 0){
        res[i++] = number % 2 + '0';
        number /= 2;
    }

    // TODO: NOT WORKING!!!
    if (negative){
        res[i++] = '-';
    }
 
    j = i - 1;
    
    while (j >= 0){
        inv[i - j - 1] = res[j];
        j--;
    }

    inv[i++] = '\n';

    inv[i] = '\0';

  /* Write n bytes from the str buffer to the standard output */
  write(STDOUT_FD, inv, n);
  return 0;
}

