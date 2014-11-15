part of dart_force_common_lib;

/**
* Holds all the cargo instances!
*/
class CargoHolder {
  
  Map<String, CargoBase> _cargos = new Map<String, CargoBase>();
  Map<String, List<String>> _subscribers = new Map<String, List<String>>();
  
  Sendable sendable;
  
  CargoHolder(this.sendable);
  
  void publish(String collection, CargoBase cargoBase) {
    _cargos[collection] = cargoBase;
    
    cargoBase.onAll((de) {
      // inform all subscribers for this change!
      List ids = _subscribers[collection];
      
      for (var id in ids) {
        sendable.sendTo(id, collection, de);
      }
    });
  }
  
  void _sendTo(collection, DataEvent de) {
    // inform all subscribers for this change!
    List ids = _subscribers[collection];
   
    for (var id in ids) {
      sendable.sendTo(id, collection, de);
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
        values.forEach((key, value) => _sendTo(collection, new DataEvent(key, value)));
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
  
  bool set(String collection, key, data) {
    bool colExist = exist(collection);
    if (colExist) { 
       _cargos[collection].setItem(key, data);
    }
    return colExist;
  }
  
}