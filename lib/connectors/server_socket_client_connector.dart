part of dart_force_server_lib;

class ServerSocketClientConnector extends Connector {
  
  int port;
  String address;
  
  
  ServerSocketClientConnector({this.address: '127.0.0.1', this.port: 4041}) {
    _controller = new StreamController<ForceSocket>();
  }
  
  Future start() {
    Socket.connect("127.0.0.1", 4041).then((Socket socket) {
      _controller.add(new ServerSocketWrapper(socket));
     });
    return _completer.future;
  }
  
}