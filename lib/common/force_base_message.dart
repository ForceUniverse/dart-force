part of dart_force_common_lib;

abstract class ForceBaseMessageSendReceiver {
  
  StreamController<ForceMessageEvent> _controller;
  
  ForceBaseMessageSendReceiver() {
    _controller = new StreamController<ForceMessageEvent>();
  }
  
  ForceMessageEvent onInnerMessage(message, {wsId: "-"}) {
    var json = JSON.decode(message);
    dynamic data = json["data"];
    dynamic request = json["request"];
    
    ForceMessageEvent vme = new ForceMessageEvent(request, data, wsId: wsId);
    
    _controller.add(vme);
    return vme;
  }
  
  void addMessage(ForceMessageEvent vme) {
    _controller.add(vme);
  }
  
  void send(request, data);
  
  Stream<ForceMessageEvent> get onMessage => _controller.stream;
}