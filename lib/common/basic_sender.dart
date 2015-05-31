part of force.common;

class Sender {
  
  Sendable sendable;
  String _reply_id;
  
  Sender(this.sendable, this._reply_id);
  
  void send(request, data) {
    sendable.send(request, data);
  }
  
  void reply(request, data) {
    sendable.sendTo(this._reply_id, request, data);
  }
  
  void sendTo(id, request, data) {
    sendable.sendTo(id, request, data);
  }
    
  void sendToProfile(key, value, request, data) {
    sendable.sendToProfile(key, value, request, data);
  }
  
}
