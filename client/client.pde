import oscP5.*;
import netP5.*;
OscP5 oscP5tcpClient;
OscMessage m;
boolean click, chat;
int left, right, up, down; // Směr stisknuté klávesy hráče
String myName;
String input;
int line = 0;
String data[];
int x, y, myX = 100, myY = 100;
int id, myId = int(random(100));
StringList playerList;
boolean connect =false, serverConnect =false;
int room;
ArrayList<TEXTBOX> textboxes = new ArrayList<TEXTBOX>();
int speed = 2;
float camX=0, camY=0;
float  Ox1, Ox2, Oy1, Oy2;
int lookRange = 350;
PImage tileset;
PImage[] tile;
boolean goLeft = true, goRight = true, goDown = true, goUp = true;
boolean showId = false;
String chatStr = "";
boolean menu;
int linesLength = 0;
int wievX = width/2;
int wievY = height/2;

void setup() {
  frameRate(60);
  size(450, 255, P3D);
  ((PGraphicsOpenGL)g).textureSampling(3);
  noStroke(); 
  noSmooth();
  players = new ArrayList<Player>();
  tiles = new ArrayList<Tile>();
  playerList = new StringList();
  nastaveniTlacitek();
  textSize(25);
  tileset = loadImage("tiles.png");
  tile = new PImage[tileset.width/16*tileset.height/16];
  int x = 0, y = 0;
  for (int i = 0; i < tile.length; i++) {
    tile[i] = tileset.get(x*16, y*16, 16, 16);
    println(x + " & " + y);
    x++;
    if (x >= tileset.width/16) {
      x=0;
      y++;
    }
  }
  wievX = width/2;
  wievY = height/2;
}


void draw() {
  if (room == 0) {
    textAlign(BOTTOM);
    background(20);
    fill(0, 125, 125);
    text("Jméno:", 15, 85);
    text("IP:", 15, 140);
    text("Port:", 15, 190);
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
      room = 2;
      if (!serverConnect) {
        String IP = textboxes.get(1).Text;
        int PORT = int(textboxes.get(2).Text);
        oscP5tcpClient = new OscP5(this, IP, PORT, OscP5.TCP);
        serverConnect = true;
      }
      if (!connect) {
        myName = textboxes.get(0).Text;
        send("n " + myName);
        thread( "nagenerovatMapu" );
        connect = true;
      }
    }
  }
  if (room == 1) {
    background(20);
    if (!chat) {
      myX += (right - left) * speed;
      myY += (down - up) * speed;
    }
    Ox1=camX-width+myX;
    Ox2=camX+myX;
    Oy1=camY-myY;
    Oy2=camY+height-myY;
    ortho(Ox1, Ox2, Oy1, Oy2);
    send(myId + " " + myX + " " + myY + " " + myName);
    /* for (int i = tiles.size()-1; i >= 0; i--) {
     if (tiles.get(i).x+wievX+32 >= myX && tiles.get(i).x-wievX <= myX && tiles.get(i).y+wievY+32 >= myY && tiles.get(i).y-wievY <= myY) {
     Tile tile = tiles.get(i);
     tile.draw();
     }
     }*/
    /*
    noFill();
     stroke(255, 0, 0);
     rect(myX, myY, wievX*2, wievY*2);
     stroke(255, 255, 0);
     rect(myX, myY, wievX*2+64, wievY*2+64);
     */
    for (int i = tiles.size()-1; i >= 0; i--) {
      if (tiles.get(i).x+wievX+32 >= myX && tiles.get(i).x-wievX <= myX && tiles.get(i).y+wievY+32 >= myY && tiles.get(i).y-wievY <= myY) {
        Tile tile = tiles.get(i);
        tile.draw();
      }
    }
    for (int i = players.size()-1; i >= 0; i--) {
      Player player = players.get(i);
      if (myId != player.id) {
        player.draw();
      }
    }
    pushMatrix();
    translate(myX, myY);
    fill(0, 125, 125);
    noStroke(); 
    ellipse(0, 0, 20, 20);
    fill(255, 255);
    text(myName, 0, 0 - 15);

    if (chat) {
      rectMode(CORNER);
      fill(0, 125);
      rect(-width/2+4, height/2-25, 200, 24);
      textAlign(LEFT, TOP);
      fill(255);
      text(chatStr + "_", -width/2+5, height/2-25);
    }
    if (menu) {
      rectMode(BOTTOM);
      fill(0, 125);
      rect(-width/2, -height/2, width, height);
    }
    fill(255);
    vykresleniInformaci();
    popMatrix();
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

void send(String message) {
  oscP5tcpClient.send(message, new Object[] {new Integer(1)});
}

void oscEvent(OscMessage theMessage) {
  //println(theMessage.addrPattern());
  input = theMessage.addrPattern();
  data = split(input, ' ');
  if (data[0].equals("m")) {
    println(data[1]);////////
    pridatInformaci(data[1]);
  }
  if (room == 1) {
    //println(theMessage.addrPattern());
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
      x = int(data[1]);
      y = int(data[2]);
    }
    if (data[0].equals("e")) {
      for (int i = players.size()-1; i >= 0; i--) {
        Player player = players.get(i);
        if (player.id == int(data[1])) {
          players.remove(i);
        }
      }
    }
  }
  if (room==0 && data[1].equals(myName)) {
    if (data[0].equals("x")) {
      connect = false;
    }
    if (data[0].equals("a")) {
      myId = int(data[2]);
      room = 1;
      connect=true;
    }
  }
}

