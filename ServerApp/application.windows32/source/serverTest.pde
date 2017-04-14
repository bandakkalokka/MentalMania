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
int roundCount = 0;
boolean connected = false;
boolean allAnswered = false;
boolean nextGame = true;
String clientInput = "";
Game g = null;

void setup() {
  c = new Client[0];
  name = new String[0];
  s = new Server(this, 5205);
}

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

  if (c.length > 0) {
    g = new Game(c);
    g.run();
    connected = true;
  }
}




Client[] addClient(Client[] a, Client c) {
  Client[] clients = new Client[a.length+1];
  for (int i = 0; i < a.length; i++) {
    clients[i] = a[i];
  }
  clients[a.length] = c;
  return clients;
}


void writeToClients(String word) {
  s.write(word + "`");
}

void checkAnswer() {
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


void disconnectEvent(Client someClient) {
  g.wait(3000, "Client " + someClient.ip() + " disconnected");
}