part of dart_force_common_lib;

/**
* Is a memory wrapper arround cargo, so we can add this to our view!
* Ideal class to use it in Angular or Polymer.
*/
class ViewCollection implements Iterable {
  
  CargoBase cargo;
  DataChangeable _changeable;
  String _collection;
  
  Map<String, EncapsulatedValue> _all = new Map<String, EncapsulatedValue>();
  
  ViewCollection(this._collection, this.cargo, this._changeable) {
   this.cargo.onAll((DataEvent de) {
     if (de.type==DataType.CHANGED) {
       _all[de.key] = new EncapsulatedValue(de.key, de.data);
     }
     if (de.type==DataType.REMOVED) {
       _all.remove(de.key);
     }
   }); 
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

  Iterable map(f(EncapsulatedValue element)) => _all.values.map(f);
  
  Iterable where(bool test(EncapsulatedValue element)) => _all.values.where(test);

  Iterable expand(Iterable f(EncapsulatedValue element)) => _all.values.expand(f);

  bool contains(Object element) => _all.values.contains(element);

  void forEach(void f(EncapsulatedValue element)) => _all.values.forEach(f);

  EncapsulatedValue reduce(EncapsulatedValue combine(EncapsulatedValue value, EncapsulatedValue element)) => _all.values.reduce(combine);
  
  dynamic fold(var initialValue,
                 dynamic combine(var previousValue, EncapsulatedValue element)) => _all.values.fold(initialValue, combine);

  bool every(bool test(EncapsulatedValue element)) => _all.values.every(test);

  bool any(bool test(EncapsulatedValue element)) => _all.values.any(test);

  List<EncapsulatedValue> toList({ bool growable: true }) => _all.values.toList(growable: growable);

  Set<EncapsulatedValue> toSet() => _all.values.toSet();

  int get length => _all.values.length;

  bool get isEmpty => _all.values.isEmpty;

  bool get isNotEmpty => _all.values.isNotEmpty;

  Iterable<EncapsulatedValue> take(int n) => _all.values.take(n);

  Iterable<EncapsulatedValue> takeWhile(bool test(EncapsulatedValue value)) => _all.values.takeWhile(test);

  Iterable<EncapsulatedValue> skip(int n) => _all.values.skip(n);

  Iterable<EncapsulatedValue> skipWhile(bool test(EncapsulatedValue value)) => _all.values.skipWhile(test);
  
  EncapsulatedValue get first => _all.values.first;

  EncapsulatedValue get last => _all.values.last;
  
  EncapsulatedValue get single => _all.values.single;

  EncapsulatedValue firstWhere(bool test(EncapsulatedValue element), { EncapsulatedValue orElse() }) => _all.values.firstWhere(test);

  EncapsulatedValue lastWhere(bool test(EncapsulatedValue element), {EncapsulatedValue orElse()}) => _all.values.lastWhere(test);

  EncapsulatedValue singleWhere(bool test(EncapsulatedValue element)) => _all.values.singleWhere(test);
  
  EncapsulatedValue elementAt(int index) => _all.values.elementAt(index);
  
  String join([String separator = ""]) {
      StringBuffer buffer = new StringBuffer();
      buffer.writeAll(this, separator);
      return buffer.toString();
  }
}

class EncapsulatedValue {
  String key;
  var value;
  
  EncapsulatedValue(this.key, this.value);
}