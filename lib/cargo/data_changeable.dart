part of force.common;

abstract class DataChangeable {

  void add(collection, key, data, {id});
  
  void set(collection, data, {id});
  
  void update(collection, key, data, {id});
  
  void remove(collection, key, {id});

}