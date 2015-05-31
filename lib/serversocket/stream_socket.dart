part of force.server;

class StreamSocket extends ForceSocket {
  
  Stream stream;
  StreamSink sink;
  StreamSubscription subscription;
  StreamController _controller;
  
  bool closed = false;
  
  StreamSocket.fromController(StreamController streamController) {
    this.stream = streamController.stream;
    this.sink = streamController;
    
    _init();
  }
  
  StreamSocket(stream) {
    this.stream = stream;
    this.sink = stream;
    
    _init();
  }
  
  void _init() {
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
    this.sink.add(data);
  }
}