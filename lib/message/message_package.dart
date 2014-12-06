part of dart_force_common_lib;

class ForceMessagePackage extends Package {
  
  String wsId;
  String request;
  dynamic profile;
  dynamic json;
  
  ForceMessageType messageType;
  
  ForceMessagePackage(this.request, this.messageType, this.json, this.profile, { this.wsId: "-"});
  
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
    if (json != null) json["data"] = this.json;
    if (json != null) json["profile"] = this.profile;
    if (json != null) json["request"] = this.request;
    if (json != null) json["type"] = this.messageType.toJson();
    return json;
  }
}