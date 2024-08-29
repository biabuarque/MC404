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


int IntegertoBinary(int number, int negative, char *result, int sizeOfResult){
    int i = 0, j, size;
    char temp[36];

    if (negative){
        number = -number;
        while (i < 32){
        temp[i++] = number % 2 + '0';
        number /= 2;
        }
    }

    else{
        while (((sizeOfResult== 0) && number > 0) || (i < sizeOfResult)){
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
    size = i + 1;

    return size;
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

long long int BinarytoInteger(char binary[], int negative, int size){
    long long int number = 0;
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

/* Provided by book. Check for redundance from IntegertoHexa...*/
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
    return 0;
}

