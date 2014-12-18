part of dart_force_common_lib;

typedef FilterCargoPackage(ForceCargoPackage fcp, Sender sender);

class CargoPackageDispatcher implements ProtocolDispatch<ForceCargoPackage> {
  
  CargoHolder cargoHolder;
  Sendable sendable;
  
  Map<String, FilterCargoPackage> _filterReceivers = new Map<String, FilterCargoPackage>();
  
  CargoPackageDispatcher(this.cargoHolder, this.sendable);
  
  void publish(String collection, CargoBase cargo, {FilterCargoPackage filter}) {
    _filterReceivers[collection] = filter;
    cargoHolder.publish(collection, cargo);
  }
  
  void dispatch(ForceCargoPackage fcp) {
    var collection = fcp.collection;
    
    // before dispatch evaluate ...
    FilterCargoPackage filterReceiver = _filterReceivers[collection];
    if (filterReceiver != null) {
      filterReceiver(fcp, new Sender(sendable, fcp.wsId));
    }
    
    if (fcp.action.type == CargoAction.SUBSCRIBE) {
      cargoHolder.subscribe(fcp.collection, fcp.params, fcp.wsId);
    } else if (fcp.action.type == CargoAction.ADD) {
      cargoHolder.add(fcp.collection, fcp.collection, fcp.data, fcp.wsId);
    } else if (fcp.action.type == CargoAction.UPDATE) {
      cargoHolder.update(fcp.collection, fcp.key, fcp.data, fcp.wsId);
    } else if (fcp.action.type == CargoAction.REMOVE) {
      cargoHolder.remove(fcp.collection, fcp.key, fcp.wsId);
    } else if (fcp.action.type == CargoAction.SET) {
      cargoHolder.set(fcp.collection, fcp.data, fcp.wsId);
    }
  }
  
}