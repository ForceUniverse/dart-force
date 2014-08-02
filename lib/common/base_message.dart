part of dart_force_common_lib;

abstract class ForceBaseMessageSendReceiver {
  
  StreamController<ForceMessageEvent> _controller;
  
  ForceBaseMessageSendReceiver() {
    _controller = new StreamController<ForceMessageEvent>();
  }
  
  ForceMessageEvent onInnerMessage(message, {wsId: "-"}) {
    ForceMessageEvent fme = constructForceMessageEvent(message, wsId: wsId);
    addMessage(fme);
    return fme;
  }
  
  ForceMessageEvent constructForceMessageEvent(message, {wsId: "-"}) {
      var json = JSON.decode(message);
      dynamic data = json["data"];
      dynamic profile = json["profile"];
      dynamic request = json["request"];
      dynamic type = json["type"];
      
      ForceMessageType fmt = new ForceMessageType.fromJson(type);
      ForceMessageEvent vme = new ForceMessageEvent(request, fmt, data, profile, wsId: wsId);
      
      return vme;
    }
  
  ForceMessageEvent addMessage(ForceMessageEvent vme) {
    _controller.add(vme);
    return vme;
  }
  
  void send(request, data);
  
  Stream<ForceMessageEvent> get onMessage => _controller.stream;
}