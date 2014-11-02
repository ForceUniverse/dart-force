part of dart_force_server_lib;

class ServerSocketConnector extends Connector {
  
  int port;
  String address;
  
  StreamController<ForceSocket> _controller;
  
  ServerSocketConnector({this.address: '127.0.0.1', this.port: 4041}) {
    _controller = new StreamController<ForceSocket>();
  }
  
  Future start() {
    ServerSocket.bind(this.address, 4041)
         .then((serverSocket) {
           serverSocket.listen((socket) {
             _controller.add(new ServerSocketWrapper(socket));
             
           });
    });
    return _completer.future;
  }
 
}