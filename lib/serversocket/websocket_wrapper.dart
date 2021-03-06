part of force.server;

class WebSocketWrapper extends ForceSocket {
  
  WebSocket webSocket;
  HttpRequest request;
  
  WebSocketWrapper(this.webSocket, [this.request]) {
    _messageController = new StreamController<MessageEvent>();
    
    this.webSocket.listen((data) {
      _messageController.add(new MessageEvent(request, data));
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