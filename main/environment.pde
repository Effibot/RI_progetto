/*Global camera settings*/
float fov = PI / 8.0;
float cameraZ = (height / 2.0) / tan(fov / 2.0);
/*Global room settings*/
float floorWidth = 400;
float floorHeight = 400;
float floorDepth = 5;
float angoloX=0;
float angoloY=0;
float angoloXp=0;
float angoloYp=0;

void camera_setup() {
    perspective(fov, float(width) / float(height),cameraZ / 10.0, cameraZ * 10.0);
    camera(width / 2.0, height / 4.0, (height / 2.0) / tan(PI * 30.0 / 180.0) + 50, width / 2.0, height / 2.0, 0, 0, 1, 0);
    translate(width / 2, height / 2, 0);
    //rotateX(PI);
    rotateY(-PI / 4);
    directionalLight(126, 126, 126, 0, 0, 1);
    ambientLight(200, 200, 200);
  rotateY(-angoloY);
    rotateX(angoloX);
}

/*Simple functions to render axis on the screen*/
        float opacity = 255;

void show_axes(boolean b) {
    //float opacity = b ? 255 : 0;
    if (b) {
    stroke(255, 0, 0, opacity);
    line(0, 0, 0, 100, 0, 0);
    fill(255, 0, 0, opacity);    
    text("X", 100, 10, 0);
    //stroke(0, 255, 0, opacity);
    //line(0, 0, 0, 0, 100, 0);
    //text("Y", 10, 100, 0);
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
    translate(0, 0, -height/8);
    pushMatrix();
    translate(0,0,floorDepth/2+10);
    show_axes(true);
    popMatrix();
    fill(255,0,0);
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
}
void mousePressed() {
angoloYp=angoloY+PI*mouseX/10000.0;
angoloXp=angoloX+PI*radians(mouseY/10000.0);
}



void mouseDragged() {
angoloY=angoloY+PI*mouseX/10000.0;
angoloX=angoloX+PI*radians(mouseY/10000.0);
}