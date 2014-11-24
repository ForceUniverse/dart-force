part of dart_force_server_lib;

/**
* Holds all interactions with the cargo instances on the server!
*/
class CargoHolderServer implements CargoHolder {
  
  Map<String, CargoBase> _cargos = new Map<String, CargoBase>();
  Map<String, List<String>> _subscribers = new Map<String, List<String>>();
  
  DataChangeable dataChangeable;
  
  var _uuid = new Uuid();
  
  CargoHolderServer(this.dataChangeable);
  
  void publish(String collection, CargoBase cargoBase) {
    _cargos[collection] = cargoBase;
    
    cargoBase.onAll((de) {
      // inform all subscribers for this change!
      _sendTo(collection, de.key, de.data);
    });
  }
  
  void _sendTo(collection, key, data) {
    // inform all subscribers for this change!
    List ids = _subscribers[collection];
   
    for (var id in ids) {
      dataChangeable.update(collection, key, data, id: id);
    } 
  }
  
  bool subscribe(String collection, String id) {
    bool colExist = exist(collection);
    if (colExist) { 
      List ids = new List();
      if (_subscribers[collection] != null) {
        ids = _subscribers[collection];
      }
      ids.add(id);
      // send data if necessary
      _subscribers[collection] = ids;
      
      // send the collection to the clients
      _cargos[collection].export().then((Map values) {
        values.forEach((key, value) => _sendTo(collection, key, value));
      });
    }
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
    bool colExist = exist(collection);
    if (colExist) { 
       _cargos[collection].setItem(_uuid.v4(), data);
    }
    return colExist;
  }
  
  generateKey(key) {
    return key;
  }
  
}