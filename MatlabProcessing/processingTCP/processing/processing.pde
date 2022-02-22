import processing.net.*;

Server s;
Client c;
String input;
int data;
int counter=0;
void setup() {
  size(450, 255);
  background(204);
  stroke(0);
  frameRate(5); // Slow it down a little
  s = new Server(this, 12345);  // Start a simple server on a port
  print(s.ip());
}
void draw() {
  if (mousePressed == true) {
    // Draw our line
    counter=counter+1;
    // Send mouse coords to other person
    s.write(counter);
  }

  // Receive data from client
  c = s.available();
  if (c != null) {
    data = c.read(); 
    print(data);
    c.clear();
  } 
}
