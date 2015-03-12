part of dart_force_client_lib;

class BrowserMessenger extends Messenger {
  Socket socket;
  
  BrowserMessenger(this.socket);
  
  void send(sendingPackage) {
    if (socket != null && socket.isOpen()) {
        print('send package to the server $sendingPackage');
        socket.send(JSON.encode(sendingPackage));
    } else {
        this.offline(sendingPackage);
    }
  }
  
  void online() {
    for (var package in notSendedPackages) {
      socket.send(JSON.encode(package));
    }
  }
}