import oscP5.*;
import netP5.*;
OscP5 oscP5tcpServer;
NetAddress myServerAddress;
String[] data;
int zW = width, zH = height;
StringList takenId, playerList;
String input;
ArrayList<TEXTBOX> textboxes = new ArrayList<TEXTBOX>();
String[] idList = new String[999];
float camX=0, camY=0;
float  Ox1, Ox2, Oy1, Oy2;
int room;
boolean click;
int speed = 5;
int line = 0;



void setup() {
  size(450, 255, P3D);
  takenId = new StringList();
  tiles = new ArrayList<Tile>();
  playerList = new StringList();
  players = new ArrayList<Player>();
  oscP5tcpServer = new OscP5(this, 29992, OscP5.TCP);
  nastaveniTlacitek();
  cutTiles();
}

void send(String message) {
  oscP5tcpServer.send(message, new Object[] {new Integer(1)});
}
void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  if(e==1){zW+=width/100;zH+=height/100;}
  if(e==-1){zW-=width/100;zH-=height/100;}
  println(zW + " " + zH);
}
void draw() {
  background(20);
  if (room == 0) {
    for (TEXTBOX t : textboxes) {
      t.DRAW();
      if (t.testVisible(room)==true) {
        t.status = true;
      } else {
        t.status = false;
        if (t.Text!="") {
          t.TextLength = 0;
          t.Text = "";
        }
        t.selected = false;
      }
    }
    drawButtonRect("Hrát", 295, 190, true);
    if (click) {
      room=2;
      thread( "nagenerovatMapu" );
      //nagenerovatMapu();
    }
  }
  if (room == 1) {
    int myY = -int(camY);//-zH/2
    int myX = int(camX);
    int wievX = width+zW;
    int wievY = height+zH;
    for (int i = tiles.size()-1; i >= 0; i--) {
      if (tiles.get(i).x+wievX+32 >= myX && tiles.get(i).x-wievX <= myX && tiles.get(i).y+wievY+32 >= myY && tiles.get(i).y-wievY <= myY) {
        Tile tile = tiles.get(i);
        tile.draw();
        if (mousePressed) {
          if (tile.x < mouseX+myX-width/2 && tile.y < mouseY+myY-height/2 && tile.x+32 > mouseX+myX-width/2 && tile.y+32 > mouseY+myY-height/2) {
            //tiles.remove(i);
            //tile.id = selectedTile;
          }
        }
      }
    }
    if (mousePressed) {
      if (width/2-width/5 < mouseX) {
        camX+=speed;
      }
      if (width/2+width/5 > mouseX) {
        camX-=speed;
      }
      if (height/2-height/5 < mouseY) {
        camY-=speed;
      }
      if (height/2+height/5 > mouseY) {
        camY+=speed;
      }
    }
    int w = zW;
    int h = zH;
    Ox1=camX-w+0;
    Ox2=camX+w;
    Oy1=camY-h;
    Oy2=camY+h-0;
    ortho(Ox1, Ox2, Oy1, Oy2);
    fill(125);
    rectMode(CORNERS);
    //rect(-250*32,-250*32,500*32,500*32);
    for (int i = players.size()-1; i >= 0; i--) {
      Player player = players.get(i);
      player.draw();
    }
  }
  if (room==2) {
    background(20);
    rectMode(CORNER);
    float load = map(line, 0, linesLength, 0, 100);
    float loadBar = map(int(load), 0, 100, 0, width/2);
    fill(0);
    rect(width/4, height/3, width/2, 20); 
    fill(0, 125, 125);
    rect(width/4, height/3, int(loadBar), 20);
    text(int(load) + "% loading map...", width/2, height/2);
    println(load);
  }
}

void oscEvent(OscMessage theMessage) {
  send(theMessage.addrPattern());
  input = theMessage.addrPattern();
  println(theMessage.addrPattern());
  data = split(theMessage.addrPattern(), ' ');
  if (data.length>3) {
    boolean nasel = false;
    for (int i = 0; i < playerList.size(); i++) {
      if (playerList.get(i).equals(data[0])) {
        nasel = true;
      }
    }
    if (!nasel) {
      players.add( new Player(int(data[0]), int(data[1]), int(data[2]), data[3]));
      playerList.append(data[0]);
    }
    for (int i = players.size()-1; i >= 0; i--) {
      Player player = players.get(i);
      if (player.id == int(data[0])) {
        player.x = int(data[1]);
        player.y = int(data[2]);
      }
    }
  }
  if (data[0].equals("e")) {
    for (int i = players.size()-1; i >= 0; i--) {
      Player player = players.get(i);
      if (player.id == int(data[1])) {
        players.remove(i);
      }
    }
  }
  if (data[0].equals("m")) {}
  
  if (data[0].equals("n")) {
    println("!!!");
    boolean free = true;
    for (int i = 0; i<playerList.size(); i++ ) {
      if (data[1].equals(playerList.get(i))) {
        free = false;
        println("!!!!! FALSE !!!!!");
      }
    }
    if (free) {
      playerList.append(data[1]);
      int newId = int(random(1000));
      for (int i = 0; i<takenId.size(); i++ ) {
        while (newId == int(takenId.get(i))) {
          newId = int(random(1000));
          println(newId);
          i = 0;
        }
      }
      takenId.append(str(newId));
      send("a " + data[1] + " " + newId);
      println(takenId + " > " + playerList);
    } else {
      send("x " + data[1]);
      println("XXX");
    }
  }
}

void keyPressed() {
  for (TEXTBOX t : textboxes) {
    if (t.status) {
      if (t.KEYPRESSED(key, (int)keyCode)) {
      }
    }
  }
}

void nastaveniTlacitek() {
  TEXTBOX jmeno = new TEXTBOX(height/2, width/8*1);
  TEXTBOX ip = new TEXTBOX(height/2, width/8*2);
  TEXTBOX port = new TEXTBOX(height/2, width/8*3);
  jmeno.room = 0;
  ip.room = 0;
  port.room = 0;
  port.cisla=true;
  port.pismena = false;
  ip.cisla = true;
  ip.dot = true;
  ip.Text = "localhost"; //17
  port.Text = "29929"; //17
  port.TextLength = 5;
  ip.TextLength = 9;
  port.W = 90;
  textboxes.add(jmeno);
  textboxes.add(ip);
  textboxes.add(port);
}

void mousePressed() {
  for (TEXTBOX t : textboxes) {
    if (t.status) {
      t.PRESSED(mouseX, mouseY);
    }
  }
}