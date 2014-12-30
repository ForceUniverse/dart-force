part of dart_force_common_lib;

/**
 * Arrange the Cargo protocol, should the package be dispatched, 
 * how converting the raw data into a cargo package, expose a stream, ...
 */
class ForceCargoProtocol extends Protocol<CargoPackage> {
  
  StreamController<CargoPackage> _controller;
  ProtocolDispatch<CargoPackage> dispatcher;
  
  ForceCargoProtocol(this.dispatcher) {
    _controller = new StreamController<CargoPackage>();
  }
  
  /**
   * Should the data be dispatch as a cargo package ... look at the data here ...
   */
  bool shouldDispatch(data) {
    return data.toString().contains("collection");
  }
  
  /**
   * Converting the raw data into a cargo package
   */
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