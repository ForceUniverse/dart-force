part of dart_force_common_lib;

class CargoPackageDispatcher implements ProtocolDispatch<ForceCargoPackage> {
  
  CargoHolder cargoHolder;
  
  // Map<String, MessageReceiver> mapping = new Map<String, MessageReceiver>();
  
  CargoPackageDispatcher(this.cargoHolder);
  
  void publish(String collection, CargoBase cargo) {
    cargoHolder.publish(collection, cargo);
  }
  
  void dispatch(ForceCargoPackage fcp) {
    var collection = fcp.collection;
    
    if (fcp.action.type == CargoAction.SUBSCRIBE) {
      cargoHolder.subscribe(fcp.collection, fcp.params, fcp.wsId);
    } else if (fcp.action.type == ForceMessageType.ADD) {
      cargoHolder.add(fcp.collection, fcp.collection, fcp.data);
    } else if (fcp.action.type == ForceMessageType.UPDATE) {
      cargoHolder.update(fcp.collection, fcp.key, fcp.data);
    } else if (fcp.action.type == ForceMessageType.REMOVE) {
      cargoHolder.remove(fcp.collection, fcp.key);
    } else if (fcp.action.type == ForceMessageType.SET) {
      cargoHolder.set(fcp.collection, fcp.data);
    }
  }
}