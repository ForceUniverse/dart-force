part of dart_force_server_lib;

 /**
 *
 * A wrapper class for the ServerSocket implementation!
 * 
 */
class ServerSocketWrapper extends ForceSocket {
  
  Socket socket;
  bool closed = false;
  
  ServerSocketWrapper(this.socket, [request]){
    _messageController = new StreamController<MessageEvent>();
    
    this.socket.transform(UTF8.decoder).listen((data) {
      print(data);
      _messageController.add(new MessageEvent(request, data));
    }).onDone(() {
      print("this is done!");
      closed = true;
    });
  }
  
  Future done() => this.socket.done;
  
  bool isClosed() {
    return closed;
  }
  
  void close() {
    socket.close();
  }

  void add(data) {
    print(socket.runtimeType);
    this.socket.write(data);
  }
}