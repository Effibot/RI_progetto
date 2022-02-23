import java.util.ArrayList;
import hypermedia.net.*;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.io.*;
import java.util.*;
public static class UDPconnect{
  private static volatile UDPconnect instance;
  private String TX_IP_Addr;
  private String RX_IP_Addr;
  private int TX_Port;
  private int RX_Port;
  public UDP udpModule;
  private ArrayList<Object> toSend;
  private String buffer;
  private String results;
  private String elem;
  
  private UDPconnect(){
    instance = this;
    String TX_IP_Addr="";
    String RX_IP_Addr="";
    int TX_Port=0;
    int RX_Port=0;
    UDP udpModule;
    String buffer;
    String results;
  }
  private void sendData(float[] toSend){
    int size=toSend.length; //<>//
    String str="[";
    for (int i=0; i<size;i++){
      if (i==size-1){
        str=str+toSend[i]+"]";
      }else{
      str = str+toSend[i]+",";
      }
    }
    println("Sending Data...");
    this.udpModule.send(str, this.RX_IP_Addr,this.RX_Port); 
    
  }

  private void EnableLog(boolean val){
    this.udpModule.log(val);
  }
  private void openConnection(){
    this.udpModule = new UDP(this,this.TX_Port,this.TX_IP_Addr);
    this.udpModule.listen(true);

  }
  private void setTX_parameters(String addr, int port){
    this.TX_IP_Addr = addr;
    this.TX_Port = port;
  }
  private void setRX_parameters(String addr, int port){
    this.RX_IP_Addr = addr;
    this.RX_Port = port;
  }
  private ArrayList<String>  getParameters(){
    ArrayList<String> info= new ArrayList<String>();
    info.add(this.TX_IP_Addr);
    info.add(this.RX_IP_Addr);
    info.add(String.valueOf(this.TX_Port));
    info.add(String.valueOf(this.RX_Port));
    return(info);
  }

  void receive( byte[] data ) {
  data = subset(data, 0, data.length); //<>//
  String message = new String( data );
  this.buffer = message;
  print("questo è il buffer"+this.buffer);

  return;
}
 private void closeConnection(){
   this.udpModule.close();
 }
  public static UDPconnect getInstance(){
    if(instance==null){
      synchronized(UDPconnect.class){
        if(instance==null){
          instance= new UDPconnect();
        }
      }
    }
    return instance;
  }
  private float[] simulate(float[] toSend){
    this.sendData(toSend);
    if (this.buffer!=null){ //<>//
    
    this.results=this.buffer; //<>//
    println("Receiving..."+this.results);
    this.buffer = null;
    return parse(this.results);
    }
    else{

      return new float[1];
    }
  }
  private float[] parse(String str){
    float[] r=new float[1]; //<>//
    if(str!=null){
    String nobrackets = str.replaceAll("[\\p{Ps}\\p{Pe}]", "");
    String[] strValues= nobrackets.split(",");
    r = new float[strValues.length];
    for(int i=0;i<strValues.length ;i++){
      r[i]=Float.parseFloat(strValues[i]);
    }
    }
     return r;
  }

  }
