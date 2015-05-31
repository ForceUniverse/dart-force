part of force.common;

typedef ValidateCargoPackage(CargoPackage fcp, Sender sender);

/**
 * Dispatch all the cargo packages to the correct methods in the cargo holder class
 * Before dispatching it he will execute the validator method corresponding a collection 
 */
class CargoPackageDispatcher extends ProtocolDispatch<CargoPackage> {
  
  CargoHolder cargoHolder;
  
  Map<String, ValidateCargoPackage> _validators = new Map<String, ValidateCargoPackage>();
  
  CargoPackageDispatcher(this.cargoHolder);
  
  void publish(String collection, CargoBase cargo, {ValidateCargoPackage filter}) {
    _validators[collection] = filter;
    cargoHolder.publish(collection, cargo);
  }
  
  /**
   * Dispatch a CargoPackage
   */
  void dispatch(CargoPackage fcp) {
    var collection = fcp.collection;
    
    // before dispatch evaluate ...
    ValidateCargoPackage validator = _validators[collection];
    if (validator != null) {
      validator(fcp, new Sender(sendable, fcp.wsId));
    }
    
    if (fcp.action.type == CargoAction.SUBSCRIBE) {
      cargoHolder.subscribe(fcp.collection, fcp.params, fcp.options, fcp.wsId);
    } else if (fcp.action.type == CargoAction.ADD) {
      cargoHolder.add(fcp.collection, fcp.collection, fcp.json);
    } else if (fcp.action.type == CargoAction.UPDATE) {
      cargoHolder.update(fcp.collection, fcp.key, fcp.json);
    } else if (fcp.action.type == CargoAction.REMOVE) {
      cargoHolder.remove(fcp.collection, fcp.key);
    } else if (fcp.action.type == CargoAction.SET) {
      cargoHolder.set(fcp.collection, fcp.json);
    }
  }
  
}