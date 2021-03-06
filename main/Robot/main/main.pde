import controlP5.*; //<>//
import controlP5.Button;
ControlP5 cp5;

int myColor = color(0);


void setup() {
  size(400,600);
  cp5 = new ControlP5(this);
  
  // replace the default controlP5 button with an image.
  // button.setImages(defaultImage, rolloverImage, pressedImage);
  // use button.updateSize() to adjust the size of the button and 
  // resize to the dimensions of the defaultImage
  cp5.addButton("ButtonA")
     .setPosition(175,275)
     .setImages(loadImage("button.png"),loadImage("button2.png"),loadImage("buttonov.png"))
     .addTextlabel("DIOCANW")
     .updateSize();
     cp5.get("ButtonA").setLabel("TORNAMBETROIA");
}

void draw() {
  background(myColor);
}

public void controlEvent(ControlEvent theEvent) {
  println(theEvent.getController().getName());
  
}

// function buttonA will receive changes from 
// controller with name buttonA
public void buttonA(int theValue) {
  println("a button event from buttonA: "+theValue);
  myColor = color(128);
}
