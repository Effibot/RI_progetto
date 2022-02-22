import java.util.ArrayList;
UDPconnect udp;
ArrayList<String> params;
String TXaddr="127.0.0.1";
String RXaddr="127.0.0.1";
int TXport =12345;
int RXport = 12346;
  ArrayList<Object> a=new ArrayList<>();
String val="";
float q1=0;
float q2=0;
float[] eq= {q1,q2};
String str;
void setup(){
  udp = UDPconnect.getInstance();
  udp.setTX_parameters(TXaddr,TXport);
  udp.setRX_parameters(RXaddr,RXport);
  params=udp.getParameters();  
  udp.openConnection();

}
void draw(){
  
}

void keyPressed(){
  if(keyCode=='1'){
    q1=q1+1;
    eq=udp.simulate(eq);
    print(eq);

  }
  if(keyCode=='Q'){
    q1=q1-1;
    eq=udp.simulate(eq);
  print(eq);
  }
  if(keyCode=='2'){
    q2=q2+1;
    eq=udp.simulate(eq);
    print(eq);

  }
  if(keyCode=='W'){
    q2=q2-1;
    eq=udp.simulate(eq);
    print(eq);
  }
}
