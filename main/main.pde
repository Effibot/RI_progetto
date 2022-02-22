/*Global variables for window configuration*/
PShape s1,s2,s3,s4,s5,s6;
int viewWidth = 1000; 
int viewHeight = 1000;
color bgColor = color(0,0,0);
Robot robot;

float alpha = 0;
float beta = 0;
float gamma = 0;

float q1 = 0;
float q2 = 0;
float q3 = 0;
float q4 = 0;
float q5 = 0;
float q6 = 0;
float x = 0;
void settings() {
/*Sketch view setup*/
size(viewWidth, viewHeight, P3D);
}

void setup() {
background(bgColor);
noFill();

/*Shapes loading*/
/*s1 = loadShape("models/Link4.obj");
s1.scale(0.2);
s2 = loadShape("models/Link5.obj");
s2.scale(0.2);
s3=loadShape("models/Link1.obj");
s3.scale(0.2);
s4=loadShape("models/rover.obj");
s4.scale(0.2);*/
robot = new Robot();
//s5 = robot.loadShape("rover.obj");
}

void draw() {
/*Background init*/
background(bgColor);
/*Loading Camera settings*/
camera_setup();
/*Initialize the world*/
//rotateY(PI/4);
room();
//show_axes(false);

fill(166);
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
robot.drawLink(robot);
/*applyMatrix(cos(q1),0.0,-sin(q1),0.0,
             sin(q1),0.0,cos(q1),0.0,
             0.0,-1.0,0.0,robot.scale(robot.roverH / 2 + robot.link1H / 2),
             0.0,0.0,0.0,1.0);*/
     
}


void keyPressed() {
    if (keyCode == LEFT){
        angoloY -= radians(5);
    }
        if (keyCode == RIGHT){
        angoloY += radians(5);
    }
    if (keyCode == DOWN){
        angoloX -= radians(5);
    }
        if (keyCode == UP){
        angoloX += radians(5);
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
    q4 += radians(2);
}
if (keyCode == '5') {
    q5 += radians(2);
}
if (keyCode == '6') {
    q6 += radians(2);
}
if (keyCode == 'X') {
    x = x+1;
}
if (keyCode == 'R'){
    q1 = 0;
    q2 = 0;
    q3 = 0;
    q4 = 0;
    q5 = 0;
    q6 = 0;
    x = 0;
}
}
