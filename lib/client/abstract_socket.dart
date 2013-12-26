part of dart_force_client_lib;

abstract class AbstractSocket {
  
  StreamController<ForceConnectEvent> _connectController;
  StreamController<MessageEvent> _messageController;
  
  void connect();
  
  void send(data);
  
  bool isOpen();
  
  Stream<MessageEvent> get onMessage => _messageController.stream;
  Stream<ForceConnectEvent> get onConnecting => _connectController.stream;
}