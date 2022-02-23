//// import UDP library
//import hypermedia.net.*;


//UDP udp;  // define the UDP object
//int counter=0;
//int PORT=12346;
//String IP_Addr="127.0.0.1";
//byte[] data;
///**
// * init
// */
//void setup() {

//  // create a new datagram connection on port 6000
//  // and wait for incomming message
//  udp = new UDP( this, 12345,IP_Addr );
//  //udp.log(true );     // <-- printout the connection activity
//  udp.listen( true );
 
//}

////process events
//void draw() {
//}

//void keyPressed(){
//  if(keyCode=='1'){
//    // Draw our line
//    counter=counter+1;
//    println(counter);
//     println("Intero in Stringa"+String.valueOf(counter));
//    // Send mouse coords to other person
//     udp.send(String.valueOf(counter), IP_Addr, PORT );
//  }
//}
///** 
// * on key pressed event:
// * send the current key value over the network
// */
////void keyPressed() {
    
////    String message  = str( key );  // the message to send
////    String ip       = IP_Addr;  // the remote IP address
////    int port        = 12346;    // the destination port
    
////    // formats the message for Pd
////    message = message+";\n";
////    // send the message
////   udp.send( message, ip, port );
    
////}

///**
// * To perform any action on datagram reception, you need to implement this 
// * handler in your code. This method will be automatically called by the UDP 
// * object each time he receive a nonnull message.
// * By default, this method have just one argument (the received message as 
// * byte[] array), but in addition, two arguments (representing in order the 
// * sender IP address and his port) can be set like below.
// */
// void receive( byte[] data ) {       // <-- default handler
////void receive( byte[] data, String ip, int port ) {  // <-- extended handler
  
  
////  // get the "real" message =
//  // forget the ";\n" at the end <-- !!! only for a communication with Pd !!!
//  data = subset(data, 0, data.length-2);
//  String message = new String( data );
  
//  // print the result
//  println( "receive: \""+message+"\" from "+IP_Addr+" on port "+PORT );
//}
