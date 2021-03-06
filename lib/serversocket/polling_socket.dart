part of force.server;

class PollingSocket extends ForceSocket {
  
  List messages = new List();
  Completer completer = new Completer.sync();
  HttpRequest request;
  
  PollingSocket(this.request) {
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
  
  void sendedData(data) {
    _messageController.add(new MessageEvent(request, data));
  }

  void add(data) {
    messages.add(data);
  }
}