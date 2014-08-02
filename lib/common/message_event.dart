part of dart_force_common_lib;

class ForceMessageEvent {
  
  String origin; 
  String wsId;
  String request;
  dynamic profile;
  dynamic json;
  
  ForceMessageType messageType;
  
  ForceMessageEvent(this.request, this.messageType, this.json, this.profile, { wsId: "-"}) {
    this.wsId = wsId;
  }
}