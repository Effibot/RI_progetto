import java.util.ArrayList;
import java.util.List;
UDPconnect udp;
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

// guadagno della legge di controllo proporzionale
float K = 0.5;

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
  noLoop();
}
void draw(){
    background(#546e7a);
  pushMatrix(); // salvo s.d.r.
  
  translate(width / 2, height / 2);   // traslo
  
  opSpace(L1, L2, L3); // disegno limite dello spazio operativo
  target(ray);
  
  treDoF(ray, L1, L2, L3, larg, q1, q2, q3, rgb); // disegno robot phantom.
  popMatrix(); // elimino s.d.r.
  controllo(1,K,q1,q2,q3,q1v,q2v,q3v);   // inserisco legge di controllo
  pushMatrix(); // risalvo s.d.r.
  translate(width / 2 , height / 2);   // traslo
  treDoF(ray, L1, L2, L3, larg, q1v, q2v, q3v, rgbV); // disegno robot vero.
  popMatrix(); // elimino s.d.r.
 
  fill(255);
  if (target_color == rgb) 
    text("Punto non raggiungibile o orientamento \nnon ammissibile. Selezionare un nuovo punto.", width / 2 - 50, 30);
  
}

 //<>// //<>// //<>// //<>//
float[] getFloats(List<Float> values) {
    int length = values.size();
    float[] result = new float[length];
    for (int i = 0; i < length; i++) {
      result[i] = values.get(i).floatValue();
    }
    return result;
  }

float[] updateParam(float[] r,float[] eq){
  float[] newparam = new float[r.length];
  
  if(!Arrays.equals(r,new float[1])){
      println("Dato modificato"+Arrays.toString(r)); //<>//
      newparam=r; //<>//
    }else{
      newparam=eq;
    };
    /*while(Arrays.equals(r,new float[1])){
  
    }*/
    return newparam;
}
// definisco legge di controllo
void controllo(float... params) {
  List<Float> data= new ArrayList<Float>();
  for(float i:params){
    data.add(i);
  }
  eq=updateParam(udp.simulate(getFloats(data)),eq);
  q1v=eq[0];
  q2v=eq[1];
  q3v=eq[2];
}
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





void mousePressed() {
  x = mouseX - width / 2;
  y = mouseY - height / 2;
  cinInv();
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
/*
///////////// NEWTON //////////////////////
// Creo un robot phantom la cui cinematica inversa è determinata dall'algoritmo di Newton.
float q_1 = PI / 2;   // parto da PI/2 per portare il robot verso il basso come condizione iniziale
float q_2 = 0.0;
float q_3 = 0.0;
color rgbN = color(104,2,151,100);
float s_123 = 0.0;
float c_123 = 0.0;
float s_12 = 0.0;
float c_12 = 0.0;
float s_23 = 0.0;
float c_23 = 0.0;
float c_1 = 0.0;
float s_1 = 0.0;
float c_2 = 0.0;
float s_2 = 0.0;
float c_3 = 0.0;
float s_3 = 0.0;
float Q1 = 0.0;
float Q2 = 0.0;
float Q3 = 0.0;
void newton() {
  
  s_123 = sin(q_1 + q_2 + q_3);
  c_123 = cos(q_1 + q_2 + q_3);
  s_12 = sin(q_1 + q_2);
  c_12 = cos(q_1 + q_2);
  s_23 = sin(q_3 + q_2);
  c_23 = cos(q_3 + q_2);
  c_1 = cos(q_1);
  s_1 = sin(q_1);
  c_2 = cos(q_2);
  s_2 = sin(q_2);
  c_3 = cos(q_3);
  s_3 = sin(q_3);
  
  // Poiché sin(q2)=0 all'inizio, siamo già in configurazione singolare pertanto l'algoritmo non funzionerebbe
  // Devo effettuare una verifica e, in caso positivo, effettuare una saturazione ad un valore di riferimento noto.
  if (abs(s_2) < 0.01) s_2 = 0.01; // impedisco all'algoritmo di andare in singolarità.
  
  Q1 = (s_12 * (y - s_123 * L3 - s_12 * L2 - s_1 * L1)) / (s_2 * L1) + (c_12 * (x - c_123 * L3 - c_12 * L2 - c_1 * L1)) / (s_2 * L1) + (s_3 * L3 * (phi - q_3 - q_2 - q_1)) / (s_2 * L1);
  Q2 = (( - s_12 * L2 - s_1 * L1) * (y - s_123 * L3 - s_12 * L2 - s_1 * L1)) / (s_2 * L1 * L2) + (( - c_12 * L2 - c_1 * L1) * (x - c_123 * L3 - c_12 * L2 - c_1 * L1)) / (s_2 * L1 * L2) + (( - s_3 * L2 * L3 - s_23 * L1 * L3) * (phi - q_3 - q_2 - q_1)) / (s_2 * L1 * L2);
  Q3 = (s_1 * (y - s_123 * L3 - s_12 * L2 - s_1 * L1)) / (s_2 * L2) + (c_1 * (x - c_123 * L3 - c_12 * L2 - c_1 * L1)) / (s_2 * L2) + ((s_23 * L1 * L3 + s_2 * L1 * L2) * (phi - q_3 - q_2 - q_1)) / (s_2 * L1 * L2);
  // lambda/2
  float kk = 0.02;
  // implemento Newton tempo discreto
  q_1 = q_1 + kk * Q1;
  q_2 = q_2 + kk * Q2;
  q_3 = q_3 + kk * Q3;
}
/////////////// GRADIENTE //////////////////////
float q_1g = PI / 2;
float q_2g = 0.0;
float q_3g = 0.0;
color rgbG = color(0,0,255,100);
float s_123g = 0.0;
float c_123g = 0.0;
float s_12g = 0.0;
float c_12g = 0.0;
float s_23g = 0.0;
float c_23g = 0.0;
float c_1g = 0.0;
float s_1g = 0.0;
float c_2g = 0.0;
float s_2g = 0.0;
float c_3g = 0.0;
float s_3g = 0.0;
float Q1g = 0.0;
float Q2g = 0.0;
float Q3g = 0.0;
float phig = 0.0;
float kg = 0.00001;
float kPhi = 0.00000001;

void gradient() {
  s_123g = sin(q_1g + q_2g + q_3g);
  c_123g = cos(q_1g + q_2g + q_3g);
  s_12g = sin(q_1g + q_2g);
  c_12g = cos(q_1g + q_2g);
  s_23g = sin(q_3g + q_2g);
  c_23g = cos(q_3g + q_2g);
  c_1g = cos(q_1g);
  s_1g = sin(q_1g);
  c_2g = cos(q_2g);
  s_2g = sin(q_2g);
  c_3g = cos(q_3g);
  s_3g = sin(q_3g);
  
  Q1g = (c_123g * L3 + c_12g * L2 + c_1g * L1) * (y - s_123g * L3 - s_12g * L2 - s_1g * L1) + ( - s_123g * L3 - s_12g * L2 - s_1g * L1) * (x - c_123g * L3 - c_12g * L2 - c_1g * L1) + phig - q_3g - q_2g - q_1g;
  Q2g = (c_123g * L3 + c_12g * L2) * (y - s_123g * L3 - s_12g * L2 - s_1g * L1) + ( - s_123g * L3 - s_12g * L2) * (x - c_123g * L3 - c_12g * L2 - c_1g * L1) + phig - q_3g - q_2g - q_1g;
  Q3g = c_123g * L3 * (y - s_123g * L3 - s_12g * L2 - s_1g * L1) - s_123g * L3 * (x - c_123g * L3 - c_12g * L2 - c_1g * L1) + phig - q_3g - q_2g - q_1g; 
  
  
  
  phig = phig + kPhi*Q3g;

  q_1g = q_1g + kg * Q1g;
  q_2g = q_2g + kg * Q2g;
  q_3g = phig - q_1g - q_2g;
}*/
