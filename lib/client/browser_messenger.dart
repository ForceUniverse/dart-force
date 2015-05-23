part of dart_force_client_lib;

class BrowserMessenger extends Messenger {
  Socket socket;
  
  BrowserMessenger(this.socket);
  
  void send(sendingPackage) {
    if (socket != null && socket.isOpen()) {
        socket.send(JSON.encode(sendingPackage));
    } else {
        this.offline(sendingPackage);
    }
  }
  

}