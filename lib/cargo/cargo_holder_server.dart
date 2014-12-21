part of dart_force_server_lib;

/**
* Holds all interactions with the cargo instances on the server!
*/
class CargoHolderServer implements CargoHolder {
  
  Map<String, CargoBase> _cargos = new Map<String, CargoBase>();
  Map<String, List<String>> _subscribers = new Map<String, List<String>>();
  
  Map<String, Map> _parameters = new Map<String, Map>();

  DataChangeable dataChangeable;
  
  var _uuid = new Uuid();
  
  CargoHolderServer(this.dataChangeable);
  
  void publish(String collection, CargoBase cargoBase) {
    _cargos[collection] = cargoBase;
    
    Map params = _parameters[collection];
    
    cargoBase.onAll((de) {
      // inform all subscribers for this change!
      if (de.type==DataType.CHANGED) {
        //before that 
        if (containsByOverlay(de.data, params)) {
           _sendTo(collection, de.key, de.data);
        }
      } else {
        if (containsByOverlay(de.data, params)) {
           _removePush(collection, de.key, de.data);
        }
      }
    });
  }
  
  void _sendTo(collection, key, data) {
    // inform all subscribers for this change!
    List ids = _subscribers[collection];
    
    if (ids != null) {
      for (var id in ids) {
        _sendToId(collection, key, data, id);
      } 
    }
  }
  
  void _sendToId(collection, key, data, id) {
       dataChangeable.update(collection, key, data, id: id);
  }
  
  void _removePush(collection, key, data) {
      // inform all subscribers for this change!
      List ids = _subscribers[collection];
     
      for (var id in ids) {
        dataChangeable.remove(collection, key, id: id);
      } 
    }
  
  bool subscribe(String collection, params, String id) {
    bool colExist = exist(collection);
    if (colExist) { 
      List ids = new List();
      if (_subscribers[collection] != null) {
        ids = _subscribers[collection];
      }
      ids.add(id);
      // send data if necessary
      _subscribers[collection] = ids;
      _parameters[collection] = params;
      
      // send the collection to the clients
      _cargos[collection].export(params: params).then((Map values) {
        values.forEach((key, value) => _sendToId(collection, key, value, id));
      });
    }
    return colExist;
  }
  
  bool exist(String collection) {
    return _cargos[collection]!=null;
  }
  
  bool add(String collection, key, data, id) {
    bool colExist = exist(collection);
    if (colExist) { 
      _cargos[collection].add(key, data);
    }
    return colExist;
  }
  
  bool update(String collection, key, data, id) {
      bool colExist = exist(collection);
      if (colExist) { 
        _cargos[collection].setItem(key, data);
      }
      return colExist;
  }
  
  bool remove(String collection, key, id) {
      bool colExist = exist(collection);
      if (colExist) { 
         _cargos[collection].removeItem(key);
      }
      return colExist;
    }
  
  bool set(String collection, data, id) {
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