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

int fillBinary(char binary[], int size, char *result){
    result[0] = '0';
    result[1] = 'b';
    int rem = 34 - size;
    for (int i = 0; i <= rem; i++){
        result[i + 2] = '0';
    }
    for (int i = 0; i < size; i++){
        result[i + rem + 3] = binary[i + 2];
    }

    return 34;
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

int HexatoBinary(char hexa[], char *result){
    result[0] = '0';
    result[1] = 'b';
    int start = 2, i = 2, tempsize;
    do {
        int value;
        if (hexa[i] <= '9'){
            value = hexa[i] - '0';
        }
        else{
            value = hexa[i] - 'a';
        }
        char tempBinary[10];

        if (i == 2){
            tempsize = IntegertoBinary(value, 0, tempBinary, 0);
        }
        else{
            tempsize = IntegertoBinary(value, 0, tempBinary, 4);
        }
        for (int j = 0; j < tempsize - 1; j++){
            result[start + j] = tempBinary[j + 2];
        }
        start += tempsize - 1;
        i++;
    } while (hexa[i] != '\n');

    result[start++] = '\n';
    result[start] = '\0';

    int size = start - 2;
    if (size == 34 && result[3] == '1'){
        size = -size;
    }
    
    return size;
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
            temp[j++] = (value - 10) + 'a';
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

int swapEndian (char binary[], char *result, int unfilledSize, int negative){
    result[0] = '0';
    result[1] = 'b';
    char filledBinary[36];
    if (negative){
    twoComplement(binary);
    }
    int size;
    if (unfilledSize < 34){
        size = fillBinary(binary, unfilledSize, filledBinary);
    }
    else{
        size = unfilledSize;
        for (int i = 0; i < 36; i++){
            filledBinary[i] = binary[i];
        }
    }
    twoComplement(filledBinary);
    twoComplement(binary);
    int i = 6, j;
    do {
        for(j = 0; j < 8; j++){
            if (filledBinary[size - i + j] == 'b'){
                break;
            }
            result[i - 4 + j] = filledBinary[size - i + j];
        }
        if (filledBinary[size - i + j] == 'b'){
                break;
            }
        i += 8;
    } while(1);

    if (size < 34){
        for (int k = i - 4 + j; k < 34; k++){
            result[k] = '0';
        }
    }
    result[34] = '\n';
    result[35] = '\0';

    return (result[2] == '1');
}

int main()
{
    char str[20], resultDecimal[36], resultBinary[36], resultHexa[36], binarySwapped[36], resultSwapped[36];
    /* Read up to 20 bytes from the standard input into the str buffer */
    int n = read(STDIN_FD, str, 20), number, size, negative;
    if (str[1] != 'x'){
        number = readDecimal(str), negative = (number < 0);
        size = IntegertoBinary(number, negative, resultBinary, 0);
        write(STDOUT_FD, resultBinary, 36);
    }

    else{
        size = HexatoBinary(str, resultBinary);
        write(STDOUT_FD, resultBinary, 36);

        negative = 0;
        if (size < 0){
            negative = 1;
            size = -size;
        }
        number = BinarytoInteger(resultBinary, negative, size);
    }
    IntegertoDecimal(number, negative, resultDecimal);
    write(STDOUT_FD, resultDecimal, 36);

    BinarytoHexa(resultBinary, resultHexa, size);
    write(STDOUT_FD, resultHexa, 36);

    int swappedNegative = swapEndian(resultBinary, binarySwapped, size, negative);
    int swappedNumber = BinarytoInteger(binarySwapped, swappedNegative, 33);
    IntegertoDecimal(swappedNumber, swappedNegative, resultSwapped);
    write(STDOUT_FD, resultSwapped, 36);

    return 0;
}

