part of dart_force_common_lib;

/**
* Holds all interactions with the cargo instances on the client!
*/
class CargoHolderClient implements CargoHolder {
  
  Map<String, CargoBase> _cargos = new Map<String, CargoBase>();
    
  DataChangeable dataChangeable;
  
  CargoHolderClient(this.dataChangeable);
  
  // publish a cargo collection
  void publish(String collection, CargoBase cargoBase) {
    _cargos[collection] = cargoBase;
  }
  
  // subscribe to changes of a cargo collection
  bool subscribe(String collection, params, String id) {
    bool colExist = exist(collection);
    // Don't need todo anything on the client
    return colExist;
  }
  
  bool exist(String collection) {
    return _cargos[collection]!=null;
  }
  
  bool add(String collection, key, data) {
    bool colExist = exist(collection);
    if (colExist) { 
      _cargos[collection].add(key, data);
    }
    return colExist;
  }
  
  bool update(String collection, key, data) {
    bool colExist = exist(collection);
    if (colExist) { 
      _cargos[collection].setItem(key, data);
    }
    return colExist;
  }
  
  bool remove(String collection, key) {
     bool colExist = exist(collection);
     if (colExist) { 
       _cargos[collection].removeItem(key);
     }
     return colExist;
   }
  
  bool set(String collection, data) {
    throw new UnsupportedError('Is not supported on the client!');
  }
  
}