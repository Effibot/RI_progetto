import processing.svg.*; //<>// //<>//
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;
import java.util.Arrays.*;
UDPconnect udp;
float obsTarget=1;
ArrayList<String> params;
String TXaddr="127.0.0.1";
String RXaddr="127.0.0.1";
int TXport =12345;
int RXport = 12346;
  ArrayList<Object> a=new ArrayList<>();
String val="";
String str;
float[] simulValues= new float[1];
////////////////////////////////////TRE DOF
// definisco dimensioni link
int L1 = 80;
int L2 = 100;
int L3 = 80;
int larg = 50;
int ray = 50;
// variabili del robot phantom
color rgb = color(255,0,0,100);
float q1 = 0.0;
float q2 = 0.0;
float q3 = 0.0;
// le variabili del robot effettivo.
color rgbV = color(0,255,0,100);
float q1v = 0.0;
float q2v = 0.0;
float q3v = 0.0;
float[] eq= {q1v,q2v,q3v};
//Path Planning
float[] mapSize={1024,1024};
float robotSize=48;
List<List<Float>> obsList=List.of(
List.of(805.0,  844.0,  180.0),
List.of(264.0,  280.0,  132.0),
List.of(440.0,  636.0,  191.0),
List.of(673.0,  788.0,  236.0),
List.of(792.0,  792.0,  232.0),
List.of(818.0,  656.0,  206.0),
List.of(574.0,  911.0,  9.03),
List.of(689.0,  493.0,  222.0),
List.of(737.0,  779.0,  208.0),
List.of(633.0,  862.0,  162.0));
// guadagno della legge di controllo proporzionale
float K = 0.05;

// posizione desiderata per cinematica inversa
float x = 0.0;
float y = L1 + L2 + L3;

// controllo del gomito
float g = 1.0; // gomito

// posizione del polso del tre dof
float xh = 0.0;
float yh  = 0.0;
color target_color = color(255,0);




// orientamento desiderato
float phi = 0.0;
//////////////////////////////////////////////////////
void setup(){
  size(800, 800);    
  background(#546e7a); 

  udp = UDPconnect.getInstance();
  udp.setTX_parameters(TXaddr,TXport);
  udp.setRX_parameters(RXaddr,RXport);
  params=udp.getParameters();  
  udp.openConnection();
}
void draw(){
    background(#546e7a);
  pushMatrix(); // salvo s.d.r.
  
  translate(width / 2, height / 2);   // traslo
  
  opSpace(L1, L2, L3); // disegno limite dello spazio operativo
  target(ray);
  
  treDoF(ray, L1, L2, L3, larg, q1, q2, q3, rgb); // disegno robot phantom.
  popMatrix(); // elimino s.d.r.
  q1v=udp.giunti[0];
  q2v=udp.giunti[1];
  q3v=udp.giunti[2];
  //controllo(1,K,q1,q2,q3,q1v,q2v,q3v);   // inserisco legge di controllo
  pushMatrix(); // risalvo s.d.r.
  translate(width / 2 , height / 2);   // traslo
  treDoF(ray, L1, L2, L3, larg, q1v, q2v, q3v, rgbV); // disegno robot vero.
  popMatrix(); // elimino s.d.r.
 
  fill(255);
  if (target_color == rgb) 
    text("Punto non raggiungibile o orientamento \nnon ammissibile. Selezionare un nuovo punto.", width / 2 - 50, 30);
  
}

 //<>// //<>// //<>//
float[] getFloats(List<Float> values) {
    int length = values.size();
    float[] result = new float[length];
    for (int i = 0; i < length; i++) {
      result[i] = values.get(i).floatValue();
    }
    return result;
  }
 //<>//

void treDoF(int ray, int L1, int L2, int L3, int larg, float q1, float q2, float q3, color rgb) {
  rotate(q1);
  link(ray,L1,larg,rgb);
  translate(0 ,L1);
  rotate(q2);
  link(ray,L2,larg,rgb);
  translate(0, L2);
  rotate(q3);
  link(ray,L3,larg,rgb);
}

void link(int R, int lung, int larg, color rgb) {
  fill(rgb);
  circle(0,0,R);
  rect(- R / 2, 0, larg, lung);
  circle(0, lung, R);
}



void opSpace(int r1, int r2, int r3) {
  fill(255);
  circle(0,0, 2 * (r1 + r2 + r3));  // devo moltiplicare per due perché per circle() il terzo parametro è il raggio.
}

void target(int R) {
  pushMatrix();
  translate(x, y);
  fill(target_color);
  circle(0,0, R + 30); 
  popMatrix();
}
// definisco legge di controllo
void controllo(float... params) {
  List<Float> data= new ArrayList<Float>();
  for(float i:params){
    data.add(i);
  }
  udp.sendData(getFloats(data));
  
}
void visione(float... params) {
  List<Float> data= new ArrayList<Float>();
  for(float i:params){
    data.add(i);
  }
  while(udp.bc==new float[2]){}
  udp.sendData(getFloats(data));
}

void pathPlanning(float proc, float mapSizeX,float mapSizeY,float robotSize,List<List<Float>> obs){//3,mapSize[1],mapSize[2],robotSize,obsList
  List<Float> data = new ArrayList<>();
  List<Float> flat = 
    obs.stream()
        .flatMap(List::stream)
        .collect(Collectors.toList());
  data.add(proc);
  data.add(mapSizeX);
  data.add(mapSizeY);
  data.add(robotSize);
  flat.forEach((x) -> data.add(x));
  udp.sendData(getFloats(data));
}

void mousePressed() {
  x = mouseX - width / 2;
  y = mouseY - height / 2;
  cinInv();
  //controllo(1,K,q1,q2,q3,q1v,q2v,q3v);
}
void keyPressed(){
  if(keyCode=='1'){
  controllo(1,K,q1,q2,q3,q1v,q2v,q3v);
  }
  if(keyCode=='2'){
    visione(2,x,y,obsTarget);
  }
  if(keyCode=='3'){
    pathPlanning(3,mapSize[0],mapSize[1],robotSize,obsList);
  }
}

/////////////////CINEMATICA INVERSA //////////////////////
// Variabili per la cinematica inversa
float A = 0.0;
float c2 = 0.0;
float s2 = 0.0;
float b1 = 0.0;
float b2 = 0.0;
float c1 = 0.0;
float s1 = 0.0;
float c3 = 0.0;
float s3 = 0.0;
void cinInv() {
  xh = x - cos(phi) * L3;
  yh = y - sin(phi) * L3;
  // inserisco controllo per determinare se sto violando lo spazio operativo
  if (xh * xh + yh * yh <= pow(L1 + L2,2) &&
    xh * xh + yh * yh >= pow(L1 - L2,2)) {
    target_color = rgbV;
  } else {
    target_color = rgb;
  }
  A = (xh * xh + yh * yh - L1 * L1 - L2 * L2) / (2 * L1 * L2);
  c2 = A;
  s2 = g * sqrt(abs(1 - A * A));
  b1 = L1 + c2 * L2;
  b2 = L2 * s2;
  c1 = b1 * xh + b2 * yh;
  s1 = - b2 * xh + b1 * yh;
  q1 = atan2(s1, c1) - PI / 2;
  q2 = atan2(s2, c2);
  q3 = phi - q1 - q2 - PI / 2;
  
  // println("q1 =" + q1 + "\tq2=" + q2 + "\tq3=" + q3);
}
