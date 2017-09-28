ArrayList<Player> players;
class Player {
  int x = 0, y = 0, id = 0;
  String name;
  public Player(int id_, int x_, int y_, String name_) {  
    x = x_;
    y = y_;
    id = id_;
    name = name_;
  } 
  void draw() { 
    fill(60);
    ellipse(x,y,20,20);
    fill(255);
    text(name,x,y-15);
  } 
}