part of dart_force_server_lib;

class StreamSocket extends ForceSocket {
  
  Stream stream;
  IOSink ioSink;
  StreamSubscription subscription;
  StreamController _controller;
  
  bool closed = false;
  
  StreamSocket(this.stream, this.ioSink) {
    _messageController = new StreamController<MessageEvent>();
    
    subscription = this.stream.transform(UTF8.decoder).listen((data) {
      _messageController.add(new MessageEvent(request, data));
    });
    subscription.onDone(() {
      closed = true;
    });
  }
  
  Future done() => this.ioSink.done;
  
  bool isClosed() {
    return closed;
  }
  
  void close() {
    ioSink.close();
  }

  void add(data) {
    this.ioSink.add(UTF8.encode(data));
  }
}