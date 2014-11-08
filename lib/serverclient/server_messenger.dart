part of dart_force_server_lib;

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
  
  void offline(sendingPackage) {
    log.warning('WebSocket not connected, message $sendingPackage not sent');
  }
}