import oscP5.*;
import netP5.*;
OscP5 oscP5tcpClient;
OscMessage m;
int globalMX, globalMY;  //vycentrování kurzoru myši
boolean click, chat;
int left, right, up, down;
String myName;
String input;
String myIP;
int line = 0;
String data[];
int x, y, myX = 100, myY = 100;
int id, myId = int(random(100));
StringList playerList;
boolean connect =false, serverConnect =false;
int room;
String IP;
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
float Grotation=0;
int linesLength = 0;
int selectedTile = 0;
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
  bullets = new ArrayList<Bullet>();
  //** cut the tiles **\\
  int x = 0, y = 0;
  for (int i = 0; i < tile.length; i++) {
    tile[i] = tileset.get(x*16, y*16, 16, 16);
    x++;
    if (x >= tileset.width/16) {
      x=0;
      y++;
    }
  }
}
void mouseMoved() {
  globalMX=int(camX+mouseX*0.5); //přepočet na střed kurzoru
  globalMY=int(camY+mouseY*0.5);
}
void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  if (selectedTile>0) {
    if (e ==  1) {
      selectedTile--;
    }
  }
  if (selectedTile<tile.length-1) {
    if (e == -1) {
      selectedTile++;
    }
  }
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
        IP = textboxes.get(1).Text;
        myIP = IP;
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
    //text(selectedTile,25,25);
    //image(tile[selectedTile],100,100,64,64);
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

    send(myId + " " + myX + " " + myY + " " + myName); // send my data for server
    int wievX = width/2;
    int wievY = height/2;
    for (int i = tiles.size()-1; i >= 0; i--) {
      if (tiles.get(i).x+wievX+32 >= myX && tiles.get(i).x-wievX <= myX && tiles.get(i).y+wievY+32 >= myY && tiles.get(i).y-wievY <= myY) {
        Tile tile = tiles.get(i);
        tile.draw();
        if (mousePressed) {
          if (tile.x < mouseX+myX-width/2 && tile.y < mouseY+myY-height/2 && tile.x+32 > mouseX+myX-width/2 && tile.y+32 > mouseY+myY-height/2) {
            //tiles.remove(i);
            selectedTile = tile.id;
            //tile.id = selectedTile;
          }
        }
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
    fill(20);
    rect(-width/2+3, -height/2+3,68,68);
    image(tile[selectedTile],-width/2+5, -height/2+5,64,64);
    
  /*for (i = players.size()-1; i >= 0; i--) {
   //you need a seperate var to get the object from the bullets arraylist then use that variable to call the functions
   Player player = players.get(i);
   player.update();
   player.render();
   }*/
  // ---* POHYB A NAČTENÍ HRÁČE *-- \\
  Grotation = atan2(mouseY-height/2, mouseX-width/2); //Calculate the angle btw mouse & center
    popMatrix();
    for (int i = bullets.size()-1; i >= 0; i--) {
    //you need a seperate var to get the object from the bullets arraylist then use that variable to call the functions
    Bullet bullet = bullets.get(i);
    bullet.update();
    bullet.render();
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
    println(myIP);
  }
}

void send(String message) {
  oscP5tcpClient.send(message, new Object[] {new Integer(1)});
}

void oscEvent(OscMessage theMessage) {
  input = theMessage.addrPattern();
  data = split(input, ' ');
  if (data[0].equals("m")) {
    // if (data[0].equals(myName)) {
    //} else {
    pridatInformaci(data[2]);
    //}
  }
  if (room == 1) {
    if (data.length>3) {
      boolean nasel = false; // nasel[CZ] = he groaned[EN]
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
  if (room==0 && data[1].equals(myName)) { // While my name is called..
    if (data[0].equals("x")) { // Player with myName is exist :(
      connect = false;
    }
    if (data[0].equals("a")) { // Player with myName doesnt exist :)
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
  if(room == 1 ){
  bullets.add( new Bullet(Grotation, new PVector(globalMX, globalMY)));
  }
}