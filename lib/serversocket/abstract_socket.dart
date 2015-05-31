part of force.server;

class MessageEvent {
  var data;
  HttpRequest request;
  
  MessageEvent(this.request, this.data);
}

abstract class ForceSocket {
  StreamController<MessageEvent> _messageController;
  
  HttpRequest request;
  
  Stream<MessageEvent> get onMessage => _messageController.stream;
  Future done();
  
  bool isClosed();
  
  void close();
  
  void add(data);
}