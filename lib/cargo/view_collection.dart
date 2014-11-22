part of dart_force_client_lib;

/**
* Is a memory wrapper arround cargo, so we can add this to our view!
*/
class ViewCollection  {
  
  CargoBase cargo;
  DataChangeable _changeable;
  String _collection;
  
  Map<String, dynamic> all = new Map<String, dynamic>();
  
  ViewCollection(this._collection, this.cargo, this._changeable) {
   this.cargo.onAll((DataEvent de) {
     all[de.key] = de.data;
   }); 
  }
  
  void update(id, value) {
   this.cargo.setItem(id, value);
   this._changeable.update(_collection, id, value);
  }
  
}

class EncapsulatedData {
  String id;
  var data;
  
  EncapsulatedData(this.id, this.data);
}