part of dart_force_client_lib;

/**
* Is a memory wrapper arround cargo, so we can add this to our view!
*/
class ViewCollection implements Iterable {
  
  CargoBase cargo;
  DataChangeable _changeable;
  String _collection;
  
  Map<String, EncapsulatedData> _all = new Map<String, EncapsulatedData>();
  
  ViewCollection(this._collection, this.cargo, this._changeable) {
   this.cargo.onAll((DataEvent de) {
     if (de.type==DataType.CHANGED) {
       _all[de.key] = new EncapsulatedData(de.key, de.data);
     }
     if (de.type==DataType.REMOVED) {
       _all.remove(de.key);
     }
   }); 
  }
  
  void update(id, value) {
   this.cargo.setItem(id, value);
   this._changeable.update(_collection, id, value);
  }
  
  void remove(id) {
    this.cargo.removeItem(id);
    this._changeable.remove(_collection, id);
  }
  
  void set(value) {
    this._changeable.set(_collection, value);
  }
  
  Iterator get iterator => _all.values.iterator;

  Iterable map(f(EncapsulatedData element)) => _all.values.map(f);
  
  Iterable where(bool test(EncapsulatedData element)) => _all.values.where(test);

  Iterable expand(Iterable f(EncapsulatedData element)) => _all.values.expand(f);

  bool contains(Object element) => _all.values.contains(element);

  void forEach(void f(EncapsulatedData element)) => _all.values.forEach(f);

  EncapsulatedData reduce(EncapsulatedData combine(EncapsulatedData value, EncapsulatedData element)) => _all.values.reduce(combine);
  
  dynamic fold(var initialValue,
                 dynamic combine(var previousValue, EncapsulatedData element)) => _all.values.fold(initialValue, combine);

  bool every(bool test(EncapsulatedData element)) => _all.values.every(test);

  bool any(bool test(EncapsulatedData element)) => _all.values.any(test);

  List<EncapsulatedData> toList({ bool growable: true }) => _all.values.toList(growable: growable);

  Set<EncapsulatedData> toSet() => _all.values.toSet();

  int get length => _all.values.length;

  bool get isEmpty => _all.values.isEmpty;

  bool get isNotEmpty => _all.values.isNotEmpty;

  Iterable<EncapsulatedData> take(int n) => _all.values.take(n);

  Iterable<EncapsulatedData> takeWhile(bool test(EncapsulatedData value)) => _all.values.takeWhile(test);

  Iterable<EncapsulatedData> skip(int n) => _all.values.skip(n);

  Iterable<EncapsulatedData> skipWhile(bool test(EncapsulatedData value)) => _all.values.skipWhile(test);
  
  EncapsulatedData get first => _all.values.first;

  EncapsulatedData get last => _all.values.last;
  
  EncapsulatedData get single => _all.values.single;

  EncapsulatedData firstWhere(bool test(EncapsulatedData element), { EncapsulatedData orElse() }) => _all.values.firstWhere(test);

  EncapsulatedData lastWhere(bool test(EncapsulatedData element), {EncapsulatedData orElse()}) => _all.values.lastWhere(test);

  EncapsulatedData singleWhere(bool test(EncapsulatedData element)) => _all.values.singleWhere(test);
  
  EncapsulatedData elementAt(int index) => _all.values.elementAt(index);
  
  String join([String separator = ""]) {
      StringBuffer buffer = new StringBuffer();
      buffer.writeAll(this, separator);
      return buffer.toString();
  }
}

class EncapsulatedData {
  String id;
  var data;
  
  EncapsulatedData(this.id, this.data);
}