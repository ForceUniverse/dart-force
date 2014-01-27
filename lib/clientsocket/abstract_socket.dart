part of dart_force_client_lib;

class SocketEvent {
  var data;
  SocketEvent(this.data);
}

class ConnectEvent {}

abstract class Socket {
  
  // For subclasses
  Socket._();
  
  factory Socket(String url, {bool usePolling: false, int heartbeat: 2000}) {
    print("chosing a socket implementation!");
    if (usePolling || !WebSocket.supported) {
      return new PollingSocket(url, heartbeat);
    } else {
      return new WebSocketWrapper(url);
    }
  }
  
  StreamController<ConnectEvent> _connectController;
  StreamController<ConnectEvent> _disconnectController;
  StreamController<SocketEvent> _messageController;
  
  void connect();
  
  void send(data);
  
  bool isOpen();
  
  Stream<SocketEvent> get onMessage => _messageController.stream;
  Stream<ConnectEvent> get onConnecting => _connectController.stream;
  Stream<ConnectEvent> get onDisconnecting => _disconnectController.stream;
}