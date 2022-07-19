

import g4p_controls.*;
import java.awt.*;
/*Global variables for window configuration*/
PShape s1, s2, s3, s4, s5, s6;
int viewWidth = 800;
int viewHeight = 600;
color bgColor = color(0, 0, 0);
//Robot robot;
RobotNew robotN;
float zoom=0;
float xDes=0.0;
float yDes = 0.0;
float zDes = 0.0;

final static ArrayList<Obstacle> obsList = new ArrayList<Obstacle>();

float alpha = 0;
float beta = 0;
float gamma = 0;

float q1 = 0;
float q2 = 0;
float q3 = PI/2;
float q4 = 0;
float q5 = 0.1;
float q6 = 0;

Obstacle obs;
boolean  play = true;
float ddx=0.0;
float x = 20;
float y = 20;
void settings() {
  /*Sketch view setup*/
  size(viewWidth, viewHeight, P3D);
}

void setup() {
  background(bgColor);
  surface.setLocation(100, 100);
  surface.setResizable(true);
  noFill();
  createGUI();
  panel1.setFont(new Font("Monospaced", Font.PLAIN, 15));

  label1.setFont(new Font("Monospaced", Font.PLAIN, 20));
  label2.setFont(new Font("Monospaced", Font.PLAIN, 20));
  label3.setFont(new Font("Monospaced", Font.PLAIN, 20));
  label4.setFont(new Font("Monospaced", Font.PLAIN, 20));
  start_btn.setFont(new Font("Monospaced", Font.PLAIN, 20));


  /*Shapes loading*/
  /*s1 = loadShape("models/Link4.obj");-
   
   s1.scale(0.2);
   s2 = loadShape("models/Link5.obj");
   s2.scale(0.2);
   s3=loadShape("models/Link1.obj");
   s3.scale(0.2);
   s4=loadShape("models/rover.obj");
   s4.scale(0.2);*/
  //robot = new Robot();
  robotN = new RobotNew();
  //s5 = robot.loadShape("rover.obj");
}
float xh, yh, zh;
void draw() {
  /*Background init*/
  background(bgColor);
  scale(zoom);
  /*Loading Camera settings*/
  /*Initialize the world*/
  //rotateY(PI/4);
  //translate(x,0,0);
  //translate(0,y,0);

  if (play) {
    panel1.setVisible(false);
    camera_setup();
    room();
    pushMatrix();
    translate(xDes, yDes, zDes);
    noStroke();
    lights();
    //sphere(5);
    popMatrix();
    //robot.drawLink(robot,x,y);


    pushMatrix();
    robotN.setPos(x, y);
    robotN.drawLink(x, y);
    show_axes(true);
    pushMatrix();
    float[] drv=robotN.dr(q1, q2, q3, q4, q5, q6);
    // drv[0],drv[1],drv[2]t
    pushMatrix();

    translate(xDes, yDes, zDes);
    box(10, 10, 10);
    popMatrix();
    float[] qq=robotN.newton(xDes, yDes, zDes);

    float[] drvv=robotN.dr(qq[0], qq[1], qq[2], qq[3], qq[4], qq[5]);
    translate(drvv[0], drvv[1], drvv[2]);


    box(10, 10, 10);

    show_axes(true);

    popMatrix();
    popMatrix();
    panel1.setCollapsed(true);
  } else {
    roomSetup();
  }
  /*camera_setup();
   room();*/


  //show_axes(false);


  /*rotateY(gamma);
   rotateX(alpha);
   rotateZ(beta);*/
  //shape(s1);
  //shape(s4);
  /*pushMatrix();
   translate(0,18.5,0);
   rotateZ(beta);
   translate(0,42.5-18.5,0);
   //pushMatrix();
   //rotateZ(beta);
   shape(s2);
   //translate(0,-18.5,0);
   popMatrix();*/
  //shape(robot.link.get(0));

  //
  //obs = new Obstacle(floorWidth/2, floorHeight/2,0,robot.inscript,40,8);

  /*applyMatrix(cos(q1),0.0,-sin(q1),0.0,
   sin(q1),0.0,cos(q1),0.0,
   0.0,-1.0,0.0,robot.scale(robot.roverH / 2 + robot.link1H / 2),
   0.0,0.0,0.0,1.0);*/
}


boolean b = false;

void keyPressed() {
  if (keyCode == LEFT) {
    angoloY -= radians(5);
  }
  if (keyCode == RIGHT) {
    angoloY += radians(5);
  }
  if (keyCode == DOWN) {
    angoloX -= radians(5);
  }
  if (keyCode == UP) {
    angoloX += radians(5);
  }
  if (keyCode == ENTER) {
    play = true;
  }
  if (keyCode == 'A') {
    alpha += 1;
  }
  if (keyCode == 'B') {
    beta += 1;
  }
  if (keyCode == 'C') {
    gamma += 1;
  }
  if (keyCode == '1') {
    q1 += radians(2);
  }
  if (keyCode == '2') {
    q2 += radians(2);
  }
  if (keyCode == '3') {
    q3 += radians(2);
  }
  if (keyCode == '4') {
    q4 += radians(5);
  }
  if (keyCode == '5') {
    q5 += radians(2);
  }
  if (keyCode == '6') {
    q6 += radians(2);
  }
  if (keyCode == 'X') {
    x = x+1;
    // println(x);
    //robot.setPos(x,y);
    robotN.setPos(x, y);
  }
  if (keyCode == 'Y') {
    y = y+1;
    //robot.setPos(x,y);
    robotN.setPos(x, y);

    //println(y);
  }
  if (keyCode == 'B') {
    b = b ? false : true;
  }
  if (keyCode == 'R') {
    q1 = 0;
    q2 = 0;
    q3 = PI/2;
    q4 = 0;
    q5 = 0;
    q6 = 0;
  }
  if (keyCode == 'U') {
    xDes +=4;
    println(xDes);
  }
  if (keyCode == 'T') {
    xDes -=4;
    println(xDes);
  }
  if (keyCode == 'I') {
    yDes +=4;
    println(yDes);
  }
  if (keyCode == 'K') {
    yDes -=4;
    println(yDes);
  }
  if (keyCode == 'Q') {
    zDes +=4;
    println(zDes);
  }
  if (keyCode == 'W') {
    zDes -=4;
    println(zDes);
  }
  if (keyCode == 'F') {
    kN =kN*2;
    println(kN);
  }
  if (keyCode == 'C') {
    kN = kN/2;
    println(kN);
  }
}
