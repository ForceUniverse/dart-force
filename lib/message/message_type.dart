part of dart_force_common_lib;

class MessageType {
  
  static const NORMAL = 'normal';
  static const BROADCAST = 'broadcast';
  static const ID = 'id';
  static const PROFILE = 'profile';
  
  String type; 
  String id;
  String key;
  String value;
  String collection;
  
  MessageType(this.type);
  
  MessageType.fromJson(json) {
      if (json!=null) {
        type = json["name"];
        if (type == ID) {
          id = json['id'];
        } else if (type == PROFILE) {
          key = json['key'];
          value = json['value'];
        }
     }
  }
  
  Map toJson() {
     Map json = new Map();
     json["name"] = type;
     if (type == ID) {
       json['id'] = id;
     } else if (type == PROFILE) {
       json['key'] = key;
       json['value'] = value;
     }
     return json;
  }
}