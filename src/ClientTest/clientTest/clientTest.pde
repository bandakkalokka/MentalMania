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

import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;
import processing.net.*;


Client c;                             //Declares a client variable
String word = "localhost:5205";       //Stores the keyboard input after game has started
String ipAdd = "";                    //Stores the ipAddress of the Server 
String name = "";                     //Stores the name provided by the user
String serverMessage = "";            //Stores the message sent from the Server
int port = 0;                         //Stores the port number of Server
boolean connected = false;            //Used to check if connection to server was successfully established
boolean mouseOnIP = false;            //Used to check when the user has exited the Main Menu
boolean mainMenu = true;              //Used to check when the user has exited the Main Menu      
boolean messageReceived = true;       //Used to limit the data sent to the Server by the Client

UI ui;                                //Declares a new variable of type class UI


void setup() {
  fullScreen();
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

void draw() {
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

void keyPressed() {
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

void initiateConnection() {
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

void mousePressed() {
  if (!connected) {
    if (width/2 - 150 < mouseX && mouseX < width/2+150 && height/2 - 20 < mouseY && mouseY < height/2 + 20) {
      mouseOnIP = true;
    } else {
      mouseOnIP = false;
    }
  }
}