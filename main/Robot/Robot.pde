PShape base, shoulder, upArm, loArm, r5c,r4c,r3c,r6c;
float rotX=0.0;
float rotY=0.0;
float posX=1, posY=50, posZ=50;
float alpha, beta, gamma;
float q1 = 0;
float q2 = 0;
float q3 = 0;
float q4 = 0;
float q5 = 0;
float q6 = 0;
float dx=0;
float opacity = 255;
boolean b = false;
void setup(){
  size(1200, 800, P3D);
  
  base = loadShape("r5.obj");
  shoulder = loadShape("r1.obj");
  upArm = loadShape("r2.obj");
  loArm = loadShape("r3.obj");
  r5c = loadShape("r5c.obj");
  r4c = loadShape("r4c.obj");
  r3c = loadShape("r3c.obj");
  r6c = loadShape("r6c.obj");
  shoulder.disableStyle();
  upArm.disableStyle();
  loArm.disableStyle(); 
}

void draw(){ 
  writePos();

  background(32);
  smooth();
  lights();
 
  fill(#FFE308); 
  noStroke();
 
  translate(width/2,height/2,0);
  //printMatrix();

  rotateX(rotX);
  rotateY(-rotY); 
  scale(4);
  rotateX(PI/2);

 
  translate(0,0,-40); 
  pushMatrix();
  rotateX(PI/2);
  //rectMode(CORNER);
  //rect(base.getWidth()/2,0,-base.getWidth(),-base.getHeight());
  shape(base);
  popMatrix();  
  //show_axes(b); 
 
  rotateZ(q1);
  translate(0, 0,29);
  rotateX(-PI/2);
  //show_axes(b);  //Q01
  pushMatrix();  
  translate(0,29-4,0);
  rotateZ(PI);
  rotateY(-PI/2);
  shoulder.setFill(color(125,0,0));
  shape(shoulder);     
  popMatrix();
 

  rotateZ(q2-PI/2);
  translate(50,0,0);
  //show_axes(b); //Q12
  pushMatrix();
  upArm.setFill(color(255,10,0));
  translate(-50, 0, 0);
  rotateY(PI/2);
  //show_axes(b);
  shape(upArm);
  popMatrix();
  
  
  rotateZ(q3);
  rotateX(-PI/2);
  //show_axes(b); //Q23
  pushMatrix();
  rotateX(PI);
  rotateZ(-PI/2);  
  r3c.setFill(color(0,255,0));
  shape(r3c);
  popMatrix();


  rotateZ(q4);
  translate(0,0,50);
  rotateX(PI/2);
  //show_axes(b); //Q34
  pushMatrix();
  translate(0,-50,0);
  rotateZ(PI/2);
  rotateY(-PI/2);
  r4c.setFill(color(255,0,0));
  shape(r4c);  
  popMatrix();
  
  
 
  rotateZ(q5);
  rotateX(-PI/2);
  show_axes(b); //Q45
  pushMatrix();
  rotateZ(PI/2);
  r5c.setFill(color(0,255,210));
  shape(r5c);
  popMatrix();
  
  
  rotateZ(q6);
  translate(0,0,12);
  show_axes(b); //Q56
  pushMatrix();
  translate(0,0,-12);
  r6c.setFill(color(0,255,210));
  shape(r6c);
  popMatrix();

}

void mouseDragged(){
  rotY -= (mouseX - pmouseX) * 0.01;
  rotX -= (mouseY - pmouseY) * 0.01;
}
void keyPressed(){
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
  if (keyCode == '7') {
    dx +=1;
    println(dx);
  }
   if (keyCode == 'R') {
    q1=0;
    q2=0;
    q3=0;
    q4=0;
    q5=0;
    q6=0;
  }
}
void show_axes(boolean b) {
  if (b) {
    stroke(255, 0, 0, opacity);
    
    line(0.0, 0.0, 0.0,100.0,0,0);
    fill(255, 0, 0, opacity);    
    text("X", 100, 10, 0);
    
    stroke(0, 255, 0, opacity);
    line(0, 0, 0, 0, 100, 0);
    text("Y", 10, 100, 0);
    stroke(0, 0, 255, opacity);
    line(0, 0, 0, 0, 0, 100);
    fill(0,0,255, opacity);
    text("Z", 0, 10, 100);
    fill(255);
    sphere(5);
    //noFill();
  }
}
