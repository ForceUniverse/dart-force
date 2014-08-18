part of dart_force_server_lib;

class StreamSocket extends Socket {
  
  Stream stream;
  StreamSubscription subscription;
  StreamController _controller;
  
  bool closed = false;
  
  StreamSocket(this.stream) {
    _messageController = new StreamController<MessageEvent>();
    
    _controller = new StreamController();
    _controller.addStream(this.stream);
    
    subscription = this.stream.listen((data) {
      _messageController.add(new MessageEvent(request, data));
    });
    subscription.onDone(() {
      closed = true;
    });
  }
  
  Future done() => _controller.done;
  
  bool isClosed() {
    return closed;
  }
  
  void close() {
    _controller.close();
  }

  void add(data) {
    this._controller.add(data);
  }
}