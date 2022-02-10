/*Global variables for window configuration*/
PShape s;
int viewWidth = 800; 
int viewHeight = 800;
color bgColor = color(0,0,0);

void settings() {
    /*Sketch view setup*/
    size(viewWidth, viewHeight, P3D);
}

void setup() {
    background(bgColor);
    noFill();
    /*Shapes loading*/
    s = loadShape("models/cubo.obj");
}

void draw() {
    /*Background init*/
    background(bgColor);
    /*Loading Camera settings*/
    camera_setup();
    /*Initialize the world*/
    room();
    show_axes(true);
    
}