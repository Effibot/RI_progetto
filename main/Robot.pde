import java.util.ArrayList;
public class Robot{
    private Robot instance = null;
    PShape rover;
    ArrayList<PShape> link = new ArrayList<PShape>();
    String path = "models/";
    ArrayList<String> linkList = new ArrayList<String>();
    Float[] q = new Float[6] ;
    Float scaleFactor = 0.2;
    float posX = 0.0;
    float posY = 0.0;
    float posZ = 0.0;
    ArrayList<Float> pos = new ArrayList<>(3);

    //misure in mm
    float roverH = 50;  // altezza rover
    float roverW = 20;  // altezza ruote rover
    float roverD = 220; // diametro rover
    float link1H = 185; // altezza baricentro link 1
    float link1R = 40;  // raggio cilindro link 1
    float link2B = 172; // distanza baricentro link 2 da baricentro 1
    float link2R2 = 48.43;  // raggio circonferanza alta link2
    float link2H = 245;    // altezza centro circ 2 link 2 da bc link 2
    float link2C2R = 36;    // raggio circ 2 link 2
    float link3C = 44;  // distanza baricentro link 3 da circ 2 link 2
    float link3align = 7;   // alignement orizzontale per link 3
    float link4C = 60;  // distanza circ link 4 da baricentro 4
    float link4B = 26.0;    // distanza baricentro link 4 da bc link 3
    float link4BZ = 250;  // baricentro link 4 da baricentro link 3
    float link5C = 6;   // distanza da baricentro 4 circonferenza link 5
    float link5BX = 71;  // distanza da baricentro 4 del baricentro 5
    float link6B = 72;   // distanza da baricentro 4 del baricentro 5
    // Coordinate dei sistemi di riferimento
    float baseX=0;
        float baseY=0;
            float baseZ=0;
            float Link1X =0;
            float Link1Y=0;
            float Link1Z=0;
            float Link2X =0;
            float Link2Y=0;
            float Link2Z=0;
            float Link3X =0;
            float Link3Y=0;
            float Link3Z=0;
            float Link4X =0;
            float Link4Y=0;
            float Link4Z=0;
            float Link5X =0;
            float Link5Y=0;
            float Link5Z=0;
            float Link6X =0;
            float Link6Y=0;
            float Link6Z=0;

    float inscript = scale(roverD/2+link4BZ + link5BX + link6B);
    private Robot() {
        // Carico tutte istanze dei link
        for (int i = 0; i <= 6; i++) { 
            link.add(loadLink(path + "Link" + i + ".obj"));
            if (i < 6) q[i] = 0.0;
        }
        pos.add(posX);
        pos.add(posY);
        posZ = -floorHeight/2 + scale(roverH/2+roverW);
        pos.add(posZ);
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
    private PShape loadLink(String objectName, color col) {
        PShape shape = loadLink(objectName);
        shape.setFill(col);
        return shape;
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
    public void drawLink(Robot robot, float x, float y) {
        //translate(0, 0, -floorHeight/2 + scale(roverH/2+roverW));
        for (int i = 0; i < robot.link.size(); i++) {
            PShape link = robot.link.get(i);
            switch(i) {
                case 0: // rover
                    translate(-x,-y,0);                       
                    pushMatrix();
                    /* R0 */
                    show_axes(b);   
                    rotateZ(PI / 2);         
                    //link.setFill(color(144,155,10));     
                    shape(link);
                    popMatrix();
                   
                    break;
                    // link i-esimo
                    
                case 1:
                    pushMatrix();                    
                    /* Q_01 */
                    rotateZ(q1);
                    show_axes(b);
                    // float L1 = roverH / 2 + link1H / 2 + link1R
                    translate(0,0,scale(roverH / 2 + link1H / 2 + link1R));
                    rotateX( -PI / 2);
                    
                    /*aggiungo rotazione per disegno*/
                    pushMatrix();
                    rotateX(PI);
                    translate(0,scale(-link1R),0);
                    link.setFill(color(75,90,2));
                    shape(link);
                    println(getMatrix());
                    popMatrix();
                    break;
                case 2: 
                    pushMatrix();
                    /* Q_12 */                    
                    rotateZ(q2);
                    translate(0,0,scale( -link3align));
                    show_axes(b);
                    rotateZ( -PI / 2);
                    translate(scale(link2H + link2C2R),0,0);                    
                    link.setFill(color(255, 255,0));
                    pushMatrix();
                    /* Rotazione Estetica */                    
                    rotateZ(-PI/2);
                    /* Traslazione estetica */
                    translate(0,scale(link2B - link1R - link2H - link2C2R),scale(link3align));                                    
                    shape(link);            
                    popMatrix();
                    break;
                case 3:
                    pushMatrix();
                    /* Q_23*/                     
                    rotateZ(q3+PI/2);
                    show_axes(b);    
                    rotateZ(-PI/2);
                    rotateX(-PI/2);                    
                    translate(scale(link3C+link4B),0,0);
                    link.setFill(color(0, 255, 255));                              
                    pushMatrix();                            
                    rotateY(-PI/2);
                    rotateX(-PI/2);
                    translate(scale(link2C2R),scale(-link4B),0);                  
                    shape(link);
                    popMatrix();
                    break;
                case 4:
                    pushMatrix();
                    /* Q_34 */
                    rotateZ(q4);                    
                    show_axes(b);
                    translate(0,0,scale(link4BZ + link5BX));                    
                    rotateX(PI / 2);
                    link.setFill(color(160,45,90));   
                    pushMatrix();                    
                    rotateZ(PI / 2);
                    rotateX(PI);    
                    translate(scale( -link5BX),0,0);             
                    shape(link);
                    popMatrix();                   
                    break;
                case 5:
                    pushMatrix(); 
                    /* Q_45 */               
                    rotateZ(q5);
                    show_axes(b);
                    rotateX(-PI/2);
                    pushMatrix();
                    rotateX(PI/2);
                    translate(scale(0),0,0);
                    rotateZ(PI/2);
                    link.setFill(color(100,200,255));
                    shape(link); 
                    popMatrix();                   
                    break;
                case 6:
                    pushMatrix();
                    rotateZ(q6);
                    show_axes(b);
                    translate(0,0,scale(link6B));
                    show_axes(b);

                    pushMatrix();
                    link.setFill(color(255,200,100));
                    shape(link);
                    popMatrix();
                    
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
        // z : 100 =zz : 20
        return z * scaleFactor;
    }
    private float Conversion(float centi) {
        float pixels= (96 * centi) / 2.54;
        return pixels;
    }

    public ArrayList<Float> getPos(){
        return this.pos;
    }
    public void setPos(Float newPosX, Float newPosY) {
        this.pos.set(1, newPosX);
        this.pos.set(2, newPosY);
    }
}
