part of force.common;

class ForceMessageProtocol extends Protocol<MessagePackage> {
  
  StreamController<MessagePackage> _controller;
  ProtocolDispatch<MessagePackage> dispatcher;
  
  ForceMessageProtocol(this.dispatcher) {
    _controller = new StreamController<MessagePackage>();
  }
  
  bool shouldDispatch(data) {
      // Test what is typical for this protocol
      return data.toString().contains("request");
  }
  
  MessagePackage onConvert(data, {wsId: "-"}) {
    MessagePackage fme = new MessagePackage.fromJson(JSON.decode(data), wsId: wsId);
      
    addMessage(fme);
    
    return fme;
  }
  
  MessagePackage addMessage(MessagePackage vme) {
    _controller.add(vme);
    return vme;
  }
  
  Stream<MessagePackage> get onMessage => _controller.stream;
}