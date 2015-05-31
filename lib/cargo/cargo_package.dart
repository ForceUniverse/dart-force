part of force.common;

/**
 * A db, cargo action that needs to happen
 */
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

/**
 * Cargo package exists out of info what we will do with the data in Cargo
 */
class CargoPackage extends Package {
   
  String wsId;
  String collection;
  String key;
  dynamic profile;
  dynamic json;
  dynamic params;
  
  Options options;
  CargoAction action;
  
  CargoPackage(this.collection, this.action, this.profile, { this.key, this.json, this.params, this.options, this.wsId: "-"});
  
  CargoPackage.fromJson(json, {this.wsId}) {
     if (json!=null) {
       this.key = json["key"];
       this.json = json["data"];
       this.profile = json["profile"];
       this.collection = json["collection"];
       this.params = json["params"];
       
       if (json["options"] != null) {
          this.options = new Options(limit: json["options"]["limit"], revert: json["options"]["revert"]);
       } else {
         this.options = new Options();
       }
       
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
    if (this.options != null) {
      json["options"] = { "limit" : options.limit, "revert" : options.revert };
    }
    return json;
  }
  
  /**
   * Cancel a cargo interaction
   */
  void cancel() {
    this.action = new CargoAction(CargoAction.CANCEL);
  }
}