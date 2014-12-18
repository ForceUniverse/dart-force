part of dart_force_common_lib;

class CargoAction {
  
  static const SUBSCRIBE = 'db.subscribe';
  static const ADD = 'db.add';
  static const SET = 'db.set';
  static const UPDATE = 'db.update';
  static const REMOVE = 'db.remove';
  static const CANCEL = 'db.cancel';
  
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

class CargoPackage extends Package {
   
  String wsId;
  String collection;
  String key;
  dynamic profile;
  dynamic json;
  dynamic params;
  
  CargoAction action;
  
  CargoPackage(this.collection, this.action, this.profile, { this.key, this.json, this.params, this.wsId: "-"});
  
  CargoPackage.fromJson(json, {this.wsId}) {
     if (json!=null) {
       this.key = json["key"];
       this.json = json["data"];
       this.profile = json["profile"];
       this.collection = json["collection"];
       
       this.action = new CargoAction.fromJson(json["action"]);
     } 
   }
  
  Map toJson() {
    Map json = new Map();
    if (this.key != null) json["key"] = this.key;
    if (this.json!= null) json["data"] = this.json;
    if (this.params != null) json["params"] = this.params;
    if (this.profile!= null) json["profile"] = this.profile;
    if (this.collection != null) json["collection"] = this.collection;
    if (this.action != null) json["action"] = this.action.toJson();
    return json;
  }
  
  void cancel() {
    this.action = new CargoAction(CargoAction.CANCEL);
  }
}