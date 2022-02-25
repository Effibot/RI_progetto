import java.util.ArrayList;
/*Global camera settings*/
float fov = PI / 4.0;
float cameraZ = (height / 2.0) / tan(fov / 2.0);
/*Global room settings*/
float floorWidth = 800;
float floorHeight = 800;
float floorDepth = 5;
float angoloX=0;
float angoloY=0;
float angoloXp=0;
float angoloYp=0;

float targetR = 20;

ArrayList<Obstacle> obsList = new ArrayList<Obstacle>();

void camera_setup() {
    //perspective(fov, float(width) / float(height),cameraZ / 10.0, cameraZ * 10.0);
    camera(width / 2.0, height / 4.0, (height / 2.0) / tan(PI * 30.0 / 180.0) + 50, width / 2.0, height / 2.0, 0, 0, 1, 0);
    translate(width / 2, height / 2, 0);
    rotateY(-PI / 4);
    directionalLight(126, 126, 126, 0, 0, 1);
    ambientLight(200, 200, 200);
    rotateY(-angoloY);
    rotateX(angoloX);
}

/*Simple functions to render axis on the screen*/
        float opacity = 255;

void show_axes(boolean b) {
    if (b) {
    stroke(255, 0, 0, opacity);
    line(0, 0, 0, 100, 0, 0);
    fill(255, 0, 0, opacity);    
    text("X", 100, 10, 0);
    /*stroke(0, 255, 0, opacity);
    line(0, 0, 0, 0, 100, 0);
    text("Y", 10, 100, 0);*/
    stroke(0, 0, 255, opacity);
    line(0, 0, 0, 0, 0, 100);
    fill(0,0,255, opacity);
    text("Z", 0, 10, 100);
    fill(0);
    sphere(5);
    }
}

/*Function to render the room*/
void room() {
    rotateX(PI/2);
    rotateZ(PI/2);    
    /*Floor*/
    pushMatrix();
    translate(0, 0, -floorHeight/2);
    fill(255);
    box(floorWidth, floorHeight, floorDepth);
    /*Left wall*/
    pushMatrix();
    translate(floorDepth/2, (floorWidth-floorDepth)/2, (floorWidth+floorDepth)/2);
    fill(255);
    box(floorWidth - floorDepth, floorDepth, floorHeight);
    popMatrix();
    /*Right wall*/
    pushMatrix();
    translate(-(floorWidth - floorDepth)/2, -floorDepth/2,(floorWidth + floorDepth)/2);
    fill(255);
    box(floorDepth, floorWidth - floorDepth, floorHeight);
    popMatrix();
    popMatrix();

    translate(floorWidth/2,floorWidth/2-floorDepth/2,-floorHeight/2+floorDepth/2+(25+14)*0.2);
    show_axes(true);

}
float border = 20;
void roomSetup() {
    pushMatrix();
    translate(floorWidth/2+border,floorWidth/2+border,0);
    fill(155);
    box(floorWidth, floorHeight, floorDepth);
    target();
    
    popMatrix();
}
void mousePressed() {
angoloYp=angoloY+PI*mouseX/10000.0;
angoloXp=angoloX+PI*radians(mouseY/10000.0);
objList.add(new Obstacle(targetX, targetY, 0.0, targetR, 0, 1.0));
}


    float targetX;
    float targetY;
void target(){
    targetX = mouseX - floorWidth/2;
    targetY = mouseY - floorHeight/2;
    pushMatrix();
    translate(targetX,targetY,floorDepth+1);
    targetColorSelect(targetAlpha);
    fill(targetColor);
    noStroke();
    cylinder(targetX,targetY,0,targetR,0.0,1.1,30);
    popMatrix();
}
color targetColor;
float targetAlpha = 80;
void targetColorSelect(float targetAlpha){
    
    if ((targetX < floorWidth/2 - targetR) && (targetX > targetR  - floorWidth/2) &&
     (targetY < floorHeight/2 - targetR) && (targetY > targetR - floorHeight/2)) {
        targetColor =  color(0,255,0,targetAlpha);
    } else {
        targetColor =  color(255,0,0,targetAlpha);
    }
}

void mouseDragged() {
angoloY=angoloY+PI*mouseX/10000.0;
angoloX=angoloX+PI*radians(mouseY/10000.0);
}
void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  fov += e/abs(e)*radians(0.5);
}

void cylinder(float xc, float yc, float zc, float bottom, float top, float h, int sides)
{

  pushMatrix();
  rotateX(PI/2);
  //translate(xc,yc,zc);
  translate(0,h/2,0);
  
  float angle;
  float[] x = new float[sides+1];
  float[] z = new float[sides+1];
  
  float[] x2 = new float[sides+1];
  float[] z2 = new float[sides+1];
 
  //get the x and z position on a circle for all the sides
  for(int i=0; i < x.length; i++){
    angle = TWO_PI / (sides) * i;
    x[i] = sin(angle) * bottom;
    z[i] = cos(angle) * bottom;
  }
  
  for(int i=0; i < x.length; i++){
    angle = TWO_PI / (sides) * i;
    x2[i] = sin(angle) * top;
    z2[i] = cos(angle) * top;
  }
 
  //draw the bottom of the cylinder
  beginShape(TRIANGLE_FAN);
 
  vertex(0,   -h/2,    0);
 
  for(int i=0; i < x.length; i++){
    vertex(x[i], -h/2, z[i]);
  }
 
  endShape();
 
  //draw the center of the cylinder
  beginShape(QUAD_STRIP); 
 
  for(int i=0; i < x.length; i++){
    vertex(x[i], -h/2, z[i]);
    vertex(x2[i], h/2, z2[i]);
  }
 
  endShape();
 
  //draw the top of the cylinder
  beginShape(TRIANGLE_FAN); 
 
  vertex(0,   h/2,    0);
 
  for(int i=0; i < x.length; i++){
    vertex(x2[i], h/2, z2[i]);
  }
 
  endShape();
  
  popMatrix();
}

