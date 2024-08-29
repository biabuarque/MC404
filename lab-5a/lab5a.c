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

void IntegertoDecimal(unsigned int number, int negative, char *result){
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

void BinarytoHexa(char binary[], char *result, int size){
    char temp[20];
    int j = 0, k;
    for (int i = size; i > 1; i -= 4){
        int value = 0;
        for (k = 0; k < 4; k++){
            if (binary[i - k] == 'b'){
                break;
            }
            value += ((binary[i - k] - '0') << k);
        }
        if (value < 10){
            temp[j++] = value + '0';
        }
        else{
            temp[j++] = (value - 10) + 'A';
        }
    }

    result[0] = '0';
    result[1] = 'x';
    
    int l = j - 1;

    while (l >= 0){
        result[j - l + 1] = temp[l];
        l--;
    }

    result[j + 2] = '\n';

    result[j + 3] = '\0';
}

void concatenate(char *result, char *b1,  char *b2,  char *b3,  char *b4,  char *b5){
    result[0] = '0';
    result[1] = 'b';
    for (int i = 2; i < 13; i++){
        result[i] = b1[21 + i];
    }
    for (int i = 13; i < 18; i++){
        result[i] = b2[16 + i];
    }
    for (int i = 18; i < 23; i++){
        result[i] = b3[11 + i];
    }
    for (int i = 23; i < 31; i++){
        result[i] = b4[3 + i];
    }
    for (int i = 31; i < 34; i++){
        result[i] = b5[i];
    }
    result[34] = '\n';
    result[35] = '\0';
}


int main()
{
    char input[30], i1[36], i2[36], i3[36], i4[36], i5[36], result[36], resultHexa[36];
    int n1, n2, n3, n4, n5;
    int n = read(STDIN_FD, input, 30);
    n1 = readDecimal(input, 0);
    n2 = readDecimal(input, 6);
    n3 = readDecimal(input, 12);
    n4 = readDecimal(input, 18);
    n5 = readDecimal(input, 24);
    IntegertoBinary(n1, (n1 < 0), i1, 32);
    IntegertoBinary(n2, (n2 < 0), i2, 32);
    IntegertoBinary(n3, (n3 < 0), i3, 32);
    IntegertoBinary(n4, (n4 < 0), i4, 32);
    IntegertoBinary(n5, (n5 < 0), i5, 32);
    concatenate(result, i5, i4, i3, i2, i1);
    BinarytoHexa(result, resultHexa, 33);
    write(STDOUT_FD, resultHexa, 36);    
    return 0;
}

