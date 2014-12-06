part of dart_force_common_lib;

class ForceMessageProtocol extends Protocol<ForceMessagePackage> {
  
  StreamController<ForceMessagePackage> _controller;
  ProtocolDispatch<ForceMessagePackage> dispatcher;
  
  ForceMessageProtocol(this.dispatcher) {
    _controller = new StreamController<ForceMessagePackage>();
  }
  
  bool shouldDispatch(data) {
      // Test what is typical for this protocol
      return data.toString().contains("request");
  }
  
  ForceMessagePackage onConvert(data, {wsId: "-"}) {
    ForceMessagePackage fme = new ForceMessagePackage.fromJson(JSON.decode(data), wsId: wsId);
      
    addMessage(fme);
    
    return fme;
  }
  
  ForceMessagePackage addMessage(ForceMessagePackage vme) {
    _controller.add(vme);
    return vme;
  }
  
  Stream<ForceMessagePackage> get onMessage => _controller.stream;
}