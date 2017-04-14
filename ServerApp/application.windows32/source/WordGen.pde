
class WordGenerator {
  
  int difficulty = 0;
  
  public WordGenerator(int difficulty) {
    this.difficulty = difficulty;
  }
  
  String generateWord() {
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