part of force.server;

class ServerMessenger extends Messenger {
  
  final Logger log = new Logger('ServerMessenger');
  
  ForceSocket socket;
  
  ServerMessenger(this.socket);
  
  void send(sendingPackage) {
    if (socket != null && !socket.isClosed()) {
        log.info('send package to the server $sendingPackage');
        socket.add(JSON.encode(sendingPackage));
    } else {
        this.offline(sendingPackage);
    }
  }
  
  void online() {
      for (var package in notSendedPackages) {
        socket.add(JSON.encode(package));
      }
  }
  
  
}