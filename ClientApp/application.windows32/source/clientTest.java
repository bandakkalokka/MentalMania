import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import ddf.minim.*; 
import ddf.minim.analysis.*; 
import ddf.minim.effects.*; 
import ddf.minim.signals.*; 
import ddf.minim.spi.*; 
import ddf.minim.ugens.*; 
import processing.net.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class clientTest extends PApplet {

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


/* Depndencies for minim and TCP network communication */










Client c;                             //Declares a client variable
String word = "";       //Stores the keyboard input after game has started
String ipAdd = "";                    //Stores the ipAddress of the Server 
String name = "";                     //Stores the name provided by the user
String serverMessage = "";            //Stores the message sent from the Server
int port = 0;                         //Stores the port number of Server
boolean connected = false;            //Used to check if connection to server was successfully established
boolean mouseOnIP = false;            //Used to check when the user has exited the Main Menu
boolean mainMenu = true;              //Used to check when the user has exited the Main Menu      
boolean messageReceived = true;       //Used to limit the data sent to the Server by the Client

UI ui;                                //Declares a new variable of type class UI


public void setup() {
  
  ui = new UI();
  ui.minim = new Minim(this);
  ui.loadMenu();
}

/** 
 *  The primary goal of the draw() function is to read input from Server.
 *  First checks whether the user has pressed a key
 *  in the main menu. Afterwards, once the client has connected to the server,
 *  it reads the inputstream from the server to check if the stream has data from the server.
 *  Once valid data is recieved, reading the data is terminated at a special character
 *  ASCII value 96 (`). Then the updateMessage() function in the ui object is called
 *  with the message from server being the arguement.
 */

public void draw() {
  if (keyPressed && mainMenu) {
    ui.exitMainMenu();
  }

  if (connected) {
    if ((serverMessage = c.readStringUntil(96)) != null) {
      serverMessage = serverMessage.substring(0, serverMessage.length()-1);
      ui.updateMessage(serverMessage);
    }
  }
}




/**
 * Updates the word and name variables. At first word is used to store the
 * IP entered by the client, afterwards, word is used to store the answers
 * entered by the client. Once the enter key is pressed, it checks to is if 
 * client is connected, once the client is connected, data stored in word will be 
 * sent to the server. The textfields are also updated.
 */

public void keyPressed() {
  if (messageReceived) {
    if (key >= ' ' && key <='z' && key != '!') {
      if (mouseOnIP) {
        word += key;
      } else {
        name += key;
      }
    } else if (key == BACKSPACE) {
      if (mouseOnIP && word.length() > 0) {
        word = word.substring(0, word.length()-1);
      } else if (name.length() > 0) {
        name = name.substring(0, name.length()-1);
      }
    } else if (keyCode == ENTER) {
      if (!connected) {
        initiateConnection();
      } else {
        c.write(word+"`");
        word = "";
        ui.ipTextField();
      }
      messageReceived = false;
    }
    if (!connected) {
      ui.nameTextField();
    }

    ui.ipTextField();
  }
}




/**
 * Only called once in the keyPressed() function 
 * to connect with the server. The IP entered by the client
 * stored in word is split and stored in array ip. The first
 * index contains the ip address, the second index contains
 * the port number. The ip address and port number are used
 * to create a new instance of the Client class which is
 * declared to the object c. The name entered by the client
 * is written to the server along with the terminating special
 * character (`) ASCII value 96.
 */

public void initiateConnection() {
  background(0);
  String[] ip = word.split(":");
  ipAdd = ip[0];
  port = Integer.parseInt(ip[1]);
  c = new Client(this, ipAdd, port);
  c.write(name+"`");
  connected = true;
  mouseOnIP = true;
  word = "";
  name = "";
}

/**
 * When mouse is clicked on the ipTextfield, the mouseOnIP is assigned true which
 * changes the data in String variable word (refer to draw() function). When the mouse
 * is clicked anywhere else within the screen, the mouseOnIP is assigned false, which
 * changes the data in String variable name (refer to draw() function);
 */

public void mousePressed() {
  if (!connected) {
    if (width/2 - 150 < mouseX && mouseX < width/2+150 && height/2 - 20 < mouseY && mouseY < height/2 + 20) {
      mouseOnIP = true;
    } else {
      mouseOnIP = false;
    }
  }
}
/**
*
*  Class UI contains the blueprint for the user interface of the Client.
*  It user interface includes Audio files, Pictures, Text Fields and Symbols.
*  The UI also checks Messages sent from the Server.
*  
*
*/

class UI {

  PImage imgCover, img0, img1, img2;        //Variables used to store the Images 
  Minim minim;                              //Used to store an instance of the Mini Sound Class
  AudioPlayer p1, p2, p3;                   //Used to store the three sounds for 2 points, 1 point and 0 points                        


/**
*
*  The updateMessage() function checks the input from the Server
*  and displays the appropriate message respectively. If the score if
*  0, the bronze 0 image will be displayed and the booooo sound effect 
*  will be played. If the score is 1, the silver 1, will be displayed and
*  the beep-beep sound effect will be played. If the score is  2, the gold
*  2 will be displayed and a cheering (YAAYY) sound effect will be played.
*  Else if the input is different from all of the above display it in 
*  display field.
*
*/

  public void updateMessage(String m) {
    background(0);

    if (m.equals("0")) {
      displayImg(img0, 0);
      playSound(p1);
    } else if (m.equals("1")) {
      displayImg(img1, 1);
      playSound(p2);
    } else if (m.equals("2")) {
      displayImg(img2, 2);
      playSound(p3);
    } else if (m.charAt(0) == '1' && m.charAt(1) == '.') {
      GameOverScreen();
      displayScores(m);
    } else {
      messageReceived = true;
      textAlign(CENTER);
      textSize(80);
      text(m, width/2, 100);
    }
  }

  /**
  *
  *  The ipTextField() function displays the what the user types
  *  and is updated every time the user pressed a key.
  *
  */

  public void ipTextField() {
    rectMode(CENTER);
    textAlign(CENTER);

    fill(255);
    rect(width/2, height/2, 400, 40);

    textSize(30);
    fill(150);
    text(word, width/2, height/2 + 10);

    if (!connected) {
      text("Enter IP of Server:", width/2 - 350, height/2 + 10);
    }
  }
  
  /**
  *
  *  The nameTextField() function is used to display the name 
  *  entered by the user. This function exists until the
  *  Main Menu exists. Afterwards, it's not called.
  *  
  */

  public void nameTextField() {
    rectMode(CENTER);
    textAlign(CENTER);

    fill(255);
    rect(width/2, height/2-200, 400, 40);

    textSize(30);
    fill(150);
    text(name, width/2, height/2 - 190);

    if (!connected) {
      text("Enter name:", width/2 - 300, height/2 - 190);
    }
  }


  /**
  *
  *  The loadPics() function is utilized to 
  *  initialize all the PImage variables that
  *  store the pictures with the respective scores.
  *  This function is called at the begining of the 
  *  program in loadMenu().
  *
  */
  
  public void loadPics() {
    img0 = loadImage("0.jpg");
    img1 = loadImage("1.jpg");
    img2 = loadImage("2.jpg");
  }


  /**
  *
  *  The loadSound() function is used to initalize 
  *  the Minim Audio Player variables with the 
  *  respective sound for each score. This function
  *  is called at the beginning of the program in loadMenu().
  *
  */
  
  public void loadSound() {
    p1 = minim.loadFile("0points.mp3");
    p2 = minim.loadFile("1point.mp3");
    p3 = minim.loadFile("2points.mp3");
  }
  
  /**
  *
  *  The displayImg() function is used to display
  *  the Images and a text stating the score
  *  received by the Client,  which are passed in to the parameters.
  *
  */

  public void displayImg(PImage img, int points) {
    imageMode(CENTER);
    image(img, width/2, height/2);
    textSize(40);
    text("You got " + points + " point(s)", width/2, height/2-250);
  }


  /**
  *
  *  The playSound() function is used to play the
  *  AudioPlayer passed in to the function as the
  *  arguement. The function rewinds the file, if
  *  if the file has already been played.
  *
  */
  
  public void playSound(AudioPlayer p) {
    p.rewind();
    p.play();
  }


  /**
  *
  *  The displayScores() takes the score as a parameter
  *  of type String which is printed on a new line using
  *  the \n (This is already done by the Server). 
  *  Then the String is displayed onto the screen.
  *  This function is called inside of the update message function
  *
  */
  
  public void displayScores(String scores) {
    textSize(40);
    text(scores, width/2, height/2-100);
  }


  /**
  *
  *  The GameOverScreen() function displays the Game Over
  *  text once he game is over. Then the entire program will
  *  exit upon System.exit(0);.
  *
  */
  
  public void GameOverScreen() {
    textAlign(CENTER);
    textSize(100);
    text("Game Over", width/2, 100);
  }

  /**
  *
  *  The loadMenu() function is used to load the 
  *  Pictures and Sounds in the Main Menu. It also 
  *  displays the Title of game, name of creators and
  *  click to start.
  *
  */

  public void loadMenu() {

    loadSound();
    loadPics();


    background(0);
    fill(255);
    textMode(CENTER);
    textSize(width/8);
    text ("Mental Mania", width/8, 200);
    textSize(height/20);
    text ("By Chathula Adikary and Ahmed Iqbal", width/4, 300);
    text("Click and press any key to begin!", width/3, 400);
    textSize(width/5);
    text("+", 40, height/2 + 300);
    text("x", width/2-350, height/2 + 300);
    text("\u00F7", width/2-100, height/2 + 300);
    text("*", width/2+200, height/2 + 300);
    text("a", width-225, height/2 + 300);
  }


  /**
  *  The exitMainMenu() function is used to 
  *  clear the Main Menu, once the Client has
  *  clicked and pressed a key.
  *
  */
  
  public void exitMainMenu() {
    background(0);
    ui.ipTextField();
    ui.nameTextField();
    mainMenu = false;
  }
}
  public void settings() {  fullScreen(); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "clientTest" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
