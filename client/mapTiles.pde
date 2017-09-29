ArrayList<Tile> tiles;
class Tile {
  int x, y, id, layer;
  public Tile(int id_, int layer_, int x_, int y_) {  
    id = id_;
    layer = layer_;
    x = x_;
    y = y_;
  } 
  void draw() { 
    if (layer!=0) {
      image(tile[10], x, y, 32, 32);
    }
    image(tile[id], x, y, 32, 32);
    textAlign(CENTER, CENTER);
    if (showId==true)text(id, x+16, y+16);
  }
}