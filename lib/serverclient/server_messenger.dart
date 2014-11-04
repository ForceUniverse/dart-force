part of dart_force_server_lib;

class ServerMessenger extends Messenger {
  ForceSocket socket;
  
  ServerMessenger(this.socket);
  
  void send(sendingPackage) {
    if (socket != null && !socket.isClosed()) {
        // print('send package to the server $sendingPackage');
        socket.add(JSON.encode(sendingPackage));
    } else {
        this.offline(sendingPackage);
    }
  }
  
  void offline(sendingPackage) {
    print('WebSocket not connected, message $sendingPackage not sent');
  }
}