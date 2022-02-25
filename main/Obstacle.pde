public class Obstacle{
    private float xc;
    private float yc;
    private float zc;
    private float r;
    private float h;
    private int sides = 30;

    public Obstacle(float xc, float yc, float zc, float r, float h){
        this.xc = xc;
        this.yc = yc;
        this.zc = zc;
        this.r = r;
        this.h = h;
    }
void cylinder(float xc, float yc, float zc, float bottom, float top, float h, int sides)
{

  pushMatrix();
  translate(xc,yc,zc);
  rotateX(PI/2);
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
void addObstacle(float x, float y){
    fill(255);
    translate(floorWidth/2+border,floorWidth/2+border,floorDepth+1);
    cylinder(x,y,0,this.r,this.r,this.h,this.sides);
}
  public static void drawObstacle(Obstacle obs){
    cylinder(obs.x,obs.y,0,obj.r,obs.r,obs.h,obs.sides);
  }
}
