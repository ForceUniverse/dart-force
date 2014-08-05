part of dart_force_server_lib;

class SocketEvent {
   
  String wsId;
  Socket socket;
  
  SocketEvent(this.wsId, this.socket);
  
  String toString() => "Socket with id $wsId";
}