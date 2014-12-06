part of dart_force_common_lib;

/**
* Holds all interactions with the cargo instances on the server!
*/
abstract class CargoHolder {
  
  Map<String, CargoBase> _cargos = new Map<String, CargoBase>();

  DataChangeable dataChangeable;
  
  CargoHolder(this.dataChangeable);
  
  void publish(String collection, CargoBase cargoBase, {PublishReceiver publishReceiver});
  
  bool subscribe(String collection, params, String id);
  
  bool exist(String collection);
  
  bool add(String collection, key, data);
  
  bool update(String collection, key, data);
  
  bool set(String collection, data);
  
  bool remove(String collection, id);
  
}