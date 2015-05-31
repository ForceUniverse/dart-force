part of force.server;

/** 
 * SocketEvent happens when a new socket is been created.
 * 
 **/
class SocketEvent {
   
  String wsId;
  ForceSocket socket;
  
  SocketEvent(this.wsId, this.socket);
  
  String toString() => "Socket with id $wsId";
}