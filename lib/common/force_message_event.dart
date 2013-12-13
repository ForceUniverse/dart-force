part of dart_force_common_lib;

class ForceMessageEvent {
  
  String origin; 
  String wsId;
  String request;
  dynamic json;
  
  ForceMessageEvent(this.request, this.json, { wsId: "-"}) {
    this.wsId = wsId;
  }
}