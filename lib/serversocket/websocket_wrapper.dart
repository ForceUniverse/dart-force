part of dart_force_server_lib;

class WebSocketWrapper extends Socket {
  
  WebSocket webSocket;
  
  WebSocketWrapper(this.webSocket) {
    _messageController = new StreamController<MessageEvent>();
    
    this.webSocket.listen((data) {
      _messageController.add(new MessageEvent(data));
    });
  }
  
  Future done() => this.webSocket.done;
  
  bool isClosed() {
    return webSocket.readyState == WebSocket.CLOSED;
  }
  
  void close() {
    this.webSocket.close();
  }

  void add(data) {
    this.webSocket.add(data);
  }
}