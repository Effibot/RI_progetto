/*Global camera settings*/
float fov = PI / 4.0;
float cameraZ = (height / 2.0) / tan(fov / 2.0);
/*Global room settings*/
float floorWidth = 400;
float floorHeight = 400;
float floorDepth = 5;


void camera_setup() {
    perspective(fov, float(width) / float(height),cameraZ / 10.0, cameraZ * 10.0);
    camera(width / 2.0, height / 4.0, (height / 2.0) / tan(PI * 30.0 / 180.0) + 50, width / 2.0, height / 2.0, 0, 0, 1, 0);
    translate(width / 2, height / 2, 0);
    rotateX(PI);
    rotateY(3 * PI / 4);
}

/*Simple functions to render axis on the screen*/
void show_axes(boolean b) {
    float opacity = b ? 255 : 0;
    stroke(255, 0, 0, opacity);
    line(0, 0, 0, 100, 0, 0);    
    text("X", 100, 10,0);
    stroke(0, 255, 0, opacity);
    line(0, 0, 0, 0, 100, 0);
    text("Y", 10, 100, 0);
    stroke(0, 0, 255, opacity);
    text("Z", 0, 10, 100);
    line(0, 0, 0, 0, 0, 100);
}

/*Function to render the room*/
void room() {
    /*Floor*/
    pushMatrix();
    translate(0, -height/5, 0);
    fill(255,0,0);
    box(floorWidth, floorDepth, floorHeight);
    /*Left wall*/
    pushMatrix();
    translate(floorDepth/2, (floorWidth+floorDepth)/2, -(floorWidth - floorDepth)/2);
    fill(255);
    box(floorWidth - floorDepth, floorHeight, floorDepth);
    popMatrix();
    /*Right wall*/
    pushMatrix();
    translate(-(floorWidth - floorDepth)/2, (floorWidth + floorDepth)/2, floorDepth/2);
    fill(255);
    box(floorDepth, floorHeight, floorWidth - floorDepth);
    popMatrix();
    popMatrix();
}