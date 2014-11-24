part of dart_force_common_lib;

abstract class DataChangeable {

  void add(collection, key, data, {id});
  
  void update(collection, key, data, {id});
  
  void remove(collection, key, {id});

}