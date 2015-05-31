part of force.common;

class MessagePackage extends Package {
  
  String wsId;
  String request;
  dynamic profile;
  dynamic json;
  
  MessageType messageType;
  
  MessagePackage(this.request, this.messageType, this.json, this.profile, { this.wsId: "-"});
  
  MessagePackage.fromJson(json, {this.wsId}) {
     if (json!=null) {
       this.json = json["data"];
       this.profile = json["profile"];
       this.request = json["request"];
       
       this.messageType = new MessageType.fromJson(json["type"]);
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