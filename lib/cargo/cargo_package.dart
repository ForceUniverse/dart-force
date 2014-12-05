part of dart_force_common_lib;

class CargoAction {
  
  static const SUBSCRIBE = 'db.subscribe';
  static const ADD = 'db.add';
  static const SET = 'db.set';
  static const UPDATE = 'db.update';
  static const REMOVE = 'db.remove';
  
  String type; 
  
  CargoAction(this.type);
  
  CargoAction.fromJson(json) {
    if (json!=null) {
        type = json["name"];
    }
  }
  
  Map toJson() {
     Map json = new Map();
     json["name"] = type;
     return json;
   }
}

class ForceCargoPackage extends Package {
   
  String wsId;
  String collection;
  String key;
  dynamic profile;
  dynamic data;
  
  CargoAction action;
  
  ForceCargoPackage(this.collection, this.action, this.profile, { this.key, this.data, this.wsId: "-"});
  
  ForceCargoPackage.fromJson(json, {this.wsId}) {
     if (json!=null) {
       this.key = json["key"];
       this.data = json["data"];
       this.profile = json["profile"];
       this.collection = json["request"];
       
       this.action = new CargoAction.fromJson(json["type"]);
     } 
   }
  
  Map toJson() {
    Map json = new Map();
    json["data"] = this.data;
    json["profile"] = this.profile;
    json["collection"] = this.collection;
    json["type"] = this.action.toJson();
    return json;
  }
}