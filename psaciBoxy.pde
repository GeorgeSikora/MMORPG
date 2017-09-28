public class TEXTBOX {
  public int X = 0, Y = 0, H = 45, W = 220;
  public int TEXTSIZE = 24;
  public int drawSpeed = 400;
  public boolean cisla = false;
  public boolean pismena = true;
  public boolean dot = false;
  public boolean status = true;
  public int room = 0;
  public color Background = color(75);
  public color Foreground = color(0, 0, 0);
  public color BackgroundSelected = color(0, 125, 125);
  public color Border = color(0);
  public boolean BorderEnable = true;
  public int BorderWeight = 2;
  public String Text = "";
  public int TextLength = 0;
  private boolean selected = false;
  private int lastDraw;
  public boolean line;
  public boolean drawLine = true;

  TEXTBOX(int x, int y) {
    X = x; 
    Y = y;
  }
  void DRAW() {
    if (status) {
      if (selected) {
        fill(BackgroundSelected);
      } else {
        fill(Background);
      }
      if (BorderEnable) {
        strokeWeight(BorderWeight);
        stroke(Border);
      } else {
        noStroke();
      }
      textAlign(BOTTOM, CENTER);
      rectMode(CORNER); 
      rect(X, Y, W, H, 10);
      fill(Foreground);
      textSize(TEXTSIZE);


      if (selected && drawLine) {
        if (drawSpeed<=millis()-lastDraw) {
          lastDraw=millis();
          if (line) {
            line = false;
          } else {
            line = true;
          }
        }
      } else {
        line = false;
      }


      if (line && selected && drawLine) {
        text(Text + "|", X + 10, Y + TEXTSIZE);
      } else {
        text(Text, X + 10, Y + TEXTSIZE);
      }
    }
  }
  boolean KEYPRESSED(char KEY, int KEYCODE) {
    if (status) {
      if (selected) {
        if (KEYCODE == (int)BACKSPACE) {
          BACKSPACE();
        }// else if (KEYCODE == 32) {

        if (cisla) {
          boolean isKeyNumber = (KEY >= '0' && KEY <= '9');

          if (isKeyNumber) {
            addText(KEY);
          }
        }
        if (pismena) {
          if (KEYCODE == (int)ENTER) {
            return true;
          } else {
            // CHECK IF THE KEY IS A LETTER OR A NUMBER
            boolean isKeyCapitalLetter = (KEY >= 'A' && KEY <= 'Z');
            boolean isKeySmallLetter = (KEY >= 'a' && KEY <= 'z');

            if (isKeyCapitalLetter || isKeySmallLetter || KEY == '.') {
              if (dot) {
                addText(KEY);
              } else {
                if (KEY != '.') {
                  addText(KEY);
                }
              }
            }
          }
        }
      }
    }
    return false;
  }

  private void addText(char text) {
    if (status) {
      if (textWidth(Text + text) < W/1.25) {
        Text += text;
        TextLength++;
      }
    }
  }

  private void BACKSPACE() {
    if (status) {
      if (TextLength - 1 >= 0) {
        Text = Text.substring(0, TextLength - 1);
        TextLength--;
      }
    }
  }

  // FUNCTION FOR TESTING IS THE POINT
  // OVER THE TEXTBOX
  private boolean overBox(int x, int y) {
    if (status) {
      if (x >= X && x <= X + W && y >= Y && y <= Y + H) {
        return true;
      }
    }
    return false;
  }

  void PRESSED(int x, int y) {
    if (status) {
      if (overBox(x, y)) {
        selected = true;
      } else {
        selected = false;
      }
    }
  }
  boolean testVisible(int room_) {
    if (room_ == room) {
      return true;
    } else {
      return false;
    }
  }
}

void drawButtonRect(String text, int x, int y, boolean status) {
  click = false;
  tint(255);
  textSize(20);
  fill(255);
  rectMode(CENTER);
  textAlign(CENTER, CENTER);
  if (status) {
    if (mouseX>x-100/2 && mouseX <x+100/2 && mouseY>y-45/2 && mouseY <y+45/2) {
      fill(82, 191, 180);
      if (mousePressed) {
        click = true;
      }
      stroke(0, 125, 125);
      noFill();
      rect(x, y, 100+2, 45+2, 10);
    }
    fill(30);
    stroke(0);
    rect(x, y, 100, 45, 10);
    fill(0, 125, 125);
    text(text, x, y);
  } else {
    fill(10);
    stroke(0);
    rect(x, y, 100, 45, 10);
    fill(80);
    text(text, x, y);
  }
}