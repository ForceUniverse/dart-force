part of force.client;

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