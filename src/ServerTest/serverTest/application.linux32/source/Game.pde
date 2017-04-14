

class Game implements Runnable {

  Client[] c;
  int startTime;
  boolean startGame = false;
  String ans = "";

  public Game(Client[] c) {
    this.c = c;
  }

  void run() {
    startTime = millis();
    wait(3000, "Next game will begin in: ");
    startGame = true;
    wait(1000, "Math Lingo");
    mathGame();
    //mathGame();
  }

  void mathGame() {
    MathEquation m = new MathEquation();
    String eqn = m.getEqn();
    ans = eqn.substring(eqn.lastIndexOf(",")+1);
    wait(1000, eqn.substring(0, eqn.lastIndexOf(",")));
  }

  void wordGame(int difficulty) {
    if (nextGame) {
      g.wait(1000, "Typing Ninja");
      nextGame = false;
    }
    WordGenerator w = new WordGenerator(difficulty);
    String word = w.generateWord();
    ans = word;
    wait(1000, word);
  }


  void wait(int wait, String word) {
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


  String getAns() {
    return ans;
  }
}