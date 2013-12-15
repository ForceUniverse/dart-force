part of dart_force_common_lib;

class ForceMessageEvent {
  
  String origin; 
  String wsId;
  String request;
  dynamic profile;
  dynamic json;
  
  ForceMessageEvent(this.request, this.json, this.profile, { wsId: "-"}) {
    this.wsId = wsId;
  }
}