part of dart_force_common_lib;

abstract class ForceBaseMessageSendReceiver {
  
  StreamController<ForceMessageEvent> _controller;
  
  ForceBaseMessageSendReceiver() {
    _controller = new StreamController<ForceMessageEvent>();
  }
  
  List<ForceMessageEvent> onInnerMessage(messages, {wsId: "-"}) {
    List<ForceMessageEvent> fmes = new List<ForceMessageEvent>();
    List<String> message_lines = removeEmptyLines(messages.split("\n"));
    for (var message in message_lines) {
      ForceMessageEvent fme = constructForceMessageEvent(message, wsId: wsId);
      fmes.add(fme);
      addMessage(fme);
    }
    return fmes;
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
  
  List<String> removeEmptyLines(List<String> lines) {
    List<String> notEmptyLines = new List<String>();
    for (String line in lines) {
      if (!line.trim().isEmpty) {
        notEmptyLines.add(line);
      }
    }
    return notEmptyLines;
  }
  
  void send(request, data);
  
  Stream<ForceMessageEvent> get onMessage => _controller.stream;
}