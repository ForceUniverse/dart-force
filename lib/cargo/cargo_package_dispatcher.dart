part of dart_force_common_lib;

typedef ValidateCargoPackage(CargoPackage fcp, Sender sender);

class CargoPackageDispatcher implements ProtocolDispatch<CargoPackage> {
  
  CargoHolder cargoHolder;
  Sendable sendable;
  
  Map<String, ValidateCargoPackage> _validators = new Map<String, ValidateCargoPackage>();
  
  CargoPackageDispatcher(this.cargoHolder, this.sendable);
  
  void publish(String collection, CargoBase cargo, {ValidateCargoPackage filter}) {
    _validators[collection] = filter;
    cargoHolder.publish(collection, cargo);
  }
  
  void dispatch(CargoPackage fcp) {
    var collection = fcp.collection;
    
    // before dispatch evaluate ...
    ValidateCargoPackage validator = _validators[collection];
    if (validator != null) {
      validator(fcp, new Sender(sendable, fcp.wsId));
    }
    
    if (fcp.action.type == CargoAction.SUBSCRIBE) {
      cargoHolder.subscribe(fcp.collection, fcp.params, fcp.wsId);
    } else if (fcp.action.type == CargoAction.ADD) {
      cargoHolder.add(fcp.collection, fcp.collection, fcp.json, fcp.wsId);
    } else if (fcp.action.type == CargoAction.UPDATE) {
      cargoHolder.update(fcp.collection, fcp.key, fcp.json, fcp.wsId);
    } else if (fcp.action.type == CargoAction.REMOVE) {
      cargoHolder.remove(fcp.collection, fcp.key, fcp.wsId);
    } else if (fcp.action.type == CargoAction.SET) {
      cargoHolder.set(fcp.collection, fcp.json, fcp.wsId);
    }
  }
  
}