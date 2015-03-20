part of dart_force_common_lib;

class PingPongPackage extends Package {
  
  String wsId;
  
  static const PING = 'PING';
  static const PONG = 'PONG';
  
  String state;
  
  PingPongPackage(this.state);
  
  PingPongPackage.fromJson(json, {this.wsId}) {
     if (json!=null) {
       state = json["state"];
     } 
   }
  
  Map toJson() {
    Map json = new Map();
    if (json != null) json["state"] = this.state;
    return json;
  }
}