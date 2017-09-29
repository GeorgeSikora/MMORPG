import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.net.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class SharedCanvasClient extends PApplet {



Client c;
String input;
int data[];
int roro;
public void setup() 
{
  roro = PApplet.parseInt(random(0,255));
  
  background(204);
  stroke(0);
  frameRate(5);
  // Connect to the server's IP address and port
  c = new Client(this,"0.tcp.ngrok.io", 16496); // Replace with your server's IP and port
}

public void keyPressed(){
 if(key=='+' && roro < 255 ) roro++;
 if(key=='-' && roro > 0   ) roro--;
}

public void draw() 
{
  if (mousePressed == true) {
    // Draw our line

    // Send mouse coords to other person
    c.write(pmouseX + " " + pmouseY + " " + mouseX + " " + mouseY + " "+ roro + "\n");
  }
  // Receive data from server
  if (c.available() > 0) {
    input = c.readString();
    input = input.substring(0, input.indexOf("\n")); // Only up to the newline
    data = PApplet.parseInt(split(input, ' ')); // Split values into an array
    // Draw line using received coords
    stroke(data[4],155,155);
    line(data[0], data[1], data[2], data[3]);
  }
  fill(199);
  rect(40,35,35,20);
  fill(0);
  text(roro,50,50);
}
  public void settings() {  size(450, 255); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "SharedCanvasClient" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
