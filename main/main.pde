/*Global variables for window configuration*/
PShape s1,s2,s3,s4,s5,s6;
int viewWidth = 1000; 
int viewHeight = 1000;
color bgColor = color(0,0,0);


float alpha =0;
float beta =0;
float gamma =0;

void settings() {
    /*Sketch view setup*/
    size(viewWidth, viewHeight, P3D);
}

void setup() {
    background(bgColor);
    noFill();
    /*Shapes loading*/
    s1 = loadShape("models/Link4.obj");
    s1.scale(0.2);
    s2 = loadShape("models/Link5.obj");
    s2.scale(0.2);
    s3=loadShape("models/Link1.obj");
    s3.scale(0.2);
    s4=loadShape("models/rover.obj");
    s4.scale(0.2);
}

void draw() {
    /*Background init*/
    background(bgColor);
    /*Loading Camera settings*/
    camera_setup();
    /*Initialize the world*/
           //rotateY(PI/4);
 room();
    show_axes(true);

    fill(166);
    rotateY(gamma);
    rotateX(alpha);
    rotateZ(beta);
    //shape(s1);
    shape(s4);
    /*pushMatrix();
        translate(0,18.5,0);
    rotateZ(beta);
    translate(0,42.5-18.5,0);
    //pushMatrix();
    //rotateZ(beta);
    shape(s2);
    //translate(0,-18.5,0);
    popMatrix();*/
}
void keyPressed() {
    if (keyCode == 'A'){
        alpha +=1;
    }
    if (keyCode == 'B'){
        beta +=1;
    }
    if (keyCode == 'C'){
        gamma +=1;
    }
}
