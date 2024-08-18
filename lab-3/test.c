int readDecimal(char str[]){
    int number = 0, start = 0;

    if (str[start] == '-'){
        start++;
    }

    for (int i = start; str[i] != '\n' && str[i] != '\0'; i++){
        number = number * 10 + str[i] - '0';
    }

    if (start == 1){
        number = -number;
    }

    return number;
}

void decimalToBinary(int number, char res[]){
    int i = 31;
    while (number > 0){
        res[i] = number % 2 + '0';
        number = number / 2;
        i--;
    }
    res[32] = '\n';
    res[33] = '\0';
}

int main(){
  char str[20];
  /* Read up to 20 bytes from the standard input into the str buffer */
  scanf("%s", str);
  int decimalinput = 0;
  if (str[0] == '-' || (str[0] >= '0' && str[0] <= '9')){
    decimalinput = 1;
  }

  /* Read decimal number*/
  int number = readDecimal(str);

  /* Convert decimal to binary */
  char binary[34];
  decimalToBinary(number, binary);

  /* Convert decimal to hexadecimal */

  /* Read hexadecimal number*/

  /* Convert hexadecimal to binary */

  /* Convert binary to decimal */

  /* Swap endianness*/


  /* Write n bytes from the str buffer to the standard output */
  printf("%s", binary);
  return 0;
}