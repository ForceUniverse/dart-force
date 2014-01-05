part of dart_force_client_lib;

class SocketEvent {
  var data;
  SocketEvent(this.data);
}

abstract class Socket {
  
  // For subclasses
  Socket._();
  
  factory Socket(String url, {usePolling: false, heartbeat: 2000}) {
    print("choose a socket implementation!");
    if (usePolling || !WebSocket.supported) {
      return new PollingSocket(url);
    } else {
      return new WebSocketWrapper(url);
    }
  }
  
  StreamController<ForceConnectEvent> _connectController;
  StreamController<SocketEvent> _messageController;
  
  void connect();
  
  void send(data);
  
  bool isOpen();
  
  Stream<SocketEvent> get onMessage => _messageController.stream;
  Stream<ForceConnectEvent> get onConnecting => _connectController.stream;
}