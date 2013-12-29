part of dart_force_server_lib;

class MessageEvent {
  var data;
  MessageEvent(this.data);
}

abstract class Socket {
  StreamController<MessageEvent> _messageController;
  
  Stream<MessageEvent> get onMessage => _messageController.stream;
  Future done();
  
  bool isClosed();
  
  void close();
  
  void add(data);
}