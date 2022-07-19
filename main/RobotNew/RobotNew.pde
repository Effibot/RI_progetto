import java.util.ArrayList;
public class RobotNew{
    private RobotNew instance = null;

    PShape rover,r1,r2,r3,r4,r5,r6;
    ArrayList<PShape> link = new ArrayList<PShape>();
    String path = "models/robot_rover";
    ArrayList<String> linkList = new ArrayList<String>();
    Float[] q = new Float[6] ;
    Float scaleFactor = 0.2;
    //misure in mm
    float roverH = 50;  // altezza rover
    float roverW = 20;  // altezza ruote rover
    float roverD = 220; // diametro rover

    private RobotNew(){
      // Carico tutte istanze dei link
        for (int i = 0; i <= 6; i++) { 
            link.add(loadLink(path + "Link" + i + ".obj"));
            if (i < 6) q[i] = 0.0;
        }
    }
  
    public void drawLink(RobotNew RobotNew, float x, float y){
        translate(-x,-y,0);                       
        pushMatrix();
        /* R0 */
        show_axes(b);   
        rotateZ(PI / 2);         
        //link.setFill(color(144,155,10));     
        shape(link);
        popMatrix();
    
    
    }
     private PShape loadLink(String objectName) {
        PShape shape = loadShape(objectName);
       // shape.scale(scaleFactor);
        return shape;
    }

    public RobotNew getInstance() {
        if (this.instance == null) {
            this.instance = new RobotNew();
        }
        return this.instance;
    }
}
