part of dart_force_server_lib;

abstract class Connector {
  
  StreamController<ForceSocket> _controller;
  
  void start();
  
  Stream<ForceSocket> wire() => _controller.stream;

}