void keyPressed() {
  if (key==ESC) {
    key=0;
    if (menu) {
      menu = false;
    } else {
      menu = true;
    }
  }
  if (chat) {
    if ((key >= 'A' && key <= 'Z')||(key >= 'a' && key <= 'z')||key=='/'||key==' ') {
      chatStr=chatStr+key;
    }
    if (key==BACKSPACE) {
      if (chatStr.length() - 1 >= 0) {
        chatStr = chatStr.substring(0, chatStr.length() - 1);
      }
    }
  }
  if (key==ENTER) {
    if (chat) {
      if (chatStr.length()>0) {
        if (chatStr.charAt(0)=='/') {
          String command = chatStr.toLowerCase();
          if (command.equals("/help")) {
            pridatInformaci("Příkazy:");
            pridatInformaci("/op <hráč> dá hráči práva");
            pridatInformaci("/deop <hráč> odebere práva hráče");
            pridatInformaci("/exit vypne hru.");
          } else if (command.equals("/showid")) {
            if (showId) {
              showId=false;
            } else {
              showId=true;
            }
          } else
            pridatInformaci("Příkaz " + command + " neexistuje.");
        } else {
          pridatInformaci(myName + " > " + chatStr);
          println(chatStr);
          //send("m " + chatStr);
        }
      }
      chat = false;
      chatStr = "";
    } else {
      chat = true;
    }
  }
  if (goLeft) {
    if (key == 'a' || key == 'A') {
      left = 1;
    }
  }
  if (goRight) {
    if (key == 'd' || key == 'D') {
      right = 1;
    }
  }
  if (goUp) {
    if (key == 'w' || key == 'W') {
      up = 1;
    }
  }
  if (goDown) {
    if (key == 's' || key == 'S') {
      down = 1;
    }
  }
  for (TEXTBOX t : textboxes) {
    if (t.status) {
      if (t.KEYPRESSED(key, (int)keyCode)) {
      }
    }
  }
}
void keyReleased() {
  if (key == 'a' || key == 'A') {
    left = 0;
  }
  if (key == 'd' || key == 'D') {
    right = 0;
  }
  if (key == 'w' || key=='W') {
    up = 0;
  }
  if (key == 's' || key == 'S') {
    down = 0;
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

void exit() {
  send("e " + myId);
  super.exit();
}

void mousePressed() {
  for (TEXTBOX t : textboxes) {
    if (t.status) {
      t.PRESSED(mouseX, mouseY);
    }
  }
}