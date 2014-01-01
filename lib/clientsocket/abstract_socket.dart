part of dart_force_client_lib;

class SocketEvent {
  var data;
  SocketEvent(this.data);
}

abstract class AbstractSocket {
  
  StreamController<ForceConnectEvent> _connectController;
  StreamController<SocketEvent> _messageController;
  
  void connect();
  
  void send(data);
  
  bool isOpen();
  
  Stream<SocketEvent> get onMessage => _messageController.stream;
  Stream<ForceConnectEvent> get onConnecting => _connectController.stream;
}