part of dart_force_server_lib;

class MessageEvent {
  var data;
  HttpRequest request;
  
  MessageEvent(this.request, this.data);
}

abstract class Socket {
  StreamController<MessageEvent> _messageController;
  
  HttpRequest request;
  
  Stream<MessageEvent> get onMessage => _messageController.stream;
  Future done();
  
  bool isClosed();
  
  void close();
  
  void add(data);
}