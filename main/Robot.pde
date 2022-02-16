import java.util.ArrayList;
public class Robot{
    private Robot instance = null;
    PShape rover;
    ArrayList<PShape> link = new ArrayList<PShape>();
    String path = "models/";
    //String rover = "rover.obj";
    ArrayList<String> linkList = new ArrayList<String>();
    Float scaleFactor = 0.2;
    //misure in mm
    float roverH = 50;  // altezza rover
    float roverW = 12;  // altezza ruote rover
    float roverD = 220; // diametro rover
    float link1H = 192; // altezza link 1
    float link1C = 103; // distanza centro link 1 da base
    float link1R = 40;  // raggio cilindro link 1
    float link2B = 172; // distanza baricentro link 2 da baricentro 1
    float link2R2 = 48.43;  // raggio circonferanza alta link2
    float link2H = 245;    // altezza centro circ 2 link 2 da 
    float link2C2R = 35;    // raggio circ 2 link 2
    float link3C = 46;  // distanza baricentro link 3 da circ 2 link 2
    float link3align = -3;   // alignement orizzontale per link 3
    float link4C = 60;  // distanza circ link 4 da baricentro 4
    float link4BX = 211;   // baricentro link 4 da baricentro link 3
    float link4BY = 31; // baricentro link 4 da baricentro link 3
    float link5C = 2;   // distanza da baricentro 4 circonferenza link 5
    float link5BX = 71;  // distanza da baricentro 4 del baricentro 5
    float link5BY = -10;   // distanza da baricentro 4 del baricentro 5
    
    private Robot() {
        // Carico tutte istanze dei link
        for (int i = 0; i <= 6; i++) { 
            link.add(loadLink(path + "Link" + i + ".obj"));
        }
    }
    
    public Robot getInstance() {
        if (this.instance == null) {
            this.instance = new Robot();
        }
        return this.instance;
    }
    
    
    private PShape loadLink(String objectName) {
        PShape shape = loadShape(objectName);
        shape.scale(scaleFactor);
        return shape;
    }
    
    public void drawLink(Robot robot) {
        //translate(0, -floorHeight / 2 + scale(roverH / 2 + roverW),0);
        for (int i = 0; i < robot.link.size(); i++) {
            PShape link = robot.link.get(i);
            switch(i) {
                case 0 : // rover
                    show_axes(true);
                    pushMatrix();
                    rotateX( -PI / 2);
                    rotateZ(PI / 2);                    
                    shape(link);
                    popMatrix();
                    break;
                // link i-esimo
                case 1:
                    pushMatrix();
                    translate(0,scale(roverH / 2 + link1H / 2),0);
                    fill(155);
                    rotateY(theta1);
                    show_axes(true);                    
                    shape(link);
                    break;
                case 2 : 
                    pushMatrix();
                    translate(0,scale(link1R),0);
                    rotateZ(theta2);
                    link.setFill(color(255, 255,0));
                    translate(0,scale(link2B - link1R),0);
                    show_axes(true);                    
                    shape(link);                    
                    break;
                case 3:
                    pushMatrix();
                    translate(0,scale(link2H - 2 * link2R2),0);
                    rotateZ(theta3);
                    translate(scale(link2C2R),scale(link3C),scale(link3align));
                    link.setFill(color(0, 255, 255));
                    show_axes(true);                    
                    shape(link);
                    break;
                case 4:
                    pushMatrix();
                    translate(scale(link4BX),scale(link4BY),0);
                    rotateX(theta4);
                    show_axes(true);
                    link.setFill(color(160,45,90));
                    show_axes(true);                    
                    shape(link);                   
                    break;
                case 5:
                    pushMatrix();                
                    translate(scale(link4C),scale(link5BY),0);
                    rotateZ(theta5);
                    show_axes(true);
                    translate(scale( -link5C),0,0);
                    link.setFill(color(100,200,255));
                    show_axes(true);                    
                    shape(link);                    
                    break;
                case 6:
                    pushMatrix();
                    translate(scale(link5BX),0,0);                    
                    rotateY(PI / 2);
                    show_axes(true);
                    rotateX(theta6);
                    link.setFill(color(255,200,100));
                    shape(link);
                    popMatrix();
                    popMatrix();
                    popMatrix();
                    popMatrix();
                    popMatrix();
                    popMatrix();
                    break;
                default:
                break;
            }
        }
    }
    
    private float scale(float z) {
        // z : 100 = zz : 20
        return z * scaleFactor;
    }
    private float Conversion(float centi) {
        float pixels = (96 * centi) / 2.54;
        return pixels;
    }
}
