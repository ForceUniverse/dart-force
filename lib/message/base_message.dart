part of dart_force_common_lib;

class ForceMessageProtocol extends Protocol<ForceMessagePackage> {
  
  StreamController<ForceMessagePackage> _controller;
  ProtocolDispatch<ForceMessagePackage> dispatcher;
  
  ForceMessageProtocol(this.dispatcher) {
    _controller = new StreamController<ForceMessagePackage>();
  }
  
  bool shouldDispatch(message) {
    return true;
  }
  
  List<ForceMessagePackage> onConvert(messages, {wsId: "-"}) {
    List<ForceMessagePackage> fmes = new List<ForceMessagePackage>();
    List<String> message_lines = removeEmptyLines(messages.split("\n"));
    for (var message in message_lines) {
      ForceMessagePackage fme = new ForceMessagePackage.fromJson(JSON.decode(message), wsId: wsId);
      fmes.add(fme);
      addMessage(fme);
    }
    return fmes;
  }
  
  ForceMessagePackage addMessage(ForceMessagePackage vme) {
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
  
  Stream<ForceMessagePackage> get onMessage => _controller.stream;
}