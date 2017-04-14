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

  void updateMessage(String m) {
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

  void ipTextField() {
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

  void nameTextField() {
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
  
  void loadPics() {
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
  
  void loadSound() {
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

  void displayImg(PImage img, int points) {
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
  
  void playSound(AudioPlayer p) {
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
  
  void displayScores(String scores) {
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
  
  void GameOverScreen() {
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

  void loadMenu() {

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
  
  void exitMainMenu() {
    background(0);
    ui.ipTextField();
    ui.nameTextField();
    mainMenu = false;
  }
}