// Re-creates the default perspective
float fov = PI/4.0;
float cameraZ = (height/2.0) / tan(fov/2.0);
float theta = 0;
float gamma = 0;
float beta = 0;
void setup(){
  size(800, 800, P3D);
background(0,0,0);
noFill();}
void draw(){
  background(0,0,0);

perspective(fov, float(width)/float(height), 
            cameraZ/10.0, cameraZ*10.0);
camera(width/2.0, height/2.0-200, (height/2.0) / tan(PI*30.0 / 180.0)+50, width/2.0, height/2.0, 0, 0, 1, 0);
translate(width/2, height/2, 0);
/*stroke(255, 0, 0);
    line(0, 0, 0, 100, 0, 0);    
    text("X",100,10,0);
    stroke(0, 255, 0);
    line(0, 0, 0, 0, 100, 0);
    text("Y",10,100,0);
    stroke(0, 0, 255);
    text("Z",0,10,100);
    line(0, 0, 0, 0, 0, 100);
pushMatrix();*/
//translate(20, 20, 0);
rotateX(PI);
rotateY(3*PI/4);
/*
rotateX(PI/2);
rotateY(PI/2);  
rotateX(-PI/4);
rotateZ(PI/6);

rotateX(theta);
rotateZ(gamma);*/
///////
rotateY(beta);
stroke(255, 0, 0);
    line(0, 0, 0, 100, 0, 0);    
    text("X",100,10,0);
    stroke(0, 255, 0);
    line(0, 0, 0, 0, 100, 0);
    text("Y",10,100,0);
    stroke(0, 0, 255);
    text("Z",0,10,100);
    line(0, 0, 0, 0, 0, 100);
////////
////////
    fill(255);
    pushMatrix();
    translate(0,-50,0);
    fill(255,0,0);
    box(400,5,400);//X=X,Y=Z,Z=Y
    /////////
    pushMatrix();
    translate(2.5,(200+2.5),-(200-2.5));
    fill(255);
    box(395,400,5);
    popMatrix();
    pushMatrix();
    translate(-(200-2.5),(200+2.5),2.5);
    fill(255);
    box(5,400,395);
    popMatrix();
    /////////
  popMatrix();

//popMatrix();
}
void keyPressed() {
    if (keyCode == 'A'){
        theta = theta + 5* PI / (180*5);
        println(theta);
    }    
    if (keyCode == 'B'){
        beta = beta + 20* PI / (180*5);
    }  
    if (keyCode == 'C'){
        gamma = gamma + 5* PI / (180*5);
    }  
}
