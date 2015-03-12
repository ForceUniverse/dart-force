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
  
  Stream<SocketEvent> _onMessage;
  Stream<ConnectEvent> _onConnecting;
  Stream<ConnectEvent> _onDisconnecting;

  
  void connect();
  
  void send(data);
  
  bool isOpen();
  
  Stream<SocketEvent> get onMessage => _stream_resolving(_messageController, _onMessage);
  Stream<ConnectEvent> get onConnecting => _stream_resolving(_connectController, _onConnecting);
  Stream<ConnectEvent> get onDisconnecting => _stream_resolving(_disconnectController, _onDisconnecting);
  
  Stream _stream_resolving(StreamController controller, Stream stream) {
     if (stream==null) {
         stream = controller.stream.asBroadcastStream();
     }
     return stream;
  }
}