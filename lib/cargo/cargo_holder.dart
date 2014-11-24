part of dart_force_common_lib;

/**
* Holds all interactions with the cargo instances on the server!
*/
abstract class CargoHolder {
  
  Map<String, CargoBase> _cargos = new Map<String, CargoBase>();
  Map<String, List<String>> _subscribers = new Map<String, List<String>>();
  
  DataChangeable dataChangeable;
  
  CargoHolder(this.dataChangeable);
  
  void publish(String collection, CargoBase cargoBase);
  
  bool subscribe(String collection, String id);
  
  bool exist(String collection);
  
  bool add(String collection, key, data);
  
  bool update(String collection, key, data);
  
  bool set(String collection, data);
  
  bool remove(String collection, id);
  
}