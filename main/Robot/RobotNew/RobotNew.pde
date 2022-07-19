import java.util.ArrayList;
public class RobotNew{
    PShape rover,r1,r2,r3,r4,r5,r6;
    ArrayList<PShape> link = new ArrayList<PShape>();
    String path = "models/robot_rover/";
    ArrayList<String> linkList = new ArrayList<String>();
    Float[] q = new Float[6] ;
    Float scaleFactorRover = 0.2;
      Float scaleFactorArms = 1.2;
    //misure in mm
    float roverH = 50;  // altezza rover
    float roverW = 20;  // altezza ruote rover
    float roverD = 220; // diametro rover
    float link1=40;
    float link2=62;
    float link3=0;
    float link4=60;
    float link5=0;
    float link6=12;
   float posX = 0.0;
    float posY = 0.0;
    float posZ = 0.0;
    ArrayList<Float> pos = new ArrayList<>(3);
    boolean b = true;
    private RobotNew(){
      // Carico tutte istanze dei link
        for (int i = 0; i <= 6; i++) { 
            if(i==0)
              link.add(loadLink(path + "Link" + i + ".obj",scaleFactorRover));
            else
              link.add(loadLink(path + "Link" + i + ".obj",scaleFactorArms));

            if (i < 6) q[i] = 0.0;
        }
                pos.add(posX);
        pos.add(posY);
        posZ = -floorHeight/2+scale(roverH/2+roverW);
        pos.add(posZ);
    }
  
    public void drawLink(float x, float y){
        translate(-x,-y,0);  
        
        pushMatrix();
        /* R0 */
        //show_axes(b);   
        rotateZ(PI / 2);       
        link.get(0).setFill(color(144,155,10));
        
        shape(link.get(0));
        popMatrix();
        
       
        rotateZ(q1);
        translate(0, 0,link1);
        rotateX(-PI/2);
        show_axes(b);  //Q01
        
        pushMatrix();  
        translate(0,29,0);
        rotateZ(PI);
        rotateY(-PI/2);
        link.get(1).setFill(color(125,0,0));
        shape(link.get(1));     
        popMatrix();
        
        rotateZ(q2-PI/2);
        translate(link2,0,0);
        //show_axes(b); //Q12
        pushMatrix();
        link.get(2).setFill(color(255,10,0));
        translate(-62, 0, 0);
        rotateY(PI/2);
        //show_axes(b);
        shape(link.get(2));
        popMatrix();
  
  
        rotateZ(q3);
        rotateX(-PI/2);
        //show_axes(b); //Q23
        pushMatrix();
        rotateX(PI);
        rotateZ(-PI/2);  
        link.get(3).setFill(color(0,255,0));
        shape(link.get(3));
        popMatrix();


        rotateZ(q4);
        translate(0,0,link4);
        rotateX(PI/2);
        show_axes(b); //Q34
        pushMatrix();
        translate(0,-60,0);
        rotateZ(PI/2);
        rotateY(-PI/2);
        link.get(4).setFill(color(255,0,0));
        shape(link.get(4));  
        popMatrix();
  

        rotateZ(q5);
        rotateX(-PI/2);
        pushMatrix();
        rotateZ(PI/2);
        link.get(4).setFill(color(0,255,210));
        shape(link.get(5));
        popMatrix();
  
        
        rotateZ(q6);
        translate(0,0,12);
        //show_axes(b); //Q56
        pushMatrix();
        translate(0,0,-12);
        link.get(6).setFill(color(0,255,210));
        shape(link.get(6));
        popMatrix();
          
    }
    
        public void DH(float theta, float d, float alpha, float a, boolean b){
        // Rotazione attorno all'asse Z di 'theta'
        rotateZ(radians(theta));
        show_axes(b);
        // Traslazione lungo l'asse Z di 'd'
        translate(0,0,scale(d));
        // Rotazione attorno all'asse X di 'alpha'
        rotateX(radians(alpha));
        // Traslazione lungo l'asse X di 'a'
        translate(scale(a),0,0);
    }
    
        private float scale(float z) {
        // z : 100 =zz : 20
        return z * scaleFactorRover;
    }
    
     private PShape loadLink(String objectName,float scaling) {
        PShape shape = loadShape(objectName);
        shape.scale(scaling);
        return shape;
    }

    public ArrayList<Float> getPos(){
        return this.pos;
    }
    
    public void setPos(Float newPosX, Float newPosY) {
        this.pos.set(1, newPosX);
        this.pos.set(2, newPosY);
    }
    
}
