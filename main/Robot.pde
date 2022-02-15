import java.util.ArrayList;
public class Robot{
/** Robot Size
rover: 180, 62
link 1: 180, 192
*/




private Robot instance = null;
PShape rover;
ArrayList<PShape> link = new ArrayList<PShape>();
String path = "models/";
//String rover = "rover.obj";
ArrayList<String> linkList = new ArrayList<String>();
Float scaleFactor = 0.2;
//misure in mm
float roverH = 50;
float roverW = 12;
float roverD = 220;
float link1H = 192;
float link1D = 215;
float link1C = 103;
float link1R = 40;
float link2H = 390;
float link2D = 186;
float link2B = 172;


private Robot(){
    // Carico tutte istanze dei link
    for (int i = 0; i < 6; i++) { 
        link.add(loadLink(path+"Link"+i+".obj"));
    }

    //link.add(loadLink(objectName));
}

public Robot getInstance() {
    if (this.instance == null){
        this.instance = new Robot();
    }
    return this.instance;
}


private PShape loadLink(String objectName){
    PShape shape = loadShape(objectName);
    shape.scale(scaleFactor);
    return shape;
}

public void drawLink(Robot robot){
    //translate(0,-floorHeight/2+scale(roverH/2+roverW),0);
    for (int i = 0; i < robot.link.size(); i++) {
        PShape link = robot.link.get(i);
        

        switch (i) {
            case 0: // rover
                pushMatrix();
                rotateX(-PI/2);
                rotateZ(PI/2);
                shape(link);
                popMatrix();
            break;
            // link i-esimo
            case 1:
                pushMatrix();
                translate(0,scale(roverH/2+link1H/2),0);
                fill(155);
                rotateY(theta1);
                shape(link);
            break;
            case 2: 
                pushMatrix();
                translate(0,scale(link1R),0);
                rotateZ(theta2);
                show_axes(true);
                //fill(0,255,0);
                translate(0,scale(link2B-link1R),0);
                shape(link);
                popMatrix();
                popMatrix();

            break;
            case 3:
            break;
            case 4:
            break;
            case 5:
            break;
            case 6:
            break;
            default:
            break;
        }
    }
}

private float scale(float z){
    // z : 100 = zz : 20
    return z*scaleFactor;
}
private float Conversion(float centi) {
    float pixels = (96 * centi) / 2.54;
    return pixels;
}
}
