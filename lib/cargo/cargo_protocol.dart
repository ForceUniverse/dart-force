part of dart_force_common_lib;

class ForceCargoProtocol extends Protocol<CargoPackage> {
  
  StreamController<CargoPackage> _controller;
  ProtocolDispatch<CargoPackage> dispatcher;
  
  ForceCargoProtocol(this.dispatcher) {
    _controller = new StreamController<CargoPackage>();
  }
  
  bool shouldDispatch(data) {
    return data.toString().contains("collection");
  }
  
  CargoPackage onConvert(data, {wsId: "-"}) {
    CargoPackage fcp = new CargoPackage.fromJson(JSON.decode(data), wsId: wsId);
    addPackage(fcp);
 
    return fcp;
  }
  
  CargoPackage addPackage(CargoPackage fcp) {
    _controller.add(fcp);
    return fcp;
  }
  
  Stream<CargoPackage> get onPackage => _controller.stream;
}