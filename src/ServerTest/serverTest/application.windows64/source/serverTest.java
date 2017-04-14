import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.net.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class serverTest extends PApplet {

/**
 *    ENGG 233 Design Project (Game)
 *    By Chathula Adikary and Ahmed Iqbal
 *
 *    Welcome to Mental Mania (Client)
 *
 *    For further information about the game please visit:
 *    http://mentalmania.paperplane.io
 *
 */



/* Dependencies for TCP network communication*/



Server s;                           //Declares a variable of type Server
Client[] c;                         //Declares an array of clients to keep track of all connected clients
int[] score;                        //Declares an array of type int to keep track of the client's scores
String[] name;                      //Declares an array of type String which keeps track of the names of clients               
int roundCount = 0;
boolean connected = false;
boolean allAnswered = false;
boolean nextGame = true;
String clientInput = "";
Game g = null;

public void setup() {
  c = new Client[0];
  name = new String[0];
  s = new Server(this, 5205);
}

public void draw() {
  if (connected) {
    checkAnswer();
    if (allAnswered) {
      if (roundCount < 5) {
        g.mathGame();
        allAnswered = false;
      } else if (roundCount < 10) {
        if (roundCount < 6) {
          nextGame = true;
        }
        g.wordGame(roundCount-1);
        allAnswered = false;
      } else {

        for (int i = 0; i < c.length; i++) {
          s.write((i+1) + ". " + name[i] + " : " + score[i] + "\n");
          println((i+1) + ". " + name[i] + " : " + score[i] + "\n");
        }
        s.write("`");
      }
      roundCount++;
    }
  }
}


public void serverEvent(Server someServer, Client someClient) {
  someClient.write("Successfully connected to server, \n waiting for other players!`");

  c = addClient(c, someClient);
  score = new int[c.length];
  name = append(name, "");

  String n = "";

  while ((n = someClient.readStringUntil(96)) == null) {
  }
  name[name.length-1] = n.substring(0, n.length()-1);

  println(name[name.length-1], "connected from", someClient.ip());

  if (c.length > 0) {
    g = new Game(c);
    g.run();
    connected = true;
  }
}




public Client[] addClient(Client[] a, Client c) {
  Client[] clients = new Client[a.length+1];
  for (int i = 0; i < a.length; i++) {
    clients[i] = a[i];
  }
  clients[a.length] = c;
  return clients;
}


public void writeToClients(String word) {
  s.write(word + "`");
}

public void checkAnswer() {
  int numofAns = 0;
  String ans = g.getAns();
  boolean firstPerson = true;

  while (numofAns < this.c.length) {

    for (int i = 0; i < this.c.length; i++) {
      clientInput = c[i].readStringUntil(96); // store client input break at ,

      if ((clientInput != null)) {
        clientInput = clientInput.substring(0, clientInput.length()-1);

        if (clientInput.equals(ans) && firstPerson) {
          score[i] +=  2;
          c[i].write("2`");
          firstPerson = false;
        } else if (clientInput.equals(ans) && !firstPerson) {
          score[i] +=  1;
          c[i].write("1`");
        } else if (!clientInput.equals(ans)) {
          score[i] += 0;
          c[i].write("0`");
        }


        numofAns++;
        println(name[i], "has", score[i], "points.", "Entered:", clientInput, "Actual:", ans);
      }
    }
  }

  allAnswered = true;
}


public void disconnectEvent(Client someClient) {
  g.wait(3000, "Client " + someClient.ip() + " disconnected");
}



class Game implements Runnable {

  Client[] c;
  int startTime;
  boolean startGame = false;
  String ans = "";

  public Game(Client[] c) {
    this.c = c;
  }

  public void run() {
    startTime = millis();
    wait(3000, "Next game will begin in: ");
    startGame = true;
    wait(1000, "Math Lingo");
    mathGame();
    //mathGame();
  }

  public void mathGame() {
    MathEquation m = new MathEquation();
    String eqn = m.getEqn();
    ans = eqn.substring(eqn.lastIndexOf(",")+1);
    wait(1000, eqn.substring(0, eqn.lastIndexOf(",")));
  }

  public void wordGame(int difficulty) {
    if (nextGame) {
      g.wait(1000, "Typing Ninja");
      nextGame = false;
    }
    WordGenerator w = new WordGenerator(difficulty);
    String word = w.generateWord();
    ans = word;
    wait(1000, word);
  }


  public void wait(int wait, String word) {
    int time = wait/1000;

    while (time > 0) {
      while (millis() > startTime + wait) {
        if (startGame) {
          writeToClients(word);
        } else {
          writeToClients(word + time);
        }
        startTime = millis();
        time--;
      }
    }
  }


  public String getAns() {
    return ans;
  }
}

class MathEquation { 
  //Math equations

  public char getSign() {
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

  public int getNumber() {
    return (int)(random (1, 12));
  }

  public String getEqn() {
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


  public int calculate(int num1, int num2, int num3, char sign1, char sign2) {
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

class WordGenerator {
  
  int difficulty = 0;
  
  public WordGenerator(int difficulty) {
    this.difficulty = difficulty;
  }
  
  public String generateWord() {
    String word = "";
    
    for(int i = 0; i < difficulty*2; i++) {
      if(difficulty > 7) {
      word += (i % 2 == 0) ? (char)random(65, 90) : (char)random(97, 122);
      }
      else {
        word += (difficulty % 2 == 0) ? (char)random(65, 90) : (char)random(97, 122);
      }
    }
    return word;
  }
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "serverTest" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
