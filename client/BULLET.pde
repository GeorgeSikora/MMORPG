ArrayList<Bullet> bullets;
class Bullet {
  PVector pozice= new PVector(0, 0);
  PVector rychlost= new PVector(0, 0);
  PVector Ppozice= new PVector(0, 0);
  PVector cil;
  float rotace;    
  public Bullet(float r_,PVector cil_) {
    rotace=r_;
    pozice = new PVector(myX, myY);
    Ppozice.set(pozice);
    rychlost = new PVector(0, 0);
    cil= cil_;
  } 

  void update() {
  PVector cil=PVector.fromAngle(rotace);
    rychlost.set(cil);
    rychlost.mult(15);
    rychlost.limit(20); 
    pozice.add(rychlost);       // k pozici se přičte rychlost
  }

  void render() { 
    //if (pozice.x > 0 && pozice.x < map[0] && pozice.y > 0 && pozice.y < map[1]) {
    //} else {
      //bullets.remove(i);
    //}
    //pozice.x, pozice.y;
    fill(255,0,0);
    //TEST//    ellipse(pozice.x, pozice.y,10,10);
    pushMatrix();
    translate(pozice.x, pozice.y);     //posunutí na pozici
    rotate(rotace);                                            //rotace
    fill(0);
    ellipse(0, 0,10,10); 
    popMatrix();
  }
}