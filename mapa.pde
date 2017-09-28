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
    if(layer!=0){image(tile[10], x, y, 32, 32);}
    image(tile[id], x, y, 32, 32);
    textAlign(CENTER, CENTER);
    if(showId==true)text(id,x+16,y+16);
    //if(id==40){
      //println(x+">"+y);
    //}
  }
}

/*void nagenerovatMapu() {
  
  // ---
  // ---
  // ---
  tiles.add( new Tile(26, 10, 4*32,   3*32));
  
  tiles.add( new Tile(40, -1, 1*32,   2*32));
  tiles.add( new Tile(30, -1, 2*32,   2*32));
  tiles.add( new Tile(41, -1, 3*32,   2*32));
  tiles.add( new Tile(42, -1, 4*32,   2*32));
  
  tiles.add( new Tile(40, -1, 1*32,   1*32));
  tiles.add( new Tile(48, -1, 2*32,   1*32));
  tiles.add( new Tile(48, -1, 3*32,   1*32));
  tiles.add( new Tile(42, -1, 4*32,   1*32));
  
  tiles.add( new Tile(3, -1, 1*32,   0*32));
  tiles.add( new Tile(4, -1, 2*32,   0*32));
  tiles.add( new Tile(5, -1, 3*32,   0*32));
  tiles.add( new Tile(6, -1, 4*32,   0*32));
  
  tiles.add( new Tile(2, -1, 1*32,   -1*32));
  tiles.add( new Tile(2, -1, 2*32,   -1*32));
  tiles.add( new Tile(7, -1, 3*32,   -1*32));
  tiles.add( new Tile(7, -1, 4*32,   -1*32));
  
  tiles.add( new Tile(0, -1, 1*32,   -2*32));
  tiles.add( new Tile(1, -1, 2*32,   -2*32));
  tiles.add( new Tile(8, -1, 3*32,   -2*32));
  tiles.add( new Tile(9, -1, 4*32,   -2*32));
  
  
  
  for (int a = -250; a < 500; a++) {
    int t = 10;
    int bac;
    for (int b = -250; b < 500; b++) {
      bac = -1;
      if (t == 35) {
        t = 45;
        bac = 10;
      } else {
        t = 10;
      }
      int r = int(random(50));
      if (t!=35 && t!=45) {
        if (r == 0 || r == 1 || r == 2 || r == 3) {
          t = 35;
          bac = 10;
        }
        if(r == 4){
          t = 21;
          bac = 10;
        }
      }
      tiles.add( new Tile(t, bac, a*32, b*32));
    }
  }
}*/