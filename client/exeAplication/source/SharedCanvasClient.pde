import processing.net.*;

Client c;
String input;
int data[];
int roro;
void setup() 
{
  roro = int(random(0,255));
  size(450, 255);
  background(204);
  stroke(0);
  frameRate(5);
  // Connect to the server's IP address and port
  c = new Client(this,"0.tcp.ngrok.io", 16496); // Replace with your server's IP and port
}

void keyPressed(){
 if(key=='+' && roro < 255 ) roro++;
 if(key=='-' && roro > 0   ) roro--;
}

void draw() 
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
    data = int(split(input, ' ')); // Split values into an array
    // Draw line using received coords
    stroke(data[4],155,155);
    line(data[0], data[1], data[2], data[3]);
  }
  fill(199);
  rect(40,35,35,20);
  fill(0);
  text(roro,50,50);
}