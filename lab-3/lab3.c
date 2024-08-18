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

void IntegertoDecimal(int number, int negative, char *result){
    int i = 0, j;
    char temp[34];

    if (negative){
        number = -number;
    }

    while (number > 0){
        temp[i++] = number % 10 + '0';
        number /= 10;
    }

    if (negative){
        temp[i++] = '-';
    }
 
    j = i - 1;
    
    while (j >= 0){
        result[i - j - 1] = temp[j];
        j--;
    }

    result[i++] = '\n';

    result[i] = '\0';
}

void twoComplement(char *binary){
    for (int i = 33; i > 1; i--){
        if (binary[i] == '0'){
            binary[i] = '1';
        }
        else{
            binary[i] = '0';
        }
    }

    for (int i = 33; i > 1; i--){
        if (binary[i] == '0'){
            binary[i] = '1';
            break;
        }
        else{
            binary[i] = '0';
        }
    }
}

int IntegertoBinary(int number, int negative, char *result){
    int i = 0, j;
    char temp[36];

    if (negative){
        number = -number;
        while (i < 32){
        temp[i++] = number % 2 + '0';
        number /= 2;
        }
    }

    else{
        while (number > 0){
        temp[i++] = number % 2 + '0';
        number /= 2;
        }
    }
 
    j = i - 1;
    
    result[0] = '0';
    result[1] = 'b';

    while (j >= 0){
        result[i - j + 1] = temp[j];
        j--;
    }

    if (negative){
        twoComplement(result);
    }

    result[i + 2] = '\n';

    result[i + 3] = '\0';

    return i + 1;
}

/* Warning: apply only for positive numbers*/
void IntegertoHexa(int number, int negative, char *result){
    int i = 0, j;
    char temp[34];

    if (negative){
        number = -number;
    }

    while (number > 0){
        int rem = number % 16;
        if (rem < 10){
            temp[i++] = rem + '0';   
        }
        else{
            temp[i++] = (rem - 10) + 'a';
        }
        number /= 16;
    }
 
    j = i - 1;
    
    result[0] = '0';
    result[1] = 'x';
    
    while (j >= 0){
        result[i - j + 1] = temp[j];
        j--;
    }

    result[i + 2] = '\n';

    result[i + 3] = '\0';

}

void BinarytoHexa(char binary[], char *result){

}

void HexatoBinary(char hexa[], char *result){

}

int BinarytoInteger(char binary[], int negative, int size){
    int number = 0;
    if (negative){
        twoComplement(binary);
        int j = 0;
        for (int i = size; i > 1; i--){
            number += ((binary[i] - '0') << j);
            j++;
        }
        twoComplement(binary);
        return -number;
    }

    else{
        int i, j = 0;
        for (i = size; i > 1; i--){
            number += ((binary[i] - '0') << j);
            j++;
        }
    }

    return number;
}

void swapEndian (char binary[], char *result){

}


int main()
{
    char str[20], resultDecimal[36], resultBinary[36], resultHexa[36], resultSwapped[36];
    /* Read up to 20 bytes from the standard input into the str buffer */
    int n = read(STDIN_FD, str, 20);
    if (str[1] != 'x'){
        int number = readDecimal(str), negative = (number < 0);
        int size = IntegertoBinary(number, negative, resultBinary);
        IntegertoDecimal(BinarytoInteger(resultBinary, negative, size), negative, resultDecimal);
        IntegertoHexa(number, negative, resultHexa);
    }
    
    /* Write n bytes from the str buffer to the standard output */
    write(STDOUT_FD, resultBinary, 36);
    write(STDOUT_FD, resultDecimal, n);
    write(STDOUT_FD, resultHexa, 36);
    return 0;
}

