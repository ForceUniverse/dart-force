part of dart_force_common_lib;

class ForceCargoProtocol extends Protocol<ForceCargoPackage> {
  
  StreamController<ForceCargoPackage> _controller;
  ProtocolDispatch<ForceCargoPackage> dispatcher;
  
  ForceCargoProtocol(this.dispatcher) {
    _controller = new StreamController<ForceCargoPackage>();
  }
  
  bool shouldDispatch(data) {
    return data.toString().contains("collection");
  }
  
  List<ForceCargoPackage> onConvert(data, {wsId: "-"}) {
    List<ForceCargoPackage> fcps = new List<ForceCargoPackage>();
    ForceCargoPackage fcp = new ForceCargoPackage.fromJson(JSON.decode(data), wsId: wsId);
      
    fcps.add(fcp);
    addMessage(fcp);
 
    return fcps;
  }
  
  ForceCargoPackage addMessage(ForceCargoPackage fcp) {
    _controller.add(fcp);
    return fcp;
  }
  
  Stream<ForceCargoPackage> get onMessage => _controller.stream;
}