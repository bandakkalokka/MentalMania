class MathEquation { 
  //Math equations

  char getSign() {
    char sign = 0;
    char sign_assigner = (char)(int)(random(1, 5));

    if (sign_assigner == 1) {
      sign = 43; // Add
    } else if (sign_assigner == 2) {
      sign = 45; // Subtract
    } else if (sign_assigner == 3) {
      sign = 120; // Multiply
    } else if (sign_assigner == 4) {
      sign = 247; // Divide
    }

    return sign;
  }

  int getNumber() {
    return (int)(random (1, 12));
  }

  String getEqn() {
    int num1 = getNumber();
    int num2 = getNumber();
    int num3 = getNumber();
    char sign1 = getSign();
    char sign2 = getSign();  

    if (sign1 == 247) {
      while (num1 % num2 != 0) {
        num1 = getNumber();
        num2 = getNumber();
      }
    }

    if (sign2 == 247) {
      while (num2 % num3 != 0) {
        num2 = getNumber();
        num3 = getNumber();
      }
    }

    if (sign1 == 247 && sign2 == 247) {
      while (num1 % num2 != 0 && num2 % num3 != 0) {
        num1 = getNumber();
        num2 = getNumber();
        num3 = getNumber();
      }
    }


    int ans = calculate(num1, num2, num3, sign1, sign2);

    return String.valueOf(num1) + sign1 + String.valueOf(num2) + sign2 + String.valueOf(num3) + "," + ans;
  }


  int calculate(int num1, int num2, int num3, char sign1, char sign2) {
    int ans = 0;

    if (sign2 == 247 || sign2 =='x' && (sign1 != 247)) {
      switch(sign2) {
      case 'x':
        ans += num2 * num3;
        break;

      case 247:
        ans += num2/num3;
        break;

      case '+':
        ans += num2 + num3;
        break;

      case '-':
        ans += num2 - num3;
        break;
      }

      switch(sign1) {
      case 'x':
        ans *= num1;
        break;

      case 247:
        ans = num1/ans;
        break;

      case '+':
        ans += num1;
        break;

      case '-':
        ans  = num1 - ans;
        break;
      }
    } else {
      
      switch(sign1) {
      case 'x':
        ans += num1 * num2;
        break;

      case 247:
        ans += num1 / num2;
        break;

      case '+':
        ans += num1 + num2;
        break;

      case '-':
        ans += num1 - num2;
        break;
      }

      switch(sign2) {
      case 'x':
        ans *= num3;
        break;

      case 247:
        ans /= num3;
        break;

      case '+':
        ans += num3;
        break;

      case '-':
        ans -= num3;
        break;
      }
    }
    return ans;
  }
}