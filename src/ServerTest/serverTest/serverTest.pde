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

import processing.net.*;

Server s;                           //Declares a variable of type Server
Client[] c;                         //Declares an array of clients to keep track of all connected clients
int[] score;                        //Declares an array of type int to keep track of the client's scores
String[] name;                      //Declares an array of type String which keeps track of the names of clients               
int roundCount = 0;                 //Keeps track of the number of rounds of the game
boolean connected = false;          //If Client is connnected to Server, then true, else false
boolean allAnswered = false;        //If all Clients have entered an answer
boolean nextGame = true;            //If the next game has started, true, else false
String clientInput = "";            //Stores the data sent by the client
Game g = null;                      //Declares a variable of type Game

void setup() {
  c = new Client[0];
  name = new String[0];
  s = new Server(this, 5205);
}


  /**
  *
  *  The draw function acts as the main loop for the game. Once
  *  all clients have entered the answer to the first question,
  *  the draw function begins. The function keeps track of the
  *  number of rounds (6 rounds for Math Lingo and 6 rounds
  *  for Typing Ninja. At the end of the game, all of the 
  *  clients' names and their respective scores are written
  *  to the clients.
  *
  */
  
void draw() {
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


  /**
  *
  *  The serverEvent() function is called when ever a Client connects to the Server.
  *  Firstly, the Client is informed that they have successfully connected.
  *  Afterwards, the Client is added to the array of clients using the user-defined
  *  append function named addClient(). Name and score arrrays are also appended.
  *  The name of the client is then added to the name array. Then the Server is
  *  informed that a Client has connected from the respective IP address.
  *  Once the required number of Clients are connected, a new instance of the Game class
  *  is created. 
  */


void serverEvent(Server someServer, Client someClient) {
  someClient.write("Successfully connected to server, \n waiting for other players!`");

  c = addClient(c, someClient);
  score = new int[c.length];
  name = append(name, "");

  String n = "";

  while ((n = someClient.readStringUntil(96)) == null) {
  }
  name[name.length-1] = n.substring(0, n.length()-1);

  println(name[name.length-1], "connected from", someClient.ip());

  if (c.length > 1) {
    g = new Game(c);
    g.run();
    connected = true;
  }
}


  /**
  *
  *  The addClient() function appends a new client to an array of Clients
  *  and returns a new array.
  */


Client[] addClient(Client[] a, Client c) {
  Client[] clients = new Client[a.length+1];
  for (int i = 0; i < a.length; i++) {
    clients[i] = a[i];
  }
  clients[a.length] = c;
  return clients;
}

  /**
  *
  *  The writeToClients() function accepts a String and 
  *  sends it to all the clients who have connected.
  *
  */

void writeToClients(String word) {
  s.write(word + "`");
}

  /**
  *
  *   The checkAnswer() function communicates with the instance
  *  of the Game class stored in variable g, to get the answer
  *  and check if the Client input is equivalent to the actual
  *  answer. The data from the Client is read until the special character
  *  ASCII value 96 (`) and stored in the clientInput variable. 
  *  The loops are utilized to check whether all Clients have input
  *  answers. Denpending on the answer, each Client is awarded, 2,
  *  1, or 0 pints and the scores is written to the Client so the
  *  respective image can be displayed.
  *
  */

void checkAnswer() {
  int numofAns = 0;
  String ans = g.getAns();
  boolean firstPerson = true;

  while (numofAns < this.c.length) {

    for (int i = 0; i < this.c.length; i++) {
      clientInput = c[i].readStringUntil(96); // store client input break at `

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


  /**
  *
  *  The disconnectEvent() function is called when ever a user
  *  is disconnected from the Server. It is used to let other
  *  clients know that another user disconnected.
  */

void disconnectEvent(Client someClient) {
  g.wait(3000, "Client " + someClient.ip() + " disconnected");
}