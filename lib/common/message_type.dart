part of dart_force_common_lib;

class ForceMessageType {
  
  static const NORMAL = 'normal';
  static const BROADCAST = 'broadcast';
  static const ID = 'id';
  static const PROFILE = 'profile';
  
  // all db types
  static const SUBSCRIBE = 'db.subscribe';
  static const ADD = 'db.add';
  static const SET = 'db.set';
  static const UPDATE = 'db.update';
  static const REMOVE = 'db.remove';
  
  String type; 
  String id;
  String key;
  String value;
  String collection;
  
  ForceMessageType(this.type);
  
  ForceMessageType.fromJson(json) {
    if (json!=null) {
      type = json["name"];
      if (type == ID) {
        id = json['id'];
      } else if (type == PROFILE) {
        key = json['key'];
        value = json['value'];
      } else if (type == SUBSCRIBE || type == ADD || type == UPDATE || type == REMOVE || type == SET) {
        collection = json['collection'];
      }
    } else {
      type = NORMAL;
    }
  }
}