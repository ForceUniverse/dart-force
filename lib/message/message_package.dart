part of dart_force_common_lib;

class ForceMessagePackage extends Package {
  
  String wsId;
  String request;
  dynamic profile;
  dynamic json;
  
  ForceMessageType messageType;
  
  ForceMessagePackage(this.request, this.messageType, this.json, this.profile, { wsId: "-"}) {
    this.wsId = wsId;
  }
  
  ForceMessagePackage.fromJson(json, {this.wsId}) {
     if (json!=null) {
       this.json = json["data"];
       this.profile = json["profile"];
       this.request = json["request"];
       
       this.messageType = new ForceMessageType.fromJson(json["type"]);
     } 
   }
  
  Map toJson() {
    Map json = new Map();
    json["data"] = this.json;
    json["profile"] = this.profile;
    json["request"] = this.request;
    json["type"] = this.messageType.toJson();
    return json;
  }
}