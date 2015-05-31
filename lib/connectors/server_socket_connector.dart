part of force.server;

class ServerSocketConnector extends Connector {
  
  int port;
  String address;
  
  StreamController<ForceSocket> _controller;
  
  ServerSocketConnector({this.address: '127.0.0.1', this.port: 4041}) {
    _controller = new StreamController<ForceSocket>();
  }
  
  Future start() {
    ServerSocket.bind(this.address, this.port)
         .then((serverSocket) {
           serverSocket.listen((socket) {
             _controller.add(new ServerSocketWrapper(socket));
             
           });
    });
    return _completer.future;
  }
 
}