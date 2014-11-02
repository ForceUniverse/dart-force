part of dart_force_server_lib;

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