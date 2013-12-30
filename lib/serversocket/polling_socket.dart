part of dart_force_server_lib;

class DataPackage {
  var data;
  DataPackage(this.data);
}

class PollingSocket extends Socket {
  
  List<DataPackage> messages = new List<DataPackage>();
  Completer completer = new Completer.sync();
  
  PollingSocket() {
    _messageController = new   StreamController<MessageEvent>();
  }
  
  Future done() {
    return completer.future;
  }
  
  bool isClosed() {
    return false;
  }
  
  void close() {
    completer.complete(const []);
  }

  void add(data) {
    messages.add(data);
  }
}