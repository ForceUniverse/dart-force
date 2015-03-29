part of dart_force_common_lib;

/** transform json objects into real objects by the user 
 * until better ways in dart this will be the way to transform our data
 **/
typedef Object deserializeData(Map json);

/**
* Is a memory wrapper arround cargo, so we can add this to our view!
* Ideal class to use it in Angular or Polymer.
*/
class ViewCollection extends Object with IterableMixin<EncapsulatedValue> {
  
  CargoBase cargo;
  DataChangeable _changeable;
  String _collection;
  
  Options options;
  
  deserializeData deserialize;
  
  Map<String, EncapsulatedValue> _all = new Map<String, EncapsulatedValue>();
  
  /// put the data raw in a map, make the map only available as a getter
  Map<String, dynamic> _raw = new Map<String, dynamic>();
  Map<String, dynamic> get data => _raw;
  
  DataChangeListener _cargoDataChange;
  
  ViewCollection(this._collection, this.cargo, this.options, this._changeable, {this.deserialize}) {
   this.cargo.onAll((DataEvent de) {
     if (de.type==DataType.CHANGED) {
       var data = de.data;
       if (data is Map && deserialize != null) {
         data = deserialize(data);
       }
       
       _addNewValue(de.key, data);
       if (_cargoDataChange!=null) _cargoDataChange(new DataEvent(de.key, data, de.type));
     }
     if (de.type==DataType.REMOVED) {
       _all.remove(de.key);
       _raw.remove(de.key);
       if (_cargoDataChange!=null) _cargoDataChange(de);
     }
   }); 
  }
  
  onChange(DataChangeListener cargoDataChange) => this._cargoDataChange = cargoDataChange;
  
  void _addNewValue(key, data) {
    if (options != null && options.hasLimit() && !_all.containsKey(key)) {
       if (options.limit == _all.length) {
          var removableKey;
          if(options.revert) {
            removableKey = _all.keys.elementAt(_all.keys.length-1);
          } else {
            removableKey = _all.keys.elementAt(0);
          }
          _all.remove(removableKey);
          if (!_raw.containsKey(key)) _raw.remove(removableKey);
       }
    }
    if (options != null && options.revert && !_all.containsKey(key)) {
        _all = insertFirstInMap(_all, key, new EncapsulatedValue(key, data)); 
        _raw = insertFirstInMap(_raw, key, data);
    } else {
      _all[key] = new EncapsulatedValue(key, data);
      _raw[key] = data;
    }
  }
  
  Map insertFirstInMap(Map map, key, value) {
    Map tempMap = new Map();
    
    tempMap[key] = value;
    tempMap.addAll(map);
    return map;
  }
  
  void update(key, value) {
   this.cargo.setItem(key, value);
   this._changeable.update(_collection, key, value);
  }
  
  void remove(id) {
    this.cargo.removeItem(id);
    this._changeable.remove(_collection, id);
  }
  
  void set(value) {
    this._changeable.set(_collection, value);
  }
  
  Iterator get iterator => _all.values.iterator;
  
}

class EncapsulatedValue {
  String key;
  var value;
  
  EncapsulatedValue(this.key, this.value);
}