part of dart_force_server_lib;

class StreamSocket extends ForceSocket {
  
  Stream stream;
  StreamSink sink;
  StreamSubscription subscription;
  StreamController _controller;
  
  bool closed = false;
  
  StreamSocket(stream) {
    this.stream = stream;
    this.sink = stream;
    
    _messageController = new StreamController<MessageEvent>();
    
    subscription = this.stream.listen((data) {
      _messageController.add(new MessageEvent(request, data));
    });
    subscription.onDone(() {
      closed = true;
    });
  }
  
  Future done() => this.sink.done;
  
  bool isClosed() {
    return closed;
  }
  
  void close() {
    sink.close();
  }

  void add(data) {
    this.sink.add(UTF8.encode(data));
  }
}