part of dart_force_server_lib;

abstract class Connector {
  
  StreamController<ForceSocket> _controller;
  Completer _completer = new Completer();
  
  Future start();
  
  Stream<ForceSocket> wire() => _controller.stream;

  void complete() {
    if (!_completer.isCompleted) _completer.complete();
  }
  
}
