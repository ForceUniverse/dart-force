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
  
  ForceCargoPackage onConvert(data, {wsId: "-"}) {
    ForceCargoPackage fcp = new ForceCargoPackage.fromJson(JSON.decode(data), wsId: wsId);
    addPackage(fcp);
 
    return fcp;
  }
  
  ForceCargoPackage addPackage(ForceCargoPackage fcp) {
    _controller.add(fcp);
    return fcp;
  }
  
  Stream<ForceCargoPackage> get onPackage => _controller.stream;
}